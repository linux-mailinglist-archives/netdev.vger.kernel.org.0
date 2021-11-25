Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DE545D569
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhKYHbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbhKYH3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:29:04 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F471C061758
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:25:53 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so5778375pjj.0
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/x+VckoADH0NLdb4zTk9/a2MskgHRA5RsXQCAS10Yqw=;
        b=b2sHMsOWWl2SIAhJ4p+thZFw7r3N6uQ+csjTe6BpUBgE9SniZbin+D8/c6Teu0ywBz
         JVHXK8lBxAjJ+Su5ad3gpoe0M8OtT+tlAsKAyP42DUAfWUSX2B8hwSQr6BdZqBTMvGoM
         AlDB8U7FqjT/+0NxU0vrNyV21IKZ2RZv6qs1isH6PsGhP8ScSP5KxtPe//4u/wMusI7S
         i9ZAgK/8QV1u2rtpV/TpUT4P8pDrDJg6g/jlHJiaDY4m7l4P0E+iHNS1lE0uO4+PWWBV
         xgvD6mGz5UyBmjeNPTCsxYtvPPeOT5AorjpioCmwI9tU4jGaQ/so628MF9vhwo9sDrym
         vJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/x+VckoADH0NLdb4zTk9/a2MskgHRA5RsXQCAS10Yqw=;
        b=USdIkgNn9q2VX29k8aFHpSTHWfQI0WmdV094A1ZgPaek73JB44/fbLyr/NzGIgzmsR
         d3sndlbVk+ATuoaJS1ETeqtFG+ADk26h0wkLXxnlCRTCrXNpPNOVe6X1BGJIL8AZ++Ga
         K/JyjuypLvrUwzPMZjWLUCgqVO5s3GnfJvhhdpNKoEO3HWKQ8xJ9DEgpd8F0lNmvuanG
         AjVU2NNm6tdBSLAJx0P7XSmJRzhEsM2TU6fnropZsxA/w0TYIN/LIXzeQxcyW5j/rWcw
         YpDiDlA1xGKE2CrYTU0iwuPywGw5nLGRAlrSm2Vim4e1Tr/SPwfRRlId3siBHGZKsP9c
         6y6Q==
X-Gm-Message-State: AOAM532wgIOuUtABOfO7qkgYq7AsI5xi9vw+LL05cp17qjQjZcX2eaiM
        Gyy1DYC04eBH/yOgU9eUkE5NNCFjCowERg==
X-Google-Smtp-Source: ABdhPJwfuabjnh2zqBwb5DK4Y0wg6xiqpzag/fBTZRD0jnicecTQsvURP2Wuq/YkNrxw7yFtENFDfw==
X-Received: by 2002:a17:902:aa89:b0:144:ea8e:1bd7 with SMTP id d9-20020a170902aa8900b00144ea8e1bd7mr26884125plr.65.1637825152583;
        Wed, 24 Nov 2021 23:25:52 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id pc1sm7763241pjb.5.2021.11.24.23.25.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 23:25:52 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hao Chen <chenhao288@hisilicon.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Danielle Ratson <danieller@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [net-next v2] net: ethtool: set a default driver name
Date:   Thu, 25 Nov 2021 15:25:44 +0800
Message-Id: <20211125072544.32578-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The netdev (e.g. ifb, bareudp), which not support ethtool ops
(e.g. .get_drvinfo), we can use the rtnl kind as a default name.

ifb netdev may be created by others prefix, not ifbX.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Hao Chen <chenhao288@hisilicon.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Danielle Ratson <danieller@nvidia.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v1: https://lore.kernel.org/all/20211124181858.6c4668db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/ 
---
 net/ethtool/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index af2d4e022076..8bf161cd5487 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -734,6 +734,10 @@ ethtool_get_drvinfo(struct net_device *dev, struct ethtool_devlink_compat *rsp)
 			sizeof(rsp->info.bus_info));
 		strlcpy(rsp->info.driver, dev->dev.parent->driver->name,
 			sizeof(rsp->info.driver));
+	} else if (dev->rtnl_link_ops) {
+		strlcpy(rsp->info.driver, dev->rtnl_link_ops->kind,
+			sizeof(rsp->info.driver));
+
 	} else {
 		return -EOPNOTSUPP;
 	}
-- 
2.27.0

