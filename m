Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4C127A463
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 01:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgI0XBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 19:01:40 -0400
Received: from sonic304-22.consmr.mail.ne1.yahoo.com ([66.163.191.148]:36261
        "EHLO sonic304-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726328AbgI0XBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 19:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601247699; bh=Ruh8whhsLaTTwjIXmzA3PCfAl+J0v/p4XdxCHWadIAE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=q/QzhmQ1PiFid7YPPHAKacKwMMWRXFkztFqjP9ZP9PPS2RaVrweoMikK7rlS9HnZk9JOxGMdD4Zl8XXR+GLfIS6lIbNvZKUS92rK/oWCFkHDtE9f5wEmzs2mZhpYa9RlLKWkMYrPIKD7xNMxHi++g2H3zgI3tIZ7VZO6MD3/RhdKL0c+WZzcki6Y3CI5AVo+Plb7YyJFzvTYknq9Ow7K8eU7PKXUtaqhNvsYAIoFhEPqCdBsNVY27G/QV8XGHtiyYe8wYFdC7a8M1qlV/Z6L/o9o3DJ85nFO4WciylN2I3DDBHLqgVbpDyxjDUiC/BwDimZ5tD9KZmCmoHI2+h6eLg==
X-YMail-OSG: CeM7uyAVM1mrWI0yJXpn8.8anbMJXiGrqbQZv57q7nxaawTnErge.saPmwLTBln
 QA4QzDAjHaLVPIZQjulOFI7rv3s0j2q1_APxUu.tpqi3_IkOI3FXfp3yUUad4MIOXPx6yrZ7zJH_
 8u5T65UaTK54QfDoA112pUffJgjANBdT5Grd25wA58.mJ8kmm8q.leBsGYiSP4C37y42MqHNfZ8T
 0.joxRy2ZytiMRhHE4rGRDIMvGK70Wyz3enzsT672S_1hN79xWbLkIYd82YAB.BzwNzfnUxL2DsQ
 lcs2nUVxvbwOfrzWv6Kz_8XCeYy2Spd1WJOLaZVzcCCfc02s_lRNiMWzCpGbtjmnDv_zxsWGHVZg
 NH6HJDnvIbpTBJsoXRXOO3q9vhuFhYOCn904n1z7h5hBEKSt6ZTat616qey2D0BidogK9nCPfcgR
 cCTC9a2QEjJK48MztFAENXxRWCl1OkEZFA_vYegBqdfAz8CZOOhUFYHQeQO4bdSCceB8kzRyrb1Q
 dUglhNJZtExVKZmBcjYGZdmz4HIuYrbRL6W0RzYY4plZ_0_9i04fycwVj4cGrZpCXtdEiofEQEso
 BES3D_48_2smPaDAEMOiQ7dqjD2P_o.sYxf0nYerUdJPgv4naiv0fGc5d.G8CuQARBw61k806mP.
 yJoYpiQ.0hECS3_MBTqH9Qw9eUrLM22Ahy5sHSYzjWWymA5inC5Qr935zsl9ob2sI9S0COcY9raT
 v_7RxJs8A28l8QANZF5Jduf0x1kfCBlUsFywwAHpWdqBox_hFDShISdUFTU6dXuQ15TVXOHUdtLm
 uOR8NZp4YGavn1xhIu6_ZamsUy5PPW3UkwY3h2vIEwX73AdoQsvIiIHwI.baWoBBJfvYd5y2DBlx
 E6kH74.0LsqVHkBvkvE_TUqcsemHUd.3M5nWJXKIsXRZFJVDeHrp9zZ19x_8tQueZqemRTA3iLid
 QcTp7s7jcA48D5JY33ee.2RMdAPcrFb8rY9oL59J2CCuU4PY1Oov3H3COHylnGCbMlYaX76_7UMW
 wccwaX7E_rL8ikENI7KlhIaEDAW8atp8Yx.RsX_kQzm5U9ktfZuJ2TQb5i.O7RACwu_qZSMtk4aG
 wqC3MWBsYV9dow.g5qAh.ltnMK.MOYAq6vjWCEAABlJ.RUiZBWiW2rcS8hNifnb0sS2TUY7mp9vG
 lMAMIwp08xgKWitzkMHPetuDe4YBR..5b3XyNjIi3Q1xq_bBHuohnFwAB_FYnlVzUhPb_IV491zv
 AAkAuGAj0uv01TS5du20CuXS7D81Tu6V7eI8PlfTtoTfIRRhhBIVyBFZQVOzU2at4iO4YQLW85ER
 Xcy8vLmD3krXz7KHe2C5oVabsCbniHnNVpDcasPUzjkr1En9sTGPoQhofqGg4LcdkNQ66XXYZ..C
 xVvBv74p75gUrnEjANHBi5sDX2mJpOP1lVjauta44pK4-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Sun, 27 Sep 2020 23:01:39 +0000
Date:   Sun, 27 Sep 2020 23:01:35 +0000 (UTC)
From:   Ms Theresa Heidi <heidiali81@gmail.com>
Reply-To: mstheresaaheidi@yahoo.com
Message-ID: <1956075593.1375628.1601247695468@mail.yahoo.com>
Subject: =?UTF-8?B?5Yy76Zmi55qE57Sn5oCl5biu5Yqp77yB?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1956075593.1375628.1601247695468.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Beloved One,=20

 CHARITY DONATION Please read carefully, I know it is true that this letter=
 may come to you as a surprise. nevertheless,i humbly ask you to give me yo=
ur attention and hear me, i am writing this mail to you with heavy sorrow i=
n my heart,i have chose to reach you through Internet because it still rema=
ins the fastest medium of communication after going through your profile.

My name is Mrs Theresa Heidi i am native France currently hospitalized in a=
 private hospital here in Israel as a result of lungs cancer I am 62 years =
old and I was diagnosed of lungs cancer for about 4 years ago, immediately =
after the death of my husband, who has left me everything he worked for. I'=
m with my laptop in a hospital here in where I have been undergoing treatme=
nt for cancer of the lungs

Now that is clear that I=E2=80=99m approaching the last-days of my life and=
 i don't even need the money again for any thing and because my doctor told=
 me that i would not last for the period of one year due to Lungs cancer pr=
oblem.I have some funds inherited from my late husband, the sum of $15 Mill=
ion United State Dollars ( US$15,000,000,00 ),This money is still with the =
foreign bank and the management just wrote me as the true owner to come for=
ward to receive the money for keeping it so long or rather issue a letter o=
f authorization to somebody to receive it on my behalf since I can't come o=
ver because of my illness or they may get it confiscated.

I need you to help me withdraw this money from the foreign bank then use th=
e funds for Charity works/assistance to less privileged people in the socie=
ty.It is my last wish to see that this money is invested to any organizatio=
n of your choice.

I decided to contact you if you may be willing and interested to handle the=
se trust funds in good faith before anything happens to me.This is not a st=
olen money and there are no dangers involved, is 100% risk free with full l=
egal proof.

I want you to take 45 percent of the total money for your personal use whil=
e 55% of the money will go to charity. I will appreciate your utmost confid=
entiality and trust in this matter to accomplish my heart desire, as I don'=
t want anything that will jeopardize my last wish.
       =20
Yours Beloved Sister.
Mrs Theresa Heidi
