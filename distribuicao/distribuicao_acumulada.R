drvPsql = RPostgreSQL::PostgreSQL()
pw <- {"35t4t15t1c4"}
cnxCoadminfo <- dbConnect(drvPsql, dbname = "coadminfo", host = "127.0.0.1", user = "usr_coadminfo_r",password =  pw)
sqlProcedimento = "SELECT
                    	  nm_matricula||'-'||cd_sequencial AS matricula
                    	, SUM(nm_valor_total)::NUMERIC(17,2) as nm_valor_total
                    FROM palco.tt_auditoria_plano_saude_procedimento
                    WHERE dt_atendimento::char(4) = '2018'
                    GROUP BY nm_matricula||'-'||cd_sequencial"
df.sql <- dbGetQuery(cnxCoadminfo, statement = sqlProcedimento)
df = df.sql


dados <- df

dados.plot <- data.frame(table(dados), table(dados)/sum(table(dados)), cumsum(prop.table(table(dados))))
dados.plot <- dados.plot[, -3]
names(dados.plot) <- c("Categoria", "FreqAbsoluta", "FreqRelativa", "FreqCumulativa")
dados.plot$FreqRelativa <- dados.plot$FreqRelativa*100
dados.plot

library(ggplot2)

ggplot(dados.plot, aes(x=Categoria, y=FreqRelativa)) +
  geom_bar(stat="identity") + 
  geom_line(aes(y=FreqCumulativa*max(FreqRelativa), group=1)) +
  labs(x="Categoria", y="Frequência Relativa (%)") + 
  geom_text(aes(label=FreqAbsoluta), vjust=-0.8) +
  scale_y_continuous(
    sec.axis=sec_axis(trans=~ .*100/(max(dados.plot$FreqRelativa)), 
                      name = "Frequência Cumulativa (%)"))
