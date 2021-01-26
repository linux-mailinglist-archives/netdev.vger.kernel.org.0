Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A183055F1
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316918AbhAZXMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbhAZVJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 16:09:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D494D221EF;
        Tue, 26 Jan 2021 21:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611695319;
        bh=bkBpnlPXphp5YIBfQclI0r681mrPpCajCNo/bOnVu/4=;
        h=From:To:Cc:Subject:Date:From;
        b=PxjT79g46yNhKWpaZqhTaALdDs9CeoQFUsAHg9dLQQG7uD9HgNyxk7kCMTVKHxkvV
         XC97dY9vXl51dd8yEzOlJW52zO30H/+pp8ejjA8uLXckamJKMupCCqBn98n4EC0qxT
         xzvt305NmCOMIHz4l8u39U3J4/ZH3/+ARyQXddI7d2GDipX/JctvFlw7WAYChXTgHa
         44c5ZZ3/NN+XzzBYVEgW9UB3x6aBVPBZwfPaBstb7LGMAb1G9ZVN/fS80CgHKKQ2MZ
         4n27C8dOXkEqB0Ty7h0+DPU/mK3gn1qsJ30ocNwkrOcf0C1vR5cha88zzqICfNz0Qs
         1a4f37iat7f1w==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] octeontx2-af: Fix 'physical' typos
Date:   Tue, 26 Jan 2021 15:08:30 -0600
Message-Id: <20210126210830.2919352-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Fix misspellings of "physical".

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c      | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e8fd712860a1..565d9373bfe4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -646,7 +646,7 @@ static int rvu_setup_msix_resources(struct rvu *rvu)
 	}
 
 	/* HW interprets RVU_AF_MSIXTR_BASE address as an IOVA, hence
-	 * create a IOMMU mapping for the physcial address configured by
+	 * create an IOMMU mapping for the physical address configured by
 	 * firmware and reconfig RVU_AF_MSIXTR_BASE with IOVA.
 	 */
 	cfg = rvu_read64(rvu, BLKADDR_RVUM, RVU_PRIV_CONST);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 634d60655a74..07ec85aebcca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+/* Marvell OcteonTx2 RVU Physical Function ethernet driver
  *
  * Copyright (C) 2020 Marvell International Ltd.
  *
-- 
2.25.1

