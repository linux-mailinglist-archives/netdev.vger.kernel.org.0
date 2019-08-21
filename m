Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017A497662
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfHUJqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:46:49 -0400
Received: from sonic301-21.consmr.mail.ir2.yahoo.com ([77.238.176.98]:36769
        "EHLO sonic301-21.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbfHUJqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 05:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566380805; bh=6Jm8q8LreSZDQlWXGeMlOj0/DuwtuKrzjIwFmKlk5Z4=; h=Date:From:Reply-To:Subject:From:Subject; b=NNovo4uUGsNhSj88FoIxec8NiDgOgfx7qu+Ktb241ULwHd7YKxKmWWE6MAc6fxRGjupNEk7akC7BK6369be0IeraHkshf+rG380/EalYC/AyNHyWITQ92IRf2sP7TDifU0AmYxpaCt2bK8bq3AP9IsA4qH789vdJHgkCbr5Ekj4vHTlsJ+VvIFCqCs7QxHAPBi3J8KEPmh57la1oy33keeMs+AE8EPNAihHzYquAtoUPSoUKeG9wIgszpOK3HYvmbSMsGbJANYdDpgFLGulAcnJurrkWgyS69uSnsTI3aSD6/kdjsMTpaUsAm6P6QK2JDktM6sCHx44Ca4Ih260s3A==
X-YMail-OSG: ntBmAicVM1nMylI7WsCzeHNKa32mlMjzLh32VOGF8wutyWm5Dd_pBck8n0N1P_S
 exXm9BVtDrkMr_UI.1s2FBl3Vc3SqtvqGo92c1QoS4tmZqw4jObQntwIkZNccqD3gW0ek3BvhxrO
 _8rgFm8vlD35xx42iXwqRtN2ivSbV9iYJNGYg.idmw6qT6_ktivqfqQl3VYqQIK1BacFFSwb1okG
 YohD9hMKEHMjW14tUEjwLgs7lqruZ45HwGbxQr_S76wgUjzN8COkV6nOh_G1kq2Jkqib.j875LgM
 B2ArJ5TpffqVgln3IpGysudxwrF2uCKnbEGXQgiiTq7wvVIT3GMXQBWM4pI68RxwNP8AIZGplimQ
 0RUf22VWVNfu.w2hHjPoQCLDdXT4xI5QS.NJcapM9vxe_HqN3jRyrIJgL5YBYkc42llg.27CRMa.
 sJZOSrnOA3pnboHY2mMcRs1scguvLDFKCAXajmO6_.0MtAnUcEK9V69sWAayUdB3TJHzKe5LgrJA
 zNJsP9kaR1VEFxIskk9ZzmpVVQ52_DIlGeOXV0mRuSVPCWPu8gfOOT45xWvPz5.n3QhOMadf0zqS
 mDGq.JF1dSzje1gAG_8zaNiz0OL7qrKA.zN2gtSFLssexMKRPOQupkKAuUaKcBFynITLoYg1jPcJ
 fTlMGZGCjZALq5RekKUjLKAPKVEgVs5TQcqrAr3PKpStUCvge5ipS5rCCkuWGuiOMLSvwytJOSbR
 D0GqfFZt74Gs08WC2J1K4SI1IF.dXaGfkKoy3lJqPqSmRwYJwZIy8KydjaCXufddlE9nA7W9y2Xh
 wmMgneKESdopBA1Rra2eKMpyVPIpTziXf9bG6nJauj9hF3vUvhaikCyxDR6Ew9srF3QvkLjSMOGo
 79bry.bDUdXPv00TD.Yyh42ZWX8eygm7k658vHhC4XOPEAeqU7zhbOGDZe4_NLczNn86nEtnh2eG
 _1Q73iQSavEzKnH.qGSr7dHoOnqgrERzVyYg2PR9BcSyPn0A9IJrjOKMqfnDvu9BLdPBdnthum91
 4cvzk_7DIuFUY2QOyMqsGA.JTnxL_RarIGth3z1ffEkdz93BYRFNUDBqYWloVavkrbIf_f9G6s64
 I5.bL99zmshdjeqwl9.eRDbOBLUgl3TQfFS_5p4hW4Er3TZaq1.JCyOEyWjKoQnXa1vZIm.w4Y_I
 Rk30oNrbSaW8vqzzu2bSUgEAy_A4I6OpbAtpS9qvxsCyi00ajwp9rg0.qJCvy_f0YnGRn5A95bfr
 SDKcI1Xn1Kg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ir2.yahoo.com with HTTP; Wed, 21 Aug 2019 09:46:45 +0000
Date:   Wed, 21 Aug 2019 09:46:44 +0000 (UTC)
From:   Wilson Smith <smithwil456@gmail.com>
Reply-To: smithwil456@gmail.com
Message-ID: <1892930539.11314489.1566380804404@mail.yahoo.com>
Subject: HELLO! PLEASE TRY AND RESPOND SOONEST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Dear Friend,

Before I introduce myself, I wish to inform you that this letter is not a h=
oax mail and I urge you to treat it serious. This letter must come to you a=
s a big surprise, but I believe it is only a day that people meet and becom=
e great friends and business partners. Please I want you to read this lette=
r very carefully and I must apologize for barging this message into your ma=
ilbox without any formal introduction due to the urgency and confidentialit=
y of this business and I know that this message will come to you as a surpr=
ise. Please this is not a joke and I will not like you to joke with it ok, =
with due respect to your person and much sincerity of purpose, I make this =
contact with you as I believe that you can be of great assistance to me. My=
 name is Mr.Wilson Smith, from London, UK. I work in Kas Bank UK branch as =
telex manager, please see this as a confidential message and do not reveal =
it to another person and let me know whether you can be of assistance regar=
ding my proposal below because it is top secret.

I am about to retire from active Banking service to start a new life but I =
am sceptical to reveal this particular secret to a stranger. You must assur=
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
 for them to control. They laundered over =C2=A35billion pounds during the =
process.

Before I send this message to you, I have already diverted (=C2=A33.5millio=
n pounds) to an escrow account belonging to no one in the bank. The bank is=
 anxious now to know who the beneficiary to the funds is because they have =
made a lot of profits with the funds. It is more than eight years now and m=
ost of the politicians are no longer using our bank to transfer funds overs=
eas. The (=C2=A33.5million pounds) has been laying waste in our bank and I =
don=E2=80=99t want to retire from the bank without transferring the funds t=
o a foreign account to enable me to share the proceeds with the receiver (a=
 foreigner). The money will be shared 60% for me and 40% for you. There is =
no one coming to ask you about the funds because I secured everything. I on=
ly want you to assist me by providing a reliable bank account where the fun=
ds can be transferred. Make Sure You Reply To My private email: wilsnl74@gm=
ail.com
