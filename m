Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519BD12CB67
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 01:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfL3AM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 19:12:59 -0500
Received: from sonic304-10.consmr.mail.bf2.yahoo.com ([74.6.128.33]:40210 "EHLO
        sonic304-10.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbfL3AM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 19:12:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1577664777; bh=RFkL5gy5YztyhjPEqb8C7YgdticOB4/BDMyv0010KkE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=c/zMnb372gpk+v5JoiWjtVmTcrmyOFKHfcaedrGrZPJpC8fyXsHFLpBVI1SC59EzNLbnx/R5SLUkYweQEtX17JracIMLnknf41u6de2TjDA7sKqBX5WrvGDSSHoGkyBoqSfixjivqfbvQgAm+MsKPPw6ZACtwAtuThLCepcqsixebOcYAdT98OKGBBWM3JcWsiXe/e1mZ++kNLuiloOBBR5xAGgWM7oJ9Kh6U6Kb0D7oezTdkhMSTirQJEKlEbwupdkA333jnYMbsF3x/sbUjXuyTKUlZ+hFf+F4TtZvr41lIUlOKjq/JunAiqyn6wMZF0ZHHvM4GYnrP7cxdxONRA==
X-YMail-OSG: IV2BasAVM1nJ1kiv9LqvnT8hHTVSII9Ji6B7BDlAnC_mf1ttQVIrukqbxxcr8p2
 6fIi6TzzpaqGDbDugTGpMC170hqpXWW9tueXGwrKBDEPVHz4cemKpVb2X8KC2FZpTAX_osVc8TK9
 B5nIWP8z6cXsSa.fjPiCLXZOl4WEfc25V8vg3PybcpYzSSz6GNT5435X80Ix42l3F.Pz2fKtlA68
 p02aOfZ.newrvb9qy5d.mAGm618pYa6thkCP4QnFAmkWFnpv6eVfySbP.Aeg_300F63q5xyF5isl
 z0ZF_oMPHCw2KWMVOIPQQSWBEu6hJcFhH.QMg.ac89cBe2tkdp58A0LXEHrSFBL9ay7maFb9ehn5
 1ztUGplDh2hZUpXwnHQNM.OvrHKauet6SVGW5KlBahDe5zqVsAzC60o5coJ6uh5pWOjGOkSdxvD7
 KwY_xs9T0cQis8wxFxwP7LMhlyUzgIfZP3RPsO6Iywjb8yRWR3e6D2N9zeyAYYtLt3abUqIhGgvG
 5feYAjDkZbEoTX0AIxVri__gNlU8oblAm4OaSsrmFYHF54hA2vIleJk.Rdz9TeV.1LrqP0QfuV8D
 atHmdE9IIB_Oq2FgZQ9n51e19dwC2au3bumGe54kPLzAMJDphDvaAahTIbLJNt4fZJC2Li3BSWxr
 RXdbJHo0JpcE0NMGE3HfftC4C4d.li4AryX.RNGiSei9BiOFo_8CqL1X_eRWMmo5uVdiNsnotp0c
 SNijLAvMIn4wEsOJCiLH9GVv3vXf6ezuSxXMXE3XpReJkhsb3I4C0PkzhQHfVJWVcpgPiPposWe5
 eWipsRYuo_d8LqhjdpEdwo2TL3m1XEUj1BAdkVtHwidh5LGMO7s4x5EpPHFvkcogf0BqOBX8k5Jy
 tx24_qHdt1UEpuR4Ltuhc6FAKSfysQOVW5rPHhou7JgZE4KNZ2QISuYqgorA6ZMS5.8mDNJjNnLA
 EcJMRmQoMrW2cueNXmH9CS8Me0.m7TmlcjwuMGkrKQPtDQCP06iyHKt6ix3WISm08f_Hez4yBtSk
 pNwGAVbcHnLo28PLRGqe5b9PEjpGfkM9EZwTeZlykExeFSKAVfKulHX.3hTQ4Cw68g6DYyFXRzaG
 2f1wK.OS61IhP2jiDuBtblV4e4TIe3gcdBrY6r5YxhBRTp1I937jqx8xCI__q_3zVbwbrmf40chy
 xKHtf4rhXiahQVTsbaQd_23bnQ.T8qyqQ6_BOiZG6vH.X2EYXE8jiwLcXvILb128QiMLtoEGRnI9
 ldeQkr2Bjemuj97uFr0VIxzRl1FJvWAPG8vA4FnryQ9vlWmVfEgTdafXGYTzP7rqyP2WOzg5i.Te
 qoFE679oeq4nm1rSqYeBKWc4SZFqly.d6_7nr
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Mon, 30 Dec 2019 00:12:57 +0000
Date:   Mon, 30 Dec 2019 00:12:54 +0000 (UTC)
From:   Mrs Aisha Al-gaddafi <mrsaishagaddafi18@gmail.com>
Reply-To: mrsaishaalgaddafi09@gmail.com
Message-ID: <1430915175.3053192.1577664774108@mail.yahoo.com>
Subject: Greetings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1430915175.3053192.1577664774108.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36 AVG/77.2.2156.122
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,

Greetings and Nice Day.

Assalamu Alaikum

May i =C2=A0use this medium to open a mutual communication with you seeking=
 your acceptance towards investing in your country under your management as=
 my partner, My name is Aisha =C2=A0Gaddafi and presently living in Oman, i=
 am a Widow and single Mother with three Children, the only biological Daug=
hter of late Libyan President (Late Colonel Muammar Gaddafi) and presently =
i am under political asylum protection by the Omani Government.

I have funds worth "Twenty Seven Million Five Hundred Thousand United State=
 Dollars" -$27.500.000.00 US Dollars which i want to entrust on you for inv=
estment project in your country.If you are willing to handle this project o=
n my behalf, kindly reply urgent to enable me provide you more details to s=
tart the transfer process.
I shall appreciate your urgent response through my email address below:

mrsaishaalgaddafi09@gmail.com

Best Regards
Mrs Aisha Gaddafi
