Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F381123261
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfLQQ0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:26:20 -0500
Received: from sonic307-2.consmr.mail.bf2.yahoo.com ([74.6.134.41]:33194 "EHLO
        sonic307-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728534AbfLQQ0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 11:26:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1576599978; bh=rLzamwWDU6w+ljUNz15IdfH92SpsSZVAbr+GO8Whobg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=sBW1X6V7IlrDL7aUOhWWKCRDXVKtgW4Ti4gzBVEhdAiif9C7kaXS7X0fDfr1EqRFg/sPtrji9iEI/7ChrzwSAK1EsAQAmYLdblaQZm/4ElhBK8tJiAzg2NlKw+bdNrvWePb6kIjgPlpdrMkO03iVNBgdQAIp+3wn+YhZ71qR77hqLFVQ0h/hxxlQLGicyWKSgZqX5u+gqxlnOMr7g3/j/etPeiyqXsiwdeU3//93C5vBNuxRuN2dHECAmrsYlubMkpPHGmAij7yipzscyItCLMj4ENDTAHfFzuWUT66T9QfOT/cTZFh6gBfNJwZerqfaQU93o3R6C5m8dJAkranTjQ==
X-YMail-OSG: chwBMN8VM1lhQ2gtBCjO_UzcUTq6TuCZM7cAk.YYR_rjh7K2MUJwwEbgbe0Eyjl
 ve3rou6AFBL8cOjsadJoR9lmZMk1Ba35_0AZP.rW2tOSWRpsMjl7O2EnnrCW_4skD631UbjrDQ2a
 uqVFK3DsCp50Wy6RCOYyTmFdx06pVyro8vHsK_rECWLy4.KOhQ4p6eNKyzZU4p25jfpiXHEAdWRp
 KL5tp6N7eZKrXEYbwhYKKegiGq5rdU7tFi39ALJu4ukISLU5kPvWH6CVbS4vYrl3rbzypvV_CLKb
 8O10S1k551_uKF8H6EOmcq8kk.ZJTxirUOjYPSgyYcI5wruQA7xGVHT6ZPww2ZtSvnIDnrLTM7.p
 tK8CndyXD7sGB9TR0P5kkaeu0gMKBtTJiv2bDLflpQ.maIMgco5UfWpvf8dUyk3KdCbhJKitOaJz
 IDOjrTqe6MwUd8nWeWH_bkhYepkluZY7O4ku_wv5iZA3SZPmT5hXwB.t67vK0rDE8qeS0l3j2X8O
 XjPydBXWBJzDszoeSMEEQI9EyWNImz5jpEUrOYX9s59wA.zPbYuUBkZ6hndI69me99qBqVD1K67K
 AWBp9cb1yJHfPGoJaQaV_61QHgmYb30I6WqSj.wJDlo_TgI6hF27.5Ub2NJNfq2xO18fjtWVVdTL
 uUqOSj.cgtkJul81qJB_98oDfsMy_7tsnIcdbBKmEfwlcjKanaBpW_EUdoVKsnZSBqe7DNtVKCQE
 YskXtcvKEPk6smeJUbjCRTDW_kTKUshe3.fKLBNJ9NjOfnRsNdoUqZrfQGX_ZsXuzAyJm1yp9Rmf
 IjsQ7tICthQbkdOmU2il0wHM4ugnc_d8kwk2EqOs9HWdJaZ3GEgSvL9jC19Yr4zHH7XEOlQtQPM1
 u1.XtyxtZGhFZ8BzuaNe3d_IPRnCZM5bL7z5WjsQpxbBA1j1FAdpgeZ6GFoKanv9b5GNMUweYZFm
 lueyZ.K5eeceM37EXFuUk2OZFeK4C2dEom7aZpmYVf9HUQ.w0g3fohxe25Fc0ioZPskO52iDLb00
 MryLS9Z.PaeLxvgpGRn2jo1a2d1uEEp3RTA42ZmXVKtxwT6TVzIiFTjmohsrpyUhSnNQucvEhpKZ
 KuKY0b.TT5WvHOUUtuYL5Ddm5ETz23GeGErwWlh9kaubq_kU.x9_lMf2JQFY9Zh0aZTOyTd6so76
 k1Zb8.PLt8G375TQP4fGz_26aXQ6GWROvlhpJjL_XIqhbtqgA30pEI939D6qIBR3TayOk3SvWGsI
 KPTSxH10hxeK6K3PjfempqS4YHIIhpXV1rclLhJgLzpLSC93IWAzBSHPzOlXi4LBGBU1Tx0.R3Ye
 q1YMlh9OrwZ93
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.bf2.yahoo.com with HTTP; Tue, 17 Dec 2019 16:26:18 +0000
Date:   Tue, 17 Dec 2019 16:26:16 +0000 (UTC)
From:   "MR.Abderazack Zebdani" <zebdanimrabderazack@gmail.com>
Reply-To: zebdanimrabderazack@gmail.com
Message-ID: <1310125084.214050.1576599976270@mail.yahoo.com>
Subject: MY CONDOLENT GREETINGS TO YOUR FAMILY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1310125084.214050.1576599976270.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36
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
