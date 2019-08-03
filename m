Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9B080492
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 08:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfHCGET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 02:04:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51488 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfHCGES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 02:04:18 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so69912251wma.1;
        Fri, 02 Aug 2019 23:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TuPsU+wIk9sIcrLOl4LJnc1V+9lHBDgGcDwEKtWWqcc=;
        b=HT8uNMOe3xQ+8v+NGlpiBqKUVlnXu+y+8pTuy/KqlOjTymceYZgX4CYrrsGfPckcQL
         v9X6pY6LtLFAY3nYKefMVPRv6kYv8WCHdOqgTaw57zNyVPZIMfFhxeOc0bmThKDJlxSl
         AXPO1owM6GP+6Q6K15mYojVWDrGlWzt/NlOJwXlQ7+zA9wuDprcfmqKwbp1XhC6c9pdF
         4ktox4g9KXM6+6OqH5uKoXnFL5Qm3CJ0/1pzxBympl+E7Z74Wd17Ntp0vtt54wn94wJR
         mOS/3C3AcSBGT8OTnMAP9dA6iMQZXd2laLo2EK/Yw76XyHC+/e3Miq9eZgoK3VvJ/kTV
         9hfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TuPsU+wIk9sIcrLOl4LJnc1V+9lHBDgGcDwEKtWWqcc=;
        b=lQ7QJRiGo2fAMhB0rE+hBPwoq1qk52a/u3EtXHAfPhDw1iIKAEtBKDuDH6sPQOdW4x
         dxGiSc4wRis8E10h3KdGOi2aDp5YdyqlnYJVU62qH0VBBFEUmbqwK37xhc5wcfKPvhOH
         D8F5G7z2yhObHIVzvFCzpdU5JYyHyfE8mCiVNJPBXp8rSU+so45ye2faU0S4eR1YgpNh
         h0p9Iu3XRIPGlGnl2AeA3/Yhee7JS5RcUuD4qVlZPzHUkKEEP994WOMWm79SQAUT0yiG
         0bpOTgYMBIwwqGbbaqPem9sOXzhp/s1gBHkdrS2U4HhSZwcZyl+KAdKDEmuVCiMHFMv/
         YS0Q==
X-Gm-Message-State: APjAAAWQ6G2a2j5UD6MEuCKTOV1tjIVibS+miMLTNFnDvA/XD1Rgjwym
        onxMOh0rSiKfB+rK52G4qVY=
X-Google-Smtp-Source: APXvYqwHgOP+QwT4wtjARAN/ZGIjpCOSDlFdPyx71PGItur4Jad51ToiXyPCxCj6XswP9TeBjy3/vA==
X-Received: by 2002:a7b:cf3a:: with SMTP id m26mr7950518wmg.6.1564812255722;
        Fri, 02 Aug 2019 23:04:15 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id t13sm93817734wrr.0.2019.08.02.23.04.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 23:04:15 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     natechancellor@gmail.com
Cc:     andrew@lunn.ch, broonie@kernel.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, hkallweit1@gmail.com,
        kernel-build-reports@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        lkp@intel.com, netdev@vger.kernel.org, rdunlap@infradead.org,
        willy@infradead.org
Subject: [PATCH v2] net: mdio-octeon: Fix Kconfig warnings and build errors
Date:   Fri,  2 Aug 2019 23:01:56 -0700
Message-Id: <20190803060155.89548-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190731185023.20954-1-natechancellor@gmail.com>
References: <20190731185023.20954-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 171a9bae68c7 ("staging/octeon: Allow test build on
!MIPS"), the following combination of configs cause a few Kconfig
warnings and build errors (distilled from arm allyesconfig and Randy's
randconfig builds):

    CONFIG_NETDEVICES=y
    CONFIG_STAGING=y
    CONFIG_COMPILE_TEST=y

and CONFIG_OCTEON_ETHERNET as either a module or built-in.

WARNING: unmet direct dependencies detected for MDIO_OCTEON
  Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=y] && MDIO_BUS [=y]
&& 64BIT [=n] && HAS_IOMEM [=y] && OF_MDIO [=n]
  Selected by [y]:
  - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC ||
COMPILE_TEST [=y]) && NETDEVICES [=y]

In file included from ../drivers/net/phy/mdio-octeon.c:14:
../drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of
function ‘writeq’; did you mean ‘writel’?
[-Werror=implicit-function-declaration]
  111 | #define oct_mdio_writeq(val, addr) writeq(val, (void *)addr)
      |                                    ^~~~~~

CONFIG_64BIT is not strictly necessary if the proper readq/writeq
definitions are included from io-64-nonatomic-lo-hi.h.

CONFIG_OF_MDIO is not needed when CONFIG_COMPILE_TEST is enabled because
of commit f9dc9ac51610 ("of/mdio: Add dummy functions in of_mdio.h.").

Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Address Randy's reported failure here: https://lore.kernel.org/netdev/b3444283-7a77-ece8-7ac6-41756aa7dc60@infradead.org/
  by not requiring CONFIG_OF_MDIO when CONFIG_COMPILE_TEST is set.

* Improve commit message

 drivers/net/phy/Kconfig       | 4 ++--
 drivers/net/phy/mdio-cavium.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 20f14c5fbb7e..0e3d9e3d3533 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -159,8 +159,8 @@ config MDIO_MSCC_MIIM
 
 config MDIO_OCTEON
 	tristate "Octeon and some ThunderX SOCs MDIO buses"
-	depends on 64BIT
-	depends on HAS_IOMEM && OF_MDIO
+	depends on (64BIT && OF_MDIO) || COMPILE_TEST
+	depends on HAS_IOMEM
 	select MDIO_CAVIUM
 	help
 	  This module provides a driver for the Octeon and ThunderX MDIO
diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
index ed5f9bb5448d..b7f89ad27465 100644
--- a/drivers/net/phy/mdio-cavium.h
+++ b/drivers/net/phy/mdio-cavium.h
@@ -108,6 +108,8 @@ static inline u64 oct_mdio_readq(u64 addr)
 	return cvmx_read_csr(addr);
 }
 #else
+#include <linux/io-64-nonatomic-lo-hi.h>
+
 #define oct_mdio_writeq(val, addr)	writeq(val, (void *)addr)
 #define oct_mdio_readq(addr)		readq((void *)addr)
 #endif
-- 
2.23.0.rc1

