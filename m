Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C2B263BB1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 06:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgIJEBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 00:01:11 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49290 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725139AbgIJEBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 00:01:08 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7234D9E82A8E3ED6449D;
        Thu, 10 Sep 2020 12:01:04 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 12:00:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] brcmsmac: phytbl_lcn: Remove unused variable 'dot11lcn_gain_tbl_rev1'
Date:   Thu, 10 Sep 2020 12:00:43 +0800
Message-ID: <20200910040043.30008-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c:108:18: warning: ‘dot11lcn_gain_tbl_rev1’ defined but not used [-Wunused-const-variable=]
 static const u32 dot11lcn_gain_tbl_rev1[] = {
                  ^~~~~~~~~~~~~~~~~~~~~~

commit ebcfc66f56a4 ("brcmsmac: phytbl_lcn: Remove unused array 'dot11lcnphytbl_rx_gain_info_rev1'")
left behind this, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../brcm80211/brcmsmac/phy/phytbl_lcn.c       | 99 -------------------
 1 file changed, 99 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 7526aa441de1..5331b5468e14 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -105,105 +105,6 @@ static const u32 dot11lcn_gain_tbl_rev0[] = {
 	0x00000000,
 };
 
-static const u32 dot11lcn_gain_tbl_rev1[] = {
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000008,
-	0x00000004,
-	0x00000008,
-	0x00000001,
-	0x00000005,
-	0x00000009,
-	0x0000000D,
-	0x00000011,
-	0x00000051,
-	0x00000091,
-	0x00000011,
-	0x00000051,
-	0x00000091,
-	0x000000d1,
-	0x00000053,
-	0x00000093,
-	0x000000d3,
-	0x000000d7,
-	0x00000117,
-	0x00000517,
-	0x00000917,
-	0x00000957,
-	0x00000d57,
-	0x00001157,
-	0x00001197,
-	0x00005197,
-	0x00009197,
-	0x0000d197,
-	0x00011197,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000008,
-	0x00000004,
-	0x00000008,
-	0x00000001,
-	0x00000005,
-	0x00000009,
-	0x0000000D,
-	0x00000011,
-	0x00000051,
-	0x00000091,
-	0x00000011,
-	0x00000051,
-	0x00000091,
-	0x000000d1,
-	0x00000053,
-	0x00000093,
-	0x000000d3,
-	0x000000d7,
-	0x00000117,
-	0x00000517,
-	0x00000917,
-	0x00000957,
-	0x00000d57,
-	0x00001157,
-	0x00005157,
-	0x00009157,
-	0x0000d157,
-	0x00011157,
-	0x00015157,
-	0x00019157,
-	0x0001d157,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-};
-
 static const u16 dot11lcn_aux_gain_idx_tbl_rev0[] = {
 	0x0401,
 	0x0402,
-- 
2.17.1


