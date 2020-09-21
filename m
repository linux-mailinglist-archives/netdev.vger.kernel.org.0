Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BE3273315
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgIUTn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:43:56 -0400
Received: from sonic313-21.consmr.mail.ir2.yahoo.com ([77.238.179.188]:37386
        "EHLO sonic313-21.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726417AbgIUTn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 15:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1600717434; bh=YiBnr4Uk8siI0dhikjlKOiXekrwpOWZKz+TPVjgu4sY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=mEQd3XTsSU8hzyoccjVQR15WkWU9eCS9/pWVHEx+zzd420j50icBmWw4ef33c1IH+zLGRtBraXQf4cd+zV9WXdYOabeTzWLz/dp3/+/H9XkiwziJs+D5gcCBLdUFTz1GPdvcrdiAChYc4L5jrM4BekXd04h6eShRcGb2trbP0SJfzt9WpRZdXzRiKP53+2ENwnLmWrLKqmPsdEBgpbJ3zGwMDf006VP82xrD9JvPqLbKzv1nWbSiHeQLYK/wGdEopTE3mGYlyrufykUwUWs8fAwhsVeLWA8axmJrUj8iHgYj5qrBCtgJJSXuhcmX8Bn5QCj4plTAb6bBYx/Y7ZksVw==
X-YMail-OSG: hnnafg8VM1n8jGofd7hA2Bjm4vSMtC9g0d6QtzQArQ7rXQxfIBTwHBzdTFzfdED
 e7TpTuimTAmEBrzEOhFCtOUA14SNmhxDIP9_96Su_zH4dHlHcNnTceSMUvyZmUj6c9vrNaYFQEy7
 0Mop.jfAtKfZvd8rf6DGHp2siLGRJ5ZzjzfL94av6H644xDeTIeADH7aS.l.LO3YTGsF8vT4TIQK
 otYpInSCx06a0Np5sizpq1DpNaJ7vUV8alzzXthAKsN92IPz0ozt37BUoUzHbiyin6K27isK3lMN
 pLvsQIb2XKkqpUamSBASeyi2RHYiCkTpVF.EJu1Nfvnd8c2u95ItigUsz80vroU6cDeyW.zd7_iD
 XbvI5V6bIlQGhG4xzJXbvAuUJQG00kWAX7O4sBvijIAo5J7yJKSnKDoo1GT9rngahWVbrYttDEt8
 lr2Yujr4l.z5OylsXVH.LQ7lJ.OYE7VWySMRchJGFWdms8E8rWSw9y2VvgqfMmDjc3HqtzajsJT3
 xgWjOuVcB.Q_sU3dUOCVRKBqoWfZAJ2RtgTLjWXL9gZAwkqzd.fgssTbSFBWXhhO2EnW9uYLd7Oj
 d2u8pBIEmGNEHu.MJynGTkaAmyEliL7_ouMrxCmhrYngVT1HoDYaXYNGnapq3U5pCeMfPmWXrT1Q
 QI2.uyNkN7xt9kC604UFAbYS1d6Be16l2EVtHEBeHBTt27_yYW0sv0HYked4ilCqYrz4wuNMLqyM
 1LQL2Q8gL31f7U6SGqEjdWaQiwungZP455aGnJgcT2nuEGFCQoqJ3d3G9UrGj3vLV1HWOOx_2RGx
 36lw9a6vsFHT8G.FqzHhgi8zLXXbn6xZctM25281vHoi29k8zoWHQL630gByYRRabVcJvb0Kfv.3
 Yp9KGcPLcpUX9p8ytH87Wyv6lTK9pHRucVHD8.pBgcY4U.YBV0x8HmTG7ypXNZe51CX3EYObSVUe
 gbP1Sbcl71xSQM9m.iXKVAQT3_MPQow0F3wPXHOhKffC.9yxD96RgLQKyaPmmoXy9KmnSJKHepNQ
 1.mMUZRD6uOX2yFcK53ksb0tglfbkSvvd41sSWoqCRuZzwBCb47kw5pVO6qAWwVEiMx41R_CX5DE
 vSOK5MfbvbXwrAAa5OvqnT2eAEWuDzp0FtiZto2UqgEygk4GTCzRRkwreR0IjGzKje_Rv52Ht_P_
 pQ3FTmpms_2I15.P5_5zYqS8bjRZErO19YqPIjZhZgP8NsghKJN2pj30uYFUoD2jG3KHIQfzZZjA
 popga4mJ4IbPHrHWxaVcz0kYthxlBlqKdhP9Fie9dRU2teT5zEgeROubKGlVseYxR27GNZqe_4bC
 TPiX6tKsqxChEwXqrghooQlrJEd8LkL_Qb4SpK8VCWOQn8auX09Mg.sidsCP61KGP.xhxMstR.n5
 7iCNqmM35XJI01TEGYMi38ojonmB8DIWvl2x8u9dO6ZNgaMDNd0hC.vCa486.dslmy27e67MXxyh
 tJSvIuH8Wud.Xn5URrqEIN3xxxQkjmNH9ZTE.i18yOfVePAe7nA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ir2.yahoo.com with HTTP; Mon, 21 Sep 2020 19:43:54 +0000
Date:   Mon, 21 Sep 2020 19:43:53 +0000 (UTC)
From:   " MRS. MARYAM COMPAORE" <mrscompaoremary2222@gmail.com>
Reply-To: mrscompaoremary2222@gmail.com
Message-ID: <12990333.3307016.1600717433355@mail.yahoo.com>
Subject: FORM.MRS.MARYAM C. RICHARD.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <12990333.3307016.1600717433355.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Beloved Friend In The Lord.

Greetings in the name of our Lord Jesus  Christ. I am Mrs. Maryam C. Richar=
d, From Poland, a widow to late (MR.RICHARD BURSON from Florida , U.S.A) l =
am 51 years old and I am a converted born again Christian, suffering from l=
ong term  Cancer of the KIDNEY, from all indication my condition is really =
deteriorating and it is quite obvious that I might not live more than two (=
2) months, according to my Doctor because the cancer has gotten to a very w=
orst / dangerous stage.

My late husband and my only child died last five years ago, his death was p=
olitically motivated. My late husband was a very rich and wealthy business =
man who was running his Gold/Diamond Business here in Burkina Faso. After h=
is death, I inherited all his business and wealth. My doctors have advised =
me that I may not live for more than two (2) months, so I now decided to di=
vide the part of this wealth, to contribute to the development of the churc=
hes in Africa, America, Asia, and Europe. I got your email id from your cou=
ntry guestbook, and I prayed over it and the spirit our Lord Jesus directed=
 me to you as an honest person who can assist me to fulfill my wish here on=
 earth before I give up in live.

My late husband, have an account deposited the sum of $5.3 Million Dollars =
in BANK OF AFRICA Burkina Faso where he do his business projects before his=
 death, So I want the Sum $5.3 Million Dollars in BANK OF AFRICA Burkina Fa=
so to be release/transfer to you as the less privileged because I cannot ta=
ke this money to the grave. Please I want you to note that this fund is lod=
ged in a Bank Of Africa in Burkina Faso.

Once I hear from you, I will forward to you all the information's you will =
use to get this fund released from the bank of Africa and to be transferred=
 to your bank account. I honestly pray that this money when transferred to =
you will be used for the said purpose on Churches and Orphanage because l h=
ave come to find out that wealth acquisition without Christ is vanity. May =
the grace of our lord Jesus the love of God and the fellowship of God be wi=
th you and your family as you will use part of this sum for Churches and Or=
phanage for my soul to rest in peace when I die.

Urgently Reply with the information=E2=80=99s bellow to this My Private E-m=
ail bellow:=20

( mrscompaoremary392@gmail.com )

1. YOUR FULL NAME..........

2. NATIONALITY.................

3. YOUR AGE......................

4. OCCUPATION.................

5. PHONE NUMBER.............

BEST REGARD.
MRS.MARYAM C. RICHARD.

