Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9051121C204
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 06:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGKENV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 00:13:21 -0400
Received: from sonic312-21.consmr.mail.sg3.yahoo.com ([106.10.244.211]:41740
        "EHLO sonic312-21.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbgGKENU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 00:13:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594440795; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Gut5Sw0A2sV2o9X0yzDGJ8HtYQznovLuqWWr0dMN+sfPYNERFaogb9ZkSy2dbcPsd5NX6382OHuX7A3O6rfEuTz44aWFG68RUmVl+K4Y1EL34Zt19TAcsdq206JXFLa/DRGjfWLa6TZhjdh3nv9OlmuYnP1XfC9YlA1U0/5L8u+X9upVrTfZSpRQzTbLAbEMINCq95kiOTMnIjTKGwy2LdCYTsqxg+ohPfmYaxxqhcb031UKtqTcHoPehz8yZ4I9pM/V/7u9rPDE2JVMQ5/9G3RSM+6zVCjpqFOFFN1qHqbOC75ikfDq8D8EttlqQZu3s6dQAf2XS2/FBVhpQ0pO1w==
X-YMail-OSG: E11m.T4VM1nzgmCQrf5qaUjqQ9U4fTdK2b1WruTFOrWy9krjjqxMnh204NQ9._t
 zRx7NziTrzJK4QYmk9nEAcPniOANJfQSfPzvYJNeYI1GgysyLDgMmZROCfj4QlUZnCBIC..UcxGr
 QwIXvVysD88.jELmMqOrUelqmt7mKN.V3h11xMh7wYP4a0Y6ZuxUVko.u_cMuaxAILM.nB9IDpL5
 cEsPYZ0TXpiIH0_wEiciCXrmU.KMveg_srBqxMdREFBfHf975JJm.eEvJ4B6idDvdMiyX2Cz03vt
 Q8yQed3hYav6ybgDi83qWag2p1.sBjVJXatCEJ6gek372Lw4Fy5XcuDl7MmovauheWG.dhkbwB8D
 P1MmnAGnicFPoCB7AeVNlHNZh0hfK7Ep_3iRVM3SlMpI3dNBuf4oxdyOxCkI0txAxZmWU.FqVsq4
 6VTsMYRArA.2BcfBNog7eXmHy4c26WSfX1nCih.TO1NbPXCzT5Kxei.kbaWKDaFvPwn4m1cNNG2s
 bj.POHGBo.CJp6EyWNm59a.SeHIFFnFA1htqjzPsRbvh0YqZ_ZOXWSsOI2YeUPu0sUMxLpk2i3yz
 3ZDS9B4KFEAi7cJ2.wBC2b4ee0Y41DfwnGgd1pupMOCYLYlC7NQf0X.rNYKuDfxqZb3lTfW3qWaz
 ZMDpyeL9.zAfuH.yrOQ1uhIokk_PHmXn3riO3uqRFrrsvV9.MxojZjZdOB6AHSb588JnMNKcV.f8
 u_rdUbOKbClLd3kD1Ip0bgT6mI3d44GvwKsTTztrxtqzh0W3k3XDwBIubrrkhzBNdrNUkdeTcKV3
 XrAfZcRGY1ieRM2EKRR0UA909Rl4B8BexAMO.dg.IxAakennfokp0FRtj8_X611LhwgU7hOEA49f
 6n02KPJz8Kv_V5B34AfCHmxJr2aKQpOxEQVPC1UKQcX1qkWc.ZAcqtkYPiWV4QSDnXTw7PLA45Cz
 ZvoO.qKihnNHju05JmQ2I4iTttifjKcx4krKjN5UGeo_LmOk8iB_SSayPvpZGwMKPWb51HT34cAk
 3stgYyXwO.keh.h_2HoaRClKeFel9HWwcSZg81WYNYTZOoh_W7c7mvkUNM5T8uo88KvOTn09nlNO
 5O.KsqAqar6bOvgG4SQ5tgyxtVix9ZueiAXg_DMjHyOxauBD0pZzy7_TCTuAMpB2Jv7mFad5uQcm
 H2oOTRrMHPJMky0O5nCs1JjfS2l982808srhBm7vk_75.YQxQBJH4fATysMX.2sMCZnYrKXaJJhN
 leuuYrU0tIFGiKX.d6bZaP9VKhJ4SVY34JnAKn7XaMNs2Tlvp8AJckQLhA3FGXdw7DKYOMBocQjJ
 e_b1rhQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.sg3.yahoo.com with HTTP; Sat, 11 Jul 2020 04:13:15 +0000
Date:   Sat, 11 Jul 2020 04:13:13 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrsminaabrunel2@gmail.com>
Reply-To: mrsminaabrunel653@gmail.com
Message-ID: <1661914196.40231.1594440793550@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1661914196.40231.1594440793550.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
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
