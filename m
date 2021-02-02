Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D2930C9C9
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbhBBS3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:29:19 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:35046 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238505AbhBBS1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:27:06 -0500
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 112IPk05011521;
        Tue, 2 Feb 2021 10:25:47 -0800
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rahul.lakkireddy@chelsio.com,
        rajur@chelsio.com
Subject: [PATCH net-next] cxgb4: Add new T6 PCI device id 0x6092
Date:   Tue,  2 Feb 2021 23:55:11 +0530
Message-Id: <20210202182511.8109-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h b/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h
index 0c5373462ced..0b1b5f9c67d4 100644
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
2.9.5

