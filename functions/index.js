const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();
exports.sendVaccineReminders = functions.pubsub
    .schedule("every 24 hours")
    .onRun(async (context) => {

        const today = new Date();
        const tomorrow = new Date(today);
        tomorrow.setDate(today.getDate() + 1); // إرسال تنبيه قبل بيوم

        const usersSnapshot = await db.collection("users").get();

        for (const userDoc of usersSnapshot.docs) {
            const userData = userDoc.data();

            const birthDateStr = userData.birthDate;
            const fcmToken = userData.fcmToken;

            if (!birthDateStr || !fcmToken) continue;

            const birthDate = new Date(birthDateStr);

            // جدول التطعيمات (تقدر تعدل على حسب جدولك)
            const vaccines = [
                { name: "تطعيم الولادة", daysAfterBirth: 0 },
                { name: "تطعيم شهرين", daysAfterBirth: 60 },
                { name: "تطعيم 4 شهور", daysAfterBirth: 120 },
                { name: "تطعيم 6 شهور", daysAfterBirth: 180 },
                { name: "تطعيم 9 شهور", daysAfterBirth: 270 },
                { name: "تطعيم سنة", daysAfterBirth: 365 },
            ];

            for (const vaccine of vaccines) {
                const vaccineDate = new Date(birthDate);
                vaccineDate.setDate(vaccineDate.getDate() + vaccine.daysAfterBirth);

                const diffDays = Math.ceil((vaccineDate - today) / (1000 * 60 * 60 * 24));

                if (diffDays === 1) {
                    // باقي يوم واحد فقط
                    await messaging.send({
                        token: fcmToken,
                        notification: {
                            title: "تذكير بالتطعيم",
                            body: `باقي يوم على ${vaccine.name}!`,
                        },
                    });
                    console.log(`تم إرسال إشعار إلى ${userData.name}`);
                }
            }
        }
        return null;
    });
