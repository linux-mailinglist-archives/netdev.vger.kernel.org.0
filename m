Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768B72CA7C9
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392084AbgLAQJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:09:41 -0500
Received: from mailout01.rmx.de ([94.199.90.91]:56587 "EHLO mailout01.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388182AbgLAQJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 11:09:40 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout01.rmx.de (Postfix) with ESMTPS id 4Cln8l19Ymz2SVQq;
        Tue,  1 Dec 2020 17:08:55 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Cln7B2648z2xc4;
        Tue,  1 Dec 2020 17:07:34 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 1 Dec
 2020 17:06:55 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 1/9] net: dsa: microchip: rename ksz9477.c to ksz9477_main.c
Date:   Tue, 1 Dec 2020 17:06:03 +0100
Message-ID: <20201201160611.22129-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201160611.22129-1-ceggers@arri.de>
References: <20201201160611.22129-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20201201-170740-4Cln7B2648z2xc4-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP functionality will be built into a separate source file
(ksz9477_ptp.c).

Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/Makefile                      | 1 +
 drivers/net/dsa/microchip/{ksz9477.c => ksz9477_main.c} | 0
 2 files changed, 1 insertion(+)
 rename drivers/net/dsa/microchip/{ksz9477.c => ksz9477_main.c} (100%)

diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 929caa81e782..c5cc1d5dea06 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_common.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477)		+= ksz9477.o
+ksz9477-objs := ksz9477_main.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477_main.c
similarity index 100%
rename from drivers/net/dsa/microchip/ksz9477.c
rename to drivers/net/dsa/microchip/ksz9477_main.c
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

