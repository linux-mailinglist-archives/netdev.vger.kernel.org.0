Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6421747D13B
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238070AbhLVLqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238045AbhLVLqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 06:46:03 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B1AC061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:46:03 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id n7so3603293uaq.12
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=sDaXiOYyDhCCFl9VutUDZc6v44b3h7h09S+Y52Cm8qw=;
        b=ke7FdfntnXOSI/DF8cGz92Z+jiMBotzbuNLcnQs9C8RSFYCjnfcImIpwBjgSpCtYJL
         lrBlDkmOANAhCyoE268oua23i8XIZlwDeRWckhDPnRZ6yMKfUS7IV+hK5pKab8OAW6Ps
         wuzm6fLHdC6X1c0nWZDCALEJ1rcHfI+/BTLS8FgstEW9Fr3VJRQ9ORnpxeMsytAVPxj3
         ZWrqZAmt++lavkrIiheo+l6Mh0YGQy0ZiCCvHdkkqxVv9gvj51YcjgXlBcBDHaAtxxuP
         BVRAOmgfUh4JP9j+ySuk/FfDO+bTXzQPxDO8EyEXrnxl8T6k+1H2qY49qJPm1iILj1fk
         v2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=sDaXiOYyDhCCFl9VutUDZc6v44b3h7h09S+Y52Cm8qw=;
        b=DqN/f6ZXcTiCXPfzfLVX+b8LoiCnzG+JiZVbo5yFxrV0oyi3aO5p/XCBafgxF6Optw
         36Hidrv/5D8/IYRaa+f8eOXERaNAryJhuHSOm9VIFTmpxCoMk6bDRsEOrMqAKNO/pjeb
         44n5kzDfsNCWSpictR3TihqnFSI1OfcmD7lc6ZaLYX5r9xQKy5VrbCWsj1zj2qkR82eK
         QuMaD/7iQNn0I2mMn1Nzwd4mk8D6QUpi4ulv4/WO9VGP6h0w2+Iy9UE303qn8zrYOC5Q
         SjbAjLeUaWGDhIjQBLYTgi1HwaNFbXnqj2H+FP5acgOpWAloJbzMbGQi97J8kASxktSu
         6XLw==
X-Gm-Message-State: AOAM532mWSE5CCVCyL5ttBL/V8T1BLaPjR2AhYMyan2M9iy513IJOkYQ
        iZOvferOv/inarlINj0EMqWcQSpR6nl4cIvb39o=
X-Google-Smtp-Source: ABdhPJz6ZYnBSRsHpykpsEpLPSvDDOGf3Sm1bhw37U6/ISdpE0vN+CC+MxG8ANTXNZCKp5a9xcgZ7lL2gmopgjBEAN0=
X-Received: by 2002:a67:e042:: with SMTP id n2mr982588vsl.15.1640173562770;
 Wed, 22 Dec 2021 03:46:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:9a43:0:b0:271:75db:9647 with HTTP; Wed, 22 Dec 2021
 03:46:02 -0800 (PST)
Reply-To: cristinacampeell@outlook.com
From:   "Mrs. Cristina Campbell" <smith76544@gmail.com>
Date:   Wed, 22 Dec 2021 11:46:02 +0000
Message-ID: <CAAYzYtPzoa1mEuiFTyeYwzZhT1gCoAEoqEVo7ue6UmXYjuCTCw@mail.gmail.com>
Subject: =?UTF-8?B?64KY66W8IOuPhOyZgOykhCDsiJgg7J6I64uIPw==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

7IKs656R7ZWY64qUIOyXsOyduCwNCg0K7J20IOydtOuplOydvOydgCDqt4DtlZjqsIAg67Cb7J2A
IOqwgOyepSDspJHsmpTtlZwg7J2066mU7J28IOykkSDtlZjrgpjsnbwg7IiYIOyeiOycvOuvgOuh
nCDsspzsspztnogg7KO87J2YIOq5iuqyjCDsnb3snLzsi63si5zsmKQuIOyggOuKlCBDcmlzdGlu
YQ0KQ2FtcGJlbGwg67aA7J247J6F64uI64ukLiDsoIDripQg64qm7J2AIEVkd2FyZCBDYW1wYmVs
bOqzvCDqsrDtmLztlojsirXri4jri6QuIOq3uOuKlCBTaGVsbCBQZXRyb2xldW0NCkRldmVsb3Bt
ZW50IENvbXBhbnkgTG9uZG9u7JeQ7IScIOydvO2WiOyKteuLiOuLpC4g64+Z7JWE7Iuc7JWEIOyn
gOyXreydmCDrhbjroKjtlZwg6rOE7JW97J6QLiDqt7jripQgMjAwM+uFhCA37JuUIDMx7J28DQrs
m5TsmpTsnbwg7YyM66as7JeQ7IScIOyCrOunne2WiOyKteuLiOuLpC4g7Jqw66as64qUIOyVhOyd
tCDsl4bsnbQgN+uFhCDrj5nslYgg6rKw7Zi87ZaI7Iq164uI64ukLg0KDQrri7nsi6DsnbQg7J20
IOq4gOydhCDsnb3snLzrqbTshJwg64KY66W8IOu2iOyMje2eiCDsl6zquLDsp4Ag7JWK7JWY7Jy8
66m0IO2VqeuLiOuLpC4g7Jmc64OQ7ZWY66m0IOyggOuKlCDrqqjrk6Ag7IKs656M7J20IOyWuOyg
oOqwgOuKlCDso73snYQg6rKD7J2065286rOgIOuvv+q4sA0K65WM66y47J6F64uI64ukLiDrgpjr
ipQg7Iud64+E7JWUIOynhOuLqOydhCDrsJvslZjqs6Ag64KY7J2YIOydmOyCrOuKlCDrgpjsnZgg
67O17J6h7ZWcIOqxtOqwlSDrrLjsoJzroZwg7J247ZW0IOyYpOuemCDqsIDsp4Ag66q77ZWgIOqy
g+ydtOudvOqzoCDrp5DtlojsirXri4jri6QuDQoNCu2VmOuCmOuLmOq7mOyEnCDsoIDsl5Dqsowg
7J6Q67mE66W8IOuyoO2RuOyLnOqzoCDsoJwg7JiB7Zi87J2EIOuwm+yVhOyjvOyLnOq4sOulvCDr
sJTrnbzripQg66eI7J2M7JeQIOyekOyEoOuLqOyytC/qtZDtmowv67aI6rWQL+uqqOyKpO2BrC/s
lrTrqLjri4gg7JeG64qUIOyYgeycoOyVhC/shozsmbjqs4TsuLUNCuuwjyDqs7zrtoDsl5Dqsowg
7J6Q7ISg7J2EIO2VmOq4sOuhnCDtlojsirXri4jri6QuIOuCmOuKlCDso73quLAg7KCE7JeQIOyn
gOyDgeyXkOyEnCDtlZzri6QuIOyngOq4iOq5jOyngCDrgpjripQg7Iqk7L2U7YuA656c65OcLCDs
m6jsnbzspogsIOuEpO2MlCwg7ZWA656A65OcLA0K67iM65287KeI7JeQIOyeiOuKlCDrqofrqocg
7J6Q7ISgIOuLqOyytOyXkCDrj4jsnYQg6riw67aA7ZaI7Iq164uI64ukLiDsnbTsoJwg6rG06rCV
7J20IOuEiOustCDrgpjruaDshJwg642UIOydtOyDgSDrgpgg7Zi87J6QIO2VoCDsiJgg7JeG7Iq1
64uI64ukLg0KDQrtlZzrsojsnYAg6rCA7KGx65Ok7JeQ6rKMIOuCtCDqs4Tsoowg7KSRIO2VmOuC
mOulvCDtj5Dsh4TtlZjqs6Ag6rGw6riw7JeQIOyeiOuKlCDrj4jsnYQg7KSR6rWtLCDsmpTrpbTr
i6gsIOuPheydvCwg7ZWc6rWtLCDsnbzrs7jsnZgg7J6Q7ISgIOuLqOyytOyXkCDrtoTrsLDtlZjr
nbzqs6ANCuyalOyyre2WiOyngOunjCDqt7jrk6TsnYAg6rGw67aA7ZWY6rOgIOuPiOydhCDtmLzs
npAg67O06rSA7ZaI7Iq164uI64ukLiDrlLDrnbzshJwg7KCA64qUIOq3uOugh+qyjCDtlZjsp4Ag
7JWK7Iq164uI64ukLiDrgrTqsIAg6re465Ok7JeQ6rKMIOuCqOqyqOuRlCDqsoPqs7wg64uk7Yis
7KeAIOyViuuKlA0K6rKDIOqwmeycvOuLiCDrjZQg7J207IOBIOq3uOuTpOydhCDrr7/snLzsi63s
i5zsmKQuIOyVhOustOuPhCDrqqjrpbTripQg64K0IOuniOyngOuniSDrj4jsnYAgNjAw66eMIOuv
uOq1rSDri6zrn6woNjAw66eMIOuLrOufrCnrnbzripQg6rGw7JWh7J2YIO2YhOq4iA0K7JiI7LmY
6riI7Jy866GcIO2DnOq1reyXkCDsnojripQg7J2A7ZaJ7JeQIOyYiOq4iO2VtCDrkZQg6rKD7J6F
64uI64ukLiDsnbQg6riw6riI7J2EIOyekOyEoCDtlITroZzqt7jrnqjsl5Ag7IKs7Jqp7ZWY6rOg
IOuLueyLoOydtCDshLHsi6TtlZjquLDrp4wg7ZWY64uk66m0IOuLueyLoOydmA0K64KY65287JeQ
7IScIOyduOulmOulvCDsp4Dsm5DtlZjquLDrpbwg67CU656N64uI64ukLg0KDQrrgpjripQg7J20
IOuPiOydhCDsg4Hsho3rsJvsnYQg7JWE7J206rCAIOyXhuq4sCDrlYzrrLjsl5Ag7J20IOqysOyg
leydhCDrgrTroLjsirXri4jri6QuIOuCmOuKlCDso73snYzsnbQg65GQ66C17KeAIOyViuycvOuv
gOuhnCDslrTrlJTroZwg6rCA64qU7KeAIOyVleuLiOuLpC4g64KY64qUDQrso7zri5jsnZgg7ZKI
IOyViOyXkCDsnojqsowg65CgIOqyg+yehOydhCDslZXri4jri6QuIOq3gO2VmOydmCDtmozsi6Ds
nYQg67Cb64qUIOymieyLnCDqt4DtlZjsl5Dqsowg7J2A7ZaJIOyXsOudveyymOulvCDsoJzqs7Xt
lZjqs6Ag6reA7ZWY6rCAIOq3gO2VmOydmCDqta3qsIDsl5DshJwg7J20DQrsnpDshKAg7ZSE66Gc
6re4656o7J2EIOymieyLnCDsi5zsnpHtlaAg7IiYIOyeiOuPhOuhnSDsnbQg6riw6riI7J2YIOy1
nOy0iCDsiJjtmJzsnpDroZzshJwg6raM7ZWc7J2EIOu2gOyXrO2VmOuKlCDsirnsnbjshJzrpbwg
67Cc7ZaJ7ZWY6rKg7Iq164uI64ukLg0KDQrrgqjsnYQg7JyE7ZW0IOyCsCDsgrbrp4zsnbQg6rCA
7LmYIOyeiOuKlCDsgrbsnbTri6QuIOuCmOuKlCDri7nsi6DsnbQg7ZWt7IOBIOuCmOulvCDsnITt
lbQg6riw64+E7ZW0IOyjvOq4sOulvCDrsJTrno3ri4jri6QuIOuLueyLoOydmCDtmozsi6DsnbQg
64qm7Ja07KeA66m0IOydtCDqsJnsnYANCuuqqeyggeydhCDsnITtlbQg64uk66W4IOyCrOuejOyd
hCDshozsi7HtlaAg7Jes7KeA6rCAIOyDneq4uCDqsoPsnoXri4jri6QuIOq0gOyLrOydtCDsl4bs
nLzsi5zri6TrqbQg7Jew652965Oc66CkIOyjhOyGoe2VqeuLiOuLpC4g64K0IOqwnOyduA0K7J20
66mU7J28KGNyaXN0aW5hY2FtcGVlbGxAb3V0bG9vay5jb20p66GcIOyXsOudve2VmOqxsOuCmCDt
mozsi6DtlaAg7IiYIOyeiOyKteuLiOuLpC4NCg0K6rCQ7IKsIO2VtOyalCwNCuynhOyLrOycvOuh
nCwNCu2BrOumrOyKpO2LsOuCmCDsuqDrsqgg67aA7J24DQrsnbTrqZTsnbw7IGNyaXN0aW5hY2Ft
cGVlbGxAb3V0bG9vay5jb20NCg==
