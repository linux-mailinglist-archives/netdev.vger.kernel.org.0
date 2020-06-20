Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A7C2024E0
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgFTPoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgFTPoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:44:04 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941BAC061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:03 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id k8so10140467edq.4
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NHGM7FHJdonIhKaKDXfiEpfgCS/Zv2JWaNe/LgX0aNo=;
        b=Qc+9CCdj1dGD0IcBMd6qygjAcSue78+YtGdV6GcLWLwCPDKyWYsRzt2Km7Nu84U6Lb
         Bt0SQQXKLA7GUrWIfh8pRKGwNfONOJNKJCQ0fuGHZOC4JQ+m2MqPE+PAwc2fY2MyiuOn
         tuFUnE7EftDv5fPBrYMe3dsLCzuYfGJ9C5Jud0uUROgig8heytwDUMSlpDvlebb6BqfG
         hw8q+HpOTkQ1TIctqsCojf3VjOOyCOjux+WvnEmiQ6BT/kX1y8jBmyx8s8lv8oZ0zhHA
         cqHYM/maLYNnJZbzL3JDmuXidJEy8MbXt5Fo+aWAZCv2jYhhi/9RKIzQRGu6uBdUSsV9
         1L9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NHGM7FHJdonIhKaKDXfiEpfgCS/Zv2JWaNe/LgX0aNo=;
        b=pdKhIyhIMf6XZx2CvACCjwUE3agfcrEOYp16/RKINMmvBrMuhaHlybDGjyBuTqrlFM
         SkucXba+PgA+EBNiqdVOK9RiJ2EHcNRjhWblxiGGWBiZY/1XV5lEFSxL4fms+54BBLDk
         TezFVVMgare6gjmNVildxIVVhAa2s2LfArI3Tg/o0Lht2JKBXnJ0or/IZVQOU+CHXtzZ
         xC0AnDyDnvJ20WX2iQoFLEgOtPYbCJ2hRA5r+QQsk0WDOJm2rdiH/w1bRTHmo3V2eMQQ
         NqLc8s1LosVPby7iMGT0iUG3MYcZnJdY9dAj+gxm/sANrC5fAXHc0vQ4QAKbRKoTyD5I
         Fknw==
X-Gm-Message-State: AOAM532/mtNkU4xO/C2jKqPieshYcMu2rsRmGn4ls/6lDWsEVREYWsMI
        bwL1TE/766wamz5VOK/CHuU=
X-Google-Smtp-Source: ABdhPJxWb/P54ov0gJUzVEVNLMGLSHGszsJBlh58pq9V/61aUVEvOffkBUPUItCQwMFqE+Hp79yE6g==
X-Received: by 2002:a50:ee01:: with SMTP id g1mr8296285eds.44.1592667842289;
        Sat, 20 Jun 2020 08:44:02 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:44:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 07/12] net: mscc: ocelot: rename MSCC_OCELOT_SWITCH_OCELOT to MSCC_OCELOT_SWITCH
Date:   Sat, 20 Jun 2020 18:43:42 +0300
Message-Id: <20200620154347.3587114-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Putting 'ocelot' in the config's name twice just to say that 'it's the
ocelot driver running on the ocelot SoC' is a bit confusing. Instead,
it's just the ocelot driver. Now that we've renamed the previous symbol
that was holding the MSCC_OCELOT_SWITCH_OCELOT into *_LIB (because
that's what it is), we're free to use this name for the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Kconfig  | 6 +++---
 drivers/net/ethernet/mscc/Makefile | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index 24db927e8b30..3cfd1b629886 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -18,8 +18,8 @@ config MSCC_OCELOT_SWITCH_LIB
 	  This is a hardware support library for Ocelot network switches. It is
 	  used by switchdev as well as by DSA drivers.
 
-config MSCC_OCELOT_SWITCH_OCELOT
-	tristate "Ocelot switch driver on Ocelot"
+config MSCC_OCELOT_SWITCH
+	tristate "Ocelot switch driver"
 	depends on NET_SWITCHDEV
 	depends on GENERIC_PHY
 	depends on REGMAP_MMIO
@@ -29,6 +29,6 @@ config MSCC_OCELOT_SWITCH_OCELOT
 	select MSCC_OCELOT_SWITCH_LIB
 	help
 	  This driver supports the Ocelot network switch device as present on
-	  the Ocelot SoCs.
+	  the Ocelot SoCs (VSC7514).
 
 endif # NET_VENDOR_MICROSEMI
diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 77222e47d63f..c6d372b6dc3f 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -9,5 +9,5 @@ mscc_ocelot_switch_lib-y := \
 	ocelot_ace.o \
 	ocelot_flower.o \
 	ocelot_ptp.o
-obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += mscc_ocelot.o
+obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
 mscc_ocelot-y := ocelot_vsc7514.o
-- 
2.25.1

