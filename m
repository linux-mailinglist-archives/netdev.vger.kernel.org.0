Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AF230630E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhA0SOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:14:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbhA0SOy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 13:14:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFA3164D9A;
        Wed, 27 Jan 2021 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611771252;
        bh=wm3JJ5QQ1TlsnXK5Lb7xrhZUrgey1pClYUoYhxm/oUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnZT0KaEwdrl9kfUSTyaMDjeoohOz8kMay6powTDE4e6mwF/v7mHZSNJw4rRG1cLy
         LaGWaijxFbAfL8ZTjH92ZNvouQ1eS9VHddLfYhX1eVRthpp3E6Ijuok7zx+Lvw7ZdC
         ZkzM7mbWftrj8rUI65XigmEF6B1xNmQcE5uUXDFRsKGUoeemo3nCWpyUJ+MusKOkVF
         NpHEOYV/MZYCM6BwbOF6OUU5AP1Dysb8ibHgSZWWsRmZIyt694ZV/yyMCMijDCi00w
         ZfsUoE3YPiro/gcyciDishBrjWcQ+8kjVYIq5us99+NxXqLg6vcqxqEWYMzjFWjy7v
         rsBkhcjOi3B9Q==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2] octeontx2-af: Fix 'physical' typos
Date:   Wed, 27 Jan 2021 12:13:59 -0600
Message-Id: <20210127181359.3008316-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210126210830.2919352-1-helgaas@kernel.org>
References: <20210126210830.2919352-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Fix misspellings of "physical".

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
Thanks, Willem!

 drivers/net/ethernet/marvell/octeontx2/af/rvu.c         | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index be8ccfce1848..b4d6a6bb3070 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+/* Marvell OcteonTx2 RVU Physical Function ethernet driver
  *
  * Copyright (C) 2020 Marvell.
  */
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

