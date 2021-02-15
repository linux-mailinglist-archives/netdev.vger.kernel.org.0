Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E630531C1BA
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 19:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhBOSix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 13:38:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230467AbhBOSiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 13:38:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9870064E13;
        Mon, 15 Feb 2021 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613414223;
        bh=UBu0Do1tJBKsqNSF6lz//geyXMo1BLqDEoi/eFKxZ9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=la1kj+1Y6jlE+N+oX4NPZPMNX0EQqrX73l4vjI7XlsqCAcQqemyip5NuNu2zgLtLJ
         2a65zTaTxpyYDdRicEJyTp5ak/+kACys5TZi8812nq63aIGxbQoJnk3knM9+puvDdh
         BC9gJUkea1ZPfpTg2BSdmBJ5nBGlvyNDYS6W97zeVwrf51mac3aJEC597eUT2/cfRV
         ADHgGJkMsO1qmlsPknSzf1YVt+bb3Vl0lxMeB/aHh9BZiZZrtkJ+nt9fM9vLiVSVVq
         I3Bv+7hobO9MyPsKALSna/4517Oh2TtuzfM3ctX6+WBSv3QPcsuPWhuh+cCCGeYGK8
         m/y/hYK/zYRWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/4] cxgb4: Add new T6 PCI device id 0x6092
Date:   Mon, 15 Feb 2021 13:36:58 -0500
Message-Id: <20210215183700.122100-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210215183700.122100-1-sashal@kernel.org>
References: <20210215183700.122100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit 3401e4aa43a540881cc97190afead650e709c418 ]

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Link: https://lore.kernel.org/r/20210202182511.8109-1-rajur@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h b/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h
index 0c5373462cedb..0b1b5f9c67d47 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h
@@ -219,6 +219,7 @@ CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN
 	CH_PCI_ID_TABLE_FENTRY(0x6089), /* Custom T62100-KR */
 	CH_PCI_ID_TABLE_FENTRY(0x608a), /* Custom T62100-CR */
 	CH_PCI_ID_TABLE_FENTRY(0x608b), /* Custom T6225-CR */
+	CH_PCI_ID_TABLE_FENTRY(0x6092), /* Custom T62100-CR-LOM */
 CH_PCI_DEVICE_ID_TABLE_DEFINE_END;
 
 #endif /* __T4_PCI_ID_TBL_H__ */
-- 
2.27.0

