--job table
jobtbl={
    ADVENTURER = 0,
    GLADIATOR = 1,
    PUGILIST = 2,
    MARAUDER = 3,
    LANCER = 4,
    ARCHER = 5,
    CONJURER = 6,
    THAUMAGURGE = 7,
    CARPENTER = 8,
    BLACKSMITH = 9,
    ARMORER = 10,
    GOLDSMITH = 11,
    LEATHERWORKER = 12,
    WEAVER = 13,
    ALCHEMIST = 14,
    CULINARIAN = 15,
    MINER = 16,
    BOTANIST = 17,
    FISHER = 18,
    PLD = 19,
    MNK = 20,
    WAR = 21,
    DRG = 22,
    BRD = 23,
    WHM = 24,
    BLM = 25,
    ARCANIST = 26,
    SMN = 27,
    SCH= 28,
    ROGUE = 29,
    NIN = 30,
    MCH = 31,
    DRK = 32,
    AST = 33,
    SAM = 34,
    RDM = 35,
    --36
    GNB = 37,
    DNC = 38,
    RPR = 39,
    SGE = 40
}
--main window
local main={}
main.open=true
main.visible=true
--set party position window
local partyposwindow={}
partyposwindow.open=false
partyposwindow.visible=false
--set party position for P2
local partyposphase2window={}
partyposphase2window.open=false
partyposphase2window.visible=false
--phase1 pantokrator
local pantokratorwindow={}
pantokratorwindow.open=false
pantokratorwindow.visible=false
--notice window
local noticewindow={}
noticewindow.open=true
noticewindow.visible=true
nwposx=0
nwposy=0
--file path to this plugin
pathJpm=GetLuaModsPath().."\\JobPriorityManager"
--load default values
defaultValue=FileLoad(pathJpm.."\\resources\\setting\\value.txt")
--this is a table of party positions. this must be in the order MTSTH1H2D1D2D3D4
partypos={}
--marker info
markerinfo={}
--name of file output to log
currentFileName=""
--values used in main window
previoustime=0
isAutoload=true
defaultRecordCheck=defaultValue["recordLog"]
owcOrderTDH=defaultValue["owcOrderTDH"]
isShowNoticeWindow=defaultValue["isShowNotice"]
isLockNoticeWindow=defaultValue["isLockNotice"]
isIncombat=false
--values used in main window. detect buff
bufflist1={}
bufflist2={}
bufflist3={}
bufflist4={}
bufflist5={}
bufflist6={}
bufflist7={}
bufflist8={}
--values used in main window. detect cast
castinglist={}
--values used in main window. detect entity
enemylist={}
allenemylist={}
--values used in party position window
msgCautionPPW=""
msgCautionPPP2W=""
msgCautionPant=""
--
addMarkerTime=0
--use for VOICEVOX
num_speaker=3
--phase number
numPhase=0
--phase1.1
buffsloop={}
playerloop=0
isLoopCall=false
--phase1.2
jobpant={}
buffspant={}
playerpantid=0
checkPant=false
--phase2.1
jobf={}--left
jobm={}--right
psf={}
psm={}
leftside={}
rightside={}
share={}
glitch=0
replaceMarker=0
--phase3.1
jobcanon={}
playercannonid=0
--phase3.3
helloworld={}
--phase3.4
joboversampled={}
--countoversampled=0
playeroversampledid=0
--phase3.4 oversample cross
joboversampledcross={}
isOverSampledCross=false
omegaoversampled=0--right 31595,left 31596
oversampledcross=""
--phase5.1
playerdeltatether=0
playerhelloworld=0
deltatether={}
--phase5.2
previoustimedelta=0
--phase5.3
sigmadebuff={}
sigmaplaystation={}
sigmatarget={}
playersigmaplaystation=0
playersigmatarget=0
--phase5.4
isPushSigma=false
--phase5.x
partydynamis={}

function main.Init()
    Argus.registerOnMarkerAdd(function(entityID,markerType)
        local e=EntityList:Get(entityID)
        if(e)then
            --set add marker time
            addMarkerTime=ml_global_information.Now
            --
            local jobid=e.job
            if(#currentFileName~=0)then
                FileWrite(pathJpm.."\\log\\marker\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..markerType..","..e.id..","..e.job..","..GetJobName(e.job).."\n",true)
            end
            --insert jobid and markertype to table
            for k,v in pairs(jobtbl) do
                if(v==jobid)then
                    markerinfo[#markerinfo+1]={v,k,markerType}
                end
            end
            --phase2.1
            if(numPhase==2.1)then
                if((markerType==416)or(markerType==417)or(markerType==418)or(markerType==419))then
                    for key,val in pairs(jobtbl) do
                        if(val==jobid)then
                            --set the marker on the left group
                            if(val==jobf[1])then
                                psf[#psf+1]={val,markerType}
                                if((#psf==4)and(#psm==4))then
                                    comparePS()
                                end
                            end
                            if(val==jobf[2])then
                                psf[#psf+1]={val,markerType}
                                if((#psf==4)and(#psm==4))then
                                    comparePS()
                                end
                            end
                            if(val==jobf[3])then
                                psf[#psf+1]={val,markerType}
                                if((#psf==4)and(#psm==4))then
                                    comparePS()
                                end
                            end
                            if(val==jobf[4])then
                                psf[#psf+1]={val,markerType}
                                if((#psf==4)and(#psm==4))then
                                    comparePS()
                                end
                            end
                            --set the marker on the right group
                            if(val==jobm[1])then
                                psm[#psm+1]={val,markerType}
                                if((#psf==4)and(#psm==4))then
                                    comparePS()
                                end
                            end
                            if(val==jobm[2])then
                                psm[#psm+1]={val,markerType}
                                if((#psf==4)and(#psm==4))then
                                    comparePS()
                                end
                            end
                            if(val==jobm[3])then
                                psm[#psm+1]={val,markerType}
                                if((#psf==4)and(#psm==4))then
                                    comparePS()
                                end
                            end
                            if(val==jobm[4])then
                                psm[#psm+1]={val,markerType}
                                if((#psf==4)and(#psm==4))then
                                    comparePS()
                                end
                            end
                        end
                    end
                end
                if(markerType==100)then
                    local countleft=0
                    local countright=0
                    share[#share+1]=jobid
                    if(#share==2)then
                        for k,v in pairs(leftside) do
                            if((v[1]==share[1])or(v[1]==share[2]))then
                                countleft=countleft+1
                            end
                        end
                        for k,v in pairs(rightside) do
                            if((v[1]==share[1])or(v[1]==share[2]))then
                                countright=countright+1
                            end
                        end
                        if((countleft==1)and(countright==1))then
                            replaceMarker=1000
                        end
                        if(countleft==2)then
                            local dup={}
                            for k,v in pairs(leftside) do
                                if((v[1]==share[1])or(v[1]==share[2]))then
                                    dup[#dup+1]=v[2]
                                end
                            end
                            if(#dup==2)then
                                if(dup[1]==416)then--circle
                                    replaceMarker=dup[2]
                                end
                                if(dup[1]==419)then--cross
                                    if(dup[2]==416)then
                                        --circle
                                        replaceMarker=dup[1]
                                    else
                                        --not circle
                                        replaceMarker=dup[2]
                                    end
                                end
                                if(dup[1]==417)then--triangle
                                    if((dup[2]==418))then
                                        --square
                                        replaceMarker=dup[2]
                                    else
                                        --not square
                                        replaceMarker=dup[1]
                                    end
                                end
                                if(dup[1]==418)then--square
                                    replaceMarker=dup[1]
                                end
                            end
                        end
                        if(countright==2)then
                            local dup={}
                            for k,v in pairs(rightside) do
                                if((v[1]==share[1])or(v[1]==share[2]))then
                                    dup[#dup+1]=v[2]
                                end
                            end
                            if(#dup==2)then
                                if(glitch==3427)then--middle
                                    if(dup[1]==416)then--circle
                                        replaceMarker=dup[2]
                                    end
                                    if(dup[1]==419)then--cross
                                        if(dup[2]==416)then
                                            --circle
                                            replaceMarker=dup[1]
                                        else
                                            --not circle
                                            replaceMarker=dup[2]
                                        end
                                    end
                                    if(dup[1]==417)then--triangle
                                        if((dup[2]==418))then
                                            --square
                                            replaceMarker=dup[2]
                                        else
                                            --not square
                                            replaceMarker=dup[1]
                                        end
                                    end
                                    if(dup[1]==418)then--square
                                        replaceMarker=dup[1]
                                    end
                                end
                                if(glitch==3428)then--remote
                                    if(dup[1]==416)then--circle
                                        replaceMarker=dup[1]
                                    end
                                    if(dup[1]==419)then--cross
                                        if(dup[2]==416)then
                                            --circle
                                            replaceMarker=dup[2]
                                        else
                                            --not circle
                                            replaceMarker=dup[1]
                                        end
                                    end
                                    if(dup[1]==417)then--triangle
                                        if((dup[2]==418))then
                                            --square
                                            replaceMarker=dup[1]
                                        else
                                            --not square
                                            replaceMarker=dup[2]
                                        end
                                    end
                                    if(dup[1]==418)then--square
                                        replaceMarker=dup[2]
                                    end
                                end
                            end
                        end
                    end
                end
            end
            --phase5.3
            if(numPhase==5.3)then
                if((markerType==416)or(markerType==417)or(markerType==418)or(markerType==419))then--circle,triangle,square,cross
                    if(not(IsIncludeBuffTOP(jobid,markerType,sigmaplaystation)))then
                        sigmaplaystation[#sigmaplaystation+1]={jobid,markerType}
                    end
                    if(jobid==Player.job)then
                        playersigmaplaystation=markerType
                    end
                end
                if(markerType==244)then
                    if(not(IsIncludeBuffTOP(jobid,markerType,sigmatarget)))then
                        sigmatarget[#sigmatarget+1]={jobid,markerType}
                    end
                    if(jobid==Player.job)then
                        playersigmatarget=markerType
                    end
                end
            end
        end
    end)
end

--detect phase
function detectPhaseTOP()
    --detect incombat
    if(isIncombat)then
        local pml=EntityList.myparty
        if(pml)then
            local i,e=next(pml)
            if((i~=nil)and(e~=nil))then
                local pm=EntityList:Get(e.id)
                if(pm)then
                    if(pm.incombat)then
                        --incombat
                        local el=EntityList("incombat")
                        if(el)then
                            local index,entity=next(el)
                            local tmpCastlist={}
                            while((index~=nil)and(entity~=nil))do
                                if((entity.chartype~=2)and(entity.chartype~=4))then
                                    local ci=entity.castinginfo
                                    if(ci)then
                                        if(ci.casttime~=nil)then
                                            if(not(ci.channelingid==0))then
                                                if(not((ci.channelingid==0)and(ci.castingid==0)and(ci.casttime==0)))then
                                                    --phase0 to phase1
                                                    if(numPhase==0)then
                                                        if(ci.channelingid==31491)then--program loop
                                                            previoustime=ml_global_information.Now
                                                            numPhase=1.1
                                                        end
                                                    end
                                                    if(numPhase==1.1)then
                                                        if(ci.channelingid==31499)then--pantokrator
                                                            previoustime=ml_global_information.Now
                                                            numPhase=1.2
                                                        end
                                                    end
                                                    --phase1.2 to phase2.1
                                                    if(numPhase==1.2)then
                                                        if((ci.channelingid==31552)or(ci.channelingid==31553))then--firewall
                                                            previoustime=ml_global_information.Now
                                                            numPhase=2.1
                                                        end
                                                    end
                                                    --phase2.2 to phase3.1
                                                    if(numPhase==2.2)then
                                                        if(ci.channelingid==31557)then--laser shower
                                                            previoustime=ml_global_information.Now
                                                            numPhase=3.1
                                                        end
                                                    end
                                                    --phase3.2 to phase3.3
                                                    --if(numPhase==3.2)then
                                                        if(ci.channelingid==31573)then--hello, world
                                                            previoustime=ml_global_information.Now
                                                            numPhase=3.3
                                                        end
                                                    --end
                                                    --phase3.3 to phase3.4
                                                    if(numPhase==3.3)then
                                                        if(ci.channelingid==31588)then--critical error
                                                            previoustime=ml_global_information.Now
                                                            numPhase=3.4
                                                        end
                                                    end
                                                    --phase3.5 to phase4
                                                    --if(numPhase==3.5)then
                                                        if(ci.channelingid==31560)then--ion efflux
                                                            previoustime=ml_global_information.Now
                                                            numPhase=4
                                                        end
                                                    --end
                                                    --phase4 to phase5.1
                                                    if(numPhase==4)then
                                                        if(ci.channelingid==31611)then--blue screen
                                                            previoustime=ml_global_information.Now
                                                            numPhase=5.1
                                                        end
                                                    end
                                                    --phase5.2 to phase5.3
                                                    --if(numPhase==5.2)then
                                                        if(ci.channelingid==32788)then--run: ****mi* (sigma version)
                                                            playerhelloworld=0
                                                            previoustime=ml_global_information.Now
                                                            numPhase=5.3
                                                        end
                                                    --end
                                                    if(numPhase==5.4)then
                                                        if(ci.channelingid==32789)then--run: ****mi* (Omega Version)
                                                            previoustime=ml_global_information.Now
                                                            numPhase=5.5
                                                        end
                                                    end
                                                    --if(numPhase==5.5)then
                                                        if(ci.channelingid==31623)then--blind faith
                                                            previoustime=ml_global_information.Now
                                                            numPhase=6
                                                        end
                                                    --end
                                                end
                                            end
                                        end
                                    end
                                end
                                index,entity=next(el,index)
                            end
                        end
                    else
                        --not incombat
                        numPhase=0
                    end
                end
            end
        end
    end
end

--notice window
function noticewindow.Draw(event,ticks)
    if(noticewindow.open)then
        GUI:SetNextWindowSize(100,100,GUI.SetCond_FirstUseEver)
        noticewindow.visible,noticewindow.open=GUI:Begin("",noticewindow.open,GUI.WindowFlags_NoTitleBar)
        if(noticewindow.visible)then
            --get window position
            local wposx,wposy=GUI:GetWindowPos()
            nwposx,nwposy=GUI:GetWindowPos()
            --phase1.1
            if((numPhase==1.1)and(#buffsloop==8))then
                local jobid=0
                for k,v in pairs(buffsloop) do
                    if(v[1]~=Player.job)then
                        if(v[2]==playerloop)then
                            jobid=v[1]
                            break
                        end
                    end
                end
                GUI:AddImage(pathJpm.."\\resources\\icon\\job\\"..GetJobName(jobid)..".png",wposx+10,wposy+10,wposx+60,wposy+60)
                if(not(isLoopCall))then
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\job\\"..jobid..".wav).PlaySync()","w"):close()
                    isLoopCall=true
                end
            end
            --phase1.2 pantokrator call swap
            if((numPhase==1.2)and(checkPant==false))then
                if(#buffspant==8)then
                    for k,v in pairs(jobpant) do
                        for key,value in pairs(buffspant) do
                            if((value[1]==v)and(value[2]==playerpantid))then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap.wav).PlaySync()","w"):close()
                                checkPant=true
                            end
                        end
                    end
                end
            end
            --phase2.1 show pos you should be placed
            if((numPhase==2.1)or(numPhase==2.2))then
                if((#leftside==4)and(#rightside==4))then
                    for k,v in pairs(leftside) do
                        if(v[1]==Player.job)then
                            if(v[2]==416)then
                                if(glitch==3427)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\circle.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\1.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\Approach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                elseif(glitch==3428)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\circle.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\1.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\DontApproach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                end
                            elseif(v[2]==419)then
                                if(glitch==3427)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\cross.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\2.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\Approach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                elseif(glitch==3428)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\cross.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\2.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\DontApproach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                end
                            elseif(v[2]==417)then
                                if(glitch==3427)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\triangle.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\3.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\Approach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                elseif(glitch==3428)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\triangle.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\3.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\DontApproach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                end
                            elseif(v[2]==418)then
                                if(glitch==3427)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\square.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\4.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\Approach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                elseif(glitch==3428)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\square.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\4.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\DontApproach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                end
                            end
                        end
                    end
                    for k,v in pairs(rightside) do
                        if(v[1]==Player.job)then
                            if(v[2]==416)then
                                if(glitch==3427)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\circle.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\1.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\Approach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                elseif(glitch==3428)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\circle.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\4.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\DontApproach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                end
                            elseif(v[2]==419)then
                                if(glitch==3427)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\cross.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\2.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\Approach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                elseif(glitch==3428)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\cross.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\3.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\DontApproach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                end
                            elseif(v[2]==417)then
                                if(glitch==3427)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\triangle.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\3.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\Approach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                elseif(glitch==3428)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\triangle.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\2.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\DontApproach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                end
                            elseif(v[2]==418)then
                                if(glitch==3427)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\square.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\4.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\Approach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                elseif(glitch==3428)then
                                    GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\square.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\1.png",wposx+110,wposy+10,wposx+160,wposy+60)
                                    GUI:AddImage(pathJpm.."\\resources\\image\\DontApproach.png",wposx+160,wposy+10,wposx+210,wposy+60)
                                end
                            end
                        end
                    end
                end
            end
            --phase2.1 swap call
            if(numPhase==2.1)then
                if((replaceMarker==416)and(glitch==3428))then
                    --swap circle
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap_circle.wav).PlaySync()","w"):close()
                    numPhase=2.2
                    previoustime=ml_global_information.Now
                end
                if((replaceMarker==419)and(glitch==3428))then
                    --swap cross
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap_cross.wav).PlaySync()","w"):close()
                    numPhase=2.2
                    previoustime=ml_global_information.Now
                end
                if((replaceMarker==419)and(glitch==3427))then
                    --swap cross
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap_cross.wav).PlaySync()","w"):close()
                    numPhase=2.2
                    previoustime=ml_global_information.Now
                end
                if((replaceMarker==417)and(glitch==3428))then
                    --swap triangle
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap_triangle.wav).PlaySync()","w"):close()
                    numPhase=2.2
                end
                if((replaceMarker==417)and(glitch==3427))then
                    --swap triangle
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap_triangle.wav).PlaySync()","w"):close()
                    numPhase=2.2
                    previoustime=ml_global_information.Now
                end
                if((replaceMarker==418)and(glitch==3428))then
                    --swap square
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap_square.wav).PlaySync()","w"):close()
                    numPhase=2.2
                    previoustime=ml_global_information.Now
                end
                if((replaceMarker==418)and(glitch==3427))then
                    --swap square
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap_square.wav).PlaySync()","w"):close()
                    numPhase=2.2
                    previoustime=ml_global_information.Now
                end
                if(replaceMarker==1000)then
                    --no swap
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\noswap.wav).PlaySync()","w"):close()
                    numPhase=2.2
                    previoustime=ml_global_information.Now
                end
            end
            --phase2.2 show swap marker
            if(numPhase==2.2)then
                if((replaceMarker==416)and(glitch==3428))then
                    --swap circle
                    GUI:AddImage(pathJpm.."\\resources\\image\\circle.png",wposx+10,wposy+60,wposx+60,wposy+110)
                end
                if((replaceMarker==419)and(glitch==3428))then
                    ---swap cross
                    GUI:AddImage(pathJpm.."\\resources\\image\\cross.png",wposx+10,wposy+60,wposx+60,wposy+110)
                end
                if((replaceMarker==419)and(glitch==3427))then
                    --swap cross
                    GUI:AddImage(pathJpm.."\\resources\\image\\cross.png",wposx+10,wposy+60,wposx+60,wposy+110)
                end
                if((replaceMarker==417)and(glitch==3428))then
                    --swap triangle
                    GUI:AddImage(pathJpm.."\\resources\\image\\triangle.png",wposx+10,wposy+60,wposx+60,wposy+110)
                end
                if((replaceMarker==417)and(glitch==3427))then
                    --swap triangle
                    GUI:AddImage(pathJpm.."\\resources\\image\\triangle.png",wposx+10,wposy+60,wposx+60,wposy+110)
                end
                if((replaceMarker==418)and(glitch==3428))then
                    --swap square
                    GUI:AddImage(pathJpm.."\\resources\\image\\square.png",wposx+10,wposy+60,wposx+60,wposy+110)
                end
                if((replaceMarker==418)and(glitch==3427))then
                    --swap square
                    GUI:AddImage(pathJpm.."\\resources\\image\\square.png",wposx+10,wposy+60,wposx+60,wposy+110)
                end
                if(replaceMarker==1000)then
                    --no swap
                    GUI:AddImage(pathJpm.."\\resources\\image\\Free.png",wposx+10,wposy+60,wposx+60,wposy+110)
                end
            end
            --phase3.1 sniper cannon call
            if(numPhase==3.1)then
                local countcanon=0
                for k,v in pairs(jobcanon) do
                    if(v[2]~=0)then
                        countcanon=countcanon+1
                    end
                end
                if(countcanon==6)then
                    local count=1
                    if((playercannonid==0)or(playercannonid==3426))then
                        for k,v in pairs(jobcanon) do
                            if(v[2]==playercannonid)then
                                if(v[1]==Player.job)then
                                    break
                                else
                                    count=count+1
                                end
                            end
                        end
                        if(count==1)then
                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\share_left1.wav).PlaySync()","w"):close()
                            numPhase=3.2
                            previoustime=ml_global_information.Now
                        elseif(count==2)then
                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\share_left2.wav).PlaySync()","w"):close()
                            numPhase=3.2
                            previoustime=ml_global_information.Now
                        end
                    elseif(playercannonid==3425)then
                        for k,v in pairs(jobcanon) do
                            if(v[2]==playercannonid)then
                                if(v[1]==Player.job)then
                                    break
                                else
                                    count=count+1
                                end
                            end
                        end
                        if(count==1)then
                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\spread_left1.wav).PlaySync()","w"):close()
                            numPhase=3.2
                            previoustime=ml_global_information.Now
                        elseif(count==2)then
                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\spread_left2.wav).PlaySync()","w"):close()
                            numPhase=3.2
                            previoustime=ml_global_information.Now
                        elseif(count==3)then
                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\spread_left3.wav).PlaySync()","w"):close()
                            numPhase=3.2
                            previoustime=ml_global_information.Now
                        elseif(count==4)then
                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\spread_left4.wav).PlaySync()","w"):close()
                            numPhase=3.2
                            previoustime=ml_global_information.Now
                        end
                    end
                end
            end
            --phase3.2 sniper cannon show jobs
            if(numPhase==3.2)then
                local index=0
                for k,v in pairs(jobcanon) do
                    if(v[2]==playercannonid)then
                        GUI:AddImage(pathJpm.."\\resources\\icon\\job\\"..GetJobName(v[1])..".png",wposx+10+50*index,wposy+10,wposx+60+50*index,wposy+60)
                        index=index+1
                    end
                end
            end
            --phase3.3
            if(numPhase==3.3)then
                if(#helloworld==8)then
                    local isBreak=false
                    for k,v in pairs(helloworld) do
                        if(v[2]==3436)then--stack
                            for key,value in pairs(helloworld) do
                                if(value[2]==3438)then--red
                                    if(value[1]==v[1])then
                                        GUI:AddImage(pathJpm.."\\resources\\image\\circle.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                        GUI:AddImage(pathJpm.."\\resources\\image\\circle_blue.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                        GUI:AddImage(pathJpm.."\\resources\\image\\DamageShare.png",wposx+10,wposy+60,wposx+60,wposy+110)
                                        GUI:AddImage(pathJpm.."\\resources\\image\\TargetAOE01.png",wposx+60,wposy+60,wposx+110,wposy+110)
                                        isBreak=true
                                        break
                                    end
                                elseif(value[2]==3439)then--blue
                                    if(value[1]==v[1])then
                                        GUI:AddImage(pathJpm.."\\resources\\image\\circle.png",wposx+10,wposy+10,wposx+60,wposy+60)
                                        GUI:AddImage(pathJpm.."\\resources\\image\\circle_blue.png",wposx+60,wposy+10,wposx+110,wposy+60)
                                        GUI:AddImage(pathJpm.."\\resources\\image\\TargetAOE01.png",wposx+10,wposy+60,wposx+60,wposy+110)
                                        GUI:AddImage(pathJpm.."\\resources\\image\\DamageShare.png",wposx+60,wposy+60,wposx+110,wposy+110)
                                        isBreak=true
                                        break
                                    end
                                end
                            end
                            if(isBreak)then
                                break
                            end
                        end
                    end
                end
            end
            --phase3.4 over sanmple call
            if(numPhase==3.4)then
                local countoversampled=0
                for k,v in pairs(joboversampled) do
                    if(v[2]~=0)then
                        countoversampled=countoversampled+1
                    end
                end
                if(countoversampled==3)then
                    if(isOverSampledCross)then
                        local countoversampledDPS=0--count the number of oversampled in DPS
                        local indexoversampledDPS={}
                        for k,v in pairs(joboversampled) do
                            if(v[2]~=0)then
                                FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",検知対象="..GetJobName(v[1]).."\n",true)
                                for i=1,#joboversampledcross do
                                    if(v[1]==joboversampledcross[i])then
                                        countoversampledDPS=countoversampledDPS+1
                                        indexoversampledDPS[#indexoversampledDPS+1]=i
                                    end
                                end
                            end
                        end
                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",DPSについた検知の数="..countoversampledDPS.."\n",true)
                        for i=1,#indexoversampledDPS do
                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",indexoversampledDPS["..i.."]="..indexoversampledDPS[i].."\n",true)
                        end
                        if(omegaoversampled==31595)then
                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",ボス検知、右\n",true)
                            --right
                            if(joboversampledcross[1]==Player.job)then--D1
                                FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",Player=D1\n",true)
                                if(playeroversampledid==0)then
                                    FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",Player=無職\n",true)
                                    --free
                                    if(countoversampledDPS==0)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay"
                                        previoustime=ml_global_information.Now
                                    end
                                    if(countoversampledDPS==1)then
                                        local index=0
                                        for i=1,#indexoversampledDPS do
                                            index=indexoversampledDPS[i]
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index="..index.."\n",true)
                                        if(index==2)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap"
                                            previoustime=ml_global_information.Now
                                        else
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==2)then
                                        local index1=0
                                        local index2=0
                                        for i=1,#indexoversampledDPS do
                                            if((index1==0)and(index2==0))then
                                                index1=indexoversampledDPS[i]
                                            elseif(index1~=0)then
                                                index2=indexoversampledDPS[i]
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index1="..index1..",index2="..index2.."\n",true)
                                        if((index1==2)and(index2==3))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        elseif((index1==2)and(index2==4))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap"
                                            previoustime=ml_global_information.Now
                                        elseif((index1~=2)and(index2~=2))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==3)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="swap"
                                        previoustime=ml_global_information.Now
                                    end
                                else
                                    FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",Player=検知\n",true)
                                    --oversampled
                                    if(countoversampledDPS==1)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_north.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay north"
                                        previoustime=ml_global_information.Now
                                    elseif(countoversampledDPS==2)then
                                        local index=0
                                        for i=1,#indexoversampledDPS do
                                            if(indexoversampledDPS[i]~=1)then
                                                index=indexoversampledDPS[i]
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index="..index.."\n",true)
                                        if(index==2)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_north.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay north"
                                            previoustime=ml_global_information.Now
                                        elseif(index==3)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_swap_left.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap left"
                                            previoustime=ml_global_information.Now
                                        elseif(index==4)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_north.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay north"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==3)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_south.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay south"
                                        previoustime=ml_global_information.Now
                                    end
                                end
                            elseif(joboversampledcross[2]==Player.job)then--D2
                                FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",Player=D2\n",true)
                                if(playeroversampledid==0)then
                                    FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",Player=無職\n",true)
                                    --free
                                    if(countoversampledDPS==0)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay"
                                        previoustime=ml_global_information.Now
                                    end
                                    if(countoversampledDPS==1)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay"
                                        previoustime=ml_global_information.Now
                                    elseif(countoversampledDPS==2)then
                                        local index1=0
                                        local index2=0
                                        for i=1,#indexoversampledDPS do
                                            if((index1==0)and(index2==0))then
                                                index1=indexoversampledDPS[i]
                                            elseif(index1~=0)then
                                                index2=indexoversampledDPS[i]
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index1="..index1..",index2="..index2.."\n",true)
                                        if((index1==1)and(index2==3))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap"
                                            previoustime=ml_global_information.Now
                                        elseif((index1==1)and(index2==4))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        elseif((index1~=1)and(index2~=1))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==3)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay"
                                        previoustime=ml_global_information.Now
                                    end
                                else
                                    FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",Player=検知\n",true)
                                    --oversampled
                                    if(countoversampledDPS==1)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_swap_north.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="swap north"
                                        previoustime=ml_global_information.Now
                                    elseif(countoversampledDPS==2)then
                                        local index=0
                                        for i=1,#indexoversampledDPS do
                                            if(indexoversampledDPS[i]~=2)then
                                                index=indexoversampledDPS[i]
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index="..index.."\n",true)
                                        if(index==1)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_left.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay left"
                                            previoustime=ml_global_information.Now
                                        elseif(index==3)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_left.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay left"
                                            previoustime=ml_global_information.Now
                                        elseif(index==4)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_swap_north.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap north"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==3)then
                                        local index1=0
                                        local index2=0
                                        for i=1,#indexoversampledDPS do
                                            if(indexoversampledDPS[i]~=2)then
                                                if((index1==0)and(index2==0))then
                                                    index1=indexoversampledDPS[i]
                                                elseif(index1~=0)then
                                                    index2=indexoversampledDPS[i]
                                                end
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index1="..index1..",index2="..index2.."\n",true)
                                        if(index1==1)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_left.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay left"
                                            previoustime=ml_global_information.Now
                                        elseif(index1~=1)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_swap_south.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap south"
                                            previoustime=ml_global_information.Now
                                        end
                                    end
                                end
                            end
                        elseif(omegaoversampled==31596)then
                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",ボス検知、左\n",true)
                            --left
                            if(joboversampledcross[1]==Player.job)then--D1
                                FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",Player=D1\n",true)
                                if(playeroversampledid==0)then
                                    --free
                                    if(countoversampledDPS==0)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay"
                                        previoustime=ml_global_information.Now
                                    end
                                    if(countoversampledDPS==1)then
                                        local index=0
                                        for i=1,#indexoversampledDPS do
                                            index=indexoversampledDPS[i]
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index="..index.."\n",true)
                                        if(index==2)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap"
                                            previoustime=ml_global_information.Now
                                        else
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==2)then
                                        local index1=0
                                        local index2=0
                                        for i=1,#indexoversampledDPS do
                                            if((index1==0)and(index2==0))then
                                                index1=indexoversampledDPS[i]
                                            elseif(index1~=0)then
                                                index2=indexoversampledDPS[i]
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index1="..index1..",index2="..index2.."\n",true)
                                        if((index1==2)and(index2==3))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        elseif((index1==2)and(index2==4))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap"
                                            previoustime=ml_global_information.Now
                                        elseif((index1~=2)and(index2~=2))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==3)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="swap"
                                        previoustime=ml_global_information.Now
                                    end
                                else
                                    --oversampled
                                    if(countoversampledDPS==1)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_north.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay north"
                                        previoustime=ml_global_information.Now
                                    elseif(countoversampledDPS==2)then
                                        local index=0
                                        for i=1,#indexoversampledDPS do
                                            if(indexoversampledDPS[i]~=1)then
                                                index=indexoversampledDPS[i]
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index="..index.."\n",true)
                                        if(index==2)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_north.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay north"
                                            previoustime=ml_global_information.Now
                                        elseif(index==3)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_swap_right.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap right"
                                            previoustime=ml_global_information.Now
                                        elseif(index==4)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_north.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay north"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==3)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_south.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay south"
                                        previoustime=ml_global_information.Now
                                    end
                                end
                            elseif(joboversampledcross[2]==Player.job)then--D2
                                FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",Player=D2\n",true)
                                if(playeroversampledid==0)then
                                    --free
                                    if(countoversampledDPS==0)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay"
                                        previoustime=ml_global_information.Now
                                    end
                                    if(countoversampledDPS==1)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay"
                                        previoustime=ml_global_information.Now
                                    elseif(countoversampledDPS==2)then
                                        local index1=0
                                        local index2=0
                                        for i=1,#indexoversampledDPS do
                                            if((index1==0)and(index2==0))then
                                                index1=indexoversampledDPS[i]
                                            elseif(index1~=0)then
                                                index2=indexoversampledDPS[i]
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index1="..index1..",index2="..index2.."\n",true)
                                        if((index1==1)and(index2==3))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\swap.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap"
                                            previoustime=ml_global_information.Now
                                        elseif((index1==1)and(index2==4))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        elseif((index1~=1)and(index2~=1))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==3)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\stay.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="stay"
                                        previoustime=ml_global_information.Now
                                    end
                                else
                                    --oversampled
                                    if(countoversampledDPS==1)then
                                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_swap_north.wav).PlaySync()","w"):close()
                                        numPhase=3.5
                                        oversampledcross="swap north"
                                        previoustime=ml_global_information.Now
                                    elseif(countoversampledDPS==2)then
                                        local index=0
                                        for i=1,#indexoversampledDPS do
                                            if(indexoversampledDPS[i]~=2)then
                                                index=indexoversampledDPS[i]
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index="..index.."\n",true)
                                        if(index==1)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_right.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay right"
                                            previoustime=ml_global_information.Now
                                        elseif(index==3)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_right.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay right"
                                            previoustime=ml_global_information.Now
                                        elseif(index==4)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_swap_north.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap north"
                                            previoustime=ml_global_information.Now
                                        end
                                    elseif(countoversampledDPS==3)then
                                        local index1=0
                                        local index2=0
                                        for i=1,#indexoversampledDPS do
                                            if(indexoversampledDPS[i]~=2)then
                                                if((index1==0)and(index2==0))then
                                                    index1=indexoversampledDPS[i]
                                                elseif(index1~=0)then
                                                    index2=indexoversampledDPS[i]
                                                end
                                            end
                                        end
                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",index1="..index1..",index2="..index2.."\n",true)
                                        if(index1==1)then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_noswap_right.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="stay right"
                                            previoustime=ml_global_information.Now
                                        elseif((index1~=1)and(index2~=1))then
                                            io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled_swap_south.wav).PlaySync()","w"):close()
                                            numPhase=3.5
                                            oversampledcross="swap south"
                                            previoustime=ml_global_information.Now
                                        end
                                    end
                                end
                            end
                        end
                    else
                        local count=1
                        if(playeroversampledid==0)then
                            for k,v in pairs(joboversampled) do
                                if(v[2]==0)then
                                    if(v[1]==Player.job)then
                                        break
                                    else
                                        count=count+1
                                    end
                                end
                            end
                            if(count==1)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\free1.wav).PlaySync()","w"):close()
                                numPhase=3.5
                                previoustime=ml_global_information.Now
                            elseif(count==2)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\free2.wav).PlaySync()","w"):close()
                                numPhase=3.5
                                previoustime=ml_global_information.Now
                            elseif(count==3)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\free3.wav).PlaySync()","w"):close()
                                numPhase=3.5
                                previoustime=ml_global_information.Now
                            elseif(count==4)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\free4.wav).PlaySync()","w"):close()
                                numPhase=3.5
                                previoustime=ml_global_information.Now
                            elseif(count==5)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\free5.wav).PlaySync()","w"):close()
                                numPhase=3.5
                                previoustime=ml_global_information.Now
                            end
                        else
                            for k,v in pairs(joboversampled) do
                                if(v[2]~=0)then
                                    if(v[1]==Player.job)then
                                        break
                                    else
                                        count=count+1
                                    end
                                end
                            end
                            if(count==1)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled1.wav).PlaySync()","w"):close()
                                numPhase=3.5
                                previoustime=ml_global_information.Now
                            elseif(count==2)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled2.wav).PlaySync()","w"):close()
                                numPhase=3.5
                                previoustime=ml_global_information.Now
                            elseif(count==3)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\oversampled3.wav).PlaySync()","w"):close()
                                numPhase=3.5
                                previoustime=ml_global_information.Now
                            end
                        end
                    end
                end
            end
            --phase3.5 over sanmple show jobs
            if(numPhase==3.5)then
                if(isOverSampledCross)then
                    --debug
                    d("oversampledcross="..oversampledcross)
                    --cross
                    if(oversampledcross=="stay")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Free.png",wposx+10,wposy+10,wposx+60,wposy+60)
                    elseif(oversampledcross=="stay left")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Free.png",wposx+10,wposy+10,wposx+60,wposy+60)
                        GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+60,wposy+10,wposx+110,wposy+60)
                    elseif(oversampledcross=="stay right")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Free.png",wposx+10,wposy+10,wposx+60,wposy+60)
                        GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+60,wposy+10,wposx+110,wposy+60)
                    elseif(oversampledcross=="stay north")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Free.png",wposx+10,wposy+10,wposx+60,wposy+60)
                        GUI:AddImage(pathJpm.."\\resources\\image\\up.png",wposx+60,wposy+10,wposx+110,wposy+60)
                    elseif(oversampledcross=="stay south")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Free.png",wposx+10,wposy+10,wposx+60,wposy+60)
                        GUI:AddImage(pathJpm.."\\resources\\image\\down.png",wposx+60,wposy+10,wposx+110,wposy+60)
                    elseif(oversampledcross=="swap")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Switch.png",wposx+10,wposy+10,wposx+60,wposy+60)
                    elseif(oversampledcross=="swap left")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Switch.png",wposx+10,wposy+10,wposx+60,wposy+60)
                        GUI:AddImage(pathJpm.."\\resources\\image\\left.png",wposx+60,wposy+10,wposx+110,wposy+60)
                    elseif(oversampledcross=="swap right")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Switch.png",wposx+10,wposy+10,wposx+60,wposy+60)
                        GUI:AddImage(pathJpm.."\\resources\\image\\right.png",wposx+60,wposy+10,wposx+110,wposy+60)
                    elseif(oversampledcross=="swap north")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Switch.png",wposx+10,wposy+10,wposx+60,wposy+60)
                        GUI:AddImage(pathJpm.."\\resources\\image\\up.png",wposx+60,wposy+10,wposx+110,wposy+60)
                    elseif(oversampledcross=="swap south")then
                        GUI:AddImage(pathJpm.."\\resources\\image\\Switch.png",wposx+10,wposy+10,wposx+60,wposy+60)
                        GUI:AddImage(pathJpm.."\\resources\\image\\down.png",wposx+60,wposy+10,wposx+110,wposy+60)
                    end
                else
                    --default
                    local index=0
                    if(playeroversampledid==0)then
                        for k,v in pairs(joboversampled) do
                            if(v[2]==0)then
                                GUI:AddImage(pathJpm.."\\resources\\icon\\job\\"..GetJobName(v[1])..".png",wposx+10+50*index,wposy+10,wposx+60+50*index,wposy+60)
                                index=index+1
                            end
                        end
                    else
                        for k,v in pairs(joboversampled) do
                            if(v[2]~=0)then
                                GUI:AddImage(pathJpm.."\\resources\\icon\\job\\"..GetJobName(v[1])..".png",wposx+10+50*index,wposy+10,wposx+60+50*index,wposy+60)
                                index=index+1
                            end
                        end
                    end
                end
            end
            --phase5.1
            if((numPhase==5.1)and(#deltatether==10))then
                if(playerdeltatether==3440)then--near
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\deltatether_near.wav).PlaySync()","w"):close()
                    numPhase=5.2
                    previoustime=ml_global_information.Now
                end
                if(playerdeltatether==3504)then--far
                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\deltatether_far.wav).PlaySync()","w"):close()
                    numPhase=5.2
                    previoustime=ml_global_information.Now
                end
            end
            --phase5.2
            if(numPhase==5.2)then
                if(playerhelloworld==3442)then--helloworld near
                    GUI:AddImage(pathJpm.."\\resources\\image\\helloworld_near.png",wposx+10,wposy+10,wposx+60,wposy+60)
                end
                if(playerhelloworld==3443)then--helloworld far
                    GUI:AddImage(pathJpm.."\\resources\\image\\helloworld_far.png",wposx+10,wposy+10,wposx+60,wposy+60)
                end
                --if(playerdynamis==1)then
                --    GUI:AddImage(pathJpm.."\\resources\\image\\dynamis1.png",wposx+10,wposy+60,wposx+60,wposy+110)
                --end
                --if((math.round(TimeSince(previoustimedelta)/1000,1)==3)and(isDeltaNotice==false))then
                --    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\count3.wav).PlaySync()","w"):close()
                --    isDeltaNotice=true
                --end
                --call hello world near or far, receive helloworld near
                if((math.round(TimeSince(previoustime)/1000,0)==32)and(isDeltaHelloWorldNotice==false))then
                    if(playerhelloworld==3442)then--helloworld near
                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\helloworld_near.wav).PlaySync()","w"):close()
                        isDeltaHelloWorldNotice=true
                    end
                    if(playerhelloworld==3443)then--helloworld far
                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\helloworld_far.wav).PlaySync()","w"):close()
                        isDeltaHelloWorldNotice=true
                    end
                    if(playerhelloworld==0)then--receive helloworld near
                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\receive_helloworld_near.wav).PlaySync()","w"):close()
                        isDeltaHelloWorldNotice=true
                    end
                end
            end
            --phase5.3
            if(((numPhase==5.3)and(#sigmadebuff==10))or((numPhase==5.4)and(#sigmadebuff==10)))then
                if(glitch==3427)then--middle
                    GUI:AddImage(pathJpm.."\\resources\\image\\Approach.png",wposx+10,wposy+10,wposx+60,wposy+60)
                end
                if(glitch==3428)then--remote
                    GUI:AddImage(pathJpm.."\\resources\\image\\DontApproach.png",wposx+10,wposy+10,wposx+60,wposy+60)
                end
                if(playerhelloworld==3442)then--helloworld near
                    GUI:AddImage(pathJpm.."\\resources\\image\\helloworld_near.png",wposx+60,wposy+10,wposx+110,wposy+60)
                end
                if(playerhelloworld==3443)then--helloworld far
                    GUI:AddImage(pathJpm.."\\resources\\image\\helloworld_far.png",wposx+60,wposy+10,wposx+110,wposy+60)
                end
                --if(playerdynamis==1)then
                --    GUI:AddImage(pathJpm.."\\resources\\image\\dynamis1.png",wposx+10,wposy+60,wposx+60,wposy+110)
                --end
            end
            --phase5.3
            if((numPhase==5.3)and(#sigmaplaystation==8)and(#sigmatarget==6))then
                local countcircle=0
                local counttriangle=0
                local countsquare=0
                local countcross=0
                for k,v in pairs(sigmaplaystation) do
                    if(v[2]==416)then
                        for key,value in pairs(sigmatarget) do
                            if(value[1]==v[1])then
                                countcircle=countcircle+1
                            end
                        end
                    end
                    if(v[2]==417)then
                        for key,value in pairs(sigmatarget) do
                            if(value[1]==v[1])then
                                counttriangle=counttriangle+1
                            end
                        end
                    end
                    if(v[2]==418)then
                        for key,value in pairs(sigmatarget) do
                            if(value[1]==v[1])then
                                countsquare=countsquare+1
                            end
                        end
                    end
                    if(v[2]==419)then
                        for key,value in pairs(sigmatarget) do
                            if(value[1]==v[1])then
                                countcross=countcross+1
                            end
                        end
                    end
                end
                local sum=countcircle+counttriangle+countsquare+countcross
                if(sum==6)then
                    if(playersigmaplaystation==416)then--circle
                        if(playersigmatarget==0)then
                            --not targeted
                            if(countcircle==1)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\right_up.wav).PlaySync()","w"):close()
                                numPhase=5.4
                                previoustime=ml_global_information.Now
                            end
                        else
                            --targeted
                            if(countcircle==1)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\left_down.wav).PlaySync()","w"):close()
                                numPhase=5.4
                                previoustime=ml_global_information.Now
                            elseif(countcircle==2)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\vertical.wav).PlaySync()","w"):close()
                                numPhase=5.4
                                previoustime=ml_global_information.Now
                            end
                        end
                    end
                    if(playersigmaplaystation==417)then--triangle
                        if(playersigmatarget==0)then
                            --not targeted
                            if(counttriangle==1)then
                                if(countsquare==1)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\right_up.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                elseif(countsquare==2)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\left_up.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                end
                            end
                        else
                            --targeted
                            if(counttriangle==1)then
                                if(countsquare==1)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\left_down.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                elseif(countsquare==2)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\right_down.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                end
                            elseif(counttriangle==2)then
                                if(countsquare==1)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\horizontal.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                elseif(countsquare==2)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\vertical.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                end
                            end
                        end
                    end
                    if(playersigmaplaystation==418)then--square
                        if(playersigmatarget==0)then
                            --not targeted
                            if(countsquare==1)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\left_up.wav).PlaySync()","w"):close()
                                numPhase=5.4
                                previoustime=ml_global_information.Now
                            end
                        else
                            --targeted
                            if(countsquare==1)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\right_down.wav).PlaySync()","w"):close()
                                numPhase=5.4
                                previoustime=ml_global_information.Now
                            elseif(countsquare==2)then
                                io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\horizontal.wav).PlaySync()","w"):close()
                                numPhase=5.4
                                previoustime=ml_global_information.Now
                            end
                        end
                    end
                    if(playersigmaplaystation==419)then--cross
                        if(playersigmatarget==0)then
                            --not targeted
                            if(countcross==1)then
                                if(countcircle==1)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\left_up.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                elseif(countcircle==2)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\right_up.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                end
                            end
                        else
                            --targeted
                            if(countcross==1)then
                                if(countcircle==1)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\right_down.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                elseif(countcircle==2)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\left_down.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                end
                            elseif(countcross==2)then
                                if(countcircle==1)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\vertical.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                elseif(countcircle==2)then
                                    io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\horizontal.wav).PlaySync()","w"):close()
                                    numPhase=5.4
                                    previoustime=ml_global_information.Now
                                end
                            end
                        end
                    end
                end
            end
            --phase5.4
            --[[
            if(numPhase==5.4)then
                if((playerdynamis==1)and(playerhelloworld==0))then
                    if((math.round(TimeSince(previoustime)/1000,0)==19)and(isSigmaTargetNotice==false))then
                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\push_target.wav).PlaySync()","w"):close()
                        isSigmaTargetNotice=true
                        isPushSigma=true
                        SendTextCommand("/mk attack <me>")
                        self.used=true
                    end
                else
                    if((math.round(TimeSince(previoustime)/1000,0)==19)and(isSigmaTargetNotice==false))then
                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\not_push_target.wav).PlaySync()","w"):close()
                        isSigmaTargetNotice=true
                        isPushSigma=false
                    end
                end
                --call hello world near or far
                if((math.round(TimeSince(previoustime)/1000,0)==23)and(isSigmaHelloWorldNotice==false))then
                    if(playerhelloworld==3442)then--helloworld near
                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\helloworld_near_sigma.wav).PlaySync()","w"):close()
                        isSigmaHelloWorldNotice=true
                    end
                    if(playerhelloworld==3443)then--helloworld far
                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\helloworld_far_sigma.wav).PlaySync()","w"):close()
                        isSigmaHelloWorldNotice=true
                    end
                    if((playerhelloworld==0)and(isPushSigma==false))then--free
                        io.popen("powershell -command -(New-Object Media.SoundPlayer "..pathJpm.."\\resources\\wav\\receive_helloworld_sigma.wav).PlaySync()","w"):close()
                        isSigmaHelloWorldNotice=true
                    end
                end
            end
            ]]
        end
        GUI:End()
    end
end

--main window
function main.Draw(event,ticks)
    if(main.open)then
        GUI:SetNextWindowSize(100,100,GUI.SetCond_FirstUseEver)
        main.visible,main.open=GUI:Begin("Job Priority Manager",main.open)
        if(main.visible)then
            --detect phase TOP
            detectPhaseTOP()
            --load default party position
            if((isAutoload==true)and(partyposwindow.open==false)and(partyposphase2window.open==false)and(pantokratorwindow.open==false))then
                partypos=FileLoad(pathJpm.."\\resources\\setting\\priority.txt")
                jobf=FileLoad(pathJpm.."\\resources\\setting\\priorityleft.txt")
                jobm=FileLoad(pathJpm.."\\resources\\setting\\priorityright.txt")
                jobpant=FileLoad(pathJpm.."\\resources\\setting\\pantokrator.txt")
            end
            --notice window
            if(isShowNoticeWindow)then
                noticewindow.open=true
            else
                noticewindow.open=false
            end
            if(isLockNoticeWindow)then
                if((nwposx~=nil)and(nwposy~=nil))then
                    GUI:SetWindowPos("noticewindow",nwposx,nwposy,GUI.SetCond_Always)
                end
            end
            --get window position
            local wposx,wposy=GUI:GetWindowPos()
            if(GUI:FreeButton("set party position",wposx+10,wposy+30))then
                msgCautionPPW=""
                partyposwindow.open=true
            end
            --if(GUI:FreeButton("",wposx+150,wposy+30))then
            --end
            local recordCheckLog,recordCheckLogPressed=GUI:Checkbox("record battle data logs",defaultRecordCheck)
            if(recordCheckLogPressed)then
                if(recordCheckLog)then
                    defaultRecordCheck=true
                    local val={isLockNotice=isLockNoticeWindow,isShowNotice=isShowNoticeWindow,recordLog=defaultRecordCheck,owcOrderTDH=owcOrderTDH}
                    FileSave(pathJpm.."\\resources\\setting\\value.txt",val)
                else
                    defaultRecordCheck=false
                    local val={isLockNotice=isLockNoticeWindow,isShowNotice=isShowNoticeWindow,recordLog=defaultRecordCheck,owcOrderTDH=owcOrderTDH}
                    FileSave(pathJpm.."\\resources\\setting\\value.txt",val)
                end
            end
            local recordCheckNotice,recordCheckNoticePressed=GUI:Checkbox("show notice window",isShowNoticeWindow)
            if(recordCheckNoticePressed)then
                if(recordCheckNotice)then
                    isShowNoticeWindow=true
                    local val={isLockNotice=isLockNoticeWindow,isShowNotice=isShowNoticeWindow,recordLog=defaultRecordCheck,owcOrderTDH=owcOrderTDH}
                    FileSave(pathJpm.."\\resources\\setting\\value.txt",val)
                else
                    isShowNoticeWindow=false
                    local val={isLockNotice=isLockNoticeWindow,isShowNotice=isShowNoticeWindow,recordLog=defaultRecordCheck,owcOrderTDH=owcOrderTDH}
                    FileSave(pathJpm.."\\resources\\setting\\value.txt",val)
                end
            end
            local recordCheckNoticeLock,recordCheckNoticeLockPressed=GUI:Checkbox("lock notice window position",isLockNoticeWindow)
            if(recordCheckNoticeLockPressed)then
                if(recordCheckNoticeLock)then
                    isLockNoticeWindow=true
                    local val={isLockNotice=isLockNoticeWindow,isShowNotice=isShowNoticeWindow,recordLog=defaultRecordCheck,owcOrderTDH=owcOrderTDH}
                    FileSave(pathJpm.."\\resources\\setting\\value.txt",val)
                else
                    isLockNoticeWindow=false
                    local val={isLockNotice=isLockNoticeWindow,isShowNotice=isShowNoticeWindow,recordLog=defaultRecordCheck,owcOrderTDH=owcOrderTDH}
                    FileSave(pathJpm.."\\resources\\setting\\value.txt",val)
                end
            end
            --detect incombat
            local pml=EntityList.myparty
            if(pml)then
                local i,e=next(pml)
                if((i~=nil)and(e~=nil))then
                    local entity=EntityList:Get(e.id)
                    if(entity)then
                        if(entity.incombat)then
                            --incombat
                            GUI:Text("incombat...   phase="..numPhase.."   time="..math.round(TimeSince(previoustime)/1000,0))
                            if(not(isIncombat))then
                                previoustime=ml_global_information.Now
                                isIncombat=true
                                --
                                if(defaultRecordCheck)then
                                    currentFileName=os.date("%Y-%m-%d %H-%M-%S")
                                    FileWrite(pathJpm.."\\log\\buff\\"..currentFileName..".txt","time,job,buffid,buffname,duration,ownerid,ownername\n",true)
                                    FileWrite(pathJpm.."\\log\\marker\\"..currentFileName..".txt","time,markerid,entityid,jobid,job\n",true)
                                    FileWrite(pathJpm.."\\log\\cast\\"..currentFileName..".txt","time,chartype,entityid,entityname,channelingid,castingid,casttime,x,y,z,heading,channeltime\n",true)
                                    FileWrite(pathJpm.."\\log\\entity\\"..currentFileName..".txt","time,chartype,entityid,contentid,modelid,entityname,x,y,z,heading\n",true)
                                    FileWrite(pathJpm.."\\log\\entity all\\"..currentFileName..".txt","time,chartype,entityid,contentid,modelid,entityname,x,y,z,heading\n",true)
                                end
                                --for phase3.1
                                jobcanon={}
                                for k,v in pairs(partypos) do
                                    if(k==1)then
                                        jobcanon[2]={v[2],0}
                                    end
                                    if(k==2)then
                                        jobcanon[3]={v[2],0}
                                    end
                                    if(k==3)then
                                        jobcanon[1]={v[2],0}
                                    end
                                    if(k==4)then
                                        jobcanon[8]={v[2],0}
                                    end
                                    if(k==5)then
                                        jobcanon[4]={v[2],0}
                                    end
                                    if(k==6)then
                                        jobcanon[5]={v[2],0}
                                    end
                                    if(k==7)then
                                        jobcanon[6]={v[2],0}
                                    end
                                    if(k==8)then
                                        jobcanon[7]={v[2],0}
                                    end
                                end
                                --for phase3.4
                                joboversampled={}
                                if(owcOrderTDH)then
                                    for k,v in pairs(partypos) do--TDH
                                        if(k==1)then
                                            joboversampled[1]={v[2],0}
                                        end
                                        if(k==2)then
                                            joboversampled[2]={v[2],0}
                                        end
                                        if(k==3)then
                                            joboversampled[7]={v[2],0}
                                        end
                                        if(k==4)then
                                            joboversampled[8]={v[2],0}
                                        end
                                        if(k==5)then
                                            joboversampled[3]={v[2],0}
                                        end
                                        if(k==6)then
                                            joboversampled[4]={v[2],0}
                                        end
                                        if(k==7)then
                                            joboversampled[5]={v[2],0}
                                        end
                                        if(k==8)then
                                            joboversampled[6]={v[2],0}
                                        end
                                    end
                                else
                                    for k,v in pairs(partypos) do--HTDH
                                        if(k==1)then
                                            joboversampled[2]={v[2],0}
                                        end
                                        if(k==2)then
                                            joboversampled[3]={v[2],0}
                                        end
                                        if(k==3)then
                                            joboversampled[1]={v[2],0}
                                        end
                                        if(k==4)then
                                            joboversampled[8]={v[2],0}
                                        end
                                        if(k==5)then
                                            joboversampled[4]={v[2],0}
                                        end
                                        if(k==6)then
                                            joboversampled[5]={v[2],0}
                                        end
                                        if(k==7)then
                                            joboversampled[6]={v[2],0}
                                        end
                                        if(k==8)then
                                            joboversampled[7]={v[2],0}
                                        end
                                    end
                                end
                            end
                        else
                            --not incombat
                            GUI:Text("wipe")
                            --
                            previoustime=0
                            --
                            markerinfo={}
                            bufflist1={}
                            bufflist2={}
                            bufflist3={}
                            bufflist4={}
                            bufflist5={}
                            bufflist6={}
                            bufflist7={}
                            bufflist8={}
                            castinglist={}
                            enemylist={}
                            allenemylist={}
                            isIncombat=false
                            --phase1.1
                            isLoopCall=false
                            buffsloop={}
                            playerloop=0
                            --phase1.2
                            buffspant={}
                            checkPant=false
                            playerpantid=0
                            --phase2.1
                            psf={}
                            psm={}
                            leftside={}
                            rightside={}
                            share={}
                            glitch=0
                            replaceMarker=0
                            --phase3.1
                            playercannonid=0
                            --phase3.3
                            helloworld={}
                            --phase3.4
                            playeroversampledid=0
                            --countoversampled=0
                            --phase3.4 oversample cross
                            omegaoversampled=0
                            oversampledcross=""
                            --phase5.1
                            playerdeltatether=0
                            playerhelloworld=0
                            deltatether={}
                            --phase5.2
                            previoustimedelta=0
                            isDeltaHelloWorldNotice=false
                            isDeltaNotice=false
                            --phase5.3
                            sigmadebuff={}
                            sigmaplaystation={}
                            sigmatarget={}
                            playersigmaplaystation=0
                            playersigmatarget=0
                            --phase5.4
                            isSigmaHelloWorldNotice=false
                            isSigmaTargetNotice=false
                            isPushSigma=false
                            --phase5
                            playerdynamis=0
                            --reset phase
                            numPhase=0
                        end
                    end
                else
                    GUI:Text("there are no party members")
                end
            end
            --record party members' buffs
            if(defaultRecordCheck)then
                local pmlist=EntityList.myparty
                if(pmlist)then
                    local i,e=next(pmlist)
                    local countPml=1
                    while((i~=nil)and(e~=nil))do
                        local entity=EntityList:Get(e.id)
                        if(entity)then
                            if(entity.incombat==true)then
                                if(countPml==1)then
                                    local ebuffs=entity.buffs
                                    if(ebuffs)then
                                        local index,buff=next(ebuffs)
                                        local tmpBufflist={}
                                        while((index~=nil)and(buff~=nil))do
                                            --phase1.1
                                            if(numPhase==1.1)then
                                                if(#buffsloop<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffsloop)))then
                                                            buffsloop[#buffsloop+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerloop=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase1.2
                                            if(numPhase==1.2)then
                                                if(#buffspant<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffspant)))then
                                                            buffspant[#buffspant+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerpantid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase2.1
                                            if(buff.id==3427)then--middle
                                                glitch=buff.id
                                            end
                                            if(buff.id==3428)then--remote
                                                glitch=buff.id
                                            end
                                            --phase3.1
                                            if(numPhase==3.1)then
                                                local count=0
                                                for k,v in pairs(jobcanon) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<6)then
                                                    if((buff.id==3425)or(buff.id==3426))then
                                                        for k,v in pairs(jobcanon) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playercannonid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.3
                                            if(numPhase==3.3)then
                                                if(#helloworld<8)then
                                                    if((buff.id==3436)or(buff.id==3437)or(buff.id==3438)or(buff.id==3439))then--stack,defamation,red,blue
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,helloworld)))then
                                                            helloworld[#helloworld+1]={entity.job,buff.id}
                                                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#helloworld="..#helloworld.."\n",true)
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.4
                                            if(numPhase==3.4)then
                                                local count=0
                                                for k,v in pairs(joboversampled) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<3)then
                                                    if((buff.id==3452)or(buff.id==3453))then
                                                        for k,v in pairs(joboversampled) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                                --countoversampled=countoversampled+1
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playeroversampledid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase5.1
                                            if(numPhase==5.1)then
                                                if(buff.id==3440)then--near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3440
                                                    end
                                                end
                                                if(buff.id==3504)then--far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3504
                                                    end
                                                end
                                                if(buff.id==3442)then--helloworld near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                            end
                                            --phase5.2
                                            if(numPhase==5.2)then
                                                if((buff.id==2534)and(math.round(buff.duration,1)==6.9))then
                                                    previoustimedelta=ml_global_information.Now
                                                end
                                                if(buff.id==3444)then
                                                    if(entity.job==Player.job)then
                                                        playerdynamis=1
                                                    end
                                                end
                                            end
                                            --phase5.3
                                            if(numPhase==5.3)then
                                                if(buff.id==3442)then--helloworld near
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                                if(buff.id==3427)then--middle
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                                if(buff.id==3428)then--remote
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                            end
                                            --
                                            local owner=EntityList:Get(buff.ownerid)
                                            local ownerid=0
                                            local ownername="nothing"
                                            if(owner)then
                                                ownerid=owner.id
                                                ownername=owner.name
                                            end
                                            --
                                            if(not(IsIncludedBuffTable(buff.id,buff.name,math.round(buff.duration,1),bufflist1)))then
                                                bufflist1[#bufflist1+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                                FileWrite(pathJpm.."\\log\\buff\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..GetJobName(entity.job)..","..buff.id..","..buff.name..","..math.round(buff.duration,1)..","..ownerid..","..ownername.."\n",true)
                                            end
                                            tmpBufflist[#tmpBufflist+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                            --
                                            index,buff=next(ebuffs,index)
                                        end
                                        local removeKey={}
                                        for k,v in pairs(bufflist1) do
                                            local flag=false
                                            for key,value in pairs(tmpBufflist) do
                                                if(value[1]==v[1])and(value[2]==v[2])then
                                                    flag=true
                                                    break
                                                end
                                            end
                                            if(not(flag))then
                                                removeKey[#removeKey+1]=k
                                            end
                                        end
                                        for k,v in pairs(removeKey) do
                                            table.remove(bufflist1,v)
                                        end
                                    end
                                end
                                if(countPml==2)then
                                    local ebuffs=entity.buffs
                                    if(ebuffs)then
                                        local index,buff=next(ebuffs)
                                        local tmpBufflist={}
                                        while((index~=nil)and(buff~=nil))do
                                            --phase1.1
                                            if(numPhase==1.1)then
                                                if(#buffsloop<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffsloop)))then
                                                            buffsloop[#buffsloop+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerloop=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase1.2
                                            if(numPhase==1.2)then
                                                if(#buffspant<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffspant)))then
                                                            buffspant[#buffspant+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerpantid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase2.1
                                            if(buff.id==3427)then--middle
                                                glitch=buff.id
                                            end
                                            if(buff.id==3428)then--remote
                                                glitch=buff.id
                                            end
                                            --phase3.1
                                            if(numPhase==3.1)then
                                                local count=0
                                                for k,v in pairs(jobcanon) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<6)then
                                                    if((buff.id==3425)or(buff.id==3426))then
                                                        for k,v in pairs(jobcanon) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playercannonid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.3
                                            if(numPhase==3.3)then
                                                if(#helloworld<8)then
                                                    if((buff.id==3436)or(buff.id==3437)or(buff.id==3438)or(buff.id==3439))then--stack,defamation,red,blue
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,helloworld)))then
                                                            helloworld[#helloworld+1]={entity.job,buff.id}
                                                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#helloworld="..#helloworld.."\n",true)
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.4
                                            if(numPhase==3.4)then
                                                local count=0
                                                for k,v in pairs(joboversampled) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<3)then
                                                    if((buff.id==3452)or(buff.id==3453))then
                                                        for k,v in pairs(joboversampled) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                                --countoversampled=countoversampled+1
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playeroversampledid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase5.1
                                            if(numPhase==5.1)then
                                                if(buff.id==3440)then--near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3440
                                                    end
                                                end
                                                if(buff.id==3504)then--far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3504
                                                    end
                                                end
                                                if(buff.id==3442)then--helloworld near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                            end
                                            --phase5.2
                                            if(numPhase==5.2)then
                                                if((buff.id==2534)and(math.round(buff.duration,1)==6.9))then
                                                    previoustimedelta=ml_global_information.Now
                                                end
                                                if(buff.id==3444)then
                                                    if(entity.job==Player.job)then
                                                        playerdynamis=1
                                                    end
                                                end
                                            end
                                            --phase5.3
                                            if(numPhase==5.3)then
                                                if(buff.id==3442)then--helloworld near
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                                if(buff.id==3427)then--middle
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                                if(buff.id==3428)then--remote
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                            end
                                            --
                                            local owner=EntityList:Get(buff.ownerid)
                                            local ownerid=0
                                            local ownername="nothing"
                                            if(owner)then
                                                ownerid=owner.id
                                                ownername=owner.name
                                            end
                                            --
                                            if(not(IsIncludedBuffTable(buff.id,buff.name,math.round(buff.duration,1),bufflist2)))then
                                                bufflist2[#bufflist2+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                                FileWrite(pathJpm.."\\log\\buff\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..GetJobName(entity.job)..","..buff.id..","..buff.name..","..math.round(buff.duration,1)..","..ownerid..","..ownername.."\n",true)
                                            end
                                            tmpBufflist[#tmpBufflist+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                            --
                                            index,buff=next(ebuffs,index)
                                        end
                                        local removeKey={}
                                        for k,v in pairs(bufflist2) do
                                            local flag=false
                                            for key,value in pairs(tmpBufflist) do
                                                if(value[1]==v[1])and(value[2]==v[2])then
                                                    flag=true
                                                    break
                                                end
                                            end
                                            if(not(flag))then
                                                removeKey[#removeKey+1]=k
                                            end
                                        end
                                        for k,v in pairs(removeKey) do
                                            table.remove(bufflist2,v)
                                        end
                                    end
                                end
                                if(countPml==3)then
                                    local ebuffs=entity.buffs
                                    if(ebuffs)then
                                        local index,buff=next(ebuffs)
                                        local tmpBufflist={}
                                        while((index~=nil)and(buff~=nil))do
                                            --phase1.1
                                            if(numPhase==1.1)then
                                                if(#buffsloop<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffsloop)))then
                                                            buffsloop[#buffsloop+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerloop=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase1.2
                                            if(numPhase==1.2)then
                                                if(#buffspant<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffspant)))then
                                                            buffspant[#buffspant+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerpantid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase2.1
                                            if(buff.id==3427)then--middle
                                                glitch=buff.id
                                            end
                                            if(buff.id==3428)then--remote
                                                glitch=buff.id
                                            end
                                            --phase3.1
                                            if(numPhase==3.1)then
                                                local count=0
                                                for k,v in pairs(jobcanon) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<6)then
                                                    if((buff.id==3425)or(buff.id==3426))then
                                                        for k,v in pairs(jobcanon) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playercannonid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.3
                                            if(numPhase==3.3)then
                                                if(#helloworld<8)then
                                                    if((buff.id==3436)or(buff.id==3437)or(buff.id==3438)or(buff.id==3439))then--stack,defamation,red,blue
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,helloworld)))then
                                                            helloworld[#helloworld+1]={entity.job,buff.id}
                                                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#helloworld="..#helloworld.."\n",true)
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.4
                                            if(numPhase==3.4)then
                                                local count=0
                                                for k,v in pairs(joboversampled) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<3)then
                                                    if((buff.id==3452)or(buff.id==3453))then
                                                        for k,v in pairs(joboversampled) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                                --countoversampled=countoversampled+1
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playeroversampledid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase5.1
                                            if(numPhase==5.1)then
                                                if(buff.id==3440)then--near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3440
                                                    end
                                                end
                                                if(buff.id==3504)then--far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3504
                                                    end
                                                end
                                                if(buff.id==3442)then--helloworld near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                            end
                                            --phase5.2
                                            if(numPhase==5.2)then
                                                if((buff.id==2534)and(math.round(buff.duration,1)==6.9))then
                                                    previoustimedelta=ml_global_information.Now
                                                end
                                                if(buff.id==3444)then
                                                    if(entity.job==Player.job)then
                                                        playerdynamis=1
                                                    end
                                                end
                                            end
                                            --phase5.3
                                            if(numPhase==5.3)then
                                                if(buff.id==3442)then--helloworld near
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                                if(buff.id==3427)then--middle
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                                if(buff.id==3428)then--remote
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                            end
                                            --
                                            local owner=EntityList:Get(buff.ownerid)
                                            local ownerid=0
                                            local ownername="nothing"
                                            if(owner)then
                                                ownerid=owner.id
                                                ownername=owner.name
                                            end
                                            --
                                            if(not(IsIncludedBuffTable(buff.id,buff.name,math.round(buff.duration,1),bufflist3)))then
                                                bufflist3[#bufflist3+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                                FileWrite(pathJpm.."\\log\\buff\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..GetJobName(entity.job)..","..buff.id..","..buff.name..","..math.round(buff.duration,1)..","..ownerid..","..ownername.."\n",true)
                                            end
                                            tmpBufflist[#tmpBufflist+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                            --
                                            index,buff=next(ebuffs,index)
                                        end
                                        local removeKey={}
                                        for k,v in pairs(bufflist3) do
                                            local flag=false
                                            for key,value in pairs(tmpBufflist) do
                                                if(value[1]==v[1])and(value[2]==v[2])then
                                                    flag=true
                                                    break
                                                end
                                            end
                                            if(not(flag))then
                                                removeKey[#removeKey+1]=k
                                            end
                                        end
                                        for k,v in pairs(removeKey) do
                                            table.remove(bufflist3,v)
                                        end
                                    end
                                end
                                if(countPml==4)then
                                    local ebuffs=entity.buffs
                                    if(ebuffs)then
                                        local index,buff=next(ebuffs)
                                        local tmpBufflist={}
                                        while((index~=nil)and(buff~=nil))do
                                            --phase1.1
                                            if(numPhase==1.1)then
                                                if(#buffsloop<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffsloop)))then
                                                            buffsloop[#buffsloop+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerloop=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase1.2
                                            if(numPhase==1.2)then
                                                if(#buffspant<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffspant)))then
                                                            buffspant[#buffspant+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerpantid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase2.1
                                            if(buff.id==3427)then--middle
                                                glitch=buff.id
                                            end
                                            if(buff.id==3428)then--remote
                                                glitch=buff.id
                                            end
                                            --phase3.1
                                            if(numPhase==3.1)then
                                                local count=0
                                                for k,v in pairs(jobcanon) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<6)then
                                                    if((buff.id==3425)or(buff.id==3426))then
                                                        for k,v in pairs(jobcanon) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playercannonid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.3
                                            if(numPhase==3.3)then
                                                if(#helloworld<8)then
                                                    if((buff.id==3436)or(buff.id==3437)or(buff.id==3438)or(buff.id==3439))then--stack,defamation,red,blue
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,helloworld)))then
                                                            helloworld[#helloworld+1]={entity.job,buff.id}
                                                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#helloworld="..#helloworld.."\n",true)
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.4
                                            if(numPhase==3.4)then
                                                local count=0
                                                for k,v in pairs(joboversampled) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<3)then
                                                    if((buff.id==3452)or(buff.id==3453))then
                                                        for k,v in pairs(joboversampled) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                                --countoversampled=countoversampled+1
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playeroversampledid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase5.1
                                            if(numPhase==5.1)then
                                                if(buff.id==3440)then--near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3440
                                                    end
                                                end
                                                if(buff.id==3504)then--far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3504
                                                    end
                                                end
                                                if(buff.id==3442)then--helloworld near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                            end
                                            --phase5.2
                                            if(numPhase==5.2)then
                                                if((buff.id==2534)and(math.round(buff.duration,1)==6.9))then
                                                    previoustimedelta=ml_global_information.Now
                                                end
                                                if(buff.id==3444)then
                                                    if(entity.job==Player.job)then
                                                        playerdynamis=1
                                                    end
                                                end
                                            end
                                            --phase5.3
                                            if(numPhase==5.3)then
                                                if(buff.id==3442)then--helloworld near
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                                if(buff.id==3427)then--middle
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                                if(buff.id==3428)then--remote
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                            end
                                            --
                                            local owner=EntityList:Get(buff.ownerid)
                                            local ownerid=0
                                            local ownername="nothing"
                                            if(owner)then
                                                ownerid=owner.id
                                                ownername=owner.name
                                            end
                                            --
                                            if(not(IsIncludedBuffTable(buff.id,buff.name,math.round(buff.duration,1),bufflist4)))then
                                                bufflist4[#bufflist4+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                                FileWrite(pathJpm.."\\log\\buff\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..GetJobName(entity.job)..","..buff.id..","..buff.name..","..math.round(buff.duration,1)..","..ownerid..","..ownername.."\n",true)
                                            end
                                            tmpBufflist[#tmpBufflist+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                            --
                                            index,buff=next(ebuffs,index)
                                        end
                                        local removeKey={}
                                        for k,v in pairs(bufflist4) do
                                            local flag=false
                                            for key,value in pairs(tmpBufflist) do
                                                if(value[1]==v[1])and(value[2]==v[2])then
                                                    flag=true
                                                    break
                                                end
                                            end
                                            if(not(flag))then
                                                removeKey[#removeKey+1]=k
                                            end
                                        end
                                        for k,v in pairs(removeKey) do
                                            table.remove(bufflist4,v)
                                        end
                                    end
                                end
                                if(countPml==5)then
                                    local ebuffs=entity.buffs
                                    if(ebuffs)then
                                        local index,buff=next(ebuffs)
                                        local tmpBufflist={}
                                        while((index~=nil)and(buff~=nil))do
                                            --phase1.1
                                            if(numPhase==1.1)then
                                                if(#buffsloop<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffsloop)))then
                                                            buffsloop[#buffsloop+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerloop=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase1.2
                                            if(numPhase==1.2)then
                                                if(#buffspant<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffspant)))then
                                                            buffspant[#buffspant+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerpantid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase2.1
                                            if(buff.id==3427)then--middle
                                                glitch=buff.id
                                            end
                                            if(buff.id==3428)then--remote
                                                glitch=buff.id
                                            end
                                            --phase3.1
                                            if(numPhase==3.1)then
                                                local count=0
                                                for k,v in pairs(jobcanon) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<6)then
                                                    if((buff.id==3425)or(buff.id==3426))then
                                                        for k,v in pairs(jobcanon) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playercannonid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.3
                                            if(numPhase==3.3)then
                                                if(#helloworld<8)then
                                                    if((buff.id==3436)or(buff.id==3437)or(buff.id==3438)or(buff.id==3439))then--stack,defamation,red,blue
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,helloworld)))then
                                                            helloworld[#helloworld+1]={entity.job,buff.id}
                                                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#helloworld="..#helloworld.."\n",true)
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.4
                                            if(numPhase==3.4)then
                                                local count=0
                                                for k,v in pairs(joboversampled) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<3)then
                                                    if((buff.id==3452)or(buff.id==3453))then
                                                        for k,v in pairs(joboversampled) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                                --countoversampled=countoversampled+1
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playeroversampledid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase5.1
                                            if(numPhase==5.1)then
                                                if(buff.id==3440)then--near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3440
                                                    end
                                                end
                                                if(buff.id==3504)then--far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3504
                                                    end
                                                end
                                                if(buff.id==3442)then--helloworld near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                            end
                                            --phase5.2
                                            if(numPhase==5.2)then
                                                if((buff.id==2534)and(math.round(buff.duration,1)==6.9))then
                                                    previoustimedelta=ml_global_information.Now
                                                end
                                                if(buff.id==3444)then
                                                    if(entity.job==Player.job)then
                                                        playerdynamis=1
                                                    end
                                                end
                                            end
                                            --phase5.3
                                            if(numPhase==5.3)then
                                                if(buff.id==3442)then--helloworld near
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                                if(buff.id==3427)then--middle
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                                if(buff.id==3428)then--remote
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                            end
                                            --
                                            local owner=EntityList:Get(buff.ownerid)
                                            local ownerid=0
                                            local ownername="nothing"
                                            if(owner)then
                                                ownerid=owner.id
                                                ownername=owner.name
                                            end
                                            --
                                            if(not(IsIncludedBuffTable(buff.id,buff.name,math.round(buff.duration,1),bufflist5)))then
                                                bufflist5[#bufflist5+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                                FileWrite(pathJpm.."\\log\\buff\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..GetJobName(entity.job)..","..buff.id..","..buff.name..","..math.round(buff.duration,1)..","..ownerid..","..ownername.."\n",true)
                                            end
                                            tmpBufflist[#tmpBufflist+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                            --
                                            index,buff=next(ebuffs,index)
                                        end
                                        local removeKey={}
                                        for k,v in pairs(bufflist5) do
                                            local flag=false
                                            for key,value in pairs(tmpBufflist) do
                                                if(value[1]==v[1])and(value[2]==v[2])then
                                                    flag=true
                                                    break
                                                end
                                            end
                                            if(not(flag))then
                                                removeKey[#removeKey+1]=k
                                            end
                                        end
                                        for k,v in pairs(removeKey) do
                                            table.remove(bufflist5,v)
                                        end
                                    end
                                end
                                if(countPml==6)then
                                    local ebuffs=entity.buffs
                                    if(ebuffs)then
                                        local index,buff=next(ebuffs)
                                        local tmpBufflist={}
                                        while((index~=nil)and(buff~=nil))do
                                            --phase1.1
                                            if(numPhase==1.1)then
                                                if(#buffsloop<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffsloop)))then
                                                            buffsloop[#buffsloop+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerloop=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase1.2
                                            if(numPhase==1.2)then
                                                if(#buffspant<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffspant)))then
                                                            buffspant[#buffspant+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerpantid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase2.1
                                            if(buff.id==3427)then--middle
                                                glitch=buff.id
                                            end
                                            if(buff.id==3428)then--remote
                                                glitch=buff.id
                                            end
                                            --phase3.1
                                            if(numPhase==3.1)then
                                                local count=0
                                                for k,v in pairs(jobcanon) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<6)then
                                                    if((buff.id==3425)or(buff.id==3426))then
                                                        for k,v in pairs(jobcanon) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playercannonid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.3
                                            if(numPhase==3.3)then
                                                if(#helloworld<8)then
                                                    if((buff.id==3436)or(buff.id==3437)or(buff.id==3438)or(buff.id==3439))then--stack,defamation,red,blue
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,helloworld)))then
                                                            helloworld[#helloworld+1]={entity.job,buff.id}
                                                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#helloworld="..#helloworld.."\n",true)
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.4
                                            if(numPhase==3.4)then
                                                local count=0
                                                for k,v in pairs(joboversampled) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<3)then
                                                    if((buff.id==3452)or(buff.id==3453))then
                                                        for k,v in pairs(joboversampled) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                                --countoversampled=countoversampled+1
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playeroversampledid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase5.1
                                            if(numPhase==5.1)then
                                                if(buff.id==3440)then--near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3440
                                                    end
                                                end
                                                if(buff.id==3504)then--far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3504
                                                    end
                                                end
                                                if(buff.id==3442)then--helloworld near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                            end
                                            --phase5.2
                                            if(numPhase==5.2)then
                                                if((buff.id==2534)and(math.round(buff.duration,1)==6.9))then
                                                    previoustimedelta=ml_global_information.Now
                                                end
                                                if(buff.id==3444)then
                                                    if(entity.job==Player.job)then
                                                        playerdynamis=1
                                                    end
                                                end
                                            end
                                            --phase5.3
                                            if(numPhase==5.3)then
                                                if(buff.id==3442)then--helloworld near
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                                if(buff.id==3427)then--middle
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                                if(buff.id==3428)then--remote
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                            end
                                            --
                                            local owner=EntityList:Get(buff.ownerid)
                                            local ownerid=0
                                            local ownername="nothing"
                                            if(owner)then
                                                ownerid=owner.id
                                                ownername=owner.name
                                            end
                                            --
                                            if(not(IsIncludedBuffTable(buff.id,buff.name,math.round(buff.duration,1),bufflist6)))then
                                                bufflist6[#bufflist6+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                                FileWrite(pathJpm.."\\log\\buff\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..GetJobName(entity.job)..","..buff.id..","..buff.name..","..math.round(buff.duration,1)..","..ownerid..","..ownername.."\n",true)
                                            end
                                            tmpBufflist[#tmpBufflist+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                            --
                                            index,buff=next(ebuffs,index)
                                        end
                                        local removeKey={}
                                        for k,v in pairs(bufflist6) do
                                            local flag=false
                                            for key,value in pairs(tmpBufflist) do
                                                if(value[1]==v[1])and(value[2]==v[2])then
                                                    flag=true
                                                    break
                                                end
                                            end
                                            if(not(flag))then
                                                removeKey[#removeKey+1]=k
                                            end
                                        end
                                        for k,v in pairs(removeKey) do
                                            table.remove(bufflist6,v)
                                        end
                                    end
                                end
                                if(countPml==7)then
                                    local ebuffs=entity.buffs
                                    if(ebuffs)then
                                        local index,buff=next(ebuffs)
                                        local tmpBufflist={}
                                        while((index~=nil)and(buff~=nil))do
                                            --phase1.1
                                            if(numPhase==1.1)then
                                                if(#buffsloop<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffsloop)))then
                                                            buffsloop[#buffsloop+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerloop=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase1.2
                                            if(numPhase==1.2)then
                                                if(#buffspant<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffspant)))then
                                                            buffspant[#buffspant+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerpantid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase2.1
                                            if(buff.id==3427)then--middle
                                                glitch=buff.id
                                            end
                                            if(buff.id==3428)then--remote
                                                glitch=buff.id
                                            end
                                            --phase3.1
                                            if(numPhase==3.1)then
                                                local count=0
                                                for k,v in pairs(jobcanon) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<6)then
                                                    if((buff.id==3425)or(buff.id==3426))then
                                                        for k,v in pairs(jobcanon) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playercannonid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.3
                                            if(numPhase==3.3)then
                                                if(#helloworld<8)then
                                                    if((buff.id==3436)or(buff.id==3437)or(buff.id==3438)or(buff.id==3439))then--stack,defamation,red,blue
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,helloworld)))then
                                                            helloworld[#helloworld+1]={entity.job,buff.id}
                                                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#helloworld="..#helloworld.."\n",true)
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.4
                                            if(numPhase==3.4)then
                                                local count=0
                                                for k,v in pairs(joboversampled) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<3)then
                                                    if((buff.id==3452)or(buff.id==3453))then
                                                        for k,v in pairs(joboversampled) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                                --countoversampled=countoversampled+1
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playeroversampledid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase5.1
                                            if(numPhase==5.1)then
                                                if(buff.id==3440)then--near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3440
                                                    end
                                                end
                                                if(buff.id==3504)then--far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3504
                                                    end
                                                end
                                                if(buff.id==3442)then--helloworld near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                            end
                                            --phase5.2
                                            if(numPhase==5.2)then
                                                if((buff.id==2534)and(math.round(buff.duration,1)==6.9))then
                                                    previoustimedelta=ml_global_information.Now
                                                end
                                                if(buff.id==3444)then
                                                    if(entity.job==Player.job)then
                                                        playerdynamis=1
                                                    end
                                                end
                                            end
                                            --phase5.3
                                            if(numPhase==5.3)then
                                                if(buff.id==3442)then--helloworld near
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                                if(buff.id==3427)then--middle
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                                if(buff.id==3428)then--remote
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                            end
                                            --
                                            local owner=EntityList:Get(buff.ownerid)
                                            local ownerid=0
                                            local ownername="nothing"
                                            if(owner)then
                                                ownerid=owner.id
                                                ownername=owner.name
                                            end
                                            --
                                            if(not(IsIncludedBuffTable(buff.id,buff.name,math.round(buff.duration,1),bufflist7)))then
                                                bufflist7[#bufflist7+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                                FileWrite(pathJpm.."\\log\\buff\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..GetJobName(entity.job)..","..buff.id..","..buff.name..","..math.round(buff.duration,1)..","..ownerid..","..ownername.."\n",true)
                                            end
                                            tmpBufflist[#tmpBufflist+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                            --
                                            index,buff=next(ebuffs,index)
                                        end
                                        local removeKey={}
                                        for k,v in pairs(bufflist7) do
                                            local flag=false
                                            for key,value in pairs(tmpBufflist) do
                                                if(value[1]==v[1])and(value[2]==v[2])then
                                                    flag=true
                                                    break
                                                end
                                            end
                                            if(not(flag))then
                                                removeKey[#removeKey+1]=k
                                            end
                                        end
                                        for k,v in pairs(removeKey) do
                                            table.remove(bufflist7,v)
                                        end
                                    end
                                end
                                if(countPml==8)then
                                    local ebuffs=entity.buffs
                                    if(ebuffs)then
                                        local index,buff=next(ebuffs)
                                        local tmpBufflist={}
                                        while((index~=nil)and(buff~=nil))do
                                            --phase1.1
                                            if(numPhase==1.1)then
                                                if(#buffsloop<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffsloop)))then
                                                            buffsloop[#buffsloop+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerloop=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase1.2
                                            if(numPhase==1.2)then
                                                if(#buffspant<8)then
                                                    if((buff.id==3004)or(buff.id==3005)or(buff.id==3006)or(buff.id==3451))then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,buffspant)))then
                                                            buffspant[#buffspant+1]={entity.job,buff.id}
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playerpantid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase2.1
                                            if(buff.id==3427)then--middle
                                                glitch=buff.id
                                            end
                                            if(buff.id==3428)then--remote
                                                glitch=buff.id
                                            end
                                            --phase3.1
                                            if(numPhase==3.1)then
                                                local count=0
                                                for k,v in pairs(jobcanon) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<6)then
                                                    if((buff.id==3425)or(buff.id==3426))then
                                                        for k,v in pairs(jobcanon) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playercannonid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.3
                                            if(numPhase==3.3)then
                                                if(#helloworld<8)then
                                                    if((buff.id==3436)or(buff.id==3437)or(buff.id==3438)or(buff.id==3439))then--stack,defamation,red,blue
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,helloworld)))then
                                                            helloworld[#helloworld+1]={entity.job,buff.id}
                                                            FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#helloworld="..#helloworld.."\n",true)
                                                        end
                                                    end
                                                end
                                            end
                                            --phase3.4
                                            if(numPhase==3.4)then
                                                local count=0
                                                for k,v in pairs(joboversampled) do
                                                    if(v[2]~=0)then
                                                        count=count+1
                                                    end
                                                end
                                                if(count<3)then
                                                    if((buff.id==3452)or(buff.id==3453))then
                                                        for k,v in pairs(joboversampled) do
                                                            if(entity.job==v[1])then
                                                                v[2]=buff.id
                                                                --countoversampled=countoversampled+1
                                                            end
                                                        end
                                                        if(entity.job==Player.job)then
                                                            playeroversampledid=buff.id
                                                        end
                                                    end
                                                end
                                            end
                                            --phase5.1
                                            if(numPhase==5.1)then
                                                if(buff.id==3440)then--near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3440
                                                    end
                                                end
                                                if(buff.id==3504)then--far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerdeltatether=3504
                                                    end
                                                end
                                                if(buff.id==3442)then--helloworld near
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#deltatether<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,deltatether)))then
                                                            deltatether[#deltatether+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#deltatether="..#deltatether.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                            end
                                            --phase5.2
                                            if(numPhase==5.2)then
                                                if((buff.id==2534)and(math.round(buff.duration,1)==6.9))then
                                                    previoustimedelta=ml_global_information.Now
                                                end
                                                if(buff.id==3444)then
                                                    if(entity.job==Player.job)then
                                                        playerdynamis=1
                                                    end
                                                end
                                            end
                                            --phase5.3
                                            if(numPhase==5.3)then
                                                if(buff.id==3442)then--helloworld near
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3442
                                                    end
                                                end
                                                if(buff.id==3443)then--helloworld far
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    if(entity.job==Player.job)then
                                                        playerhelloworld=3443
                                                    end
                                                end
                                                if(buff.id==3427)then--middle
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                                if(buff.id==3428)then--remote
                                                    if(#sigmadebuff<10)then
                                                        if(not(IsIncludeBuffTOP(entity.job,buff.id,sigmadebuff)))then
                                                            sigmadebuff[#sigmadebuff+1]={entity.job,buff.id}
                                                        end
                                                        FileWrite(pathJpm.."\\log\\debug\\"..currentFileName..".txt",os.date("%H:%M:%S")..",#sigmadebuff="..#sigmadebuff.."\n",true)
                                                    end
                                                    glitch=buff.id
                                                end
                                            end
                                            --
                                            local owner=EntityList:Get(buff.ownerid)
                                            local ownerid=0
                                            local ownername="nothing"
                                            if(owner)then
                                                ownerid=owner.id
                                                ownername=owner.name
                                            end
                                            --
                                            if(not(IsIncludedBuffTable(buff.id,buff.name,math.round(buff.duration,1),bufflist8)))then
                                                bufflist8[#bufflist8+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                                FileWrite(pathJpm.."\\log\\buff\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..GetJobName(entity.job)..","..buff.id..","..buff.name..","..math.round(buff.duration,1)..","..ownerid..","..ownername.."\n",true)
                                            end
                                            tmpBufflist[#tmpBufflist+1]={buff.id,buff.name,math.round(buff.duration,1)}
                                            --
                                            index,buff=next(ebuffs,index)
                                        end
                                        local removeKey={}
                                        for k,v in pairs(bufflist8) do
                                            local flag=false
                                            for key,value in pairs(tmpBufflist) do
                                                if(value[1]==v[1])and(value[2]==v[2])then
                                                    flag=true
                                                    break
                                                end
                                            end
                                            if(not(flag))then
                                                removeKey[#removeKey+1]=k
                                            end
                                        end
                                        for k,v in pairs(removeKey) do
                                            table.remove(bufflist8,v)
                                        end
                                    end
                                end
                            end
                        end
                        i,e=next(pmlist,i)
                        countPml=countPml+1
                    end
                end
            end
            --record entity castinginfo
            if(defaultRecordCheck)then
                local el=EntityList("incombat")
                if(el)then
                    if(isIncombat)then
                        local i,e=next(el)
                        local tmpCastlist={}
                        while((i~=nil)and(e~=nil))do
                            if((e.chartype~=2)and(e.chartype~=4))then
                                local ci=e.castinginfo
                                if(ci)then
                                    if(ci.casttime~=nil)then
                                        if(not(ci.channelingid==0))then
                                            if(not((ci.channelingid==0)and(ci.castingid==0)and(ci.casttime==0)))then
                                                if(ci.channelingid==31595)then--right
                                                    omegaoversampled=ci.channelingid
                                                elseif(ci.channelingid==31596)then--left
                                                    omegaoversampled=ci.channelingid
                                                end
                                                if((ci.channeltime>0.01)and(ci.channeltime<0.02))then
                                                    if(not(IsIncludedCastTable(e.id,e.name,ci.channelingid,ci.castingid,ci.casttime,castinglist)))then
                                                        castinglist[#castinglist+1]={e.id,e.name,ci.channelingid,ci.castingid,ci.casttime}
                                                        FileWrite(pathJpm.."\\log\\cast\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..e.chartype..","..e.id..","..e.name..","..ci.channelingid..","..ci.castingid..","..ci.casttime..","..e.pos.x..","..e.pos.y..","..e.pos.z..","..e.pos.h..","..ci.channeltime.."\n",true)
                                                    end
                                                    tmpCastlist[#tmpCastlist+1]={e.id,e.name,ci.channelingid,ci.castingid,ci.casttime}
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            i,e=next(el,i)
                        end
                        local removeKey={}
                        for k,v in pairs(castinglist) do
                            local flag=false
                            for key,value in pairs(tmpCastlist) do
                                if(value[1]==v[1])and(value[2]==v[2])and(value[3]==v[3])and(value[4]==v[4])and(value[5]==v[5])then
                                    flag=true
                                    break
                                end
                            end
                            if(not(flag))then
                                removeKey[#removeKey+1]=k
                            end
                        end
                        for k,v in pairs(removeKey) do
                            table.remove(castinglist,v)
                        end
                    end
                end
            end
            --record visible entity
            if(defaultRecordCheck)then
                local el=EntityList("incombat")
                if(el)then
                    if(isIncombat)then
                        local i,e=next(el)
                        local tmpEnemylist={}
                        while((i~=nil)and(e~=nil))do
                            if(Argus.isEntityVisible(e.id))then
                                if((e.chartype==5)or(e.chartype==11))then
                                    local modelid=Argus.getEntityModel(e.id)
                                    if(not(modelid))then
                                        modelid="nothing"
                                    end
                                    if(not(IsIncludedEnemyTable(e.id,e.contentid,modelid,enemylist)))then
                                        enemylist[#enemylist+1]={e.id,e.contentid,modelid}
                                        FileWrite(pathJpm.."\\log\\entity\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..e.chartype..","..e.id..","..e.contentid..","..modelid..","..e.name..","..e.pos.x..","..e.pos.y..","..e.pos.z..","..e.pos.h.."\n",true)
                                    end
                                    tmpEnemylist[#tmpEnemylist+1]={e.id,e.contentid,modelid}
                                end
                            end
                            i,e=next(el,i)
                        end
                        local removeKey={}
                        for k,v in pairs(enemylist) do
                            local flag=false
                            for key,value in pairs(tmpEnemylist) do
                                if((value[1]==v[1])and(value[2]==v[2])and(value[3]==v[3]))then
                                    flag=true
                                    break
                                end
                            end
                            if(not(flag))then
                                removeKey[#removeKey+1]=k
                            end
                        end
                        for k,v in pairs(removeKey) do
                            table.remove(enemylist,v)
                        end
                    end
                end
            end
            --record all entity
            if(defaultRecordCheck)then
                local el=EntityList("incombat")
                if(el)then
                    if(isIncombat)then
                        local i,e=next(el)
                        local tmpEnemylist={}
                        while((i~=nil)and(e~=nil))do
                            if((e.chartype==5)or(e.chartype==11))then
                                local modelid=Argus.getEntityModel(e.id)
                                if(not(modelid))then
                                    modelid="nothing"
                                end
                                if(not(IsIncludedEnemyTable(e.id,e.contentid,modelid,allenemylist)))then
                                    allenemylist[#allenemylist+1]={e.id,e.contentid,modelid}
                                    FileWrite(pathJpm.."\\log\\entity all\\"..currentFileName..".txt",os.date("%H:%M:%S")..","..e.chartype..","..e.id..","..e.contentid..","..modelid..","..e.name..","..e.pos.x..","..e.pos.y..","..e.pos.z..","..e.pos.h.."\n",true)
                                end
                                tmpEnemylist[#tmpEnemylist+1]={e.id,e.contentid,modelid}
                            end
                            i,e=next(el,i)
                        end
                        local removeKey={}
                        for k,v in pairs(allenemylist) do
                            local flag=false
                            for key,value in pairs(tmpEnemylist) do
                                if((value[1]==v[1])and(value[2]==v[2])and(value[3]==v[3]))then
                                    flag=true
                                    break
                                end
                            end
                            if(not(flag))then
                                removeKey[#removeKey+1]=k
                            end
                        end
                        for k,v in pairs(removeKey) do
                            table.remove(allenemylist,v)
                        end
                    end
                end
            end
        end
        GUI:End()
    end
end

--party position setting window
function partyposwindow.Draw(event,ticks)
    if(partyposwindow.open)then
        GUI:SetNextWindowSize(100,100,GUI.SetCond_FirstUseEver)
        partyposwindow.visible,partyposwindow.open=GUI:Begin("set party position",partyposwindow.open)
        if(partyposwindow.visible)then
            local msgPartyPosStatus=""
            local wposx,wposy=GUI:GetWindowPos()
            if(#partypos==8)then
                msgPartyPosStatus="party position has been set"
            else
                msgPartyPosStatus="select in the order of MTSTH1H2D1D2D3D4. this does not support job duplication"
            end
            local recordCheck,recordCheckPressed=GUI:Checkbox("oversampled wave cannon order (default TDH)",owcOrderTDH)
            if(recordCheckPressed)then
                if(recordCheck)then
                    owcOrderTDH=true
                    local val={isLockNotice=isLockNoticeWindow,isShowNotice=isShowNoticeWindow,recordLog=defaultRecordCheck,owcOrderTDH=owcOrderTDH}
                    FileSave(pathJpm.."\\resources\\setting\\value.txt",val)
                else
                    owcOrderTDH=false
                    local val={isLockNotice=isLockNoticeWindow,isShowNotice=isShowNoticeWindow,recordLog=defaultRecordCheck,owcOrderTDH=owcOrderTDH}
                    FileSave(pathJpm.."\\resources\\setting\\value.txt",val)
                end
            end
            GUI:Text(msgPartyPosStatus)
            GUI:Text(msgCautionPPW)
            if(GUI:FreeButton("CLEAR",wposx+10,wposy+65))then
                partypos={}
                msgCautionPPW=""
            end
            if(GUI:FreeButton("SAVE PARTY POSITION",wposx+57,wposy+65))then
                FileSave(pathJpm.."\\resources\\setting\\priority.txt",partypos)
                msgCautionPPW=""
            end
            if(GUI:FreeButton("LOAD DEFAULT POSITION",wposx+202,wposy+65))then
                partypos={}
                partypos=FileLoad(pathJpm.."\\resources\\setting\\priority.txt")
                msgCautionPPW=""
            end
            if(GUI:FreeButton("SET JOBS FOR P1 PANTOKRATOR",wposx+10,wposy+90))then
                msgCautionPant=""
                pantokratorwindow.open=true
            end
            if(GUI:FreeButton("SET PHASE2 POSITION",wposx+210,wposy+90))then
                msgCautionPPP2W=""
                partyposphase2window.open=true
            end
            --tank
            if(GUI:FreeImageButton("PLD",pathJpm.."\\resources\\icon\\job\\PLD.png",wposx+10,wposy+120,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(19))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"PLD",19}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("WAR",pathJpm.."\\resources\\icon\\job\\WAR.png",wposx+70,wposy+120,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(21))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"WAR",21}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("DRK",pathJpm.."\\resources\\icon\\job\\DRK.png",wposx+130,wposy+120,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(32))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"DRK",32}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("GNB",pathJpm.."\\resources\\icon\\job\\GNB.png",wposx+190,wposy+120,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(37))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"GNB",37}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            --healer
            if(GUI:FreeImageButton("WHM",pathJpm.."\\resources\\icon\\job\\WHM.png",wposx+10,wposy+180,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(24))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"WHM",24}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("SCH",pathJpm.."\\resources\\icon\\job\\SCH.png",wposx+70,wposy+180,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(28))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"SCH",28}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("AST",pathJpm.."\\resources\\icon\\job\\AST.png",wposx+130,wposy+180,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(33))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"AST",33}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("SGE",pathJpm.."\\resources\\icon\\job\\SGE.png",wposx+190,wposy+180,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(40))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"SGE",40}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            --melee
            if(GUI:FreeImageButton("MNK",pathJpm.."\\resources\\icon\\job\\MNK.png",wposx+10,wposy+240,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(20))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"MNK",20}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("DRG",pathJpm.."\\resources\\icon\\job\\DRG.png",wposx+70,wposy+240,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(22))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"DRG",22}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("NIN",pathJpm.."\\resources\\icon\\job\\NIN.png",wposx+130,wposy+240,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(30))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"NIN",30}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("SAM",pathJpm.."\\resources\\icon\\job\\SAM.png",wposx+190,wposy+240,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(34))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"SAM",34}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("RPR",pathJpm.."\\resources\\icon\\job\\RPR.png",wposx+250,wposy+240,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(39))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"RPR",39}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            --range
            if(GUI:FreeImageButton("BRD",pathJpm.."\\resources\\icon\\job\\BRD.png",wposx+10,wposy+300,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(23))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"BRD",23}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("MCH",pathJpm.."\\resources\\icon\\job\\MCH.png",wposx+70,wposy+300,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(31))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"MCH",31}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("DNC",pathJpm.."\\resources\\icon\\job\\DNC.png",wposx+130,wposy+300,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(38))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"DNC",38}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            --magic
            if(GUI:FreeImageButton("BLM",pathJpm.."\\resources\\icon\\job\\BLM.png",wposx+10,wposy+360,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(25))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"BLM",25}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("SMN",pathJpm.."\\resources\\icon\\job\\SMN.png",wposx+70,wposy+360,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(27))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"SMN",27}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            if(GUI:FreeImageButton("RDM",pathJpm.."\\resources\\icon\\job\\RDM.png",wposx+130,wposy+360,50,50))then
                if(#partypos<8)then
                    msgCautionPPW=""
                    if(CheckJobDuplication(35))then
                        msgCautionPPW="duplicates not allowed"
                    else
                        partypos[#partypos+1]={"RDM",35}
                    end
                else
                    msgCautionPPW="no more party members can be set"
                end
            end
            --display the currently selected jobs
            local xdiff=0
            for k,v in pairs(partypos) do
                GUI:AddImage(pathJpm.."\\resources\\icon\\job\\"..v[1]..".png",wposx+10+xdiff*60,wposy+430,wposx+60+xdiff*60,wposy+480)
                xdiff=xdiff+1
            end
            --check job duplication
            function CheckJobDuplication(jobid)
                local isDup=false
                for k,v in pairs(partypos) do
                    if(v[2]==jobid)then
                        isDup=true
                    end
                end
                return isDup
            end
        end
        GUI:End()
    end
end

--party position setting window for phase2
function partyposphase2window.Draw(event,ticks)
    if(partyposphase2window.open)then
        GUI:SetNextWindowSize(100,100,GUI.SetCond_FirstUseEver)
        partyposphase2window.visible,partyposphase2window.open=GUI:Begin("set party position for phase2",partyposphase2window.open)
        if(partyposphase2window.visible)then
            local msgPartyPosStatus=""
            local wposx,wposy=GUI:GetWindowPos()
            if((#jobf==4)and(#jobm==4))then
                msgPartyPosStatus="party position has been set"
            else
                msgPartyPosStatus="select in low order of priority.\nthe above is on the right, the under is on the left. this does not support job duplication"
            end
            GUI:Text(msgPartyPosStatus)
            GUI:Text(msgCautionPPP2W)
            if(GUI:FreeButton("CLEAR",wposx+10,wposy+65))then
                jobf={}
                jobm={}
                msgCautionPPP2W=""
            end
            if(GUI:FreeButton("SAVE PARTY POSITION",wposx+57,wposy+65))then
                FileSave(pathJpm.."\\resources\\setting\\priorityleft.txt",jobf)
                FileSave(pathJpm.."\\resources\\setting\\priorityright.txt",jobm)
                msgCautionPPP2W=""
            end
            if(GUI:FreeButton("LOAD DEFAULT POSITION",wposx+202,wposy+65))then
                jobf={}
                jobm={}
                jobf=FileLoad(pathJpm.."\\resources\\setting\\priorityleft.txt")
                jobm=FileLoad(pathJpm.."\\resources\\setting\\priorityright.txt")
                msgCautionPPP2W=""
            end
            --tank
            if(GUI:FreeImageButton("PLD",pathJpm.."\\resources\\icon\\job\\PLD.png",wposx+10,wposy+90,50,50))then
                SetPartyPosPhase2(19)
            end
            if(GUI:FreeImageButton("WAR",pathJpm.."\\resources\\icon\\job\\WAR.png",wposx+70,wposy+90,50,50))then
                SetPartyPosPhase2(21)
            end
            if(GUI:FreeImageButton("DRK",pathJpm.."\\resources\\icon\\job\\DRK.png",wposx+130,wposy+90,50,50))then
                SetPartyPosPhase2(32)
            end
            if(GUI:FreeImageButton("GNB",pathJpm.."\\resources\\icon\\job\\GNB.png",wposx+190,wposy+90,50,50))then
                SetPartyPosPhase2(37)
            end
            --healer
            if(GUI:FreeImageButton("WHM",pathJpm.."\\resources\\icon\\job\\WHM.png",wposx+10,wposy+150,50,50))then
                SetPartyPosPhase2(24)
            end
            if(GUI:FreeImageButton("SCH",pathJpm.."\\resources\\icon\\job\\SCH.png",wposx+70,wposy+150,50,50))then
                SetPartyPosPhase2(28)
            end
            if(GUI:FreeImageButton("AST",pathJpm.."\\resources\\icon\\job\\AST.png",wposx+130,wposy+150,50,50))then
                SetPartyPosPhase2(33)
            end
            if(GUI:FreeImageButton("SGE",pathJpm.."\\resources\\icon\\job\\SGE.png",wposx+190,wposy+150,50,50))then
                SetPartyPosPhase2(40)
            end
            --melee
            if(GUI:FreeImageButton("MNK",pathJpm.."\\resources\\icon\\job\\MNK.png",wposx+10,wposy+210,50,50))then
                SetPartyPosPhase2(20)
            end
            if(GUI:FreeImageButton("DRG",pathJpm.."\\resources\\icon\\job\\DRG.png",wposx+70,wposy+210,50,50))then
                SetPartyPosPhase2(22)
            end
            if(GUI:FreeImageButton("NIN",pathJpm.."\\resources\\icon\\job\\NIN.png",wposx+130,wposy+210,50,50))then
                SetPartyPosPhase2(30)
            end
            if(GUI:FreeImageButton("SAM",pathJpm.."\\resources\\icon\\job\\SAM.png",wposx+190,wposy+210,50,50))then
                SetPartyPosPhase2(34)
            end
            if(GUI:FreeImageButton("RPR",pathJpm.."\\resources\\icon\\job\\RPR.png",wposx+250,wposy+210,50,50))then
                SetPartyPosPhase2(39)
            end
            --range
            if(GUI:FreeImageButton("BRD",pathJpm.."\\resources\\icon\\job\\BRD.png",wposx+10,wposy+270,50,50))then
                SetPartyPosPhase2(23)
            end
            if(GUI:FreeImageButton("MCH",pathJpm.."\\resources\\icon\\job\\MCH.png",wposx+70,wposy+270,50,50))then
                SetPartyPosPhase2(31)
            end
            if(GUI:FreeImageButton("DNC",pathJpm.."\\resources\\icon\\job\\DNC.png",wposx+130,wposy+270,50,50))then
                SetPartyPosPhase2(38)
            end
            --magic
            if(GUI:FreeImageButton("BLM",pathJpm.."\\resources\\icon\\job\\BLM.png",wposx+10,wposy+330,50,50))then
                SetPartyPosPhase2(25)
            end
            if(GUI:FreeImageButton("SMN",pathJpm.."\\resources\\icon\\job\\SMN.png",wposx+70,wposy+330,50,50))then
                SetPartyPosPhase2(27)
            end
            if(GUI:FreeImageButton("RDM",pathJpm.."\\resources\\icon\\job\\RDM.png",wposx+130,wposy+330,50,50))then
                SetPartyPosPhase2(35)
            end
            --display the currently selected jobs
            local xdiff=0
            --GUI:Text("jobs for female. low priority order")
            for k,v in pairs(jobm) do
                GUI:AddImage(pathJpm.."\\resources\\icon\\job\\"..GetJobName(v)..".png",wposx+10+xdiff*60,wposy+400,wposx+60+xdiff*60,wposy+450)
                xdiff=xdiff+1
            end
            xdiff=0
            --GUI:Text("jobs for male. low priority order")
            for k,v in pairs(jobf) do
                GUI:AddImage(pathJpm.."\\resources\\icon\\job\\"..GetJobName(v)..".png",wposx+10+xdiff*60,wposy+450,wposx+60+xdiff*60,wposy+500)
                xdiff=xdiff+1
            end
            --check job duplication
            function CheckJobDuplicationPhase2(jobid,table)
                local isDup=false
                if(not(#table==0))then
                    for k,v in pairs(table) do
                        if(v==jobid)then
                            isDup=true
                        end
                    end
                end
                return isDup
            end
            function SetPartyPosPhase2(jobid)
                local sumps=#jobf+#jobm
                if((sumps>=0)and(sumps<=3))then
                    if(CheckJobDuplicationPhase2(jobid,jobf))then
                        msgCautionPPP2W="duplicates not allowed"
                    else
                        jobm[#jobm+1]=jobid
                    end
                elseif((sumps>=4)and(sumps<=7))then
                    if(CheckJobDuplicationPhase2(jobid,jobm))then
                        msgCautionPPP2W="duplicates not allowed"
                    else
                        jobf[#jobf+1]=jobid
                    end
                elseif(sumps==8)then
                    msgCautionPPP2W="no more party members can be set"
                end
            end
        end
        GUI:End()
    end
end

--window for phase1 pantokrator
function pantokratorwindow.Draw(event,ticks)
    if(pantokratorwindow.open)then
        GUI:SetNextWindowSize(100,100,GUI.SetCond_FirstUseEver)
        pantokratorwindow.visible,pantokratorwindow.open=GUI:Begin("phase1 pantokrator",pantokratorwindow.open)
        if(pantokratorwindow.visible)then
            local msgPartyPosStatus=""
            local wposx,wposy=GUI:GetWindowPos()
            if((#jobpant>=3))then
                msgPartyPosStatus="jobs has been set"
            else
                msgPartyPosStatus="select the job you should check with pantokrator"
            end
            GUI:Text(msgPartyPosStatus)
            GUI:Text(msgCautionPant)
            if(GUI:FreeButton("CLEAR",wposx+10,wposy+65))then
                jobpant={}
                msgCautionPant=""
            end
            if(GUI:FreeButton("SAVE PARTY POSITION",wposx+57,wposy+65))then
                FileSave(pathJpm.."\\resources\\setting\\pantokrator.txt",jobpant)
                msgCautionPant=""
            end
            if(GUI:FreeButton("LOAD DEFAULT POSITION",wposx+202,wposy+65))then
                jobpant={}
                jobpant=FileLoad(pathJpm.."\\resources\\setting\\pantokrator.txt")
                msgCautionPant=""
            end
            --tank
            if(GUI:FreeImageButton("PLD",pathJpm.."\\resources\\icon\\job\\PLD.png",wposx+10,wposy+90,50,50))then
                SetJobPantokrator(19)
            end
            if(GUI:FreeImageButton("WAR",pathJpm.."\\resources\\icon\\job\\WAR.png",wposx+70,wposy+90,50,50))then
                SetJobPantokrator(21)
            end
            if(GUI:FreeImageButton("DRK",pathJpm.."\\resources\\icon\\job\\DRK.png",wposx+130,wposy+90,50,50))then
                SetJobPantokrator(32)
            end
            if(GUI:FreeImageButton("GNB",pathJpm.."\\resources\\icon\\job\\GNB.png",wposx+190,wposy+90,50,50))then
                SetJobPantokrator(37)
            end
            --healer
            if(GUI:FreeImageButton("WHM",pathJpm.."\\resources\\icon\\job\\WHM.png",wposx+10,wposy+150,50,50))then
                SetJobPantokrator(24)
            end
            if(GUI:FreeImageButton("SCH",pathJpm.."\\resources\\icon\\job\\SCH.png",wposx+70,wposy+150,50,50))then
                SetJobPantokrator(28)
            end
            if(GUI:FreeImageButton("AST",pathJpm.."\\resources\\icon\\job\\AST.png",wposx+130,wposy+150,50,50))then
                SetJobPantokrator(33)
            end
            if(GUI:FreeImageButton("SGE",pathJpm.."\\resources\\icon\\job\\SGE.png",wposx+190,wposy+150,50,50))then
                SetJobPantokrator(40)
            end
            --melee
            if(GUI:FreeImageButton("MNK",pathJpm.."\\resources\\icon\\job\\MNK.png",wposx+10,wposy+210,50,50))then
                SetJobPantokrator(20)
            end
            if(GUI:FreeImageButton("DRG",pathJpm.."\\resources\\icon\\job\\DRG.png",wposx+70,wposy+210,50,50))then
                SetJobPantokrator(22)
            end
            if(GUI:FreeImageButton("NIN",pathJpm.."\\resources\\icon\\job\\NIN.png",wposx+130,wposy+210,50,50))then
                SetJobPantokrator(30)
            end
            if(GUI:FreeImageButton("SAM",pathJpm.."\\resources\\icon\\job\\SAM.png",wposx+190,wposy+210,50,50))then
                SetJobPantokrator(34)
            end
            if(GUI:FreeImageButton("RPR",pathJpm.."\\resources\\icon\\job\\RPR.png",wposx+250,wposy+210,50,50))then
                SetJobPantokrator(39)
            end
            --range
            if(GUI:FreeImageButton("BRD",pathJpm.."\\resources\\icon\\job\\BRD.png",wposx+10,wposy+270,50,50))then
                SetJobPantokrator(23)
            end
            if(GUI:FreeImageButton("MCH",pathJpm.."\\resources\\icon\\job\\MCH.png",wposx+70,wposy+270,50,50))then
                SetJobPantokrator(31)
            end
            if(GUI:FreeImageButton("DNC",pathJpm.."\\resources\\icon\\job\\DNC.png",wposx+130,wposy+270,50,50))then
                SetJobPantokrator(38)
            end
            --magic
            if(GUI:FreeImageButton("BLM",pathJpm.."\\resources\\icon\\job\\BLM.png",wposx+10,wposy+330,50,50))then
                SetJobPantokrator(25)
            end
            if(GUI:FreeImageButton("SMN",pathJpm.."\\resources\\icon\\job\\SMN.png",wposx+70,wposy+330,50,50))then
                SetJobPantokrator(27)
            end
            if(GUI:FreeImageButton("RDM",pathJpm.."\\resources\\icon\\job\\RDM.png",wposx+130,wposy+330,50,50))then
                SetJobPantokrator(35)
            end
            --display the currently selected jobs
            local xdiff=0
            for k,v in pairs(jobpant) do
                GUI:AddImage(pathJpm.."\\resources\\icon\\job\\"..GetJobName(v)..".png",wposx+10+xdiff*60,wposy+400,wposx+60+xdiff*60,wposy+450)
                xdiff=xdiff+1
            end
            --check job duplication
            function CheckJobDuplicationPant(jobid,table)
                local isDup=false
                if(not(#table==0))then
                    for k,v in pairs(table) do
                        if(v==jobid)then
                            isDup=true
                        end
                    end
                end
                return isDup
            end
            function SetJobPantokrator(jobid)
                if(#jobpant<3)then
                    if(CheckJobDuplicationPant(jobid,jobpant))then
                        msgCautionPant="duplicates not allowed"
                    else
                        jobpant[#jobpant+1]=jobid
                    end
                else
                    msgCautionPant="no more jobs can be set"
                end
            end
        end
        GUI:End()
    end
end

--
function comparePS()
    if((#psf==4)and(#psm==4))then
        for key,value in pairs(psf) do--leftside
            if(value[1]==jobf[4])then--on the left,highest priority
                leftside[#leftside+1]={value[1],value[2]}
            end
            if(value[1]==jobf[3])then--on the left,second highest priority
                for k,v in pairs(psf) do
                    if(v[1]==jobf[4])then
                        if(v[2]==value[2])then
                            --same as the player with the highest priority on the left
                            rightside[#rightside+1]={value[1],value[2]}
                        else
                            --not same as the player with the highest priority on the left
                            leftside[#leftside+1]={value[1],value[2]}
                        end
                    end
                end
            end
            if(value[1]==jobf[2])then--on the left,second lowest priority
                local count=0
                for k,v in pairs(psf) do
                    if(v[1]==jobf[4])then
                        if(v[2]==value[2])then
                            --same as the player with the highest priority on the left
                            rightside[#rightside+1]={value[1],value[2]}
                        else
                            --not same as the player with the highest priority on the left
                            count=count+1
                        end
                    end
                    if(v[1]==jobf[3])then
                        if(v[2]==value[2])then
                            --same as the player with the second highest priority on the left
                            rightside[#rightside+1]={value[1],value[2]}
                        else
                            --not same as the player with the second highest priority on the left
                            count=count+1
                        end
                    end
                end
                if(count==2)then
                    leftside[#leftside+1]={value[1],value[2]}
                end
            end
            if(value[1]==jobf[1])then--on the left,lowest priority
                local count=0
                for k,v in pairs(psf) do
                    if(v[1]==jobf[4])then
                        if(v[2]==value[2])then
                            --same as the player with the highest priority on the left
                            rightside[#rightside+1]={value[1],value[2]}
                        else
                            --not same as the player with the highest priority on the left
                            count=count+1
                        end
                    end
                    if(v[1]==jobf[3])then
                        if(v[2]==value[2])then
                            --same as the player with the second highest priority on the left
                            rightside[#rightside+1]={value[1],value[2]}
                        else
                            --not same as the player with the second highest priority on the left
                            count=count+1
                        end
                    end
                    if(v[1]==jobf[2])then
                        if(v[2]==value[2])then
                            --same as the player with the second lowest priority on the left
                            rightside[#rightside+1]={value[1],value[2]}
                        else
                            --not same as the player with the second lowest priority on the left
                            count=count+1
                        end
                    end
                end
                if(count==3)then
                    leftside[#leftside+1]={value[1],value[2]}
                end
            end
        end
        for key,value in pairs(psm) do--rightside
            if(value[1]==jobm[4])then--on the right,highest priority
                rightside[#rightside+1]={value[1],value[2]}
            end
            if(value[1]==jobm[3])then--on the right,second highest priority
                for k,v in pairs(psm) do
                    if(v[1]==jobm[4])then
                        if(v[2]==value[2])then
                            --same as the player with the highest priority on the right
                            leftside[#leftside+1]={value[1],value[2]}
                        else
                            --not same as the player with the highest priority on the right
                            rightside[#rightside+1]={value[1],value[2]}
                        end
                    end
                end
            end
            if(value[1]==jobm[2])then--on the right,second lowest priority
                local count=0
                for k,v in pairs(psm) do
                    if(v[1]==jobm[4])then
                        if(v[2]==value[2])then
                            --same as the player with the highest priority on the right
                            leftside[#leftside+1]={value[1],value[2]}
                        else
                            --not same as the player with the highest priority on the right
                            count=count+1
                        end
                    end
                    if(v[1]==jobm[3])then
                        if(v[2]==value[2])then
                            --same as the player with the second highest priority on the right
                            leftside[#leftside+1]={value[1],value[2]}
                        else
                            --not same as the player with the second highest priority on the right
                            count=count+1
                        end
                    end
                end
                if(count==2)then
                    rightside[#rightside+1]={value[1],value[2]}
                end
            end
            if(value[1]==jobm[1])then--on the right,lowest priority
                local count=0
                for k,v in pairs(psm) do
                    if(v[1]==jobm[4])then
                        if(v[2]==value[2])then
                            --same as the player with the highest priority on the right
                            leftside[#leftside+1]={value[1],value[2]}
                        else
                            --not same as the player with the highest priority on the right
                            count=count+1
                        end
                    end
                    if(v[1]==jobm[3])then
                        if(v[2]==value[2])then
                            --same as the player with the second highest priority on the right
                            leftside[#leftside+1]={value[1],value[2]}
                        else
                            --not same as the player with the second highest priority on the right
                            count=count+1
                        end
                    end
                    if(v[1]==jobm[2])then
                        if(v[2]==value[2])then
                            --same as the player with the second lowest priority on the right
                            leftside[#leftside+1]={value[1],value[2]}
                        else
                            --not same as the player with the second lowest priority on the right
                            count=count+1
                        end
                    end
                end
                if(count==3)then
                    rightside[#rightside+1]={value[1],value[2]}
                end
            end
        end
    end
end

--[[
--use this function to do any kind of asynchronous http calls
function CreateAudioQuery(text)
    text=string.gsub(text,"(.)",function (x) return string.format("\\x%02X",string.byte(x)) end)
    text=string.gsub(text,"\\x","%%")
    d("text:"..text)
    local params={
        host="127.0.0.1",
        path="audio_query?text="..text.."&speaker="..num_speaker,--
        port=50021,
        method="POST",--"GET","POST","PUT","DELETE"
        https=false,
        onsuccess=successAudioQuery,
        onfailure=failedAudioQuery,
        getheaders=true,--true will return the headers, if you dont need it you can leave this at nil
        --body=jsondata,--optional, if not required for your call can be nil or ""
        headers={["Content-Type"]="application/json;charset=utf-8"}--optional, if not required for your call can be nil or ""
    }
    HttpRequest(params)
end
function synthesis(speaker,data)
    d(json.encode(data))
    local params={
        host="127.0.0.1",
        path="synthesis?speaker="..speaker,--
        port=50021,
        method="POST",--"GET","POST","PUT","DELETE"
        https=false,
        onsuccess=successSynthesis,
        onfailure=failedSynthesis,
        getheaders=true,--true will return the headers, if you dont need it you can leave this at nil
        body=json.encode(data),--optional, if not required for your call can be nil or ""
        headers={["Content-Type"]="application/json;charset=utf-8"}--optional, if not required for your call can be nil or ""
    }
    HttpRequest(params)
end
function successAudioQuery(str,header,statuscode)
    d("AudioQuery HTTP Request: success.")
    d("AudioQuery HTTP Result Header:"..tostring(header))
    d("AudioQuery HTTP Result StatusCode:"..tostring(statuscode))
    local params={
        host="127.0.0.1",
        path="synthesis?speaker="..num_speaker,--
        port=50021,
        method="POST",--"GET","POST","PUT","DELETE"
        https=false,
        onsuccess=successSynthesis,
        onfailure=failedSynthesis,
        getheaders=true,--true will return the headers, if you dont need it you can leave this at nil
        body=str,--optional, if not required for your call can be nil or ""
        headers={["Content-Type"]="application/json;charset=utf-8"}--optional, if not required for your call can be nil or ""
    }
    HttpRequest(params)
end
function failedAudioQuery(error, header, statuscode)
    d("AudioQuery HTTP Failed Error:"..error)
    d("AudioQuery HTTP Failed Header:"..header)
    d("AudioQuery HTTP Failed StatusCode:"..tostring(statuscode))
end
function successSynthesis(str,header,statuscode)
    d("synthesis HTTP Request: success.")
    d("synthesis HTTP Result Header:"..tostring(header))
    d("synthesis HTTP Result StatusCode:"..tostring(statuscode))
    --i want to play str as wav file
end
function failedSynthesis(error, header, statuscode)
    d("synthesis HTTP Failed Error:"..error)
    d("synthesis HTTP Failed Header:"..header)
    d("synthesis HTTP Failed StatusCode:"..tostring(statuscode))
end
]]

function IsIncludedBuffTable(id,name,duration,table)
    local isInclude=false
    if(#table~=0)then
        for k,v in pairs(table) do
            if((v[1]==id)and(v[2]==name))then
                if(v[3]>=duration)then
                    isInclude=true
                    break
                end
            end
        end
    end
    return isInclude
end
function IsIncludedCastTable(id,name,channelingid,castingid,casttime,table)
    local isInclude=false
    if(#table~=0)then
        for k,v in pairs(table) do
            if((v[1]==id)and(v[2]==name)and(v[3]==channelingid)and(v[4]==v[4]==casttime)and(v[5]==casttime))then
                isInclude=true
                break
            end
        end
    end
    return isInclude
end
function IsIncludedEnemyTable(id,contentid,modelid,table)
    local isInclude=false
    if(#table~=0)then
        for k,v in pairs(table) do
            if((v[1]==id)and(v[2]==contentid)and(v[3]==modelid))then
                isInclude=true
                break
            end
        end
    end
    return isInclude
end
function IsIncludeBuffTOP(jobid,buffid,table)
    local isInclude=false
    if(#table~=0)then
        for k,v in pairs(table) do
            if((v[1]==jobid)and(v[2]==buffid))then
                isInclude=true
                break
            end
        end
    end
    return isInclude
end
function GetJobName(jobid)
    local jobname=""
    for k,v in pairs(jobtbl) do
        if(v==jobid)then
            jobname=k
        end
    end
    return jobname
end

RegisterEventHandler("Gameloop.Draw",main.Draw,"main-AnyNameHereToIdentYourCodeInCaseOfError")
RegisterEventHandler("Gameloop.Draw",pantokratorwindow.Draw,"pantokratorwindow-AnyNameHereToIdentYourCodeInCaseOfError")
RegisterEventHandler("Gameloop.Draw",partyposphase2window.Draw,"partyposphase2window-AnyNameHereToIdentYourCodeInCaseOfError")
RegisterEventHandler("Gameloop.Draw",partyposwindow.Draw,"partyposwindow-AnyNameHereToIdentYourCodeInCaseOfError")
RegisterEventHandler("Gameloop.Draw",noticewindow.Draw,"noticewindow-AnyNameHereToIdentYourCodeInCaseOfError")
RegisterEventHandler("Module.Initalize",main.Init,"main.Init")