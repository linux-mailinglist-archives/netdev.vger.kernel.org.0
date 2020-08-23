Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA7224EB12
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 06:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgHWDyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 23:54:40 -0400
Received: from sonic315-15.consmr.mail.bf2.yahoo.com ([74.6.134.125]:40414
        "EHLO sonic315-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbgHWDyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 23:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598154878; bh=AQzYtvSOiUY90uQODdLnEa+9DHtvFLv5+8o9By6UHPE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=N+DZZHDYi6y/ycfDtX1UJJ3sucyTpNjOuu7bI+/ef1OIlH0dNNposvqxd60OFVSsbjuee/joiyF9NI7c74rqZVJjx2NdD4QLKt/Dlb3qA1Dg+5p46WCKLO6rbqc70jOsOzrpPUO7Sj+Je2ormG+KjvR+ZbbaTLgC8u2kK7ZdXV1TXJxSj6J45RCw88X0PP4MFiz0YA8+2r5p8J10p/XbNOpUqLxFK9wsEX8to9hOTIXSagfEwJQG9uTX0eQSMJgKy1k/AIGFRgW6IWvPpiQRqUzj/fgoRlS9IC4hvSaglq3GTu/VUkE9vWdejenebp4hSyGQKV9Rx3j9Xpz36pSvZg==
X-YMail-OSG: u5b85h0VM1kT9cflZhVCIDOoH3Rg2k4k_2XXh8iMiobnp5b4zw3dsUMqiTadZFq
 wU0R7lwILw47SmVN.0Ui2pTTqcM.mIRFKeIuig77ZI4wKopIXznpPxqnqVFejjK4IVuxYWKFJNGo
 nhtIJzSQJHTRrxQJi32GgDDidD2a7pxXyijB9QUMndw7PWAmNMsiFVgbw2..2Cap9kjcAvk5smLq
 JWrPvts91W7NOYPPDwPoOYfdGyxx4oDiSputmk.jtGHHSymc1qHBFRFQSDEoc7tWtjTqoJLNXExA
 .IqPYTAyrgW62J8EwPccH7pPtRjBRnnslv7ky3XkSxJNQTVQYr.EAw2GTf6JmTLbTdc9ajwzGGsH
 aRwIFvymnup3rlL0aqxIeb8fdWIo1ls9.vkX6haYwRZHpvhPkbJ7b9I5tWJtlgnCm_MbBwlmJXIe
 nQBY2PW69DyGJz9omJFL2QlwxVu1snUyQk8L3aFHfm2ozljR6Jj_wkUhLLRMaOpTc7BykR.YAH0y
 9YvLN5TMxbXetkxcs3Xbys7l_FyOgOOW6OqVwQ7v30_JRQNQtYVe5rmgubGZkLMdXDeqMIR5TLIA
 .w_z16ggiZIHfDhUb96gGg_qTXoMhcdrd5gBtEfgYW51blecybvVXgvDQif7tcuIlsP28daaXjEw
 nka9fPLJtqHul3JP5IMgIGyJjhnW79wXUPDI4ubH8n0lUeDKf4CKLoEIbTRKafeqrmS6WO9heOIE
 G.hLmB3P3EE8bDQAbin2u0wMrIoB9isuvnn2mHrgrtiEUYrnZmSa5Geudrdo7OOQaeAGEB.1cyxM
 JZ.YfSOu9fjsiSGt6LE2gimwpcoXAUDNeqZl.SJWZ4zIAyyjV18W41YlT5tLxrjNjuoaka663gY4
 GUVogh8vyrgVgcmbXjO4elJPB4rWXokPpn3i2ymcXuouV.BMGnkJyH3RGY3xZaQ5pMbYpQojtEra
 X0vR2JYFnjbz3cHactTdwNRamvNZl9cEgBJW8zSQqFNPL55iF4dyM.6R3rHbgiz1zNwjP2hx64jA
 i.lIeGwEF5O8PCpXn9DgQVWILuSSnyjDso2GTWXCZlHxfaPPFCDnuZji4zp87HN9SqeOWR7ZSUS3
 2bLIz5hVnhgjZcfRxpj.xAcwNMYpYR1QlPlgPT6k.AVSg31K5TT6kEORRJ.osJfSEMZTSc1ysYvM
 uJzMyciabayBrLHPRJ30eQ2sofVQXZDE3dVQGS1ZPo2IAplm7uP1f.nS6ImlSojMSsWNgcK2f4MX
 hhJJolB0HjmM3LnJugPydBiNaErDRmYqtFoAWDHr7XQ6KMT28dHF9vGMsblm.zEBVwErYtmven9p
 SPJvroiOwY2rKsDxrZ4QdIY12KaPXfNaMPxk_tMNRnK_vkk3K4uVP1XJz5kE.VPdX6jWYRtEY.B.
 tDtXsfY.3L6Qx0qRAL1o0EfifQMIfv6VUik09XWcTNZVFsAgQCA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Sun, 23 Aug 2020 03:54:38 +0000
Date:   Sun, 23 Aug 2020 03:54:36 +0000 (UTC)
From:   Milla <millasmith2110@gmail.com>
Reply-To: millasmith20100@gmail.com
Message-ID: <1244179735.4564582.1598154876246@mail.yahoo.com>
Subject: compensation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1244179735.4564582.1598154876246.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dear Friend,

I am sorry, but happy to inform you about my success in getting those funds=
 transferred under the cooperation of a new partner from Vietnam. Though, I=
 tried my best to involve you in the business, but the whole situation chan=
ged. Presently, I am in Vietnam for investment projects with my own share o=
f the total sum. Meanwhile, I did not forget your past efforts and attempts=
 to assist me in transferring those funds despite that it failed us some at=
 a point.

Now, contact my secretary in Burkina Faso. His name is Mr. Milla Smith. Thi=
s is his email address; millasmith20100@gmail.com Ask him to send you the t=
otal of $850,000.00 (Eight Hundred and Fifty Thousand US Dollars) which I k=
ept for your compensation for all the past efforts and attempts to assist m=
e in this matter. I appreciated your efforts at that time very much. So, fe=
el free and get in touch with my secretary, Mr. Milla Smith and instruct hi=
m where to send the amount to you. Please, do let me know immediately you r=
eceive it, so that we can share joy after all the sufferings at that time.

Finally, I=E2=80=99m very busy here, because of the investment projects whi=
ch I and my new partner are having at hand. I had forwarded instruction to =
the secretary on your behalf to receive that money. He will send the funds =
to you without any delay OK. Extend my greetings to your family.


My Best regards,
Yours brother
Mr. Abu Salam
Greetings from Vietnam
