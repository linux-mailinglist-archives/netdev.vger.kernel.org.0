Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98E812DEDC
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 13:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAAMFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 07:05:32 -0500
Received: from sonic308-1.consmr.mail.bf2.yahoo.com ([74.6.130.40]:36928 "EHLO
        sonic308-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgAAMFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 07:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1577880330; bh=rLzamwWDU6w+ljUNz15IdfH92SpsSZVAbr+GO8Whobg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=B11DIK29CH9F/B+YRrmwo0qI+cPAQ0caJ5jX/9dMdQa9hnOUxqWDafngs2hNF9Iqdi2GBfRU76C1kga2GRmLlUBU8Cr46nUtv4Kx3oq09KbzvoW7FY8FHXbkiHgq1dKNqM8tcklglSx7HLjton+NbzfUyzbq7cxeC2Jrwc35FgorqyRswapqw0qh7uU0l+Tw2jz5BZ96RAOCePlJtOshCDvIVJ21ledMXLiUFvgoqf6iA18KVuxr2+NSgRYX9oD5unyP9iF/8FA8fwvj2uZ5tljy+eN0aFGk60EDvAZfy5I6qUdCC9/CYVlLCDlumYVvFJvpc+Tn1/uIuBvcmbuOQA==
X-YMail-OSG: tMY9O3QVM1mN9JRWnFgViCptAVWSf69T9Wsr.gP_gfAIpouDjzixdqjiIgisHJ3
 C.tw1j61eNJcUj.yiALL4FMi0SqlGF7lXujgejpPjgWcvBDBBEVfQ0FzgVZzcYC0oq95vZhYMKgj
 LUnDDD02Cr2uJz2Ogj.pDHBLXZRzw9NAegMDgcGxnBO6LL3e7efzrbYCyY8gkLjxr7SWhawC6QMJ
 F1OTHsPs2ADSx9_HozBIquhDhZQlpbYewUuuQ77pYEeH5JpR66e33h98giBa6DBD8trrGRzt4J6R
 ZZkl4vkdO6HpsGWPgcdOCOXQPkgxSgx3nM0mZP5rbl0Z.w4fwGyj3h_yxyzu0UU_bFexT3104lu8
 .THebBZuuHY1yRMwxz7QAHZJL2rvEs_Av81TrZMdndlsBzFr5Zab2bw9k.yXGHqyKU97tLks.CMg
 QDsJnzfdxZw1o.nFhMeDRrNqqOfjJCFABUSRo.MRhW3WuEAb4m_y0q8zXtx.sGx3bVHqtBn6kXd2
 9b__MUurPCH8mtjLuuX8Qr5nwGbUIFFuuTqf12HTbcXp1YJus8yavsDgBmAcjkiFCPK.CG1tHeYw
 L9ER6e7JVZLYbPXdGYrq2qQeGMJ7M3kmcHxeMOasnxxSKg3h.Hng8ZFBZ.sARlorUyNx6vNwyriE
 hgGnt5iQIoR404EWNcRxllXPKA8V9M2JvXnKUgiRNTkaufRsKZCFf04VrnBEB1mpC2q8J0LVUiA7
 xRmMeUwOS.EZr2hdgzFdaRm62d3XdqZR5KL9gdbLTWh8SDlMjuUOKC2IWmMWES7XKZlLFhiBOV_m
 f_mEGJMotHnHRc0We2LeYY46gCwuNyyzZYYGSZVstLyCi81_23YFzeLkriP9toIHIK3AYTcfdCy5
 5xDA5dGhHaeMkeDmGL_Yl7SPPZ_UevgJQY0PmRu60q.Wr5PfFZnJFM8AzCVS8jCV1DPoGWx7jD4h
 UCFKr514kinV2vCY3Z7WKdzSVgqDmEEtklMQfJLCwU4.HiDzWypka7p9bbCiBGQhcw6gKwJNxmmu
 C2.vUq_VIXZ0Ig23iDSjSWXCKhA_FCodeotXwkhpdh_OVC.Y.qQchBfhd8wTa26hdsPg_2RfWh6g
 y2QqgAid_.yNlgWPP8NXKsQK2DiyY0HnZ.DPaItP7VIQJ_KVAE6HrORRNovKTE5WiUkcy2Vp5sxm
 5Zgu7bl6dd0ShQ7vMT.uBCKK08.7w.gjv1HZ6cQSESd1cX4WmBpLS1tONDv5kj2bafiekuDIVXA2
 SHvxyzBCwMeH2vrZFt0At93rjMgLpomCT3GHp8UhbYzVzjkUTj88v9tmvZ55lNTzBp2XhCu_Nu6E
 g0ZOtdA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Wed, 1 Jan 2020 12:05:30 +0000
Date:   Wed, 1 Jan 2020 12:05:26 +0000 (UTC)
From:   "MR.Abderazack Zebdani" <zebdanimrabderazack@gmail.com>
Reply-To: zebdanimrabderazack@gmail.com
Message-ID: <297120597.3576493.1577880326400@mail.yahoo.com>
Subject: MY CONDOLENT GREETINGS TO YOUR FAMILY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <297120597.3576493.1577880326400.ref@mail.yahoo.com>
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
