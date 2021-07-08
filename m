Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35653BF64A
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhGHHfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:35:36 -0400
Received: from smtp-34-i2.italiaonline.it ([213.209.12.34]:55603 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229842AbhGHHff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 03:35:35 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2021 03:35:34 EDT
Received: from oxapps-11-062.iol.local ([10.101.8.72])
        by smtp-34.iol.local with ESMTPA
        id 1OOpmO9WMLCum1OOpmcB8O; Thu, 08 Jul 2021 09:24:44 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1625729084; bh=ZFcvfYIu04Jwk1y4dAI4qU91JWbmprdVROAPFA3RXWc=;
        h=From;
        b=C33kLZ1+HYZH+/R5yvH7LKvjTfTKfgR8RAYMZfvuD8k646ZgEurp2uW26AMssQPjI
         5E190UzuZED8k8ryFx1Pf+tR3qEabAGTMv/En+PzynC1vYpTyO74wFMMtHgScW+Sfj
         R8JW2s2ZqRhphg348n1uMc3H+zeWgYU7kYUThl4tUIM92ngZMS412fcJEyM5nst+3B
         RUjT8gN744QiBujwWYE+WZX79atRp3sl9HZpJ3/0S6guVkReWFkjqVSDcHLm2a/G/Y
         xoSD5rNGdHGKY9b+4GxOZu7QTUJSPfcshpboD0lLKFumEf7RPQ8+z1REP3JrFlZS68
         GM5ACjtmy54Lg==
X-CNFS-Analysis: v=2.4 cv=a8D1SWeF c=1 sm=1 tr=0 ts=60e6a83c cx=a_exe
 a=ArCppHiS2LX9rvfu7+HyXQ==:117 a=C-c6dMTymFoA:10 a=IkcTkHD0fZMA:10
 a=vesc6bHxzc4A:10 a=J1Y8HTJGAAAA:8 a=NRFWTJTpNJUI3RitD60A:9 a=QEXdDO2ut3YA:10
 a=y1Q9-5lHfBjTkpIzbSAN:22
Date:   Thu, 8 Jul 2021 09:24:43 +0200 (CEST)
From:   dariobin@libero.it
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, jonathan.lemon@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org
Message-ID: <48220229.92708.1625729083880@mail1.libero.it>
In-Reply-To: <20210708.001404.122934424143086559.davem@davemloft.net>
References: <20210708050849.11959-1-dariobin@libero.it>
 <20210708.001404.122934424143086559.davem@davemloft.net>
Subject: Re: [PATCH] ptp: fix PTP PPS source's lookup cookie set
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev34
X-Originating-IP: 185.33.57.41
X-Originating-Client: open-xchange-appsuite
x-libjamsun: 3PyYk19zG1o8mnI2s2jZE59u2Tz78qKN
x-libjamv: DavxN2eeZiI=
X-CMAE-Envelope: MS4xfFCSJpA/OjFfBSSRErxdbTy+ce/E1c56GUHbCXQanXQOj0xvzrKIfkeubhPvW1Cj9OqhN6Wgro42DVt77NMDAJWbGw5p/svNATW8J9Z6K9VA0h+0vef7
 3G/zfkLv4vJLqLsnMZfpbvp3bZDCtz6IhryfDkLDFS0RGbFExP2l6wVlfvDd8iND91A8f+3NpP9BJVF7UGj1WMvcbdXtVKnBleNcFF8tPZB733+GaYMv2PAS
 NHkqmrUhbCALPh3keEPPo6dhZop+KVFMq8tL9xr9wj4u8hoKTy8iJLXAs8qm3L+V9PcHtsktxC572SrelGWoUIG5ThJybzrsXT4EkRI52ROFEt/qBsTQHvyL
 coOdS5eR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> Il 08/07/2021 09:14 David Miller <davem@davemloft.net> ha scritto:
> 
>  
> this pastch does not apply to the current net tree, that is why I keep marking it "Not Applicable"
> in patchwork.

I applied and tested the patch this morning on the mainline kernel. What am I missing?
Should I wait for the merge windows to end?

Thanks and regards,
Dario
