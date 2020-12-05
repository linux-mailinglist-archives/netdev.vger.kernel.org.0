Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A322CFD71
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgLESdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgLES2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 13:28:11 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F45AC02B8F4;
        Sat,  5 Dec 2020 07:28:21 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id v143so8463721qkb.2;
        Sat, 05 Dec 2020 07:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p27tFArilkZQWJdOTlf5pr+2+ufCtLUXxx/1mCNOCZE=;
        b=hDqspYp+RpmFlHKhRJ0iKCqouC3FQC8x9de7IcsA6Xzh9PLeAhRZAFLvfRSGWOrGLL
         1YBstsLwavL2oX40C1X5WbhiYx04K4eKvhyZl47O63+8T8cML3jxc1BrkESokJmns4EV
         RSgoanu3FYwdBF2XgjWRtqTItVKAdccf5T6h38Bw7Q8l9PM5eyfxylMFBuRBHezxG3k/
         rsRJPAOC+ZGEeRzs98WPKYOIbkqFT4YWi+asOrtBSUPg6+018MTB1LjiU+iI5zCqHbSb
         RyZ0IsgN7szcIdBeu//tv3yCus/wniSC2WtAZflhqjPdhcwqZkE2qtySFDNzw2Y8M/Tm
         XGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p27tFArilkZQWJdOTlf5pr+2+ufCtLUXxx/1mCNOCZE=;
        b=mnxnZkiCoyv80KOszGr26r2suIOLqIFKIObi7B0SyuugCBCnYJaRrgUaANQG5XsLeU
         Vf9/wE2NvgwLhous93iPFYizw/Vw40O5FtuMb+DeQDLDCx04TagKEMr7Gm1bb31twJtG
         Dt8Hk9XntV4R+OoTXRYZggGAw18kYEGP4J5EVOuZB2QYLK/1p3B39nH4n0N0UEmMaYz3
         7JQM1+Zac2O5aUsd81MsTf9oPTOuENeKLq5txyfHETeA1dzhY/yAiqo3aqF1Trmckeqo
         rOHJ31qODsHPH77xghH+PL7fZRY+QkhB+xrjldkoV0BBYtn3ZQ0gS5/E9iIBNqTQQdwf
         +32g==
X-Gm-Message-State: AOAM532Gg02GY4j/SA1lxlsTktPfOUjCcNwpMzyIfp3OcjiMahzPTsPu
        LYlRoMSUBv2+oI0Z4Q+eJts=
X-Google-Smtp-Source: ABdhPJyS3Aw08iF/Hfmw/pps+0TGaXcOHPxy9f3DhL1XFmpMOenttZapYx0Ys2zJtivOkU0WM+sd5Q==
X-Received: by 2002:a37:9f4a:: with SMTP id i71mr1841817qke.480.1607182100064;
        Sat, 05 Dec 2020 07:28:20 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id o16sm9008554qkg.27.2020.12.05.07.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 07:28:19 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v1 2/2] net: dsa: microchip: improve port count comments
Date:   Sat,  5 Dec 2020 10:28:14 -0500
Message-Id: <20201205152814.7867-2-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201205152814.7867-1-TheSven73@gmail.com>
References: <20201205152814.7867-1-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Port counts in microchip dsa drivers can be quite confusing:
on the ksz8795, ksz_chip_data->port_cnt excludes the cpu port,
yet on the ksz9477, it includes the cpu port.

Add comments to document this situation explicitly.

Fixes: 912aae27c6af ("net: dsa: microchip: really look for phy-mode in port nodes")
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 905b2032fa42

To: Woojung Huh <woojung.huh@microchip.com>
To: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
To: Andrew Lunn <andrew@lunn.ch>
To: Vivien Didelot <vivien.didelot@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
To: Vladimir Oltean <olteanv@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Helmut Grohne <helmut.grohne@intenta.de>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/dsa/microchip/ksz8795.c | 12 +++++++++---
 drivers/net/dsa/microchip/ksz9477.c | 16 ++++++++++++----
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index f5779e152377..99183347053f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1190,7 +1190,9 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 4,		/* total physical port count */
+		.port_cnt = 4,		/* total physical port count, excluding
+					 * the cpu port
+					 */
 	},
 	{
 		.chip_id = 0x8794,
@@ -1199,7 +1201,9 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 3,		/* total physical port count */
+		.port_cnt = 3,		/* total physical port count, excluding
+					 * the cpu port
+					 */
 	},
 	{
 		.chip_id = 0x8765,
@@ -1208,7 +1212,9 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 4,		/* total physical port count */
+		.port_cnt = 4,		/* total physical port count, excluding
+					 * the cpu port
+					 */
 	},
 };
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 2f5506ac7d19..e56122ffd495 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1482,7 +1482,9 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
-		.port_cnt = 7,		/* total physical port count */
+		.port_cnt = 7,		/* total physical port count, including
+					 * the cpu port
+					 */
 		.phy_errata_9477 = true,
 	},
 	{
@@ -1492,7 +1494,9 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
-		.port_cnt = 7,		/* total physical port count */
+		.port_cnt = 7,		/* total physical port count, including
+					 * the cpu port
+					 */
 		.phy_errata_9477 = true,
 	},
 	{
@@ -1502,7 +1506,9 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
-		.port_cnt = 3,		/* total port count */
+		.port_cnt = 3,		/* total physical port count, including
+					 * the cpu port
+					 */
 	},
 	{
 		.chip_id = 0x00956700,
@@ -1511,7 +1517,9 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
-		.port_cnt = 7,		/* total physical port count */
+		.port_cnt = 7,		/* total physical port count, including
+					 * the cpu port
+					 */
 	},
 };
 
-- 
2.17.1

