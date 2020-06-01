Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73A91EB273
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 01:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgFAX4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 19:56:44 -0400
Received: from sonic308-10.consmr.mail.ne1.yahoo.com ([66.163.187.33]:34213
        "EHLO sonic308-10.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726472AbgFAX4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 19:56:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1591055803; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=KL6zFI7nsgL+LhP4VckICxZ+GkRKXASsPdsZ2J9Av5jIdb7twjJbv4z32cldmDVAGGDQGFevYvLjkvHcDEkuGUupZanhTjK8eIQER9D6AqSRkkvWObZq8jp6Du/SGEtjuxpiq0GWlrPFm4CIyeu5V6YQnEMtAzW5G+5MXadjrExUK9BIlPro+d4nU39S22alVzawe4QB62ZuT5EWm46rQiOJ/TADTF80P0bmB25J5FkJMMZ87kGsL0up+FQ/xreDHW90Iucoytq0UVOxleItU2hO2mOngegvOOrVlZ/4w7O+JCUQ5kwEzmez38WAyJmB1MQCJMi/KHqd5xm9OIvw7A==
X-YMail-OSG: O0Ici_QVM1mB9qv5MzgppSg_.arx4QsVQjDVWfoIv_6s.efZKelBpn0brUGrHAQ
 E8VqK2jJvj7_k1Oa2epzTsAUXy1d9sZNPE5v_ZyYO6CoPVY9Dt675nrJtCFnmM1p_uuP1W1vgRuT
 b9pXkCiwXXGTfezTLm2A0hbjiMRJWkQgNs6Xb0imgjmxxMkE0rTAdAdAmZi90UP96mPncuHYL9XV
 wS2eMYg6zYFrJhzbhxeNrmd1pBKcMxN0ZcRGUQhrQTwJ8UQ.47zM95G.QdBNLhbUvFe9HNi4yEbt
 egc80xXIMYcgdooKnbrgYyStic9EylliuiBkO4vKt0r.wxfrYYgVEsV_n.0vn5fbekbGzBMu3PfP
 MNjvnLdLUP48N11MtsLlIeH7A_gKJDMtILkQD3pIquH6CvYXHf8Zy_COYZFfkn1X5tB756p08_Tb
 0Eswhhi5T8rZV.X_u49vbGWa3TotlKdrtesiNGJdsiq6bDee6sMrPC.UGxYahQUDA6Y91fe95t3n
 vRaOTC1vl6JFh7QGbJLF6PYrMRFOXZMV8yobKEGLvbM9wXEAJCwWLy6AZTs6j9ejezdD5jC0gjub
 ld6CXG1rccl5uGr.K6Eynxxs2DuHquyMqzflBIvvadklJXl.BZE64swEOkv1sthiIUx4FqDfQJxu
 CU7awI.6jwd1UCQQutb2kWb6ZzCCZqTLe0sfl48KKRyefCwD_MZgA2TK7kWTi3Dq2SfNs41zoTCq
 gUxB8GBR72EGf7od1wOMq30AT5A9SvhPZ7dCvC0z3juG89dUrnn96bOOH3E3RYagYaxwnrl_QvHp
 iqeObkkNGSbyyITtAyh2Ms7wiax5OQ3pWUjXWy4eQ4kNrIZLAsVbTxzW45wlfsT7hD7dCZW4ewHX
 5cwu4uD8irxHDxYNqTSYZAN8i.3.TybQXILzkAX40cQ8DepfS58FtYN231t1EuovFO3CgxtJ_CYB
 yjm30XUvNnIKKRCsoOgohKVxOaVqTuLnIMeDC9PKGzg2.eaC.tUtAclHC0DbibwOtp.7BwbknEgA
 jtUUs6Qgp3u.zdarA1qisrlwuXYtduXEgAF7T3E6PxmxdogHLxJND5uxj7TMsqmACC2pf6Nyeh3Z
 ScVTOOPi_qzWQpSA5D6CkfvvNpJWFL6lK3BfK5wkcQDQk0rknb7vjrLfIgNzD9AtD9HVRJgxc555
 m0t0RfPvDuuk2Yy9XOj0ldD1G2ttTbnx01Ny6v4yY3Q87fnXU6mrgnQvYeaiLPZgPPIosqKfL82O
 MfgP2WoH9Et9toLPQavrPKgCL.b97V2DzUvFzdL3Lf34eGwQEzZFjLa2E__6VgU3m4tbwf2o-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Mon, 1 Jun 2020 23:56:43 +0000
Date:   Mon, 1 Jun 2020 23:56:37 +0000 (UTC)
From:   " Mrs. Mina A. Brunel" <mrsminaabrunel2334@gmail.com>
Reply-To: bmrsminaa232@gmail.com
Message-ID: <1146360412.1171587.1591055797867@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1146360412.1171587.1591055797867.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16037 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36
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
