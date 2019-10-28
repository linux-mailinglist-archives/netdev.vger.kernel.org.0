Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3D0E7A30
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbfJ1UgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:36:18 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39833 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfJ1UgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:36:18 -0400
Received: by mail-pg1-f193.google.com with SMTP id p12so7729562pgn.6;
        Mon, 28 Oct 2019 13:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=2eVkQtIn/kKnma8y9cwV6ClxG9uop+VztYkAE7P1mO8=;
        b=b//ClzcUZP5lNIguYzGrNsqlLmWAsiXCNmR6XVmRGQyO9IpHdPNJNM3zwzsH6xbL7l
         r6aAJHRua/sLXQEKp5pe+yZxE/Y4WHHYlRMls9e7L9PHXOxFd52kwC++T07yRbwY4OJ0
         o60C7ky1UJWOR6dS/uOHP+ukjEh/qQP8cxiSuTRCuweAoQ0tQAWMycdUMUh5PX4HeyE8
         txTZcIw4mE3lTbFYmd9Mtm4hz1V6iyNHh0+JKKLdBF8+EeCK9ueRBZ/iKSXUepxpC8g7
         e3lmsLfto5jfL9qiHSDhGAJYsaEeFV2EuqE9Pfr57eTtPTaNVWM8Ir5qkc4Y2lXjvpbR
         DgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=2eVkQtIn/kKnma8y9cwV6ClxG9uop+VztYkAE7P1mO8=;
        b=HTXhfJtqOSie4U+oSzBvTHMW4Hr/XSg21q1O8pMJlX6lva/yGQ5YNwbG+TMLqtst3O
         b8VDudavBg3LvhRNEnwFkUyn+BV09ML8V4IiUtj1ACJX4f5taEUwVXCe2gWtz0MbcNtQ
         XazUGtC3woGVJhgy94Kok2hiZugPh9+egffwEA7ve9s45sTbYk7Ew4P2H3zeBT4avDfH
         BNcAQQAc3R+VZzXm1h5Od4V0xUwDx8Vo6MkPD1Zkx7SNG8qDWRpbxEP1A0FFaDE+YY+u
         8MhlBB/sXX1wSb1syx1qOxxnR1swet6i3hu/PiFHRCrPGZY0vL5caCHEed2ZYGSsmjcp
         iJIQ==
X-Gm-Message-State: APjAAAV1g+8fXv9aVr3kgXCIIvzuOWMC7ZFC80BkbkOk0qCMf+cYvFVV
        t5fjTcvZtkDwppkiJKiMyi4=
X-Google-Smtp-Source: APXvYqxn4r3LTRA9B5aBfCDAvI4pAQSPotWe8JAzIrgIs7Z+04gKfRBPz3DLEc0RryrCUMBZKIaILw==
X-Received: by 2002:a63:2225:: with SMTP id i37mr13535290pgi.62.1572294977814;
        Mon, 28 Oct 2019 13:36:17 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id e17sm11126717pgg.5.2019.10.28.13.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:36:17 -0700 (PDT)
Date:   Tue, 29 Oct 2019 02:06:09 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     nbd@openwrt.org, john@phrozen.org, sean.wang@mediatek.com,
        nelson.chang@mediatek.com, davem@davemloft.net,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] mediatek: mtk_eth_path.c: Remove unneeded semicolon
Message-ID: <20191028203609.GA29373@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unneeded semicolon in mtk_eth_path.c

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_path.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
index ef11cf3d1ccc..0fe97155dd8f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_path.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -57,7 +57,7 @@ static int set_mux_gdm1_to_gmac1_esw(struct mtk_eth *eth, int path)
 	default:
 		updated = false;
 		break;
-	};
+	}
 
 	if (updated) {
 		val = mtk_r32(eth, MTK_MAC_MISC);
@@ -143,7 +143,7 @@ static int set_mux_gmac1_gmac2_to_sgmii_rgmii(struct mtk_eth *eth, int path)
 	default:
 		updated = false;
 		break;
-	};
+	}
 
 	if (updated)
 		regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
@@ -174,7 +174,7 @@ static int set_mux_gmac12_to_gephy_sgmii(struct mtk_eth *eth, int path)
 		break;
 	default:
 		updated = false;
-	};
+	}
 
 	if (updated)
 		regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
-- 
2.20.1

