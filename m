Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E662139563E
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhEaHhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:37:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60533 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhEaHhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:37:11 -0400
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncSR-0002hi-Tx
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:35:31 +0000
Received: by mail-wm1-f72.google.com with SMTP id n127-20020a1c27850000b02901717a27c785so4429183wmn.9
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JmosCUrJkhqoGDagpIXrPPS//+f2tiAx4PxvTD+0vzc=;
        b=KxdUEY9a+QWLl5bnVusrCiTIiLsYAWZJJ3XjSXT3XPu+ihWWbbYntL5yI1zFjzO1y4
         2Vw6nCFF+TeUyXOo32OEtkMVVIHWbNTbpnSJNuBHNo1TvKYqKiskHGNCGMfSem7g5eEC
         gqCbzX5ec9SZDK+ppVI8gCVDohcmNYdnE+bioRaCK8xtuoKI6Z3dPrNy1KiQ7hqq8jeR
         g7uzqfG8DUuWK2mxZ4fzZ++iCorjtMlBtJ8ijzWZRd+jJmazMIilnqyv+7ihkXcDsDCP
         zuB3LZ21NvHNP/LhuQayNsTk2KQQl/OH033vmU9C7y+XNtI8qNj7zRyRFlT+QTKaWw7f
         qf1Q==
X-Gm-Message-State: AOAM533RtywY8qohsy7IwbA6opheBzjmx3vYnBCM+CEDHRx2+SwHaI8W
        VzN3kM4BHbr32o8cMUoUJDtMkoYRvR/vcem0c8htpxaLKehqcI/PXmYONNimVPmtpY+fXUBwFeN
        MBQAJH6j5SQdJn+cII0AnhdOBiI/HOhESOg==
X-Received: by 2002:adf:bc06:: with SMTP id s6mr13230774wrg.250.1622446531210;
        Mon, 31 May 2021 00:35:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/SAo+136ZY4ki3Yjmxa9I5pVJzmJ5Qz3WO+6pZiolXWGniwPT7ol1K37M1TrQfTyMcnvzwQ==
X-Received: by 2002:adf:bc06:: with SMTP id s6mr13230764wrg.250.1622446531011;
        Mon, 31 May 2021 00:35:31 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id g10sm17217780wrq.12.2021.05.31.00.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:35:30 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 03/11] nfc: mrvl: use SPDX-License-Identifier
Date:   Mon, 31 May 2021 09:35:14 +0200
Message-Id: <20210531073522.6720-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
References: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use SPDX-License-Identifier: GPL-2.0-only, instead of hand writing it.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcmrvl/fw_dnld.c | 13 +------------
 drivers/nfc/nfcmrvl/fw_dnld.h | 15 ++-------------
 drivers/nfc/nfcmrvl/i2c.c     | 15 ++-------------
 drivers/nfc/nfcmrvl/main.c    | 13 +------------
 drivers/nfc/nfcmrvl/nfcmrvl.h | 15 ++-------------
 drivers/nfc/nfcmrvl/spi.c     | 15 ++-------------
 drivers/nfc/nfcmrvl/uart.c    | 13 +------------
 drivers/nfc/nfcmrvl/usb.c     | 15 ++-------------
 8 files changed, 13 insertions(+), 101 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index 52c8ae504e32..05df7ad224d5 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -1,19 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Marvell NFC driver: Firmware downloader
  *
  * Copyright (C) 2015, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
  */
 
 #include <linux/module.h>
diff --git a/drivers/nfc/nfcmrvl/fw_dnld.h b/drivers/nfc/nfcmrvl/fw_dnld.h
index 058ce77b3cbc..7c4d91b01910 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.h
+++ b/drivers/nfc/nfcmrvl/fw_dnld.h
@@ -1,20 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Marvell NFC driver: Firmware downloader
  *
  * Copyright (C) 2015, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- **/
+ */
 
 #ifndef __NFCMRVL_FW_DNLD_H__
 #define __NFCMRVL_FW_DNLD_H__
diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index 3c9bbee98237..59a529e72d96 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -1,20 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Marvell NFC-over-I2C driver: I2C interface related functions
  *
  * Copyright (C) 2015, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- **/
+ */
 
 #include <linux/module.h>
 #include <linux/interrupt.h>
diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index 529be35ac178..a4620b480c4f 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -1,19 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Marvell NFC driver: major functions
  *
  * Copyright (C) 2014-2015 Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
  */
 
 #include <linux/module.h>
diff --git a/drivers/nfc/nfcmrvl/nfcmrvl.h b/drivers/nfc/nfcmrvl/nfcmrvl.h
index e84ee18c73ae..0b4220bb91bc 100644
--- a/drivers/nfc/nfcmrvl/nfcmrvl.h
+++ b/drivers/nfc/nfcmrvl/nfcmrvl.h
@@ -1,20 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Marvell NFC driver
  *
  * Copyright (C) 2014-2015, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- **/
+ */
 
 #ifndef _NFCMRVL_H_
 #define _NFCMRVL_H_
diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index 0647b85930a6..66696321c645 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -1,20 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Marvell NFC-over-SPI driver: SPI interface related functions
  *
  * Copyright (C) 2015, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- **/
+ */
 
 #include <linux/module.h>
 #include <linux/interrupt.h>
diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
index 7194dd7ef0f1..d7ba5b5c653c 100644
--- a/drivers/nfc/nfcmrvl/uart.c
+++ b/drivers/nfc/nfcmrvl/uart.c
@@ -1,19 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Marvell NFC-over-UART driver
  *
  * Copyright (C) 2015, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
  */
 
 #include <linux/module.h>
diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index bcd563cb556c..50f06dd1ba25 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -1,20 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Marvell NFC-over-USB driver: USB interface related functions
  *
  * Copyright (C) 2014, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- **/
+ */
 
 #include <linux/module.h>
 #include <linux/usb.h>
-- 
2.27.0

