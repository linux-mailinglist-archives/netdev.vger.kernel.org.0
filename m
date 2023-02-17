Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E92F69A99B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjBQLCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjBQLCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:02:24 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A095E62439;
        Fri, 17 Feb 2023 03:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676631742; x=1708167742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F2mURk/fbobB4rI6EopNkBH1Wbw2zILKSpSvtFfxyOs=;
  b=eQNrVXFDEmZzuAZDqlRVBTjeGoRydN9SESgFhTA4pQ9PUpAOAeuxXc1B
   kZUtuaahjaGYvQATNYZOvO7gFqwNFJsmBSyh0KDGdxO1CvFkOwxXAeNOv
   ylZPs1AbZOHGv04ZnH8us0rVMhGVboPYvsTNBRGpxLdeeEvObaI+9c0mV
   5NTtv6R0QOp4Z1lLdcoe6ZkpweKpYAg76RxK4gD1JxiCFqzJIMkt63Mim
   Kh4z27MoxPhO+QxIARXFwFiyOgNXBckNZzpW+G4YaSrbUx67QTMik84oz
   INmU2O+o0CUjlmbZHERgjBokzEXqEXmLtg0jC0Xq/LbWoVXOZSCotp6mH
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669100400"; 
   d="scan'208";a="201101424"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 04:02:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 04:02:20 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 04:02:17 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH v2 net-next 5/5] net: dsa: microchip: remove num_alus_variable
Date:   Fri, 17 Feb 2023 16:32:11 +0530
Message-ID: <20230217110211.433505-6-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    Remove num_alus variable from ksz_chip_data structure since
    it is unused now.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 16 ----------------
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 01adcbeffaaa..152f68eda355 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1095,7 +1095,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8563_CHIP_ID,
 		.dev_name = "KSZ8563",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
@@ -1124,7 +1123,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8795_CHIP_ID,
 		.dev_name = "KSZ8795",
 		.num_vlans = 4096,
-		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
@@ -1163,7 +1161,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8794_CHIP_ID,
 		.dev_name = "KSZ8794",
 		.num_vlans = 4096,
-		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
@@ -1188,7 +1185,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8765_CHIP_ID,
 		.dev_name = "KSZ8765",
 		.num_vlans = 4096,
-		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
@@ -1213,7 +1209,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8830_CHIP_ID,
 		.dev_name = "KSZ8863/KSZ8873",
 		.num_vlans = 16,
-		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x4,	/* can be configured as cpu port */
 		.port_cnt = 3,
@@ -1234,7 +1229,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9477_CHIP_ID,
 		.dev_name = "KSZ9477",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
@@ -1268,7 +1262,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9896_CHIP_ID,
 		.dev_name = "KSZ9896",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x3F,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
@@ -1301,7 +1294,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9897_CHIP_ID,
 		.dev_name = "KSZ9897",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
@@ -1332,7 +1324,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9893_CHIP_ID,
 		.dev_name = "KSZ9893",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
@@ -1358,7 +1349,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9563_CHIP_ID,
 		.dev_name = "KSZ9563",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
@@ -1385,7 +1375,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9567_CHIP_ID,
 		.dev_name = "KSZ9567",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
@@ -1417,7 +1406,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9370_CHIP_ID,
 		.dev_name = "LAN9370",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
@@ -1443,7 +1431,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9371_CHIP_ID,
 		.dev_name = "LAN9371",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
@@ -1469,7 +1456,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9372_CHIP_ID,
 		.dev_name = "LAN9372",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
@@ -1499,7 +1485,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9373_CHIP_ID,
 		.dev_name = "LAN9373",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x38,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
@@ -1529,7 +1514,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9374_CHIP_ID,
 		.dev_name = "LAN9374",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8a71e035b699..40c4f5f2d9d5 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -44,7 +44,6 @@ struct ksz_chip_data {
 	u32 chip_id;
 	const char *dev_name;
 	int num_vlans;
-	int num_alus;
 	int num_statics;
 	int cpu_ports;
 	int port_cnt;
-- 
2.34.1

