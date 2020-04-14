Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1783E1A8F4E
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 01:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634416AbgDNXt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:49:57 -0400
Received: from sonic303-3.consmr.mail.bf2.yahoo.com ([74.6.131.42]:38159 "EHLO
        sonic303-3.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2634404AbgDNXtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:49:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1586908188; bh=q1Er/SdqxATomBDx27mJAnsQxxrJWpCL+Y8MaW3053A=; h=Date:From:Reply-To:Subject:References:From:Subject; b=QEk5giC2E2UGQIVRGgpT5FWmxdxL7/FYimF3RLvQrFvsjl5lb9T/31Bcjuyne7/6UiQ9nii8h3Q0f0DOunHtvYjSQALVSsKzHf9myTPOO5uPxQePAUJvKFphmHZh6HYHv5QqouWsvz0nVeYVJjFOiUZCN8vGlhl2nLHFHLlN1HwVPPl5y30ZUt4Emxc+dLAxqg7nkroTgfRiH3jKQmVrP2JHR9fWH+eBdMu6EFFcmUjtm7vWwoZWiQQpQsgqvlAwWOrNxQzJyj4NogE6Os3syBH8FvLFbfDObF3be/yFZe/uYfd4yOu90vq0T60cpeF4/Y69OlyrC3JyqERa5f8m5g==
X-YMail-OSG: NBwRheUVM1ma19dQlmiiXTI6OMUjJrCS__K3kWf_V_IsjA4Zm0SyMKtn1C_7wzI
 ZVZQy2JywAioe612M3yMQRky43HB_istmhwtQyVwq8RZZOVjd066E0s5wXY3OG1MAnaPMMKyJBPS
 YIUVDvZJJDJZjB54ST15Yn5gCF.W_gbgMAD4bwd1QDd9wVNrLjNn43VABJxeUNCSaCiB9McYXzrI
 wDO5dntcATPqZbl9n.SCSVbeRJB.yMxz7XjJyx3fgKWxRFtHxIQb9Kt4tOZi6akQh_K9_e2gi6Bm
 t7AwQkscTQklSABFlIRvyPY7RsHxd6uAJWVsBy.YxZqsulsX8LHh3M0NVoaOeKRMlPwEFYGnsjdL
 Ctm73vXW1U.nBDYfqqiOl8B5dXPHnFSLmBn3etX4IyiQTVudK85blUKQz3rYZLUnnUnZcsA6XZSd
 .O_GD4QdjzkGodorp8u3DJ_Urdk.CxO3P.i6tm0kJHs1VvS2Fo7YSNYuU9iQUWqKjsKg3jPgORcK
 AgeWT7GqwK2LIA9qpQt7WdW1z1Q65bkELT1LiIe6R5HVdoYWalnKFu9Bke_W_Kad9kk9ibMrCL4L
 QOOjJrwg3lbClJdA43HMiEe7NZCNWiMDzLL8.AHKTwZBT.TNbhJBiAZLS6ju4RLx4VMYEfmNRnHs
 SZX02p78pJNfGbGEH0UDQKZnglUTFwZ6X7t_XtSsHMBFjiqWryELrNVJG1Sb2eJMstMczms.jTv_
 2GWCB9bpo.iieznETuMQfGATO9Gn81pQJCpgGPIKJVbu_7PvmgfA3Fu0A0dRuZChPpjQQ0_l8QkD
 0PzoKGOf1VMactN20NwC9re5Y9MUu0VvT1WffIeYPF2STLvlK5CehQfaxTcYKLTD49njaIrFdY5x
 IP4Vtn3KhNkXNJEwuaxzAbTI9ZpxAiHUcq36PEORLQvaMRD4_Wy6.z_G1NbullvgbbhwnM62moQr
 bdHZ6Q1QcO.tWisndeuoGU8g7GjLV.x98Y6XlmIyeEVeJwAuCGLq6qZSFwDGa9O.daIL7BJSQOXP
 Ydk5MAIXZnIR8VaUG6gRTg97kGD3MzkvBg9ul6DHaNZlv7QK0N4TeZT4_OR4A1xWiO2kTMYR6I_Y
 cGEH6ZC8AU.e.M25ZZJ.rp90glTqPRxmWsEQ4CAUxyIEg39eJaFZGVax4HILbwBr4dKqw_uYOL2p
 _pRZrUaW5lHqUQALbtG_fSaFvUsDPq0T2LdZlzjxrxBzLKzEjgVLW26H98bdi1ZaY.s_Y3VHoo.3
 Ei9E5nvWB3iOvH6sELH0r13Tb76fWmQ0uoxRmR0O1P_8A51eQb5WxSjWH76zSafIakBg.lLPnZEy
 D
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Tue, 14 Apr 2020 23:49:48 +0000
Date:   Tue, 14 Apr 2020 23:49:45 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.minaabrunel209@gmail.com>
Reply-To: mrs.minaabrunel2021@aol.com
Message-ID: <127520250.441952.1586908185814@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <127520250.441952.1586908185814.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15651 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.92 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



My Dear in the lord


My name is Mrs. Mina A. Brunel I am a Norway Citizen who is living in Burki=
na Faso, I am married to Mr. Brunel Patrice, a politician who owns a small =
gold company in Burkina Faso; He died of Leprosy and Radesyge, in the year =
February 2010, During his lifetime he deposited the sum of =E2=82=AC 8.5 Mi=
llion Euro) Eight million, Five hundred thousand Euros in a bank in Rome th=
e capital city of Italy in Southern Europe. The money was from the sale of =
his company and death benefits payment and entitlements of my deceased husb=
and by his company.

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
