Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAAA223C11
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 15:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgGQNOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 09:14:05 -0400
Received: from sonic316-11.consmr.mail.bf2.yahoo.com ([74.6.130.121]:33625
        "EHLO sonic316-11.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbgGQNOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 09:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594991641; bh=CJfHRA3PAxA/lp6Mz2SeiBBl59bd5y646SzWk6cUNN4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=UuDdktdOSEl01DI/lgYB2Y1CoZrtncM2++2POgLGDR3nmDX6xNwTUekjNSk9Yc/qAIIQEF/PfcUya/l+wFYGuDDP9deKj+JFBJhqFQg7QcbatQXnJ3dPZHijAHNixFdiT/sPVyEwbv8ei10/hGdlSGT82GIQLJSr7YIUTXySEhqOyf2hzmE006O1ck4nAjQE7YZ2MKcOv1++EeMAhPJbG8z89WuZFg6IInx7CfVj1V0RZzZ5xEXBH9wxH7tLrlGQ8mRVblzyzfj6vxa48rfiFExLYf8WX2R/uOYQRpjIGEUqSbZIUZ10Q0z7YVYEEetuQ7Emi8peQXq7MfAgqDu2vQ==
X-YMail-OSG: _RFP5V4VM1kHhR8dIpoaqxgw3auKJ2PYZk0PDlWAg7GKn.7cUEtbS9yzlApKRLS
 W2W3tYLvUKRjH7wkaGrIQIz.KbUGki9BHoBka2lBcgZb0roX9SwAl0MP7tz_Jimia3nqLxCEo0Xz
 mh0xm5GlN9lo9Qxu896l91mXDnuunXB3ui.tSGfRoCCku2lg4ImjoX1A4S4iwJtF98Aq0VP0kW.1
 y5fJBktHgw_sSEqm3_cKHCDvOakxeR5JjuyuMayh90f78q8slJ0RuP5c1FjE72Z3hBFhia0Nuuf3
 yJh.d4ZyOyBFRqF_J7NGrmfW.Tkiv6K7Ytys25mr9KvSzx8l1nSOhbAEf7glyziI4YkvWwxH1yIZ
 G9bYJvbZix8W_2kOwetbpfCvE04DstVcFiTtO_DijDvFplj3qZuKR19Avx4nH0v.GgIoPGPwRrX_
 hQdOyF3WtSHQWqIGPuo4XI11v5.mZmguX6zrFymmKhO4sODam0x3ygg0PwFu0IZ4FBkgVhuDjKt_
 4CuGaF5GZdLwd04NpoeJgq3ZiWBNsTmrBMxMHOM05bSn4TrCgDRsMcXNa0fOLpCXjl6NO6cmGrVO
 IUqKpzqqqNneQmvw.1z0m18AZZH3L5279GuO0f6f8eQDHG8.GYsF.R2oKhqG9.qLeunEtcYjJbb7
 x2kudVVPkA1lcI8q3F4XiOgWv4waXJoqpGu0gahSI1ChbAQBcIi_RPVGnfIrLOMDsVnbrb5Bpc4s
 FBSA1nkCxxcUQTjGJOLuaVa3RG8_iRkPoISr6uRAn0c7idLq10qX4q2lEMd.JdaEtR2QHw7HE_7S
 5SwxmsikL4rZxcc5cRitdBJH2HfezasDDC.4k_Uo2TvWg.7qAjab0NxRcJ0y61qQjU5QJk8f9_Zg
 8nMznkONGDGIfXvZ4EjgGo1fce3eFP.lYIwXWlZRIlQwC4R_VssbSSJ.DLAapwxo49.AukPcT_yB
 I_DruiMOVIuqumZagT2lc.DFbQiKTVSpoyM4IdImaHGu8rdSazjtozmeyasi6LkZxAdF2xI5Sibc
 S5qGato0f5o4yukCNxqA7Y87q2K4OqUpGBVB.HwZ01LXkHRJb0JtkW95oydXAvCnVaUbwekh4FXw
 _PrZZoh2QJNYzIOcRuAT.ZfAO3J0B.Y2MdPH7h1PoE8P1AJyntJV7jzMpdygtszeSeXpCTwsISV7
 EeAqiDi34D2rwJEBWf0bBqViaGXdRAapL5bUq.NRRgUTCxJcqFne0AYh6TML9KHRZbv9jqS1AZzG
 2q8ETagqaxFIPFeEwxeuu6tEq7YEjbbe3ZoRhiMhULv_WrH1QTGG2uUmzW8eZoWXzwLrIfUvwYA-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Fri, 17 Jul 2020 13:14:01 +0000
Date:   Fri, 17 Jul 2020 13:13:56 +0000 (UTC)
From:   Tapsoba Ahmed <chikabarnabas@gmail.com>
Reply-To: tapsobaahmed100@gmail.com
Message-ID: <1303070556.2201669.1594991636979@mail.yahoo.com>
Subject: I NEED YOUR URGENT RESPOND PLEASE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1303070556.2201669.1594991636979.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear Friend,

My name is Mr.Tapsoba Ahmed. I have decided to seek a confidential co-operation  with you in the execution of the deal described here-under for our both  mutual benefit and I hope you will keep it a top secret because of the nature  of the transaction, During the course of our bank year auditing, I discovered  an unclaimed/abandoned fund, sum total of {US$19.3 Million United State  Dollars} in the bank account that belongs to a Saudi Arabia businessman Who unfortunately lost his life and entire family in a Motor Accident.

Now our bank has been waiting for any of the relatives to come-up for the claim but nobody has done that. I personally has been unsuccessful in locating any of the relatives, now, I sincerely seek your consent to present you as the next of kin / Will Beneficiary to the deceased so that the proceeds of this account valued at {US$19.3 Million United State Dollars} can be paid to you, which we will share in these percentages ratio, 60% to me and 40% to you. All I request is your utmost sincere co-operation; trust and maximum confidentiality to achieve this project successfully. I have carefully mapped out the moralities for execution of this transaction under a legitimate arrangement to protect you from any breach of the law both in your country and here in Burkina Faso when the fund is being transferred to your bank account.

I will have to provide all the relevant document that will be requested to indicate that you are the rightful beneficiary of this legacy and our bank will release the fund to you without any further delay, upon your consideration and acceptance of this offer, please send me the following information as stated below so we can proceed and get this fund transferred to your designated bank account immediately.

-Your Full Name:
-Your Contact Address:
-Your direct Mobile telephone Number:
-Your Date of Birth:
-Your occupation:

I await your swift response and re-assurance.

Best regards,
Mr.Tapsoba Ahmed.

