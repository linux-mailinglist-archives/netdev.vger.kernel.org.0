Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0887038FF8D
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhEYKyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:54:22 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:54024 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhEYKyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:54:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Ua4WxO9_1621939968;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Ua4WxO9_1621939968)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 May 2021 18:52:49 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     yisen.zhuang@huawei.com
Cc:     salil.mehta@huawei.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] net: hns: Fix kernel-doc
Date:   Tue, 25 May 2021 18:52:47 +0800
Message-Id: <1621939967-67560-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix function name in hns_ethtool.c kernel-doc comment
to remove these warnings found by clang_w1.

drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:202: warning: expecting
prototype for hns_nic_set_link_settings(). Prototype was for
hns_nic_set_link_ksettings() instead.
drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:837: warning: expecting
prototype for get_ethtool_stats(). Prototype was for
hns_get_ethtool_stats() instead.
drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:894: warning:
expecting prototype for get_strings(). Prototype was for
hns_get_strings() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 'commit 262b38cdb3e4 ("net: ethernet: hisilicon: hns: use phydev
from struct net_device")'
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index da48c05..7e62dcf 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -192,7 +192,7 @@ static int hns_nic_get_link_ksettings(struct net_device *net_dev,
 }
 
 /**
- *hns_nic_set_link_settings - implement ethtool set link ksettings
+ *hns_nic_set_link_ksettings - implement ethtool set link ksettings
  *@net_dev: net_device
  *@cmd: ethtool_link_ksettings
  *retuen 0 - success , negative --fail
@@ -827,7 +827,7 @@ static int hns_set_coalesce(struct net_device *net_dev,
 }
 
 /**
- * get_ethtool_stats - get detail statistics.
+ * hns_get_ethtool_stats - get detail statistics.
  * @netdev: net device
  * @stats: statistics info.
  * @data: statistics data.
@@ -885,7 +885,7 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 }
 
 /**
- * get_strings: Return a set of strings that describe the requested objects
+ * hns_get_strings: Return a set of strings that describe the requested objects
  * @netdev: net device
  * @stringset: string set ID.
  * @data: objects data.
-- 
1.8.3.1

