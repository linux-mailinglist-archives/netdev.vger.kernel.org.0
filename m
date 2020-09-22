Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065CD273E6B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIVJVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:21:09 -0400
Received: from sonic304-56.consmr.mail.bf2.yahoo.com ([74.6.128.31]:37416 "EHLO
        sonic304-56.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726489AbgIVJVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1600766467; bh=2EMRCKNCFf5xTxpxMtNErtUNe3lTdsc9wFZgwmyTwck=; h=Date:From:Reply-To:Subject:References:From:Subject; b=brOBs815IAJtqF6HGbJYGhvEZuc7fihQpl+N4Q9QRucnpkIBnSQf0NRFmvSG+YR43iu0VIBiwAMrXzb5PuFXdo2PMWuzXgZnag8H65eNprag5sUNcpNilc58aSzewjWQqYZaYfWQR7HpTxE1J4wOGN7FT5XJ+44lvfqpapPa40TuLHCvvq92mO9q1cdwPQDkGJjNIDDSYRKK1iU3u3xF/1r+Ot5pUmsaCsYSeJx9zsRrwKOzaUHRODn24L6J0ljA/mzw9t4GL145R1aYG7SDlNaTiJi6w+qE3Z7kSoSsnQm9L7YGulxbUomoQsBLTTjMp3L1y2RoEzJah/wUAyCrfg==
X-YMail-OSG: LWbAm3MVM1lelJ6aoSjcWLjSi97n5kN4l_Z5_qBuq9MmH0uTsKBCZHAKaq2DA5M
 7hfhYjqLdf1NT.jFaHgPsbEVSDXxPN5dHzKOULA0GsUFLqToZo8W7ErMeq2hQN2kcomD1neCspfb
 Z3z37JDQzzhC00HLU6WTPY6LCw3YDMG32nyFjQBYv5VFFgz..Jc_uEJyJXsUC_XRDl8o.wDWJsYX
 8TAHGHf48JcE1SE0IREppWU_B5dXEwrfsKBaIjXZ0m.e7zufCQjrdMs4P9KUPfQz58pyDlDHHSPW
 .u8iqlSKqtuQ49ykVa2bmqxh8xxys7o0wWJoFt0IbBya7ljRbQ_kVm8eeA9Z3N5yJ5m.0VylGRln
 fwpAL19WjMCoSUVwRba9OG2gA7mr0jpqG7Mxt3EhaW0YRr_I.ANtL.Dpr.LqQfhtHe0UBDu1GmK9
 IaJ6Mt7UPZSGSieD0.HbarphFHS7rM6UlHE5j2j6sLzIKRWx7_h91pjN6HdURMRnxKeZKaSBaMfB
 ndYVMNUEqlOw8xgB1Oks4T43kCiIPO0YSp7cmWYMwboIpfTpNSSUtk47t_R1jTGKAkGwelocntYL
 Pb9bFaWk547Dd8dYsarS6cC9UMR9XH1JXPm5bCWzKqlBRPU4UY34qS32KTsOgGK0qBB9VVnhSy3Q
 bKfzP1T8jjrp5qm9Fh5ee39BHJTtPt94_b43LnlLU1DdhzUzazOzK98W1zrjesXEF0Y0cCEev7YC
 gwbN278NdzdQwBQmyHCE4EDPC86Fz7x_6sjziQjSYryijU8kmRe_lc7XTZSoT4anuPqfLT1Uoawr
 ippBulT9QDACPKbPYQCsuSlvCEjPKiUYKJmHzH0tGRuIZr.Zgm8I6ECbRG9SsseXlk9hdJZJajzO
 WHM.Kmq7l9u1uAJd7twNVmCySqX.qOEDzPBoaaVH5khaZ_UdVpOIKzlQBL1u9PYvIqAOIrHup1zh
 wSb898C5aqlhVICZkMqWOI5NoJj2JWc7c9CmjRrNAjmZNmQfT1_Yh44WZ79f3fVTUsHAn_6fJ.JS
 k.MMfLplkMiR9Bn3wFKPlLwxUPOMlsHQ4LBkG7jmPjEYITUpL5YW.nhcF0qtMiDDqSQhQgt4nJBu
 tH5eBLLAzD5Puilr0hkBqkKAl5KHYLoqHrYIHaEGTSJz4QL_1uAswAxAau8B4OcI7cN0F_JzIifV
 MeEJw9O539IqDHYcl2vXTzaFtz4oRf.rZwruAkIZmnS6FEduWg.OKjX8EEiml__uFkncvFcMKUUb
 iyhNWv3IKWxQl1euSGUpY8Bwm0EKSs_X0HNrN6H3TwaQFOVYTAfPzjifpxuD4lgi8F53XsVDCu89
 P3wIYzRDgDmyM_TeSThTLw11uQGzVUefrGXa3J2JPN6qdNMlrGBbFeC1u9ZQOgUw30WFnspPnh5F
 Yr_d.GFeF6Qf2k3cQhvngKVHrsoU1IHX5ILHfvj_YfqYPuMhUSccWxCMxhMshrzcP44Nq7xzE3Zo
 dXAqT5y1c4knn
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Tue, 22 Sep 2020 09:21:07 +0000
Date:   Tue, 22 Sep 2020 09:21:06 +0000 (UTC)
From:   Sgt Vivian Robert <sgtviianrobert@gmail.com>
Reply-To: sgtviianrobert@gmail.com
Message-ID: <323707766.4677731.1600766466986@mail.yahoo.com>
Subject: kindly responce to my mail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <323707766.4677731.1600766466986.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:80.0) Gecko/20100101 Firefox/80.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Good Day, I am glad to contact you through this medium I=E2=80=99m Sgt Vivi=
an Robert am from united state, 28 years old single I am the only surviving=
 child of my late parents, I am America female soldier presently in Afghani=
stan for the training, advising the Afghan forces and also helping in stabi=
lizing the country against security challenges, am Actually seeking your as=
sistance to evacuate the sum of $3.5 million, This money I got it as my rew=
ard in service by Afghanistan government to support me for my Good job in t=
heir land. Right now, I want you to stand as my beneficiary and receive the=
 fund my certificate of deposit from the Bank where this fund deposited and=
 my authorization letter is with me now.My contact with you is not by my po=
wer but it is divinely made for God's purpose to be fulfilled in our lives.=
 I want you to be rest assured that this transaction is legitimate and a 10=
0% risk free involvement, all you have to do is to keep it secret and confi=
dential to yourself , this transaction will not take more than 7 working ba=
nking days for the money to get into your account based on your sincerity a=
nd cooperation. i want you to take 40% Percent of the total money for your =
personal use While 20% Percent of the money will go to charity, people in t=
he street and helping the orphanage the remaining 40% percent of the total =
money .you will assist me to invest it in a good profitable Venture or you =
keep it for me until I arrive your country. If you=E2=80=99re willing to as=
sist me contact me through my email address =E2=80=9Csgtviianrobert@gmail.c=
om.

Sgt Vivian Robert
