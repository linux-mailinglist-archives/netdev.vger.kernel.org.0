Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F1C10B007
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK0NTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:19:17 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39034 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfK0NTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:19:17 -0500
Received: by mail-pf1-f194.google.com with SMTP id x28so10985001pfo.6;
        Wed, 27 Nov 2019 05:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=HSvzzY/G7lC73xlGrMu73kxZNzii6k+S2gUvGl4rWlM=;
        b=MlUM2RjzlBn2unniM/WJl4TDvrx0YjlGycQFTXHiwoXbaH//v34CbIzU+Rfr4i1SjZ
         ATVk70dyZZ2ONyNZU1rC7OSgnueL7CM7VJnMjWrGqUgo09O93KGbe+/WEAZwVjMdATx3
         mB3gOgK1oDBnuClVaD2Zqcl16+ueoRgzcSrTgStrzWnIo0XgFSkWFI0rfAolixqnOazW
         1s9vJy8tmtEuTZVsTMs6R4P1LYZj+O3kSk8/NmQiEmqk8b8GVe4SmCeELn0i0LcEeuI+
         0qPx/HGUnY3jjcVRmZweVXki8m1iUdSVGU5atMojUzNGNSvQIA856Iy0kOY3Ma8WLCFK
         cjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=HSvzzY/G7lC73xlGrMu73kxZNzii6k+S2gUvGl4rWlM=;
        b=aRYczHGY0EvxeXAnsp4zPo8PaXFAOh3TN6lSpKPpwPWg3VdwyHV9kIaPhzHGzL23it
         W738Mm2d1qLpejAZm9mRT3+WCrI/KrT8idAwDZUMsYMFNXUNt1DmJKl1WJsH9J+Vq0cX
         tYceygWJdRprsqfDo+TInRcAv7A4ze9hIYyfYfzQ/pVWLHbRICNcQpT4riQx9UvqIY+l
         9GfYUiuhGpskU//wZzW3hFSjbI3VIYpVds5jF5PCw4DuvC7OV+ZsS6dOhFLww+MGmXaE
         16pMrtsj+MmkWx+D0WPZZ+BowI/06DU0E5t/8npbyMjT+5eZ04SSabXTdo4mYxeqpJ/0
         PVzg==
X-Gm-Message-State: APjAAAVOvd1mb22taAilasqcjwBLlDlyStiJhEBFj7pprzpIaqmyHvOJ
        nXqV2AMSsC4r7Tld4Hl/GQ3UwHkOErCMrA==
X-Google-Smtp-Source: APXvYqzphMU1x4UjTe568wWqFDGp/UWVlLIHRgKsVhKnaVdDOWmCrzuYvlzznTz8o+Wyb3bRIZBR1Q==
X-Received: by 2002:a63:e94d:: with SMTP id q13mr4832006pgj.209.1574860756204;
        Wed, 27 Nov 2019 05:19:16 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id l7sm2597116pfl.11.2019.11.27.05.19.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Nov 2019 05:19:15 -0800 (PST)
Date:   Wed, 27 Nov 2019 18:49:08 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: phy: Use the correct style for SPDX License
 Identifier
Message-ID: <20191127131904.GA28829@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header files related to PHY Layer for Ethernet drivers.
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used). This patch also gives an explicit
block comment to the SPDX License Identifier.

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
Changes in v2:
  - Remove unwanted blank space.
---
 drivers/net/phy/aquantia.h    | 4 ++--
 drivers/net/phy/bcm-phy-lib.h | 2 +-
 drivers/net/phy/mdio-cavium.h | 2 +-
 drivers/net/phy/mdio-i2c.h    | 2 +-
 drivers/net/phy/mdio-xgene.h  | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/aquantia.h b/drivers/net/phy/aquantia.h
index 5a16caab7b2f..c684b65c642c 100644
--- a/drivers/net/phy/aquantia.h
+++ b/drivers/net/phy/aquantia.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * HWMON driver for Aquantia PHY
+/* SPDX-License-Identifier: GPL-2.0 */
+/* HWMON driver for Aquantia PHY
  *
  * Author: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
  * Author: Andrew Lunn <andrew@lunn.ch>
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 5ecacb4e64f0..c86fb9d1240c 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2015 Broadcom Corporation
  */
diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
index b7f89ad27465..e33d3ea9a907 100644
--- a/drivers/net/phy/mdio-cavium.h
+++ b/drivers/net/phy/mdio-cavium.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2009-2016 Cavium, Inc.
  */
diff --git a/drivers/net/phy/mdio-i2c.h b/drivers/net/phy/mdio-i2c.h
index 751dab281f57..b1d27f7cd23f 100644
--- a/drivers/net/phy/mdio-i2c.h
+++ b/drivers/net/phy/mdio-i2c.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * MDIO I2C bridge
  *
diff --git a/drivers/net/phy/mdio-xgene.h b/drivers/net/phy/mdio-xgene.h
index b1f5ccb4ad9c..8af93ada8b64 100644
--- a/drivers/net/phy/mdio-xgene.h
+++ b/drivers/net/phy/mdio-xgene.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /* Applied Micro X-Gene SoC MDIO Driver
  *
  * Copyright (c) 2016, Applied Micro Circuits Corporation
-- 
2.17.1

