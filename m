Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA78A796F
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 05:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfIDDt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 23:49:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55714 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726770AbfIDDt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 23:49:27 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5BD1BE39B1A16764AF13;
        Wed,  4 Sep 2019 11:49:25 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 11:49:18 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <kvalo@codeaurora.org>, <pkshih@realtek.com>
CC:     <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] net: remove an redundant continue
Date:   Wed, 4 Sep 2019 11:46:21 +0800
Message-ID: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the help of Coccinelle. we find some place to replace.

@@

for (...;...;...) {
   ...
   if (...) {
     ...
-   continue;
   }
}


zhong jiang (3):
  rtlwifi: Remove an unnecessary continue in
    _rtl8723be_phy_config_bb_with_pgheaderfile
  nfp: Drop unnecessary continue in nfp_net_pf_alloc_vnics
  ath10k: Drop unnecessary continue in ath10k_mac_update_vif_chan

 drivers/net/ethernet/netronome/nfp/nfp_net_main.c    | 4 +---
 drivers/net/wireless/ath/ath10k/mac.c                | 4 +---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 1 -
 3 files changed, 2 insertions(+), 7 deletions(-)

-- 
1.7.12.4

