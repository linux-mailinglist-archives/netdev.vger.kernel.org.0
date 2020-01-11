Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4825137C4F
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgAKIUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:20:21 -0500
Received: from sonic302-1.consmr.mail.bf2.yahoo.com ([74.6.135.40]:43378 "EHLO
        sonic302-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728595AbgAKIUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 03:20:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578730819; bh=rLzamwWDU6w+ljUNz15IdfH92SpsSZVAbr+GO8Whobg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=MSibc7UEw4VtfjkFP7qv/RR3WMEZ3TvB25lMVHCIJzX9P5HqGseue6SH15A+fiWjJhQrhG7KV2kCbIlZHzn/fR23LXgKL0TjOunxIaE3cZoxo2vweAq/1ta/oP395aHiKgCM4uJr4fC0Cz6d3xqhrCVZDwTkWHdKPcmTsCb9MLoHGL/j3H5tsa/OnK/XmOuJcaYPJ97neDCVzdroqk5jJAmkqcr+eoKodrcu2N2Pj+qBatPmuMBda4nR/5ChgGBTwr9ohfhtY+hDCz6/IAACWVvNZpDU7ztjfTuFFUvikOjQhhdMJQoJe7xWRYSb28QUafUvUEguC3phBL2GsqF1iw==
X-YMail-OSG: 5bI1lR4VM1llky_6K6QRR6JF3FDN9OTxEaTITXhSrubm0PLq335JNBmVpE1at5x
 WTXS0yfYYJdMdAFeQlMTWhOHXftlpT0_Um._1l._l2fO63G05Bwcr_ITVHFBqYOF696EY4EkvE6d
 9uQ1ekkhbUhf.UyOK4omp40k4qG0OZEq48CqcBlNrBLE9hN5.aCvgRdQYMkZHvogLGD7_n0swgBN
 5mZjuYc6mPR2cEcdlu2.zbUpT7hNvTDrLtJpj8ySdrpLEbX.Dg1RHBJjeAA1iAdpoQrleZoA.YMh
 YqkZpHdv40u3ntVrtxhu5xe4IFTcTzdHMfx_Mxx1wgUVWkowyCOeYlhsdKtxQ_14NUBxgjvQrErb
 l2BFC3SRpcOCwlutBTRzFiAe8KjO0Qlr2QV1AwxhS9MCoU5KLdEIVvGAcNAgqDalIx0O4RpzNvlt
 9uLyXX188x27DWWPqq3MR.SqGeRlJYiwvBI0Y3STC8uNbENvjBXpzzvkNpy8sCi1nAHF9r5aKkj5
 4mcVhqLLOPdfqNYcpsmpNuAwPGbEDc6xha4JkHz8txreeoz7a20_8BHGNdND67YhT3Mi_Nigrq1Z
 OxCzi9P8dQyjeITVwg0MINLATURMQvglRnl5Cq_UECmxW7obOwYbHmtUDYi4jUYhuUVsNHIdqHAK
 fAdKIvHJA4dzHhtMbMxij94UH4.ug0Ehg.SL5t5TjNcFbkbOL0gFS6PwOKeENbeF.uLdFRJWBhtD
 Nk0UbTSivnrsM0iWDin.DMuBgMElb3gIWvXYkRreiuHWbciEWm8pw9L1bOkVyJbU.dF1OThFC63T
 nG67uGV.MB.Q5sdcvuTd__GWOIvbfteadjaIefg5bEq6wbodHVVR6uhtUch2gjAYRq1_NcHaejk8
 rFp7R1bibGOz11sC18T2UXi8oIUv5qd16wuSjc_nTRLdFvz8F4XshRh_1IKPQD0.awc9yq5k1_Kf
 C2vfwNVXRWiw0QNIjxFkj30h6HXipqko7aoDOJ8OL6kt_lwEfuMOBU.ip9KlXZf6leAi_SR2.Xmb
 4WEPrw8dZdwsT7fiYV7iwoavzZwKH3WV7BZHCva1RyDFPLcW5loO7_XpgdrzkLvGm.SPPO4vXFio
 a6CbUaCDDScwVRp1WVjY7s1eQw7BrT9VYCjTgMt4fa.TP8ipUIzPo04XrzUZWicLZRmWv_VqfLK3
 rYG6KOVA0sVUKo6yQBh9w7ick3yMSFk_xJ6gTNeTe0sz3JgH16TDsloM66WRPFR9HNkpjAoUOce_
 _IweVJl9ElutKeAaPLr3TNiiCsHi58.zJV0.5ahPU2ZAkk8nzTWyT0wg4Hb7qPGJHnR4otGVg9XN
 Qmg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Sat, 11 Jan 2020 08:20:19 +0000
Date:   Sat, 11 Jan 2020 08:20:15 +0000 (UTC)
From:   "MR.Abderazack Zebdani" <zebdanimrabderazack@gmail.com>
Reply-To: zebdanimrabderazack@gmail.com
Message-ID: <2028710208.6539028.1578730815412@mail.yahoo.com>
Subject: MY CONDOLENT GREETINGS TO YOUR FAMILY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <2028710208.6539028.1578730815412.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Greetings My Dear Friend,

Before I introduce myself, I wish to inform you that this letter is not a h=
oax mail and I urge you to treat it serious.This letter must come to you as=
 a big surprise, but I believe it is only a day that people meet and become=
 great friends and business partners. Please I want you to read this letter=
 very carefully and I must apologize for barging this message into your mai=
l box without any formal introduction due to the urgency and confidentialit=
y of this business. I make this contact with you as I believe that you can =
be of great assistance to me. My name is Mr.Abderazack Zebdani, from Burkin=
a Faso, West Africa. I work in Bank Of Africa (BOA) as telex manager, pleas=
e see this as a confidential message and do not reveal it to another person=
 and let me know whether you can be of assistance regarding my proposal bel=
ow because it is top secret.

I am about to retire from active Banking service to start a new life but I =
am skeptical to reveal this particular secret to a stranger. You must assur=
e me that everything will be handled confidentially because we are not goin=
g to suffer again in life. It has been 10 years now that most of the greedy=
 African Politicians used our bank to launder money overseas through the he=
lp of their Political advisers. Most of the funds which they transferred ou=
t of the shores of Africa were gold and oil money that was supposed to have=
 been used to develop the continent. Their Political advisers always inflat=
ed the amounts before transferring to foreign accounts, so I also used the =
opportunity to divert part of the funds hence I am aware that there is no o=
fficial trace of how much was transferred as all the accounts used for such=
 transfers were being closed after transfer. I acted as the Bank Officer to=
 most of the politicians and when I discovered that they were using me to s=
ucceed in their greedy act; I also cleaned some of their banking records fr=
om the Bank files and no one cared to ask me because the money was too much=
 for them to control. They laundered over $5billion Dollars during the proc=
ess.

Before I send this message to you, I have already diverted ($10.5million Do=
llars) to an escrow account belonging to no one in the bank. The bank is an=
xious now to know who the beneficiary to the funds because they have made a=
 lot of profits with the funds. It is more than Eight years now and most of=
 the politicians are no longer using our bank to transfer funds overseas. T=
he ($10.5million Dollars) has been laying waste in our bank and I don=E2=80=
=99t want to retire from the bank without transferring the funds to a forei=
gn account to enable me share the proceeds with the receiver (a foreigner).=
 The money will be shared 60% for me and 40% for you. There is no one comin=
g to ask you about the funds because I secured everything. I only want you =
to assist me by providing a reliable bank account where the funds can be tr=
ansferred.

You are not to face any difficulties or legal implications as I am going to=
 handle the transfer personally. If you are capable of receiving the funds,=
 do let me know immediately to enable me give you a detailed information on=
 what to do. For me, I have not stolen the money from anyone because the ot=
her people that took the whole money did not face any problems. This is my =
chance to grab my own life opportunity but you must keep the details of the=
 funds secret to avoid any leakages as no one in the bank knows about my pl=
ans.Please get back to me if you are interested and capable to handle this =
project, I am looking forward to hear from you immediately for further info=
rmation.
Thanks with my best regards.
Mr.Abderazack Zebdani.
Telex Manager
Bank Of Africa (BOA)
Burkina Faso.
