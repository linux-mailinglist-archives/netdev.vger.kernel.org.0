Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A7A1FDA17
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgFRALw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:11:52 -0400
Received: from sonic312-22.consmr.mail.bf2.yahoo.com ([74.6.128.84]:41726 "EHLO
        sonic312-22.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726815AbgFRALw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592439109; bh=q1Er/SdqxATomBDx27mJAnsQxxrJWpCL+Y8MaW3053A=; h=Date:From:Reply-To:Subject:References:From:Subject; b=NnpTxAVQ92SSS8Yo81WLITtrFFcvmoRqj/v8+pMH5NWSt5ZQwpUZG3HQ5UYBsuF28Onm/jELuy20Sh9YxlRLQSBPiz/l57qs1ScA0/QQ4GwM+3SpUZAA3tHt/iBQPJhFfjsw55P0sJcJMBbBnLJVK04g1TkLomGzdfNxWy7+/tEWY1T5iUn4brGFnzaO5SL3uVTmYn3GSTt2123rD8atJI7/xbD+3xAIrrkf7I2Xlm+3mf31AMw2hWKPMu7sKYUkeI/HQLgxVef5nbTMBWcFSCwQmJiAw6k/d2BIwiTmctw9HQdxnXGmQdwVA74ntaL9ohKfB26Pd6I5E/FCcJDl3A==
X-YMail-OSG: WjmsTcUVM1lj0hxIPN16WQJ6KIqqPluMlp5omQ_HQYITcwr3bi6ftM4Z3gfpTnd
 t.f0eQvHFAzM_yuYeOVrauHou6Gla4R9dw.SERNfMgAlxBA7_6.jaVBeeJuaHR7JCu3tcYzm_NP2
 tBU1nW5iFFrvAihmsy1LFGwQVwmEdPTBvLJV0j.l9dYt9YZITsfnUtWovb9YVtyzzQr7M2a4b7fy
 1zRv6W7OkSmn9rraMGptPpHgQq2RpEaomGSKqpFPeX0tUd7r0TUriJoJ47FxOeH8ubF6UfWK5cn0
 18OZPyvQk_HSBIMzPe5I3PrnbAAqLpCCbvx0fxFdeIUb0zNAgn9688bp30ww8cErkPmhwU0lVNn9
 RIvvmGsO3SC060uAkDjwcFWogt3y6GTfduK2cGvEzyWYPzAwcJT__eb48AJ1asC6M4bGaUYoQ5.x
 h.mAjjWu0jQqVFzVmCXb4kxnMCw.hmDAgEm5pclIWErkJTqETST3UE.jNAZ98tSKcr19w2PlMjMr
 e5cxDw237HavKQSz.0sEELjCDFw59uSdoe9AQHRhnaD2L6esAvZm2I4CDGZ8KZuwFEFqQpN0jSlq
 TzgJ02Bu7ellENPibbVGSKqdNqByPXZ2hU2MmXgVup8Df60pQWigLcScJIBwdJ9uGg7oFIs9ti3b
 HYAF0m.8isS3f0yaO5qbUFklO6.8nLbjlyzYqCAQId8tFEJyAEPMi5kk7.Bj6ESg9ntjFs_ntjH0
 WfptgZRSEEoPfiOhAedsYBkO0V2ERP9NAWKWMw8u.goG62Cn4xlTIu3kYu8xOzs07pSAGxiquh8C
 y5I7UNrOH3NR0K_oGfgvn3uFiUpRdMHpTNO2vWvpX3c6k1lMcwllEE.nt809ffmfSU8a8zIO1kc4
 tN.B9UCqsiUCkDfOitJf869eq9fxOgKjgTsV1ZfGbaDHJGOyvGZnBM55I83HZzMzfSMUQMyKuCKA
 te30jKIVIKNkMjl9x2rXXk5BIplfGsYAWoM8XDP9tTcxI455pl31qNZaWT26zpEmeJYoTbIUcaNv
 Y5Kusg2jWmlPqpyz2sjSc0Fi1X9bw0DaaVWb.qrnQqMX4uhW4tRATkQ8.aAHJTJWX4oIsF7iSjem
 NlDGVsrq8EQtbld9dVS..th5AA9tYTMm2_ExpgLXP4.LPWpkYsdhcXz.I7X1u7eubsbw1Hdr9fsZ
 lcs_4gOQQTjVntPXTic5dZTt2C8piweNDMZq5D_WHVwz3CQPHdPJpTzgywSQ09H9HGBngh8rsfci
 nhu6KEjqo9UHPyJi8IpgjJyru89JPoMMF1GRqJzw4U8G91C4FMLCXhbndZ4FZqpiwViscuVKx76m
 Hb_vUAp8TZIBm5eJsETwkepGxEQejN0jnEfvvX3e8NTrsrIuhaIY-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.bf2.yahoo.com with HTTP; Thu, 18 Jun 2020 00:11:49 +0000
Date:   Thu, 18 Jun 2020 00:11:45 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.minaabrunel209@gmail.com>
Reply-To: mrs.minaabrunel2021@aol.com
Message-ID: <251450884.1820788.1592439105984@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <251450884.1820788.1592439105984.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16119 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:77.0) Gecko/20100101 Firefox/77.0
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
