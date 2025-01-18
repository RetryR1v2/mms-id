Config = {}


Config.defaultlang = "de_lang" -- Set Language (Current Languages: "en_lang" English, "de_lang" German)
Config.Debug = true
-----------------------------------------------------------------------------------
---------------------------------ID Settings----------------------------------
-----------------------------------------------------------------------------------

Config.AusweisBlips = true
Config.CreateNPC = true
Config.Show3dText = true
Config.AusweisLocations = {

    {
        coords = vector3(-251.55, 742.91, 118.09),   --- Also the Location of Blip and Npc (Valentine)
        NpcHeading = 110.86,
    },
    {
        coords = vector3(-798.78, -1194.6, 44.0),   --- Also the Location of Blip and Npc (Blackwater)
        NpcHeading = 175.84,
    },
}

Config.IdCardItem = 'idcard'
Config.HuntingIdItem = 'jagtlizenz'

Config.UpdateIdPrice = 10.00
Config.AusweisPreis = 10.00
Config.AusweisVerlorenPreis = 15.00
Config.ChangeFotoPreis = 10.00

Config.JobLockHunting = false
Config.HuntingCommand = 'Jagdlizenz' -- Command TO Popup HunterLicense Menü
Config.HuntingJobs =  {
    {JobName = 'schmied1'},
}
Config.HuntingLicensePrice = 10.00
Config.HuntingLicenseVerlorenPrice = 30.00
Config.HuntingIdPicture = 'https://i.postimg.cc/V6C2XNBp/Jagdlizenz.png' -- <-- Picture of Directlink from  https://postimg.cc Readme for Picture Info

Config.CreateDoctorRecipes = true
Config.DoktorCommand = 'Attest' -- Command TO Popup Doktors Menü
Config.DoktorJobs =  {
    {JobName = 'doktor1'},
}
