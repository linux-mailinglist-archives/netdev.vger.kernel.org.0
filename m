Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6032D23AF79
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 23:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgHCVKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 17:10:15 -0400
Received: from sonic314-20.consmr.mail.ir2.yahoo.com ([77.238.177.146]:33997
        "EHLO sonic314-20.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728400AbgHCVKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 17:10:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1596489013; bh=4GgFxXkhC86dj48BmrELV5zlxicqlhhIXyZgiwEolDI=; h=Date:From:Reply-To:Subject:References:From:Subject; b=hGjgq1AMnFKUNJmvA+Amkr//cQqzWElA++Np18Kdail0Z6OOrdpL4XPNC3qlouCpWcMo3NGZHISaGnrkwO1D3Z6rQY8NioGPnKUYlaUoG/AI6bjqBjwjiNesfNp7ry0OacnP4XL+kO91GxuPK5gATwVqtAWVb4iqm0xiGva+z2Z5THyYtz0KvhcIRYbCse2HCgpACrmhtWHTohO8LvA7HXK3YCB8noT4nBTkuA0yW04Wt6xkam7opDR51YQQkuUqANeTtpsMrsyh3WOtmAUivQeeuzZThN2SfO0k46HiAOePIE/B9PdSkQ8yy+At0paxyLEaO/43A54SA7dFpmvdpg==
X-YMail-OSG: ZjXOTFUVM1lYDrMD70zhLoSGHcZauZ_QRpaS4OxR3Iy8sl0E8Iec.ApiFrm7Di6
 _YB6l1NjYVyPVwZ78wyrG2zXiFSfg0e4zhZp4mHpLl977HCNEUR8k5Egf360oNQvsVI12GmSEOyu
 YZJK4tcAeebUwjF8lZl19nhxqsWOJommZKLsVLwq3n5jCnPruwtKaSoLQrYSfVNZd0xZEmAvlgjb
 lgTOYoM6i2VohEQEv_xQDEzRAb7bNGVJx5pi6BR9U4sD_q7SvXEzYclztCmGbJ5lzn5bQ7A7bMoH
 VQbYm4xUYSimuIwe1cJ2CEVz_TQPi6oGX70Lo4IE6dcb6fGEBHXHn2Y1P1st_5kPgDIoB04tFmFx
 xCJATvOpfcoAve9vyovgC7JKJftQvPEUajNneyEFoA9.hf3SpgxaUtC72agYBgMfREpcerRl6SV3
 MqhbljfxAf1.MiOAVxQiiALh9hSNrXw8s.d69TG9nhnFIa9iHJvy3dNakspBsQEjwqx7R6ZTHUm4
 I0BHLStthn.MsKSvcG_ZLNRA_RHDENGOSZocWKWf2AUbbOQx8pAjSggmsDUw9QYx7pugZqG8RUXn
 01rXQSqf5GNp4FNm0DbrXU4TMA7mpLeN8n73NKU0EMxJVCPr78cFXDDWMDbOP9ljp7Ysa141T4N_
 SLQuylEiYMwqvYK_IcWVbRrny9PUJeWpeDnzwlK9HDyZorbnpxiFiGmYMYG6OeMoG79ReoJIkO_H
 oL8yxC837BdztvgkOZW3wiCbNtJF2YQTPmhRRrDE0nATvVkaFk__c.yQcyJYz_OI9M0BbtqQQDRi
 mfqnwyj98ME2YETAQ8eTMwhLr4OijtNn98I0YfbZH4trt_u.PGOY8_3PQ6SK_wwz7G9A3vB5m7hb
 UXmxd2rk_eWm861XH2IskHKOr942NZqkYuxV3RoSStCUGrLBBKisbXlqc41ceypT.ymeOvtsW4__
 GB0OA8PDX0lBMKZgzSxnTExpYHn6Og7wQn8wYCcUw4Ux3xRIIP1uZfOKPizKmPi5oDrOJoY5OKAK
 dcA5vB6Rx54dU9hvc9PDpMkquITKdiQHb6uqyni5Oc1Gsepez.UEPNkDtEPlSv7GiuXEhWcTtYoT
 cjOgerl98O5vyz70Brs5vf26MtUqcKPzCd64PRiU.RdA23bSQXTuV0HE_0d8mN6PuSU_P_cTP9bD
 Z8aTf.nG.ouLwiHa.J6Xqiogt8cku5NcBjWEukeunLAA8V2mgykn2SD47HHdrcN.QWJ7szwqzGaH
 tfW0ISmMKrmNPLG2vq5Yaxa8O
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ir2.yahoo.com with HTTP; Mon, 3 Aug 2020 21:10:13 +0000
Date:   Mon, 3 Aug 2020 21:10:10 +0000 (UTC)
From:   Zeena Hamad <zeena.hamad121@aol.com>
Reply-To: zeenahamad@aol.com
Message-ID: <713931143.16757734.1596489010375@mail.yahoo.com>
Subject: Hello Dear.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <713931143.16757734.1596489010375.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,

How are you today, I hope you are doing great. It is my great pleasure
to contact you and i hope you don't mind, I was just surfing through
the Internet search when I found your email address, I want to make a
new and special friend, I hope you don't mind.

My name is Zeena Hamad, I am from the South Sudan but presently
I live in a mission house in Burkina Faso and I will give you pictures
and details of me as soon as I hear from you.

Bye

Zeena Hamad
