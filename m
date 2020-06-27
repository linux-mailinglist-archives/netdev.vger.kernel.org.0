Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CCE20C407
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 22:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgF0UYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 16:24:04 -0400
Received: from sonic313-9.consmr.mail.ne1.yahoo.com ([66.163.185.32]:35890
        "EHLO sonic313-9.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbgF0UYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 16:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1593289443; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=i5BaG78Awnbc5Uw+TBmbIHQ8R/A/bmaJ6uuKNz1Q5yiTj913mkKI1hdCsicJBSNNBuEzLnyq3UZanU5KUosw9fFGgiDFhA+negIu5vPQwbLGRVioWjvjE/Tz7RhakdPw6v8uMwdnV/Lnqz5ETjiumWXXKVvvmQlBrB6oEv4fDj30Mkywho1TMKg82rW/Me4CklHlUSLJgZ4YHx9RpoAKmZvGXO89a898jaKcTfuRDBJHFZNNk+eTxpFOK5sySov96qWth/sL5DjsmXGBT3noQeGEZY+ffwI98/6cbysSR+762P+7l/oiTAKG//gWu3tGRccKELTlpn7E1YL9ay8+yg==
X-YMail-OSG: K6Zn8JsVM1lXOwX.FCrEdjzysdOVeDukyVo4CE2OaR_ULFkZp.IVuF1xpieZo2I
 ZF.r5N7eZPg_G2eF3BcGsEJjT9ZFwXK6EQ8YkBor4nX_3eSMqlwAEbbZknh1g5W7ZYlWMWLxxrKv
 RovwaI8z.clEtOLZadiOYoCuWDd1ur8ydAERcdBsQMf9Ac7BWJFdKh3UGlcrFrj5bogkUSiPeusU
 eYYmusjsQym6D3eb2v1xQ9uqI.kXKuWm3Z9NgobTmZOj6uoVuCt7KRaJN38VRkN.PW9qg4aOQxl3
 jK0tmCqIxr0d4dy_koMRl9ALXO6heam1WPhFgDCNeiywh_97FrGCtew.I6CsK9LoIwnf7.aGH4o5
 Z3IRSzXw8Q_UaFnv7N4Dr0ezPeCtIFn9fPuiyQP1Od_DnxOocJb4zW3Ppbx.I0NWCxI.kdxKLCpE
 W_TaIT3IY8mjokg24wdJBNNIamkZ5FW1tzpxIiZkhHfTRPIzWvXJa44ADu.Xrxar_G65_wdQPlJ_
 Uk3kJo4mG3.uVpNFCbEnc_SjpYQecs9I7QXb0Bb7yyrqXZCuLbCAK8wAeLHoxdRPyAR3.9DVtSl3
 7M2HcfEPEf6G5L361Nu0GIHDFE.vr03EBEtIsDXBdXoIgU8UFrD1hEh8XCq.eaGWY2pMkyBdsYoa
 sphYg_izAdvag1WaD_u1PSznJvg0Ec4G8Y4X1RyI7AYbvypwFpOyFECjW3zAI7E62ageT39rQJT6
 Iuf8dI9X4yM7f18nj3Ra77J.he8I9RNbkFiON98A7v.7TggTQW1zFoHvjF_FXQuZgxBVDfLTHQs8
 7uvKXnqT7dlqg1tOepBuDqqAhafha9UzqEzeo7Lge3wGpz_NzO2ZWRDfQoJ6cAf8FyU8rQd2pk4A
 .b_Y9jeQN12ET7UncaQfbOMRqFqSE27A2hQwbtTeKauBnkuHtq932HlDor.zphkpuf89fYMClA7V
 7LTMnRgboUP3ciN4kSXWPAeYZj1GYLKZEyyNYBrET8wGyLCXcBp.wDos4znGkYCsuqDp_DJ_WMRe
 Yuy_63FGTL2m9pPKFLPvkKBtarJHID7_0u8z5VQvdT06bYtG4RNV3TvpsZSME19u5d2LtSsK5FOk
 1RERQ2UVzz.7fT41kyOtifXI5.6ita7wFb4hYkLTIlpui7LUQDvygtDt7ykoqsOOwbcJo86baggT
 BcJN0slYlLrYtRFuRL.R8SdBU4eI2Eo8qxFffOslzRXFxME0htmJZ.7LhNt5NR8j7IYuRjcwa2XS
 FfdP1OpH5MJ_iQBZPKR6Uhj484VWIwaYmbnXAUeh.ijs4uqDIAcTsvZbE99z5wGyKzFu6bKB9Qid
 YGw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Sat, 27 Jun 2020 20:24:03 +0000
Date:   Sat, 27 Jun 2020 20:23:58 +0000 (UTC)
From:   "Mina A. Brunel" <mrsminaabrunel2334@gmail.com>
Reply-To: mrsminaabrunel57044@gmail.com
Message-ID: <1391510444.4676429.1593289438432@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1391510444.4676429.1593289438432.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16138 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



My Dear in the lord


My name is Mrs. Mina A. Brunel I am a Norway Citizen who is living in Burki=
na Faso, I am married to Mr. Brunel Patrice, a politicians who owns a small=
 gold company in Burkina Faso; He died of Leprosy and Radesyge, in year Feb=
ruary 2010, During his lifetime he deposited the sum of =E2=82=AC 8.5 Milli=
on Euro) Eight million, Five hundred thousand Euros in a bank in Ouagadougo=
u the capital city of of Burkina in West Africa. The money was from the sal=
e of his company and death benefits payment and entitlements of my deceased=
 husband by his company.

I am sending you this message with heavy tears in my eyes and great sorrow =
in my heart, and also praying that it will reach you in good health because=
 I am not in good health, I sleep every night without knowing if I may be a=
live to see the next day. I am suffering from long time cancer and presentl=
y I am partially suffering from Leprosy, which has become difficult for me =
to move around. I was married to my late husband for more than 6 years with=
out having a child and my doctor confided that I have less chance to live, =
having to know when the cup of death will come, I decided to contact you to=
 claim the fund since I don't have any relation I grew up from an orphanage=
 home.

I have decided to donate this money for the support of helping Motherless b=
abies/Less privileged/Widows and churches also to build the house of God be=
cause I am dying and diagnosed with cancer for about 3 years ago. I have de=
cided to donate from what I have inherited from my late husband to you for =
the good work of Almighty God; I will be going in for an operation surgery =
soon.

Now I want you to stand as my next of kin to claim the funds for charity pu=
rposes. Because of this money remains unclaimed after my death, the bank ex=
ecutives or the government will take the money as unclaimed fund and maybe =
use it for selfishness and worthless ventures, I need a very honest person =
who can claim this money and use it for Charity works, for orphanages, wido=
ws and also build schools and churches for less privilege that will be name=
d after my late husband and my name.

I need your urgent answer to know if you will be able to execute this proje=
ct, and I will give you more information on how the fund will be transferre=
d to your bank account or online banking.

Thanks
Mrs. Mina A. Brunel
