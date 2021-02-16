Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E30831D0EA
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhBPTWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:22:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhBPTWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 14:22:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B3364EAD;
        Tue, 16 Feb 2021 19:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613503286;
        bh=FwzLSkHq/fQKXd7PxmVrEybGxcvHyVQtbZPZ5PEVB+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZ9ON9D/0sLfuFKWG96uxwE5QdjVp0qc4LgYXDs4QnStVvJOPDP3VCdnuPHCYfVN/
         VSkwChYmN0ZXq7bQWOA9N69zLwij+PuP/WxzZuGjFtAbeql327SgtlEnT/LsBRkt8V
         EAYtyUWupRo3OzwgUXtT/yaVN6KaTnwxRHcMMccg4duC1wuCCg4Qp0oSiULAjAJxQ8
         T5BinTSHdJg/SPqTbgIpHos0wsxT9JWOhY/nHdtRcwdnonnKT7L2Ul/bWW8RHMr8Qr
         PvshmEtvwTsQheF0UqBiHTdpwHT5agHD2RwAtLZsNXBoZ0ebsvH8+nsfqtN6KErZ4F
         3Rmn4ED03TC3w==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, kuba@kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, lkp@intel.com, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 3/4] net: phylink: Add 5gbase-r support
Date:   Tue, 16 Feb 2021 20:20:54 +0100
Message-Id: <20210216192055.7078-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210216192055.7078-1-kabel@kernel.org>
References: <20210216192055.7078-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5GBASER interface type and speed to phylink.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 84f6e197f965..053c92e02cd8 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -306,6 +306,10 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 2500baseX_Full);
 			break;
 
+		case PHY_INTERFACE_MODE_5GBASER:
+			phylink_set(pl->supported, 5000baseT_Full);
+			break;
+
 		case PHY_INTERFACE_MODE_USXGMII:
 		case PHY_INTERFACE_MODE_10GKR:
 		case PHY_INTERFACE_MODE_10GBASER:
-- 
2.26.2

