Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B562D4FC0
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 14:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbfJLMly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 08:41:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44109 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfJLMjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 08:39:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id q21so7669527pfn.11;
        Sat, 12 Oct 2019 05:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=toRju7pMffgXEwZqaFPKvT2vXBWZ70KWyEPi9fKD0Jk=;
        b=bybSJWr4j2RFeqmtYm6uTmudpNyQNY+RCgzTLuAL+CSSWa+yJNkqvj+0/MPdQSaqmg
         MHzwknxWDFMxSG0Z8LxNYC2H4WqMyyOFpil+BJm3U04Z+oR6z03FAUZy+WvXtGtL04S+
         CrwWH5tp7NeICR86JPjk0JvbFt9s4HA/ffEcxAh6pkyIKR4NPw3NA+qDmnH7kQTWJe1H
         pTspzOXaEpf1DiNNYRWJIM0UKgauH5ZPibPH5xUDJHgJKa2rtmWSwNU3goyIPFWxjuwd
         OXWlPcVCz0ShrMVxpwyPVCV9e08UnWx0OiqoVlyXK48h3Fxre6C4yc95IOLE4PaLR9/j
         QWCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=toRju7pMffgXEwZqaFPKvT2vXBWZ70KWyEPi9fKD0Jk=;
        b=FPVVvfIvF7gIpLeILADU7Ce1AxgjgHJ71eL8x31LUUDQv4+OKTUNnCDcVB4xOAp6iG
         Z55Bnr0FQbiM9I/CUCiN1iA73RYNB8zJzLu9vF6rb4jY5NrXfXbwlgRsKRwfcHCpr2F8
         8ypCXrgz56/hn1UB0UgFKUdk0q2WHuuhAxnDKoPI1gJ3eZ7e5gALnlXZBSNlpe32aFXO
         s0TmppvgifVPVkeP1l+ae5Dg7LBf3CfjwXXKWmt9bg9aDwkmLGP4tFMN3xmjw6uui/gW
         DsoUOry6vo1F5hrCRoSvOiq9RZdWdXNyzdea3GvFtWRDchWlirnkTHyid5nYzNnZGyHz
         R+iQ==
X-Gm-Message-State: APjAAAVFYl3jQ7S8G+F1NaqGNOydTI91paI+5XizJ+hd8MQnHTrkWcXo
        p724VraQH33E9lXWdmU8lC4njBivHxavIQ==
X-Google-Smtp-Source: APXvYqy9DzN+NiszbCbWjyXjQ4gh3UkEfjMYjgDz01rSJMmmwW9ibUqBVB8eeCeLRGnYBI4haxq8/A==
X-Received: by 2002:a17:90a:bd8e:: with SMTP id z14mr22860702pjr.40.1570883991797;
        Sat, 12 Oct 2019 05:39:51 -0700 (PDT)
Received: from nishad ([2406:7400:54:9230:b578:2290:e0c4:6e96])
        by smtp.gmail.com with ESMTPSA id 7sm10717934pgj.35.2019.10.12.05.39.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 12 Oct 2019 05:39:51 -0700 (PDT)
Date:   Sat, 12 Oct 2019 18:09:41 +0530
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
Subject: [PATCH] net: dsa: sja1105: Use the correct style for SPDX License
 Identifier
Message-ID: <20191012123938.GA6865@nishad>
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
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h                | 4 ++--
 drivers/net/dsa/sja1105/sja1105_dynamic_config.h | 4 ++--
 drivers/net/dsa/sja1105/sja1105_ptp.h            | 4 ++--
 drivers/net/dsa/sja1105/sja1105_static_config.h  | 4 ++--
 drivers/net/dsa/sja1105/sja1105_tas.h            | 4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 8681ff9d1a76..fb7a6fff643f 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2018, Sensor-Technik Wiedemann GmbH
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Copyright (c) 2018, Sensor-Technik Wiedemann GmbH
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_H
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
index 740dadf43f01..4f64adb2d26a 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_DYNAMIC_CONFIG_H
 #define _SJA1105_DYNAMIC_CONFIG_H
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index af456b0a4d27..c7e598fd1504 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_PTP_H
 #define _SJA1105_PTP_H
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 7f87022a2d61..ee66fae6128b 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: BSD-3-Clause
- * Copyright (c) 2016-2018, NXP Semiconductors
+/* SPDX-License-Identifier: BSD-3-Clause */
+/*  Copyright (c) 2016-2018, NXP Semiconductors
  * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_STATIC_CONFIG_H
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
index 0b803c30e640..c3ea7be52b9c 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.h
+++ b/drivers/net/dsa/sja1105/sja1105_tas.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  */
 #ifndef _SJA1105_TAS_H
 #define _SJA1105_TAS_H
-- 
2.17.1

