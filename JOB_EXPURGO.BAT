########################.BAT##################################################################
REM Expurgo de arquivos de backup do Confie (Sintegra)
forfiles /p "E:\inetpub\wwwroot\downloadupload\arquivostmp" /S /d -1 /C "cmd /c del @path /Q
forfiles /p "E:\Arquivos\SolucaoSintegra\Upload\Backup" /S /d -60 /C "cmd /c del @path /Q"

REM Expurgo de arquivos do Base de Inconsistencia
forfiles /p "E:\Arquivos\BI\Upload\Envio\FW_TMP" /S /d -30 /C "cmd /c del @path /Q

REM Expurgo de arquivos do PortfolioMA
forfiles /p "E:\Arquivos\PortfolioMA\Processados" /S /d -60 /C "cmd /c del @path /Q
forfiles /p "E:\Arquivos\PortfolioMA\Envio" /S /d -60 /C "cmd /c del @path /Q
forfiles /p "E:\Arquivos\PortfolioMA\Upload" /S /d -60 /C "cmd /c del @path /Q

###########################################################################################################################
BASH 
SHELL /opt/ctmage/ctm_scripts/expurgo_linux_spobrwasbatch01.sh

######################################################################################
#
# ********** SERVIDOR: spobrwasbatch01
# ********** JOB: EXPURGO_SPOBRWASBATCH01_CA
# ********** Responsavel pela ShellScript: An Prod PA
# ********** Autor: Roberto Martins
#
######################################################################################
#
# Sintaxe do comando (todos os 4 parâmetros devem ser informados):
# RemoveArqs <dir> <profundidade de subdiretórios> <dias de retenção> <filtro de arquivo>
#    <profundidade de subdiretórios> => "1" equivale somente ao diretório informado
#    <filtro de arquivo> => Informar entre aspas simples ' . Para todos os arquivos informar '*'
#
######################################################################################

#!/bin/bash
set +xv
function RemoveArqs(){

       echo " "
       echo " "
       echo " "
       echo "################################################################################"
       echo " "
       echo "Parametros informados"
       echo "Diretorio              : $1"
       echo "Niveis de SubDiretorio : $2"
       echo "Filtro                 : $4"
       echo "Idade                  : arquivos mais antigos que $3 dias"
       echo " "
       echo " "

	### Verifica se todos os parametros foram informados
	if [ "$4" == "" ]
	then
		echo "Erro: todos os 4 parametros devem ser informados"
		echo RC 1
		if [ $TemErros -lt 1 ] ; then TemErros=1 ; fi
		return 1
	fi

	### Verifica se o diretorio informado existe
	if [ ! -d "$1" ]
	then
		echo "Erro: $1 nao e um diretorio ou o diretorio nao existe"
		echo RC 2
		if [ $TemErros -lt 2 ] ; then TemErros=2 ; fi
		return 2
	fi

	### Listando os arquivos que atendem o critério
	echo "Apagando arquivos:"
	find $1 -maxdepth $2 -ctime +$3 -name "$4" -type f -ls

	### Removendo os arquivos
	find $1 -maxdepth $2 -ctime +$3 -name "$4" -type f -exec rm -vf {} \;
	echo RC $?
	if [ $TemErros -lt $? ] ; then TemErros=$? ; fi
	return $?
}

#=====================
## Zera RC do job
TemErros=0
#----------------------

#Sintaxe do comando (todos os 4 parâmetros devem ser informados):
#RemoveArqs <dir> <profundidade de subdiretórios> <dias de retenção> <filtro de arquivo>
#   <profundidade de subdiretórios> => "1" equivale somente ao diretório informado
#   <filtro de arquivo> => Informar entre aspas simples ' . Para todos os arquivos informar '*'
# Exemplo: RemoveArqs /tmp/RAM/ 1 0 '*'

RemoveArqs '/home/cduser/campanha/envio/' 1 8 '*'
# RemoveArqs '/home/cduser/campanha/envio/fw_tmp/' 1 8 '*'

#Req 1025229
RemoveArqs '/home/cduser/BVHOMOLOG/BV1/PROCESSED/' 4 31 '*'
RemoveArqs '/home/cduser/BVHOMOLOG/BV3/PROCESSED/' 4 31 '*'

#RITM1571491
RemoveArqs '/home/produtos/joblogs/server1/' 1 31 '*zip'
#----------------------
echo " "
echo "---- Fim do script ----"
echo "Maior RC = $TemErros"
exit $TemErros

#################################################################### 2ª EXEMEPLO DE BASH####################################################################
######################################################################################
#
# ********** SERVIDOR:SPOBRPCSLDB02
# ********** JOB:EXPURGO_SPOBRPCSLDB02
# ********** Responsavel pela ShellScript: An Prod PA
# ********** Autor: Roberto Martins
#
######################################################################################
#
# Veja como usar no final do script.
#
######################################################################################

#!/bin/bash
set -xv
function RemoveArqs(){

       echo " "
       echo " "
       echo " "
       echo "################################################################################"
       echo " "
       echo "Parametros informados"
       echo "Diretorio              : $1"
       echo "Niveis de SubDiretorio : $2"
       echo "Filtro                 : $4"
       echo "Idade                  : arquivos mais antigos que $3 dias"
       echo " "
       echo " "

        ### Verifica se todos os parametros foram informados
        if [ "$4" == "" ]
        then
                echo "Erro: todos os 4 parametros devem ser informados"
                echo RC 1
                if [ $TemErros -lt 1 ] ; then TemErros=1 ; fi
                return 1
        fi

        ### Verifica se o diretorio informado existe
        if [ ! -d "$1" ]
        then
                echo "Erro: $1 nao e um diretorio ou o diretorio nao existe"
                echo RC 2
                if [ $TemErros -lt 2 ] ; then TemErros=2 ; fi
                return 2
        fi

        ### Listando os arquivos que atendem o critÃ©rio
        echo "Apagando arquivos:"
        find $1 -maxdepth $2 -mtime +$3 -name "$4" -type f -ls

        ### Removendo os arquivos
        find $1 -maxdepth $2 -mtime +$3 -name "$4" -type f -exec rm -vf {} \;
        echo RC $?
        if [ $TemErros -lt $? ] ; then TemErros=$? ; fi
        return $?
}

#=====================
## Zera RC do job
TemErros=0
#----------------------

#Sintaxe do comando (todos os 4 parÃ¢metros devem ser informados):
#RemoveArqs '<dir>' <profundidade de subdiretÃ³rios> <dias de retenÃ§Ã£o> <filtro de arquivo>
#   '<dir>'                                             => informar entre aspas simples
#   <profundidade de subdiretÃ³rios> => "1" equivale somente ao diretÃ³rio informado. Recursividade nos subdiretÃ³rios.
#   <dias de retenÃ§Ã£o>                          => dias a partir da Ãºltima modificaÃ§Ã£o
#   <filtro de arquivo>                         => Informar entre aspas simples ' . Para todos os arquivos informar '*'
/opt/datalicensing_enriquecimento/saida/BACKUP_SAIDA
# Exemplo:
# RemoveArqs '/tmp/RAM/' 1 0 '*'

RemoveArqs '/home/oracle/scripts/Powercurve/NEXTEL/IN/' 1 1 '*.csv'
RemoveArqs '/home/oracle/scripts/Powercurve/NEXTEL/OUT/' 1 1 '*.csv'
RemoveArqs '/home/oracle/scripts/Powercurve/NEXTEL/IN/' 1 1 '*.CSV'
RemoveArqs '/home/oracle/scripts/Powercurve/NEXTEL/OUT/' 1 1 '*.CSV'

#----------------------
echo " "
echo "---- Fim do script ----"
echo "Maior RC = $TemErros"
exit $TemErros




###########################################################################################################################################################################


powershell 

Linha de comando:powershell -noprofile C:\adm\CONTROLM\Expurgo\Expurgo_Win_03_Excecao.ps1 exit $LASTEXITCODE

<# 
	Apaga arquivos conforme parametros informados
	Script criado por Roberto Martins - An Prod PA
	----
	Renomear este arquivo para "Expurgo_Win.ps1"
	Linha de comando do job: powershell -noprofile "<caminho+nome_script_expurgo>.ps1" exit $LASTEXITCODE
#>

Function Delete-Files-excecao {
Param(
   [Parameter(Mandatory=$true)]
   [string]$diret = "",

   [Parameter(Mandatory=$true)]
   [string]$filtro = "",

   [Parameter(Mandatory=$true)]
   [int]$periodo
	)
    $ErroLocal = 0
	if (!(test-path -LiteralPath $diret -PathType Container)) {
		write-output "Diretorio $diret nao existe."
		$ErroLocal = 3
	        $script:TemErros = $ErroLocal
		return
		}
    ## Seleciona os arquivos e grava na variável
    [array]$Arqs=Get-ChildItem -Recurse -LiteralPath ${diret} -Filter ${filtro} | where {$_.LastWriteTime -lt (Get-Date).AddDays(${periodo}*(-1))} | where {$_.CreationTime -lt (Get-Date).AddDays(${periodo}*(-1))} | where { !$_.PSIsContainer } | where { $_.Directory -notlike "*Procuracao074*" }
    write-output "################################################################################"
    write-output " "
    write-output " "
    write-output "Parâmetros informados"
    write-output "Diretório : $diret"
    write-output "Filtro    : $filtro"
    write-output "Idade     : arquivos mais antigos que $periodo dias"
    write-output " "
    Write-output "Lista de arquivos a serem removidos" $Arqs | format-table -AutoSize
    write-output " "
    write-output " "
    ## Se não houver arquivos que atendem o critério, sai com RC = 1
    if ( ${Arqs}.count -lt 1 ) {
        write-output ${Arqs}.count "Não há arquivos"
        if ( $ErroLocal -eq 0 ) { 
            $ErroLocal = 1
        }
    } 
    Else {
        ## Se houver arquivos remove 1 a 1
		Write-output "Quantidade de arquivos a serem removidos: $(${Arqs}.count)"
		foreach ( $_ in $Arqs ) {
			  Remove-Item -literalpath $($_.FullName) -ErrorAction SilentlyContinue
			##### Grava mensagem na Sysout sobre sucesso/falha ao remover o arquivo
			If ( $? ) {
				Write-output "Sucesso ao Remover $($_.fullname) "
			}        
			Else {
				Write-output "***** Erro ao remover $($_.fullname)  *****"      
				$ErroLocal = 2
			}
		}
    }
    ## Informa o RC do Step e grava no RC do job
    write-output "RC = $ErroLocal"
    if ( $script:TemErros -lt $ErroLocal ) {
       $script:TemErros = $ErroLocal
    }
}
    
write-output " -- Iniciando o script -- "
#----------------------
## Zera RC do job
$TemErros = 0
#=====================

Delete-Files-excecao -diret "G:\Sistemas\SISDAT\AGINFO\Lotes\" -filtro "*.*" -periodo 180
Delete-Files-excecao -diret "G:\Sistemas\DELIVERY_MS_CD\OI\SAIDA\ENVIADO\" -filtro "*.*" -periodo 180
Delete-Files-excecao -diret "G:\Sistemas\DELIVERY_MS_CD\BNB\SAIDA\ENVIADO\" -filtro "*.*" -periodo 180
Delete-Files-excecao -diret "G:\Sistemas\DELIVERY_MS_CD\SICOOB\SAIDA\ENVIADO\" -filtro "*.*" -periodo 60
Delete-Files-excecao -diret "G:\Sistemas\Ebisys_prepaid_control\" -filtro "oneshot_ordercreation*" -periodo 90
Delete-Files-excecao -diret "G:\Sistemas\Ebisys_prepaid_control\" -filtro "Subscription_2lastevents*" -periodo 30
Delete-Files-excecao -diret "G:\Sistemas\SISDAT\CE\Avon\Arquivos\Processados\" -filtro "*.*" -periodo 30

#=====================
write-output " "
write-output "---- Fim do script ----"
write-output "Maior RC = $TemErros"
Exit $TemErros

