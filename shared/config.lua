return {
    NotifyDuration = 5000, -- Notif Durasi
    Cooldown = 60, -- Cooldown 
    Location = {
        ["JobBell"] = {
            [1] = { -- Contoh Menggunakan Image Link
                coords = vec3(-1846.4949, -1187.5017, 13.0172), -- Koordinat
                debug = false, -- Ingin ada Debug Atau Tidak?
                useped = false, -- Ingin Gunain Ped Atau Tidak?
                pedModel = "a_m_m_business_01",  -- Model Ped
                radius = 1, -- Radius Target
                rotation = 50, -- rotation Target
                job = 'police',
                sound = 'Alert',
                callmessage = 'Warga membutuhkan pertolongan bantuan di rumah sakit',
                Cooldown = 60,
                icon = "fas fa-bell",  -- Icon Target
                label = "Bell" -- Label Target
            },
            [2] = { -- Contoh Menggunakan Image Local
                coords = vec3(-1836.6008, -1188.7816, 14.2164), -- Koordinat
                debug = false, -- Ingin ada Debug Atau Tidak?
                useped = false, -- Ingin Gunain Ped Atau Tidak?
                pedModel = "a_m_m_business_01",  -- Replace with the desired ped model
                radius = 1, -- Radius Target
                rotation = 50,  -- Rotation Target
                job = 'ambulance',
                sound = 'Alert',
                callmessage = 'Warga membutuhkan pertolongan bantuan di rumah sakit',
                icon = "fas fa-bell", -- Icon Target
                label = "Bell" -- Label Target
            },
        },
    }
}