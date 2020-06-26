Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0DE20B11B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 14:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgFZMFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 08:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgFZMFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 08:05:37 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C57C08C5DB;
        Fri, 26 Jun 2020 05:05:37 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e15so6725971edr.2;
        Fri, 26 Jun 2020 05:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7AUVic1Y5MTcZ9Y09JPQEhG9Xb1GhH74cCEqiNFQyeo=;
        b=sCTvLyzvfG61CEw6PS/+ZDFbAEA1jjY1z5t0Vb2HtBM4NTvCaCYHVj6TVox/BI84G2
         Tk5OFYEV1b9aRmbI2qoiRX1RgaAHnSl7pOhTFtX5KfmmK5uvBZmINMwyrEde/rJhSZ6Q
         sCX7n4toc9R3wNiUCMLdIxyRwgm0ZIIP4JuvW7JtLtQESVxnueatAWgyM/9IDTiiGmKq
         lKIBrVZGEnTvQ4rXV4dKI/lG8hD/lkTjEY/RiaKEw1ECPXceaSkjnoLMXaQy/wye7ANa
         prX0MAN0W32DheJNlQ9wEy8H2GblFBSD9QGNPCEBl0zIDz+SDUb5eLBLx+xOD1PLVcdF
         DrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7AUVic1Y5MTcZ9Y09JPQEhG9Xb1GhH74cCEqiNFQyeo=;
        b=FxaPeocPBT743g6vI51yrOowVxwboU6p7H8/w4TAfOxBZdttuWRMdesaQkETeff+5V
         RUrGVzm0q62fzr+rMWiTontp0HvyTzu7zzSUDUyRvmuvauGDNEJhwKi1VYwBZEE+uKmn
         SRnaHN1Vj0AjGS1MhkuDZpUdpR0fI8HcVq3TNKy5kWWh/P0yuYS1MH6zU0KtW4iHbC/B
         Ojzv93gOJ/aBpQP2wYPoMLNxaQ2KpNrIyBvwfolUJGqZONDzwNgpFT1nDHmTJXU7baTi
         zKvVrhE55DAo+fySz77rh/OWNl3GFiw6s/5Q+UY8l1wYRmolgfcepEZgj9M2Z4qRl94B
         o99w==
X-Gm-Message-State: AOAM531HcofQNFObZAp7F54p7uIeO17b12mAwXsu+7vg8gFnLdGo7JQX
        2J+o8Xdez+gctRuHZpNM65I=
X-Google-Smtp-Source: ABdhPJxA60jOtfzOkAemDvxspe50YaRE1GzXfaeagKO2wJzWFn6BjlrOjGLEWZ46HXXmW+OQKbef1Q==
X-Received: by 2002:a50:ee87:: with SMTP id f7mr3045824edr.355.1593173135719;
        Fri, 26 Jun 2020 05:05:35 -0700 (PDT)
Received: from debian.home (ip51ccf9cd.speed.planet.nl. [81.204.249.205])
        by smtp.gmail.com with ESMTPSA id l27sm5024153ejk.25.2020.06.26.05.05.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 05:05:35 -0700 (PDT)
From:   Johan Jonker <jbx6244@gmail.com>
To:     peppe.cavallaro@st.com
Cc:     alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, heiko@sntech.de,
        linux-rockchip@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: stmmac: change Kconfig menu entry to STMMAC/DWMAC
Date:   Fri, 26 Jun 2020 14:05:26 +0200
Message-Id: <20200626120527.10562-1-jbx6244@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a Rockchip user wants to enable support for
the ethernet controller one has to search for
something with STMicroelectronics.
Change the Kconfig menu entry to STMMAC/DWMAC,
so that it better reflects the options it enables.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 36bd2e18f..8f7625cc8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config STMMAC_ETH
-	tristate "STMicroelectronics Multi-Gigabit Ethernet driver"
+	tristate "STMMAC/DWMAC Multi-Gigabit Ethernet driver"
 	depends on HAS_IOMEM && HAS_DMA
 	select MII
 	select MDIO_XPCS
@@ -26,7 +26,7 @@ config STMMAC_SELFTESTS
 	  results to the netdev Mailing List.
 
 config STMMAC_PLATFORM
-	tristate "STMMAC Platform bus support"
+	tristate "STMMAC/DWMAC Platform bus support"
 	depends on STMMAC_ETH
 	select MFD_SYSCON
 	default y
-- 
2.11.0

