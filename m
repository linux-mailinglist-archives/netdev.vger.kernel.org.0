Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731473017B
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfE3SHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:07:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42258 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbfE3SGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=x5p0hhe3NdFLJnDuryoCvKPCaApmMx5KZ6kuZQWqKIM=; b=IfbtgnIBmUS3PIRgW4Vm9rIBL9
        MbVcdNsa8n/lq0T7xNG183KsxA5iIWxr8tFajOWkcSZoMeYMRlzGM5u9pP9WurpRhnwCZQlXo0/CC
        vBtZC3jNTjXanoYfKAC5KUJeg3KBhsHfttKdYdRLGvBbnZTdwMc/IijtQ+KZ5LD/XsHA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWPRX-0000Oq-K6; Thu, 30 May 2019 20:06:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     linville@redhat.com
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 2/2] ethtool: Add 100BaseT1 and 1000BaseT1 link modes
Date:   Thu, 30 May 2019 20:06:16 +0200
Message-Id: <20190530180616.1418-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530180616.1418-1-andrew@lunn.ch>
References: <20190530180616.1418-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel can now indicate if the PHY supports operating over a
single pair at 100Mbps or 1000Mbps.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 ethtool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 66a907edd97b..35158939e04c 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -494,8 +494,10 @@ static void init_global_link_mode_masks(void)
 		ETHTOOL_LINK_MODE_10baseT_Full_BIT,
 		ETHTOOL_LINK_MODE_100baseT_Half_BIT,
 		ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+		ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
 		ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
 		ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+		ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
 		ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
 		ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
 		ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
@@ -634,10 +636,14 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
 		  "100baseT/Half" },
 		{ 1, ETHTOOL_LINK_MODE_100baseT_Full_BIT,
 		  "100baseT/Full" },
+		{ 1, ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
+		  "100baseT1/Full" },
 		{ 0, ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
 		  "1000baseT/Half" },
 		{ 1, ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
 		  "1000baseT/Full" },
+		{ 1, ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
+		  "1000baseT1/Full" },
 		{ 0, ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
 		  "1000baseKX/Full" },
 		{ 0, ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
-- 
2.20.1

