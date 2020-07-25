Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651CC22D9CF
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 22:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGYURH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 16:17:07 -0400
Received: from sonic301-37.consmr.mail.bf2.yahoo.com ([74.6.129.236]:41456
        "EHLO sonic301-37.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbgGYURG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 16:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595708225; bh=AEu8nK9QzTA2tbqo2l5BVwPShMs+2VsmLoZOZv6b3Lc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=t+ubkTDOy0sH56OY9wRobDG1Sx0mUfvPs6qrYwIwP3Pc1uRh2g5d2o/8EzlnCC/QT3iYgsQpZ6RLMlwEYQs86TWgCOmPmPS/Z2pRzdtvkSingJyXVy2sz6+jUTjzMTW3FzbuUAkoAuoj5VduhmIH25zD9twpeyDU26x6RDqNMw98Ky/ZEpJxOgZhEw0FU/DeVkfTh+hIsbKJVJ7/vW//2fvyDek5AuOP9zzOj6QSpmLO5HNhNhdtwNuiNtkGBo79gDD0AgZrnuPrzIKBtu/Rxi/V+RnMSearyZCImFbQKZHXMPksnDQ9eZlL59GBGtEH38OdU+3oIvFzLXCTy/sCpg==
X-YMail-OSG: ElWD.fMVM1kG.eZP6bvIANnCa07ZHWBsDZGNDCZfEiyWud0uBfXHT871ni2xE8d
 eOTlOrERWD2Sn8RrCnDJ8UvxeS7OhpgTSOn5dSfSXYWFKybS_JuXmvRJ2YbH07tYcmBq0kQvR2K5
 4Am3IJBGws8hUrX9o20pMTR0KpObHhzYmINonGn2olTu8qO1kHYy5qWY.hiC8_TC1vUoDP55UvJD
 rq552sReS93IMsEYtzeFHfDaocrCbcqFTmZb_3d9NsRiLxpK.8_XvEt1UT21ah8Kj_AREJvVOAyn
 7xPLXUWrKcz.yoB48IK61ADNCxInHL4VDGUmM_hNby.2QYfoTRYqLEMCe.ngXWWazfSF9ZDNvlA_
 eXWj3g0lKsscs4FCMZWpMKdXfu6SJhBmJHQ7ztvq8ub1VUc_TgYOwQfS2bckOis44jsf.dpoYpEp
 03jTAO3tTytZqsoyUnzNoDJAdLQMz2ydtSvHva6iaH9Oa2SHspxdCm4ELYFGmFocIYRl.lxWU4gL
 d7Sdf5NjuCWqGSzRjAv0fCmFXcPYc6r_qzHiV3WUpUQh19nmBGw05IoGimAKLQUuMxjy8RjwAfqs
 1RGANwto.jDvSDiMFVLpHl55yANDC8xwLjsmDtSIPlPiSUzThFnJZ2XPrQozGwZ3LF8OHkQV87sx
 CAtcZXCP2kcRzFMd7XKLmPV1.kHbWXVGoF11ZdOqKvHq0IxJ40r95DmDZUC148m0NWWUVJ7VK.LA
 aahJXQnlJF8Tw7Yg6WU2kfbDkRA_HZl2ZSF8DwCBhQwkpnETnj3IU9xT1BEzTQmWE3lZXc1x2zoq
 fiN60QXmnF2aP3NWap6vpDsZzgfmfzCDO5LcVKJ8PDpp3.GqgQvvIox0LYM8gD.FRKJOqhVrnfBV
 kz9GH1m5uZrgLZtneDLl.CLywVgUWDpqEOfHATfzGlZCCOH6Fk7ub5xonJCmVd99TbW1LRbTULMt
 IbPB0YABc213._qRVoSl_.a1vcNi150FlEjqJ1WLLnkSSAWRbm_EBfxAc5CPeNiwVPafkjrPS1W_
 _VrU7pK61hD7iNi1Jo2dieQrFL53HzU6ZpF687Bo2GYo1AwB.I_LGeN3GSg_ugDVpKYQi6FbUQls
 CUFG9FblFvPSZ3LStchOyM32jJxvstKjN1SynstZSz2KTG7sIwL6eI8KnwlSwW1MRKUmE2dGmqnS
 WVJQ1RKgF0vkdyTBkdTO1PedO0COWsVvj3eTPyehoR_V5T7SvzQQR7O5ZgD2hkbxE4bxdn6xU5YY
 ycqtEWz8l0F1N7.GoccIGbEa7B4t88dt73caNgTojBVzo2PKGtshRLr3Vs8uX3is4N7pQnTa735I
 g_Ytoj_ZzzFSgtFe3msVVUY1O_ldFd1cI
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Sat, 25 Jul 2020 20:17:05 +0000
Date:   Sat, 25 Jul 2020 20:15:05 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau16@nuedsend.online>
Reply-To: maurhinck8@gmail.com
Message-ID: <774217544.5006404.1595708105115@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <774217544.5006404.1595708105115.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck8@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
