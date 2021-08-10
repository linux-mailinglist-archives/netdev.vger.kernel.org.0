Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590593E8447
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhHJU0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:26:18 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:59678 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhHJU0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 16:26:16 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2021 16:26:15 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 76A1720CBC74
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
To:     <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH] MAINTAINERS: switch to my OMP email for Renesas Ethernet
 drivers
Organization: Open Mobile Platform
Message-ID: <9c212711-a0d7-39cd-7840-ff7abf938da1@omp.ru>
Date:   Tue, 10 Aug 2021 23:17:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm still going to continue looking after the Renesas Ethernet drivers and
device tree bindings. Now my new employer, Open Mobile Platform (OMP), will
pay for all my upstream work. Let's switch to my OMP email for the reviews.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: net/MAINTAINERS
===================================================================
--- net.orig/MAINTAINERS
+++ net/MAINTAINERS
@@ -15803,7 +15803,7 @@ F:	Documentation/devicetree/bindings/i2c
 F:	drivers/i2c/busses/i2c-emev2.c
 
 RENESAS ETHERNET DRIVERS
-R:	Sergei Shtylyov <sergei.shtylyov@gmail.com>
+R:	Sergey Shtylyov <s.shtylyov@omp.ru>
 L:	netdev@vger.kernel.org
 L:	linux-renesas-soc@vger.kernel.org
 F:	Documentation/devicetree/bindings/net/renesas,*.yaml
