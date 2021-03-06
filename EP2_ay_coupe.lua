--Ce programme permet de découper un arbre seul. 
--Plus d'info sur https://www.youtube.com/watch?v=rnhgpmMM6jM et https://www.youtube.com/watch?v=aPwSHFlwwq0

--Initialisation slots turtle
slotCharbon = 7
slotWood = 1
slotPlastic = 2
slotTree = 3
slotWaypoint = 8
slotChest = 9
slotBonemeal = 10
 
--Permet à la turtle de refaiure le plein d'energie si la turtle à moins de 800 d'énergie
function reEnergy()
        turtle.select(slotCharbon)
        if turtle.getFuelLevel() < 800 then
                turtle.suck()
                turtle.refuel()
        end
end

--Permet de déposer le bois dans le container situé en dessous de la turtle
function deposeWood()
        turtle.select(slotWood)
        turtle.drop(turtle.getItemCount(slotWood)-1)
end
 
--Idem, mais pour le plastique
function deposePlastic()
        turtle.select(slotPlastic)
        turtle.drop(turtle.getItemCount(slotPlastic)-1)
end
 
--Permet de refaire le plein de Saplings si la turtle en à moins de 2 dans son inventaire
function reTree()
        turtle.select(slotTree)
        if turtle.getItemCount(slotTree) < 2 then
                turtle.suck()
        end
end

--Permet de refaire le plein de Bonemeal
function reBonemeal()
        turtle.select(slotBonemeal)
        if turtle.getItemCount(slotBonemeal) < 5 then
                turtle.suckUp()
        end
end

--Vérifie si le block situé sous la turtle est du même type que le waypoint défini plus haut. Utilisé comme réparage 
--pour le déplacement de la turtle (nottament lors de son initialisation)
function isWaypoint()
        turtle.select(slotWaypoint)
        return turtle.compareDown()
end

--Vérifie si le bloc situé devant la turtle est de type chest
function isChest()
        turtle.select(slotChest)
        return turtle.compare()
end

--Replante un arbre
function rePlant()
        turtle.select(slotTree)
        turtle.place()
end
 
--Fonction qui permet de déposer le bois, le plastic, refaire le plein d'énergie et de sapling, de replanter l'arbre et 
--d'attendre qu'il pousse
function reAndFill(init)
        if not init then
                turtle.turnLeft()
                turtle.turnLeft()
                while turtle.forward() do
                end
        end
        turtle.turnLeft()
        reEnergy()
        turtle.turnRight()
        deposeWood()
        deposePlastic()
        turtle.turnRight()
        reTree()
        turtle.turnRight()
        reBonemeal()
        i = 0
        while isWaypoint() do
                i = i+1
                turtle.forward()
                if i > 10 then
                        break
                end
        end
        if not isWaypoint() then
                turtle.back()
        end
        rePlant()
        os.sleep(200)
        turtle.select(slotBonemeal)
        for i=0,4 do
                turtle.place()
        end
end

--Fonction qui permet de découper l'arbre. Fonctionnement uniquement avec des troncs droits (une seule ligne de tronc). 
--La turtle casse le bois et monte en hauteur tant qu'il y a du bois devant elle, jusqu'a atteindre la cime de l'arbre.
function decoupeArbre()
        turtle.select(slotWood)
        while turtle.detect() do
                turtle.dig()
                turtle.digUp()
                turtle.up()
        end
        while not isWaypoint() do
                turtle.down()
        end
end

--Fonction d'initialisation, déclenchée au démarrage de la turtle. Indispensable pour repositioner correctement la
--turtle (utile en cas de reboot serv par exemple)
function init()
        turtle.select(slotCharbon)
        turtle.refuel(1)
        local i = true
        while i do
         if not isWaypoint() then
                if not turtle.down() then
                        i = false
                end
                else
                i = false
         end           
        end
       
        i = true
        while i do
                if not turtle.forward() then
                        if isChest() then
                                i = false
                        else
                                turtle.turnLeft()
                        end
                else
                        if isWaypoint() then
                                i = false
                        else
                                turtle.back()
                                turtle.turnLeft()
                        end
                end            
        end
        while turtle.forward() do
                if not isWaypoint() then
                        turtle.turnLeft()
                        turtle.turnLeft()
                        turtle.forward()
                end
        end
        tourne()
end

--Fonction principale, appelé par le programme parent
function tourne()
        reAndFill(true)
        while true do
                decoupeArbre()
                reAndFill()
        end    
end
