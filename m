Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963EF107E76
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 14:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKWNI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 08:08:27 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:45499 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfKWNI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 08:08:27 -0500
Received: by mail-pj1-f66.google.com with SMTP id m71so4382590pjb.12;
        Sat, 23 Nov 2019 05:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=bQPOmB6uOGZ2tirIZp69eeW8KP/lls7xjJX/xrKZza4=;
        b=iW8BociEN1RTqb+QhcWPt6vA1o/AFzZSE940W1J24I503CaLAZlOJ8DDSJkPiw1tvO
         XwnB/5vIDvi+h5uImf57H2zcLkMZ5tH/aW3x3wUnIQ46lYJvV1EuHvfYFg0XgLro7TSp
         +sipK1nv6uBagxi28WFWrhk2/Eog9Ey84Ligc+uUfIvIBtlGiu29DUC0iBkUvvvTX+Bg
         xOX1o6Ii/wP/ugjYqUUQownyhlRdcG/nojZnstzHN2nLZwR1Q2I9MuX7Nc5D2l9kZuWj
         8xkxzvav0aBNF7+9oEfXPV0T74q5Hq5BL73twpXt2HGk6M8gClhfyng90WEclPHL7lrE
         xUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=bQPOmB6uOGZ2tirIZp69eeW8KP/lls7xjJX/xrKZza4=;
        b=qpd2d+rkvib5yFviuVPkijLi/ZhxHo5t1OwrdQmwi/hWN/9SJ4V1OYQZ5Nth6mlfO0
         EB9Wqqlwy7jXzJ8GQ3DH3ZMTqo39XFrIdG0P1Ca7pQdqbck/gx3+jK6pUPY4l52doXF9
         lgLzhXj4J9j4W32AbXc9gjoR1BSlQ7s57y+HOXboDk3OjnWfQt1jVETnuH/llFtTis9j
         tcTB+UdImAXdOqbki7xJrzOBDt8J980/9cr7ahHSEMWcZP/3iEaAgUYGpJkE43/HtzQI
         GG0Q6jclzPh0qur3ptM8wYx+4QjJ/loOnCkGIBdj0llsWthGy29j4NXxtUAev1b2gIfL
         k88g==
X-Gm-Message-State: APjAAAX4tZxIGwcoE0ASIIzbXQRLMrJ7mCGmhh9gkSZcHPEr9NbiP3EY
        0fWQHF5NbVVQtQi4L926hZ0=
X-Google-Smtp-Source: APXvYqyGXIG1l3cVb9cOrEeVKeV2vpc33vOhvoSWgz0KHC102QopMHaUrhNYkck+L3PZAUlAz58xRQ==
X-Received: by 2002:a17:902:82c3:: with SMTP id u3mr12804738plz.73.1574514506505;
        Sat, 23 Nov 2019 05:08:26 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id q20sm1646148pff.134.2019.11.23.05.08.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Nov 2019 05:08:26 -0800 (PST)
Date:   Sat, 23 Nov 2019 18:38:19 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: Use the correct style for SPDX License Identifier
Message-ID: <20191123130815.GA3288@nishad>
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
 drivers/net/phy/aquantia.h    | 4 ++--
 drivers/net/phy/bcm-phy-lib.h | 2 +-
 drivers/net/phy/mdio-cavium.h | 2 +-
 drivers/net/phy/mdio-i2c.h    | 2 +-
 drivers/net/phy/mdio-xgene.h  | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/aquantia.h b/drivers/net/phy/aquantia.h
index 5a16caab7b2f..40e0be0f4e1c 100644
--- a/drivers/net/phy/aquantia.h
+++ b/drivers/net/phy/aquantia.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * HWMON driver for Aquantia PHY
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  HWMON driver for Aquantia PHY
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

