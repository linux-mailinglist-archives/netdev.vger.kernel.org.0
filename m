Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40172D7D3
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfE2Ial (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:30:41 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:41654 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbfE2Ial (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:30:41 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D77A9C263B;
        Wed, 29 May 2019 08:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559118623; bh=HWlisUVHIuO4P0hWOEPlpTin/ujXVBoRHkrNFSxF3W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=B4x35i2i4K4mpXoLyav290RYtabrf3xTdgACbuCOiwPD/z9dBb7o/imrZ3pR8+vQN
         aR9gi1z8lxMd0NdDgAvxMn4N+YedBkH0TE3EGZPJfPFP4tarj24ROcRWxSAWujac80
         M440wamPM/qsldzJqR+FEjh4uKo1j4KPknyolj5AdbiR5//pmULeIPRcRUWs73OLPp
         t9ZxG7jnGkOxYcwRK3n667JwsMBQmzLrn4rk58oRgxZb2wu4zJ6nEknYWO2UlVeP3a
         SoYvh/CMJ7fnYZ2FeZbLqm6yDzVeH6Gx6OMyCiTglJy9XFmsa8Me/QSObj5B5VnYR/
         dnw/7fEeSMbdA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 3AD4AA009F;
        Wed, 29 May 2019 08:30:40 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 536713E88E;
        Wed, 29 May 2019 10:30:39 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 1/2] net: stmmac: selftests: Fix sparse warning
Date:   Wed, 29 May 2019 10:30:25 +0200
Message-Id: <6e6f527d5dcd92acaf9d21b2e5cc3a2ebfebf88b.1559118521.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1559118521.git.joabreu@synopsys.com>
References: <cover.1559118521.git.joabreu@synopsys.com>
In-Reply-To: <cover.1559118521.git.joabreu@synopsys.com>
References: <cover.1559118521.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable shall be __be16. Fix it.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 33dc37c7e1c1..9d9bad5d31bf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -114,7 +114,7 @@ static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
 	}
 
 	if (attr->vlan) {
-		u16 *tag, *proto;
+		__be16 *tag, *proto;
 
 		if (!attr->remove_sa) {
 			tag = (void *)ehdr + ETH_HLEN;
-- 
2.7.4

