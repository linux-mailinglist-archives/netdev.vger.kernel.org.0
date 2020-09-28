Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803EB27A937
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgI1ICM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:02:12 -0400
Received: from sonic310-13.consmr.mail.bf2.yahoo.com ([74.6.135.123]:40695
        "EHLO sonic310-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726648AbgI1ICL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 04:02:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601280129; bh=K7hhfUMXU22WN8N5HS73egl7nWN4C1aERKkeTnV90nw=; h=Date:From:Reply-To:Subject:References:From:Subject; b=KUU0tSY7EaAfr6xy2S1hzPx5iwoHEGBK1h4YgpwLPMmIpbkE0Kn3esY0K5rWfrh8RkHGlYFOUlOM1YJZ0eiGpAtr3UbOnVn6bBMAsytxcfMFN4FqsqiqF8TOC+RxoyohFlwJ8TECmpROqE+OroWxVf3imOvIYp4d/9QbejPLRERU16bvu9cE7ppB+gltE8qeFXkjrd8ErWsJhXyGf8nuO2G8CqJOyDSQoMxsKIEM5b66xT83s+HtPwrAJ0oBL4r/EaUb/F1x678cOwYNQXsvhRaAJD7Eml2n6vjZw/fudpqYpJfAFN+h2P3GGNJ7aySLIByrTGuZ3XXpDP8LJpJIJQ==
X-YMail-OSG: JSctPpUVM1kbyVIMxvtwUkBZPKbpW4MZaS4Sc8AHnNdlVSbxK3PCAce8lORcZZS
 9uLP7VTdrvEfK1XeatgdQtoH2xPqqUwQ7gMnzumXIWtRmk3TKsB.8mLqkPAZkyQdn3SJhEroSJzU
 DktjnhkAS3YB8EhBgQIzO1Sw294Xnjx0tOpwdMbB9H_lSDne9HSV_QEUdcCiAvQLojLZCkkak7NL
 qR7w0hZNl2Ax58uc4AUHKbOuTl7iVl3JxvoNieCXXK2I5.LPSEFDuNaf1h443zY9iurwUQn0Kpo1
 ebfmey_qkBzN_wICVEVNl28V9J47vudvrJ_Ty.21nODFbkTJsF3L_zZPK1OKNxwaKySiXXhdzWlJ
 MgJAtX_QJ_sRn1VHjP3YCleWZ_mw_rSO6B23.bfMLeKBqWKZAdH4O8Ln7AubEBkCZna47JuPQj3P
 BjLda_G4dosShsrRLMkTZaxUKdtFV2Smj39WADOY4zwiqQ2QwdIBRO93o8EI6jJdd3dot5i07cbC
 lZx02IbPYSR6W1euVXm5YSSfPq7W1XxAPnrxnVDPDUrksm9_SDqpr0IybYEQTS_hiNIPQJh9Swu1
 xBwPdqk.tqj0V_oRk335AMyI_2VFjX9JTnQn2S.girBUWbvMy9pUuh81Q_Hs5q1WtvKrxsfFyQHq
 h8wpOSSoQRAAnwHFwof9I04lQ4suXLwJjV6mtBE25n7yCxN_qqGxFNIJ0an1Igv0mOcSlURGxsli
 eSq8IhGcwa9Lhx83xqwGqtkWD8R7Pq.b7PXeWrMef1_R9pikdt74drRnwZfX9tqlkrf7drh_5hMf
 Cyf8JuIbToMxZtlIiWn8SpmVO8sm4fdEn8Zdz3EiS0EEEx3KTjXb4P8ePGMpvzppYg64lquqU5Vc
 OKMZeJyRXQKoG4.VhyGLaPvu4nE3EFUZ.dVUYsSwG6NOFtfG_.iaOUA6gM.tFofkfAPZ8RbOowna
 OEtXh17wjlSafo0_rmmuw1fMludBmb0yEPABjaCovHKmQfJGfM8WMXgCCpclhRdIoxt1EHfMy49T
 4NCQoTVqZ.7lXZqJNgc1v9Vg.P8rbignmJCK7bPmmaK_qziXNO7_exTHkZQhybAx2KNMguv5TH2b
 TLoF1En5B4U0XdhjkPuShogaCnXibq0obecKoHaQKgpSoFGF0BzQa1VIHx8Bna7Lhgcfh0saRxCl
 F8Rag.oATWyeHkT7A4LxpyHYx31MnX3r_Yawg_P3kPWwlJGHLi2D4gWMh0evbuabtMZP3Hv9EHxd
 gr2ovAexxVVo7jlfpBJNdnyFU9_rv9kVQGr_6_znMY9r7ylMKjiZuYNz4tshZ055F01l.g4qu_lm
 9qobZgSwGkgCd_EBQRSSHxYnjORpWE8m62wAjyKIt2y5GhOxiPRf67Qa5G_xYOoBGz9epCJjj7Eg
 WOXKyiO1y0DJyRS7v1R3nANwZ__kUyOp6Lo.hqB6_BwcOOA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Mon, 28 Sep 2020 08:02:09 +0000
Date:   Mon, 28 Sep 2020 08:01:52 +0000 (UTC)
From:   mrsflora.the1983@gmail.com
Reply-To: manueke.flora@gmail.com
Message-ID: <414739788.1367795.1601280112735@mail.yahoo.com>
Subject: Greetings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <414739788.1367795.1601280112735.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I know that this letter will be a very big surprise to you my name is Mrs. =
Theresia Manueke from Indonesia, I am a terribly sick woman who have decide=
d to donate what I have Inherited from my late Husband to you for the work =
of  God., I just came across your email contact from my personal search, I=
=E2=80=99m a business woman from Indonesia dealing with gold exportation he=
re in the Republic of Burkina Faso. I was diagnosed with ovarian cancer dis=
ease which doctors have confirmed that i have just few weeks to leave, Now =
that I=E2=80=99m ending the race like this, without any family members and =
no child, I have decided to hand over the sum of ($3.5 Million Dollar) in m=
y account to you for the help of orphanage homes/the needy once in your loc=
ation to fulfill my wish on earth. You may be wondering why I chose you. Bu=
t someone lucky has to be chosen according to the revelation I heard after =
my prayers today.
=20
But before handing over my data=E2=80=99s to you, kindly assure me that you=
 will take only 40% of the money and share the rest to orphanage homes/the =
needy once, response quickly to enable me forward you the bank contact deta=
ils and my valid International passport now that I have access to internet =
before it will be too late as the bank is aware of my decision over the fun=
d and awaiting for whom I will instruct to contact them forward a Scanned c=
opy of my valid international passport for their confirmation, Note that it=
 will only cost you for change of ownership according to the bank, and plea=
se don=E2=80=99t be discouraged about the change of ownership because at th=
is stage if no one apply for the money it will go to bank treasury when I=
=E2=80=99m gone and they will not use it to help the needy once to fulfill =
my wish,
=20
Thank you for your co-operation.
Your, Sincerely
Mrs Flora Theresia
