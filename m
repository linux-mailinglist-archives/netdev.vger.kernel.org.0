Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CAD11474B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 19:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbfLEStO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 13:49:14 -0500
Received: from sonic303-3.consmr.mail.bf2.yahoo.com ([74.6.131.42]:42959 "EHLO
        sonic303-3.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726589AbfLEStO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 13:49:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1575571753; bh=6u3qDl6yXWBH9oVBF6VmNFaXPPfmaUEmS0LDo6+oXlw=; h=Date:From:Reply-To:Subject:From:Subject; b=XdUCqmRieTLF6RsuEUqOqM+7QGEyrra0xYU7zvbz5lm+PPMBcoXCw/xGrw1soEZfnCimvD9zP6wWm0lf4ZsHD/QzU3qaNaJThsijIbVyj1/c/a4tdasUKmGh5tr9shXrOm9AIOhH03nwmP7uxZX9/1H7yTG6hdqXRosXY/CK1qm/mqAOaTdZgRCm6u5pilgDUC9BCgMEj1ssRkt+aWcw4Uo9mgDVL8qDP93uDCKGO1sslM56Q5zm7oyeV6yTzrYaXeBIRDouJTYuG9UosrvK5yB0FqgaWjIIbXrFzclL/z+ZMVJGF9jHQm1oBwrN/yumsEsrAZstA+MyddEPn4e0tA==
X-YMail-OSG: XZd6IRwVM1m8_PJ52Xnz3gzG9m9a2aGUWpIDsI3RyKsJrsD84PCVaml4dEfwHb2
 Hfed9cfYb0d63XfUzy2RnBcjMqxAWbNudnjEegl7DNYgE5JcLfSpA2FDGyk.elnIggfHkyNf4WAo
 GBovNvahJi9s63BcU0BOvwr0Vx3sFkoNjn_PypbhUSmBTW11m0HghJhGwfqpxg0__oK9Z9Ku60UT
 Y_l1zprxO8vSKkUSs79FAXWdeIT.9rVikpdhy8DUeYgHFzr.ffycaYOfZOj.DtXB1Oc_t8Jqpws5
 dXDJdUybNPA.dL.RtbqzE_Mr2EWQytWxa.8i2AyJPB1kcLnIDsDg37eLSMfs72.IqkjJ8f.9QltQ
 MRLWTSI2EcdnaiwbJTkeJcrU66ZZiqghEMzG4U9j4OWuLg5FArOAPx8rqdFcKN.7OY9Atrh2Klpx
 hcR3xd4bZekG4hOsP1a9Mn0mouTX9G0UBYCGz.AtNB0_zItzfQD3RVUktQUR.pNGAl1ULnuQzPKy
 NQ9elYO3x3nKe3aQ6sHUbZHIED0H0E7fOKPIKq8nojF.hny5lQJY1HEAhg12w17Xqw0mr0vhO28u
 UTQVvDsBueefcg7LLYaR0z.aX0QwnrET2N_xznUqtCtiFzS7WkyDVswUBmpiv2i16lTKGgOcBpgv
 f_w2fELu23lnd.0LWabWhJFksuZKfrYcXQuVV6KWQoJ5FNfWYwbhiBa8UJk7mM5EdwlZ3FFDvB5Z
 tnG.RGxSzYUarPNKCL4xbcRHqdGRGAfy2dc9VilWy7..AbUS_kKRqYngh8oxqqAH6tMwBrVE6bpc
 v1mPS2n1HAsBhHnhsCMmz7hjcgQEqYA0wIkjFzaY8ZAcUrQRJnsL_C5zfOzulXZ5f7CmCE78jDpx
 _8JvnBYIRt0L3_pcX6gStuTa_Uy3PGZC2qmh5824TKN9mPTA0UJWKMjyrlE84OxvnZ38IqoLVnCq
 HjtQd1x4AVQTrb45OBzM78ZDvW_vSJ_Gtr7GXUFJOFnUsjV.Duj9djsohW2mEYB1oJqfYhGt4afe
 zzECDBC.kGcKiKMgyU9nzu7eC_.O_0JLa80HOBFJTsdFrKOoVeZukJHzKLN29MHI2sG71KNDl1zv
 c7PDvGq3Fl79xWSCpLv0UvphaKx.Mw8LDHagMBL.kshOQGmJ1z3bYn3I.oPSle1OJAXhfgZOpOKz
 xeR5tqOi41K75ACGxtTIq9APVFpzZ2jGsxxpgNupkVNQ1gUOLmYh89SQccA.ig_ePk0rMBYDgfbH
 Kn7Z8iEHS.Nmsq.9iE4ayQvfS6ynu8vo5QVrIhxw0wuoB1u70BcwUas_IXxjDKog2tuBWCc5ImAF
 tUcTjAowppE7dmA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Thu, 5 Dec 2019 18:49:13 +0000
Date:   Thu, 5 Dec 2019 18:49:09 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh222@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <455615886.6183617.1575571749805@mail.yahoo.com>
Subject: I NEED YOUR HELP FOR THIS TRANSFER.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dear Friend,

I am Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment and the amount is (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me after success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other .

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa Hugh
