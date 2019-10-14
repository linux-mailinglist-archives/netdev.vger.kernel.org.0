Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9B8D6724
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 18:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388035AbfJNQVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 12:21:32 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44531 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729889AbfJNQVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 12:21:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id q15so8215039pll.11;
        Mon, 14 Oct 2019 09:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=XJ1DbTHwQkp6rz8764Ynj3HtGD3CNAlvqeCKZgSoVQ0=;
        b=YkE2NEEBQSwXfOv2XRFZzx4Ygv0E1pGi5Y6ukpAcSKn+qrh0g4f2XtsI+WdBGG5JnL
         gr9b72YQ9fTyqnPmL02ubAP8MG6rJxIddzgn9tuwa8ftCJfjqYyHqFa/ZsSBxv4UUmP4
         p3IczoTvhsJIJulLzvUhvzchfD7krk4kcL1Q6AuMJSLsCQpN9cLC/F0z1ki47CGkSqGU
         lFOwqdkq9QuPgAF6ouQpYKjeg43AEc80IuUraZ7HJZ00exki8/fVGfWs6gQUI9yKtO8C
         Ziu5b0JDSkUxZHBfOmLcVHKjNI1+55Fpko3KO6QPLFOZIid/5qgj1UVe5pJtk67kBYIF
         U+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=XJ1DbTHwQkp6rz8764Ynj3HtGD3CNAlvqeCKZgSoVQ0=;
        b=NfQ+xaIX4xyLq2/sS1zlGr7GnIJysdQHa/vopsBQG2sPsTYZeZrtniPsHPb/yINP0b
         ne6SelIfDoZHtP1BNqbxipDuEEMzG3AiHFuvmBCqzJ+4ZIu9UNYNqDh/8+zGDhmXWG3G
         L00wub1WnPFImRsSV9jW4+9q4uLrwZf8WaYF9PPRweP3D0vvce5Xg0xmJWybITGpedD2
         ApzeHqAuQ/HuGj09NI9m8CCsBsM4Bj9VNTi/qywupcPVju8TUdsbANzryKkRjdYm9ekb
         jQkxZfJqIXqdiB8hTBRVrfJwCLJY80ty4A85A/taUftDdRdK5NWnEsN75lzbJtu7jBez
         QS8g==
X-Gm-Message-State: APjAAAXKS5xqkV2ojM5Cardzj/qGIcHeg+vZ23vNIbOqBvFk0QXe2UE3
        iCrPq4+KZBlqgYme9sHa6uE=
X-Google-Smtp-Source: APXvYqyD30S+hd0zi0LGH5vSH5pXI4H6Jmrw2/vgufLPKDa5X6EfbljsT4vWOTPRqxzZ75NG5ocsbw==
X-Received: by 2002:a17:902:7d92:: with SMTP id a18mr26228068plm.102.1571070091621;
        Mon, 14 Oct 2019 09:21:31 -0700 (PDT)
Received: from nishad ([2406:7400:54:c1b:38e9:5260:8522:a8f0])
        by smtp.gmail.com with ESMTPSA id m19sm14877483pjl.28.2019.10.14.09.21.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Oct 2019 09:21:31 -0700 (PDT)
Date:   Mon, 14 Oct 2019 21:51:20 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: dsa: sja1105: Use the correct style for SPDX License
 Identifier
Message-ID: <20191014162116.GA5024@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style
in header files related to Distributed Switch Architecture
drivers for NXP SJA1105 series Ethernet switch support.
It uses an expilict block comment for the SPDX License
Identifier.

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
Changes in v2:
  - Modify the commit message to reflect the changes done.
  - Correct some indentation errors.
---
 drivers/net/dsa/sja1105/sja1105.h                | 4 ++--
 drivers/net/dsa/sja1105/sja1105_dynamic_config.h | 4 ++--
 drivers/net/dsa/sja1105/sja1105_ptp.h            | 4 ++--
 drivers/net/dsa/sja1105/sja1105_static_config.h  | 4 ++--
 drivers/net/dsa/sja1105/sja1105_tas.h            | 4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 8681ff9d1a76..b0dada13c377 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2018, Sensor-Technik Wiedemann GmbH
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2018, Sensor-Technik Wiedemann GmbH
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_H
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
index 740dadf43f01..1fc0d13dc623 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_DYNAMIC_CONFIG_H
 #define _SJA1105_DYNAMIC_CONFIG_H
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index af456b0a4d27..394e12a6ad59 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_PTP_H
 #define _SJA1105_PTP_H
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 7f87022a2d61..f4a5c5c04311 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: BSD-3-Clause
- * Copyright (c) 2016-2018, NXP Semiconductors
+/* SPDX-License-Identifier: BSD-3-Clause */
+/* Copyright (c) 2016-2018, NXP Semiconductors
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_STATIC_CONFIG_H
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
index 0b803c30e640..0aad212d88b2 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.h
+++ b/drivers/net/dsa/sja1105/sja1105_tas.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_TAS_H
 #define _SJA1105_TAS_H
-- 
2.17.1

