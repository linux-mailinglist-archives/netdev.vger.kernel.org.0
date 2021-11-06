Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467C1446C36
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 04:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhKFDR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 23:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhKFDR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 23:17:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6677EC061570
        for <netdev@vger.kernel.org>; Fri,  5 Nov 2021 20:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=257xpXZTZhrRkeI8MnMBy7Q/W2QpOh7S6UfC9AcF3Ts=; b=hr1esui0tRYrryIG49poL4X8B/
        FNt0bpIhjQCtxTqvJYqj6BXiEgQ6BvwSvlALfihL5Ed+wo0CzOrqyPzbWZK7kwe7KMrRTRByb9WzJ
        oDgMUgRQaA96OlSUI61CJaAFKWgEHPN/w6D8MN+lhGBgZ/LXHbfKBaSpy0x+cx84H9lS5To+Y3BBx
        0s0/Q37BUrLMO/+ar+/BGcEw4ORXDuXWLqR93YOlkvoaA5CCcMC6L1pTeVquf3oQV8s5ew/6L5H9O
        KfjSaHbJyAuUNBwdnlX8/e7jTaTtPVDTb8eSJyZl6WWNLoS50gHoFmztKYx33QHjasTcoKBm5h/Zw
        VaKXXDBQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjCAE-00Cc6Y-I7; Sat, 06 Nov 2021 03:14:42 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Peng Li <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH -net] net: hisilicon: fix hsn3_ethtool kernel-doc warnings
Date:   Fri,  5 Nov 2021 20:14:41 -0700
Message-Id: <20211106031441.3004-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix kernel-doc warnings and spacing in hns3_ethtool.c:

hns3_ethtool.c:246: warning: No description found for return value of 'hns3_lp_run_test'
hns3_ethtool.c:408: warning: expecting prototype for hns3_nic_self_test(). Prototype was for hns3_self_test() instead

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Peng Li <lipeng321@huawei.com>
Cc: Guangbin Huang <huangguangbin2@huawei.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-next-20211106.orig/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ linux-next-20211106/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -238,9 +238,11 @@ static void hns3_lb_clear_tx_ring(struct
 }
 
 /**
- * hns3_lp_run_test -  run loopback test
+ * hns3_lp_run_test - run loopback test
  * @ndev: net device
  * @mode: loopback type
+ *
+ * Return: %0 for success or a NIC loopback test error code on failure
  */
 static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 {
@@ -398,7 +400,7 @@ static void hns3_do_selftest(struct net_
 }
 
 /**
- * hns3_nic_self_test - self test
+ * hns3_self_test - self test
  * @ndev: net device
  * @eth_test: test cmd
  * @data: test result
