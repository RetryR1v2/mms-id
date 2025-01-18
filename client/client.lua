---@diagnostic disable: undefined-global
local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local FeatherMenu =  exports['feather-menu'].initiate()


local CreatedBlips3 = {}
local CreatedNpcs3 = {}
local HuntingLizenzOpen = false
local Ausweisgot = false
local jagtlizenzgot = false
local MyidOpen = false
local DocPaperOpen = false

Citizen.CreateThread(function()
local AusweisMenuPrompt = BccUtils.Prompts:SetupPromptGroup()
    local ausweisprompt = AusweisMenuPrompt:RegisterPrompt(_U('PromptName'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'})
    if Config.AusweisBlips then
        for h,v in pairs(Config.AusweisLocations) do
        local lotteryblip = BccUtils.Blips:SetBlip(_U('BlipName'), 'blip_job_board', 3.2, v.coords.x,v.coords.y,v.coords.z)
        CreatedBlips3[#CreatedBlips3 + 1] = lotteryblip
        end
    end
    if Config.CreateNPC then
        for h,v in pairs(Config.AusweisLocations) do
        local ausweisped = BccUtils.Ped:Create('A_M_O_SDUpperClass_01', v.coords.x, v.coords.y, v.coords.z -1, 0, 'world', false)
        CreatedNpcs3[#CreatedNpcs3 + 1] = ausweisped
        ausweisped:Freeze()
        ausweisped:SetHeading(v.NpcHeading)
        ausweisped:Invincible()
        SetBlockingOfNonTemporaryEvents(ausweisped:GetPed(), true)
        end
    end
    while true do
        Wait(1)
        for h,v in pairs(Config.AusweisLocations) do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local dist = #(playerCoords - v.coords)
        if dist < 2 then
            AusweisMenuPrompt:ShowGroup(_U('PromptName'))
            if Config.Show3dText then
            BccUtils.Misc.DrawText3D(v.coords.x, v.coords.y, v.coords.z, _U('ThreeDCreateID'))
            end
            if ausweisprompt:HasCompleted() then
                TriggerEvent('mms-id:client:openidmenu')
            end
        end
    end
    end
end)

RegisterNetEvent('mms-id:client:openidmenu')
AddEventHandler('mms-id:client:openidmenu',function()
    AusweisMenu:Open({
        startupPage = AusweisMenuPage1,
    })
end)


Citizen.CreateThread(function ()
    AusweisMenu = FeatherMenu:RegisterMenu('ausweismenu', {
        top = '20%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '700px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '800px',
        style = {
            ['border'] = '5px solid orange',
            -- ['background-image'] = 'none',
            ['background-color'] = '#FF8C00'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '250px'
            }
        },
        draggable = true,
    })
    AusweisMenuPage1 = AusweisMenu:RegisterPage('seite1')
    AusweisMenuPage1:RegisterElement('header', {
        value = _U('Licenses'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage1:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage1:RegisterElement('button', {
        label = _('IdPrice') .. Config.AusweisPreis ..'$',
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:createid')
    end)
    AusweisMenuPage1:RegisterElement('button', {
        label = _U('IdLost').. Config.AusweisVerlorenPreis ..'$',
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:regiveid')
    end)
    AusweisMenuPage1:RegisterElement('button', {
        label = _U('UpdateOwnID').. Config.UpdateIdPrice ..'$',
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:updateownid')
    end)
    AusweisMenuPage1:RegisterElement('button', {
        label = _U('ChangePicture').. Config.ChangeFotoPreis ..'$',
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:changephoto')
    end)
    if Config.JobLockHunting == false then
    AusweisMenuPage1:RegisterElement('button', {
        label = _U('BuyHuntingLicense') .. Config.HuntingLicensePrice.. '$',
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:createhuntingid')
    end)
    AusweisMenuPage1:RegisterElement('button', {
        label = _U('LostHuntingID').. Config.HuntingLicenseVerlorenPrice ..'$',
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:regivehuntingid')
    end)
    end
    AusweisMenuPage1:RegisterElement('button', {
        label =  _U('CloseMenu'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        AusweisMenu:Close({ 
        })
    end)
    AusweisMenuPage1:RegisterElement('subheader', {
        value = _U('Licenses'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage1:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    }) 

    ------- Seite 6 Menü mit Command für Joblock

    AusweisMenuPage6 = AusweisMenu:RegisterPage('seite6')
    AusweisMenuPage6:RegisterElement('header', {
        value = _U('HuntingLicense'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage6:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage6:RegisterElement('button', {
        label = _U('JobGiveHuntingLicense'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:createjobhuntingid')
    end)
    AusweisMenuPage6:RegisterElement('button', {
        label = _U('JobRevokeHuntingLicense'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:revokehuntingid')
    end)
    AusweisMenuPage6:RegisterElement('button', {
        label = _U('JobMyOwnLizenz'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:createmyownhuntingid')
    end)
    AusweisMenuPage6:RegisterElement('button', {
        label =  _U('CloseMenu'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        AusweisMenu:Close({ 
        })
    end)
    AusweisMenuPage6:RegisterElement('subheader', {
        value = _U('HuntingLicense'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage6:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    }) 

    ------- Seite 7 Rezept

    AusweisMenuPage7 = AusweisMenu:RegisterPage('seite7')
    AusweisMenuPage7:RegisterElement('header', {
        value = _U('CreateRcipeHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage7:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    local Firstname = ''
    AusweisMenuPage7:RegisterElement('input', {
    label = _U('Firstname'),
    placeholder = "...",
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    }
    }, function(data)
        Firstname = data.value
    end)
    local Lastname = ''
    AusweisMenuPage7:RegisterElement('input', {
    label = _U('Lastname'),
    placeholder = "...",
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    }
    }, function(data)
        Lastname = data.value
    end)
    local RecipeReason = ''
    AusweisMenuPage7:RegisterElement('textarea', {
    label = _U('RecipeReason'),
    placeholder = "....",
    rows = "6",
    -- cols = "14",
    resize = false,
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    }
    }, function(data)
        RecipeReason = data.value
    end)
    local Therapie = ''
    AusweisMenuPage7:RegisterElement('textarea', {
    label = _U('Therapie'),
    placeholder = "....",
    rows = "6",
    -- cols = "14",
    resize = false,
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    }
    }, function(data)
        Therapie = data.value
    end)
    local Days = ''
    AusweisMenuPage7:RegisterElement('input', {
    label = _U('Duration'),
    placeholder = "...",
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    }
    }, function(data)
        Days = data.value
    end)
    AusweisMenuPage7:RegisterElement('button', {
        label = _U('CreateRecipe'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-id:server:createdoctorrecipe',Firstname,Lastname,RecipeReason,Therapie,Days)
        AusweisMenu:Close({ 
        })
    end)
    AusweisMenuPage7:RegisterElement('button', {
        label =  _U('CloseMenu'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        AusweisMenu:Close({ 
        })
    end)
    AusweisMenuPage7:RegisterElement('subheader', {
        value = _U('CreateRcipeSubHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage7:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    }) 
end)


RegisterNetEvent('mms-id:client:changephoto')
AddEventHandler('mms-id:client:changephoto',function ()
    local photolinkinput = {
        type = "enableinput",
        inputType = "input",
        button = _U('Confirm'),
        placeholder = "",
        style = "block",
        attributes = {
            inputHeader = _U('InputDirctlink'),
            type = "text",
            pattern = "[0-9A-Za-z:/.]+", --  only numbers "[0-9]" | for letters only "[A-Za-z]+" 
            title = _U('AllAllowed'),
            style = "border-radius: 10px; background-color: ; border:none;"
        }
    }
    TriggerEvent("vorpinputs:advancedInput", json.encode(photolinkinput), function(result)
        
        if result ~= "" and result then
            local photolink = result
            TriggerServerEvent('mms-id:server:changephoto',photolink)
        else
            print(_U('NoInput'))
        end
    end)
end)

RegisterNetEvent('mms-id:client:createid')
AddEventHandler('mms-id:client:createid',function ()
    TriggerServerEvent('mms-id:server:createid')
end)

RegisterNetEvent('mms-id:client:updateownid')
AddEventHandler('mms-id:client:updateownid',function ()
    TriggerServerEvent('mms-id:server:updateownid')
end)

RegisterNetEvent('mms-id:client:regiveid')
AddEventHandler('mms-id:client:regiveid',function ()
    TriggerServerEvent('mms-id:server:regiveid')
end)

RegisterNetEvent('mms-id:client:revokehuntingid')
AddEventHandler('mms-id:client:revokehuntingid',function ()
    TriggerServerEvent('mms-id:server:revokehuntingid')
end)

RegisterNetEvent('mms-id:client:createmyownhuntingid')
AddEventHandler('mms-id:client:createmyownhuntingid',function()
    TriggerServerEvent('mms-id:server:createmyownhuntingid')
end)


RegisterNetEvent('mms-id:client:createhuntingid')
AddEventHandler('mms-id:client:createhuntingid',function ()
    local huntingiddays = {
        type = "enableinput",
        inputType = "input",
        button = _U('Confirm'),
        placeholder = "",
        style = "block",
        attributes = {
            inputHeader = _U('HowManyDays').. Config.HuntingLicensePrice .. '$',
            type = "number",
            pattern = "[0-9]", --  only numbers "[0-9]" | for letters only "[A-Za-z]+" 
            title = _U('OnlyNumbers'),
            style = "border-radius: 10px; background-color: ; border:none;"
        }
    }
    TriggerEvent("vorpinputs:advancedInput", json.encode(huntingiddays), function(result)
        
        if result ~= "" and result then
            local days = result
            TriggerServerEvent('mms-id:server:createhuntingid',days)
        else
            print(_U('NoInput'))
        end
    end)
end)

RegisterNetEvent('mms-id:client:showid')
AddEventHandler('mms-id:client:showid',function()
    TriggerServerEvent('mms-id:server:showidclosestplayer')
end)

RegisterNetEvent('mms-id:client:showhuntingid')
AddEventHandler('mms-id:client:showhuntingid',function()
    TriggerServerEvent('mms-id:server:showhuntingidclosestplayer')
end)

RegisterNetEvent('mms-id:client:regivehuntingid')
AddEventHandler('mms-id:client:regivehuntingid',function ()
    TriggerServerEvent('mms-id:server:regivehuntingid')
end)

RegisterNetEvent('mms-id:client:deltehuntingid')
AddEventHandler('mms-id:client:deltehuntingid',function ()
    TriggerServerEvent('mms-id:server:deltehuntingid')
end)

RegisterNetEvent('mms-id:client:openid')
AddEventHandler('mms-id:client:openid',function(firstname,lastname,nickname,job,age,gender,date,picture)
    if not MyidOpen then
        MyidOpen = true
    elseif MyidOpen then
        AusweisMenuPage2:UnRegister()
    end
    AusweisMenuPage2 = AusweisMenu:RegisterPage('seite2')
    AusweisMenuPage2:RegisterElement('header', {
        value = _U('Id'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage2:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage2:RegisterElement("html", {
        slot = 'header',
        value = {
            [[
                <img width="200px" height="200px" style="margin: 0 auto;" src="]] .. picture .. [[" />
            ]]
        }
    })
    Firstname = AusweisMenuPage2:RegisterElement('textdisplay', {
        value = _U('Firstname') .. firstname..'.',
        style = {}
    })
    Lastname = AusweisMenuPage2:RegisterElement('textdisplay', {
        value = _U('Lastname') .. lastname..'.',
        style = {}
    })
    Nickname = AusweisMenuPage2:RegisterElement('textdisplay', {
        value = _U('Nickname') .. nickname..'.',
        style = {}
    })
    Job = AusweisMenuPage2:RegisterElement('textdisplay', {
        value = _U('Job') .. job .. '.',
        style = {}
    })
    Age = AusweisMenuPage2:RegisterElement('textdisplay', {
        value = _U('Age') .. age .. '.',
        style = {}
    })
    Gender = AusweisMenuPage2:RegisterElement('textdisplay', {
        value = _U('Gender') .. gender .. '.',
        style = {}
    })
    Date = AusweisMenuPage2:RegisterElement('textdisplay', {
        value = _U('CreationDate') .. date .. '.',
        style = {}
    })
    AusweisMenuPage2:RegisterElement('button', {
        label =  _U('ShowID'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:showid')
    end)
    AusweisMenuPage2:RegisterElement('button', {
        label =  _U('HideID'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        AusweisMenu:Close({ 
        })
    end)
    MyidOpen = true
    AusweisMenu:Open({
        startupPage = AusweisMenuPage2,
    })
end)

RegisterNetEvent('mms-id:client:openhuntingid')
AddEventHandler('mms-id:client:openhuntingid',function(firstname,lastname,age,date,picture,days)
    if not HuntingLizenzOpen then
        HuntingLizenzOpen = true
    elseif HuntingLizenzOpen then
        AusweisMenuPage3:UnRegister()
    end
    AusweisMenuPage3 = AusweisMenu:RegisterPage('seite3')
    AusweisMenuPage3:RegisterElement('header', {
        value = _U('HuntingLicense'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage3:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage3:RegisterElement("html", {
        slot = 'header',
        value = {
            [[
                <img width="200px" height="200px" style="margin: 0 auto;" src="]] .. picture .. [[" />
            ]]
        }
    })
    FirstnameH = AusweisMenuPage3:RegisterElement('textdisplay', {
        value = _U('Firstname')..firstname..'.',
        style = {}
    })
    LastnameH = AusweisMenuPage3:RegisterElement('textdisplay', {
        value = _U('Lastname')..lastname..'.',
        style = {}
    })
    AgeH = AusweisMenuPage3:RegisterElement('textdisplay', {
        value = _U('Age')..age..'.',
        style = {}
    })
    DateH = AusweisMenuPage3:RegisterElement('textdisplay', {
        value = _U('CreationDate')..date..'.',
        style = {}
    })
    DaysH = AusweisMenuPage3:RegisterElement('textdisplay', {
        value = _U('ValidFor') .. days .. _U('Days') .. '.',
        style = {}
    })
    AusweisMenuPage3:RegisterElement('button', {
        label =  _U('ShowHuntingLicense'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:showhuntingid')
    end)
    AusweisMenuPage3:RegisterElement('button', {
        label =  _U('BurnHuntingLicense'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-id:client:deltehuntingid')
        AusweisMenu:Close({ 
        })
    end)
    AusweisMenuPage3:RegisterElement('button', {
        label =  _U('HideHuntingLicense'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        AusweisMenu:Close({ 
        })
    end)
    AusweisMenuPage3:RegisterElement('subheader', {
        value = _U('HuntingLicense'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage3:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenu:Open({
        startupPage = AusweisMenuPage3,
    })
end)



RegisterNetEvent('mms-id:client:opendocpaper')
AddEventHandler('mms-id:client:opendocpaper',function(Name,DocName,Age,Date,Reason,Therapie,Days,MyOwn)
    if not DocPaperOpen then
        DocPaperOpen = true
    elseif DocPaperOpen then
        AusweisMenuPage8:UnRegister()
    end
    AusweisMenuPage8 = AusweisMenu:RegisterPage('seite8')
    AusweisMenuPage8:RegisterElement('header', {
        value = _U('MyDoctorsRecipeHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage8:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    PatientName = AusweisMenuPage8:RegisterElement('textdisplay', {
        value = _U('Patient')..Name..'.',
        style = {
            ['font-size'] = '20px',
            ['font-weight'] = 'bold',
            ['color'] = 'orange',
        }
    })
    PatientAge = AusweisMenuPage8:RegisterElement('textdisplay', {
        value = _U('Age')..Age..'.',
        style = {
            ['font-size'] = '20px',
            ['font-weight'] = 'bold',
            ['color'] = 'orange',
        }
    })
    RecipeReason = AusweisMenuPage8:RegisterElement('textdisplay', {
        value = _U('Reason') .. Reason,
        style = {
            ['font-size'] = '20px',
            ['font-weight'] = 'bold',
            ['color'] = 'orange',
        }
    })
    RecipeTherapie = AusweisMenuPage8:RegisterElement('textdisplay', {
        value = _U('Therapie') .. Therapie,
        style = {
            ['font-size'] = '20px',
            ['font-weight'] = 'bold',
            ['color'] = 'orange',
        }
    })
    DoctorName = AusweisMenuPage8:RegisterElement('textdisplay', {
        value = _U('DoctorsName')..DocName..'.',
        style = {
            ['font-size'] = '20px',
            ['font-weight'] = 'bold',
            ['color'] = 'orange',
        }
    })
    DateCreated = AusweisMenuPage8:RegisterElement('textdisplay', {
        value = _U('CreationDate')..Date..'.',
        style = {
            ['font-size'] = '20px',
            ['font-weight'] = 'bold',
            ['color'] = 'orange',
        }
    })
    DaysValid = AusweisMenuPage8:RegisterElement('textdisplay', {
        value = _U('ValidFor') .. Days .. _U('Days') .. '.',
        style = {
            ['font-size'] = '20px',
            ['font-weight'] = 'bold',
            ['color'] = 'orange',
        }
    })
    if MyOwn then
        AusweisMenuPage8:RegisterElement('button', {
        label =  _U('ShowDoctorsRecipe'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-id:server:showdoctorrecipe')
    end)
    end
    AusweisMenuPage8:RegisterElement('subheader', {
        value = _U('MyDoctorsRecipeSubHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenuPage8:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    AusweisMenu:Open({
        startupPage = AusweisMenuPage8,
    })
end)


----------------- GET ID FROM ANOTHER PLAYER

RegisterNetEvent('mms-id:client:getid')
AddEventHandler('mms-id:client:getid',function (firstname,lastname,nickname,job,age,gender,date,picture)
        -------------- Seite 4 GETID
    if not Ausweisgot then
        Ausweisgot = true
    elseif Ausweisgot then
        AusweisMenuPage4:UnRegister()
    end
        AusweisMenuPage4 = AusweisMenu:RegisterPage('seite4')
        AusweisMenuPage4:RegisterElement('header', {
            value = _U('Id'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        AusweisMenuPage4:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        AusweisMenuPage4:RegisterElement("html", {
            slot = 'header',
            value = {
                [[
                    <img width="200px" height="200px" style="margin: 0 auto;" src="]] .. picture .. [[" />
                ]]
            }
        })
        FirstnameGot = AusweisMenuPage4:RegisterElement('textdisplay', {
            value = _U('Firstname') .. firstname .. '.',
            style = {}
        })
        LastnameGot = AusweisMenuPage4:RegisterElement('textdisplay', {
            value = _U('Lastname') .. lastname .. '.',
            style = {}
        })
        NicknameGot = AusweisMenuPage4:RegisterElement('textdisplay', {
            value = _U('Nickname') .. nickname .. '.',
            style = {}
        })
        JobGot = AusweisMenuPage4:RegisterElement('textdisplay', {
            value = _U('Job') .. job .. '.',
            style = {}
        })
        AgeGot = AusweisMenuPage4:RegisterElement('textdisplay', {
            value = _U('Age') .. age .. '.',
            style = {}
        })
        GenderGot = AusweisMenuPage4:RegisterElement('textdisplay', {
            value = _U('Gender') .. gender .. '.',
            style = {}
        })
        DateGot = AusweisMenuPage4:RegisterElement('textdisplay', {
            value = _U('CreationDate') .. date .. '.',
            style = {}
        })
        AusweisMenuPage4:RegisterElement('button', {
            label =  _U('HideID'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            AusweisMenu:Close({ 
            })
        end)
        AusweisMenuPage4:RegisterElement('subheader', {
            value = _U('Id'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        AusweisMenuPage4:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        Ausweisgot = true
        AusweisMenu:Open({
            startupPage = AusweisMenuPage4,
        })
end)

RegisterNetEvent('mms-id:client:gethuntingid')
AddEventHandler('mms-id:client:gethuntingid',function (firstname,lastname,age,date,picture,days)
        -------------- Seite 4 GETID
        if not jagtlizenzgot then
            jagtlizenzgot = true
        elseif jagtlizenzgot == true then
            AusweisMenuPage5:UnRegister()
        end
        AusweisMenuPage5 = AusweisMenu:RegisterPage('seite5')
        AusweisMenuPage5:RegisterElement('header', {
            value = _U('HuntingLicense'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        AusweisMenuPage5:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        AusweisMenuPage5:RegisterElement("html", {
            slot = 'header',
            value = {
                [[
                    <img width="200px" height="200px" style="margin: 0 auto;" src="]] .. picture .. [[" />
                ]]
            }
        })
        FirstnameGotH = AusweisMenuPage5:RegisterElement('textdisplay', {
            value = _U('Firstname') .. firstname .. '.',
            style = {}
        })
        LastnameGotH = AusweisMenuPage5:RegisterElement('textdisplay', {
            value = _U('Lastname') .. lastname .. '.',
            style = {}
        })
        AgeGotH = AusweisMenuPage5:RegisterElement('textdisplay', {
            value = _U('Age') .. age .. '.',
            style = {}
        })
        DateGotH = AusweisMenuPage5:RegisterElement('textdisplay', {
            value = _U('CreationDate') .. date .. '.',
            style = {}
        })
        DaysGotH = AusweisMenuPage5:RegisterElement('textdisplay', {
            value = _U('ValidFor') .. days .. _U('Days') .. '.',
            style = {}
        })
        AusweisMenuPage5:RegisterElement('button', {
            label =  _U('HideHuntingLicense'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            AusweisMenu:Close({ 
            })
        end)
        AusweisMenuPage5:RegisterElement('subheader', {
            value = _U('HuntingLicense'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        AusweisMenuPage5:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        jagtlizenzgot = true
        AusweisMenu:Open({
            startupPage = AusweisMenuPage5,
        })
end)


RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter',function()
    Citizen.Wait(10000)
    if Config.JobLockHunting then
        local Job = VORPcore.Callback.TriggerAwait('mms-id:callback:getplayerjob')
        for c,v in ipairs(Config.HuntingJobs) do
            if Job == v.JobName then
                RegisterCommand(Config.HuntingCommand, function()
                    TriggerEvent('mms-id:client:openjobhuntingcreation')
                end)
            end
        end
    end

    if Config.CreateDoctorRecipes then
        local Job = VORPcore.Callback.TriggerAwait('mms-id:callback:getplayerjob')
        for c,v in ipairs(Config.DoktorJobs) do
            if Job == v.JobName then
                RegisterCommand(Config.DoktorCommand, function()
                    TriggerEvent('mms-id:client:opendoccreation')
                end)
            end
        end
    end
end)

if Config.Debug then
Citizen.CreateThread(function ()
    if Config.JobLockHunting then
        local Job = VORPcore.Callback.TriggerAwait('mms-id:callback:getplayerjob')
        for c,v in ipairs(Config.HuntingJobs) do
            if Job == v.JobName then
                RegisterCommand(Config.HuntingCommand, function()
                    TriggerEvent('mms-id:client:openjobhuntingcreation')
                end)
            end
        end
    end
    Citizen.Wait(250)
    if Config.CreateDoctorRecipes then
        local Job = VORPcore.Callback.TriggerAwait('mms-id:callback:getplayerjob')
        for c,v in ipairs(Config.DoktorJobs) do
            if Job == v.JobName then
                RegisterCommand(Config.DoktorCommand, function()
                    TriggerEvent('mms-id:client:opendoccreation')
                end)
            end
        end
    end
end)
end

RegisterNetEvent('mms-id:client:openjobhuntingcreation')
AddEventHandler('mms-id:client:openjobhuntingcreation',function()
    AusweisMenu:Open({
        startupPage = AusweisMenuPage6,
    })
end)

RegisterNetEvent('mms-id:client:opendoccreation')
AddEventHandler('mms-id:client:opendoccreation',function ()
    AusweisMenu:Open({
        startupPage = AusweisMenuPage7,
    })
end)

RegisterNetEvent('mms-id:client:createjobhuntingid')
AddEventHandler('mms-id:client:createjobhuntingid',function ()
    local jobhuntingiddays = {
        type = "enableinput",
        inputType = "input",
        button = _U('Confirm'),
        placeholder = "",
        style = "block",
        attributes = {
            inputHeader = _U('JobHowManyDays'),
            type = "number",
            pattern = "[0-9]", --  only numbers "[0-9]" | for letters only "[A-Za-z]+" 
            title = _U('OnlyNumbers'),
            style = "border-radius: 10px; background-color: ; border:none;"
        }
    }
    TriggerEvent("vorpinputs:advancedInput", json.encode(jobhuntingiddays), function(result)
        
        if result ~= "" and result then
            local days = result
            TriggerServerEvent('mms-id:server:createjobhuntingid',days)
        else
            print(_U('NoInput'))
        end
    end)
end)

---- CleanUp on Resource Restart 

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
    for _, npcs in ipairs(CreatedNpcs3) do
        npcs:Remove()
	end
    for _, blips in ipairs(CreatedBlips3) do
        blips:Remove()
	end
    end
end)