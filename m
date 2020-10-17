Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941CC291424
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 21:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439418AbgJQTeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 15:34:22 -0400
Received: from sonic310-20.consmr.mail.sg3.yahoo.com ([106.10.244.140]:34594
        "EHLO sonic310-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439379AbgJQTeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 15:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602963257; bh=RchYhSnUH4D8ir65x6OKK1yxktPnAGhcFCbackPivPM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=hGNNdcfT2jtOGwdyoC03Vuru+RSoMAbbpiIWGZrxGsS38kZ3KdDmxuhZ6KOJmAPIC3R2aDjXuNr6iYiPL0LRaP0z/mLe2f/jBBbss1U4q2u5RsO78mKehJdXqEHouC9wtM0o/OMvW6LldpThgB9sWYE8wO50Z1E4aVTGBtiug90AH4lena5eCxmt7ZsjOSgtR9iFsMO/gSC5MwpUEdaCjfHO98Aa3vuurkcfA57mgaMgx5tcDmSrk7MV22lUnHGcs3bJ3Zuhf/bAondosLkIeq/1HFzraye4H+41WgU/XDehlRobVIWd6ZNEDokeFaLixU4XVMpSVM+3iiCUjZ8/SQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602963257; bh=ayk953KaTqNS/SMlD/jXTyGIi5gGn//LRifT7doGyi4=; h=Date:From:Subject; b=eXlw6tBaa6WaXoCfrgIjQqQHicjP4fwOYiycsWpJDZgl+J+CfHUTPnbafdhrey6BY9bGU9+jqIHLI5j5PYXnLm53HPk329fb7JruQBfs6zdjbqGP+j16APlKmTscZKSG8BYQAPmBi0UnXR+eITG4xj6QjemjSUYU3zm9JJnSoyXazaKeQI7JihYEWC/qaT/HYwVwRp1PjHzeYQ0EkRT+RHdFfCzisrgHW0EJ7Nsg7JVweujGR1yIf2QK1M5WPNqMK8DCD0q3KPLWLW3MaxX1Y8ZV4L4m/mr+x5AKYlehW4MQ5nzDFiR+/7BKoUrusnEg9/jyE53JwLwvTlKAtoBBgA==
X-YMail-OSG: L6WZF0YVM1len2Ybt_yRfU_sj4LuL7xSgkIykWsRJCv1aVqU99QGu.LfVO9kn17
 SZAvsLdqD2nJ6qaPlky5ihi_ttETzeGgKzMMA4_TpQ902EoDOz1v27Ot.w0TLEs83CWUosGIfG1t
 AgfEveXKg2RjFWqSlz_JxjSmy1Bo91CS8RAqBKKjLXEigbQQXC_gb7n3jaOaViReLW21OAhohKWS
 fM.LNaxIw90oJ3yr4Xgb3GDTpm10YUoZQtYEl.ckpwkMjcDm7s0YHWqOXzAV1v4TkMDq_wlSNuo_
 ZIy5th6OVVSBq4zcNIGjK2b1M9bG6kV9WQWMHFHzaM85GLR_mnK3KDztq5X3QfAyj0t1WrAaBo0S
 1VCxBwnn9jMiblOLSOHa5j8NUhoSWF9ab7YEBvBIE9ZWR5V2DN1noIsoZGUimnW0OlskYQgO9a2g
 VI.JI6LDwyUBPi.qkaRlNF4vqkkTV3P2A2zqLGoSH42yHGgdRDxeNLS9_O1U0vTfe09_PMoraxAk
 m8Qi7GhWm5LTknV9C7V5WH5kRQSqQoi3QA7sYruq_RcKPkKxCz4Gw8qpgVGToIclj_9RK7yyVDPX
 IpP.Lo7UAV4go8CMiPbpiJw3rSd0Kvoq2p2xBHwueXdub5qb6UFyJQRjwWgSk7Lkt76gpNz799yc
 IsXZ8w8wQBLoNlALRSjwd98ZUdTN3tq7jm1G7MwssaA0zonIzWQ2M_qrLxjOAeU4RQfLRzlucde2
 HlDxvvFcQ2dlLQiYlfVRduzsx6xgK_5NxKN6JRqOn7tAO1otfRC2P1JV.hpM9TEfZzXZ57VwuYbG
 VDIHVRymv8nPLo5duRV7NMu5B_AEmyTygceOVPKuTa6HWt4pUNWN8jXv3LiDmoRRbEOpDnoM3Y0G
 Cms19HH9C0Un0mGeZQ8nIgb6EzHeDqCw18Hc4CsjOLQHi227jM5DGM7oV9wXKQhi0slAPBatdt.w
 XQg6_h_AwLlWNSUQH6X6hi5TTmkUCz3Qa9fdyp83yXgsE62EisipPkeaJVGgQuml6TV_Yn4FFovm
 7PTdj6r63mB3y2RRPMWy4T3_fkYCOiADM_Fz5HcRtQeM.ncm2fZX5So72rwh0w_j2t7wquVk_rdM
 j.rpfwIL8Y43Oc5RkdOCQR6qJXDtycnIIqOyDo_LB7HlnM6TYGFsnYR93J_XLepFWLrjFl5l7WbO
 VpP.nVfptxIQSZBWNHazUiM4jRZjpmAhFn.boyEl6y7.eBxLTjaxQ4atC1AbZdna7Hb_LYCPSIXk
 xixB1O9CzwEJYZ.sEt4Y8zpzx1rVk4dZdfGmlfB6xzIvHeyuuR9.bGd6tq5qhvvGj_jVkW5uAdGd
 fK.7Y8N.PFCgu2n0BmlU4c.iv5Q174sybDAagUpZPkplc8RoYmNltlRI9zXgUoXzYl2fGW2q2NRq
 THUDQYWjolJVEO8BQecnw41xfmHUc6aELeLGkcP_rLR3ajSKKEZ4g5gT..0QGrKjZAn.C9aHG6ag
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.sg3.yahoo.com with HTTP; Sat, 17 Oct 2020 19:34:17 +0000
Date:   Sat, 17 Oct 2020 19:34:13 +0000 (UTC)
From:   "Mrs. Grace Williams" <gw78986@gmail.com>
Reply-To: gw78986@gmail.com
Message-ID: <1375662865.303833.1602963253843@mail.yahoo.com>
Subject: FORM MRS.GRACE WILLIAMS
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1375662865.303833.1602963253843.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello To Whom It May Concern,
Dear Friend,

Please forgive me for stressing you with my predicaments as I know
that this letter may come to you as big surprise. Actually, as my
pastor advised me to reject earthly reward and thanks by handing the
project to someone I have never seen or met for a greater reward in
heaven waits for whoever can give such a costly donation. I came
across your E-mail from my personal search, and I decided to email you
directly believing that you will be honest to fulfill my final wish
before or after my death.

Meanwhile, I am Madam Grace Williams, 53 years, am from UK, married
JO Williams my mother she from South Korea, we live together in USA
before he dead. I am suffering from Adenocarcinoma Cancer of the lungs
for the past 8 years and from all indication my condition is really
deteriorating as my doctors have confirmed and courageously advised me
that I may not live beyond 2 weeks from now for the reason that my
tumor has reached a critical stage which has defiled all forms of
medical treatment.

Since my days are numbered, I=E2=80=99ve decided willingly to fulfill my
long-time vow to donate to the underprivileged the sum of Eight
Million Five Hundred Thousand Dollars I deposited in a different
account over 10 years now because I have tried to handle this project
by myself but I have seen that my health could not allow me to do so
anymore. My promise for the poor includes building of well-equipped
charity foundation hospital and a technical school for their survival.

If you will be honest, kind and willing to assist me handle this
charity project as I=E2=80=99ve mentioned here, I will like you to Contact =
me
through this email address (gracewillia01@gmail.com).

Best Regards!
Mrs. Grace Williams
