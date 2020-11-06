Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12AE2A9108
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgKFILc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:11:32 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:57520 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725616AbgKFILc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:11:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UEPFNeZ_1604650287;
Received: from aliy80.localdomain(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEPFNeZ_1604650287)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Nov 2020 16:11:28 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
To:     alex.aring@gmail.com
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/ieee802154: remove unused macros to tame gcc
Date:   Fri,  6 Nov 2020 16:10:37 +0800
Message-Id: <1604650237-22192-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Alexander Aring <alex.aring@gmail.com> 
Cc: Stefan Schmidt <stefan@datenfreihafen.org> 
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: Jakub Kicinski <kuba@kernel.org> 
Cc: linux-wpan@vger.kernel.org 
Cc: netdev@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 net/ieee802154/nl802154.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 7c5a1aa5adb4..1cebdcedc48c 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2098,11 +2098,7 @@ static int nl802154_del_llsec_seclevel(struct sk_buff *skb,
 #define NL802154_FLAG_NEED_NETDEV	0x02
 #define NL802154_FLAG_NEED_RTNL		0x04
 #define NL802154_FLAG_CHECK_NETDEV_UP	0x08
-#define NL802154_FLAG_NEED_NETDEV_UP	(NL802154_FLAG_NEED_NETDEV |\
-					 NL802154_FLAG_CHECK_NETDEV_UP)
 #define NL802154_FLAG_NEED_WPAN_DEV	0x10
-#define NL802154_FLAG_NEED_WPAN_DEV_UP	(NL802154_FLAG_NEED_WPAN_DEV |\
-					 NL802154_FLAG_CHECK_NETDEV_UP)
 
 static int nl802154_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 			     struct genl_info *info)
-- 
1.8.3.1

