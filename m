Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B225926F532
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIREfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgIREfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 00:35:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B015FC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 21:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=IuEQoXED3a1R2JhR0RJXE+dYfdFfK1ROSygKFuifAeU=; b=AWre/EoYMeFkLWe9v8Vc5zUU1D
        zb+KiSBFpyivVhWI2oM+iS0ezDFO5UtcryC/1hcc2b9ueGoOrqZfh6KK0NdUZaN3UwhGihFt2bNWe
        HUws8lkeVvWKTNMBQud5x5Ji4brQ8pHsCU/zn/e/aAxdy2In4F7i+Lnvq4i+/xTxEbWpdjkN6JWEP
        v9H5OF2Zbc8jqFnnd96e1VsLY5dcBMl2f7fY76AlUI8AIp7fCC3GOMnf8zQNCRBmJHHMaubLjywca
        8G5RpH00cX4zl1nLytDk6ce81rAtluv7MVxlyWSsUF2Xyk+YhrWcaKHFwIugWz93nwkrzj/SNzIyI
        iAWod5ow==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJ87X-0003Ci-Pu; Fri, 18 Sep 2020 04:35:40 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org
Subject: [PATCH 7/7 net-next] net: bridge: delete duplicated words
Date:   Thu, 17 Sep 2020 21:35:21 -0700
Message-Id: <20200918043521.17346-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918043521.17346-1-rdunlap@infradead.org>
References: <20200918043521.17346-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop repeated words in net/bridge/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: bridge@lists.linux-foundation.org
---
 net/bridge/br_ioctl.c |    2 +-
 net/bridge/br_vlan.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200917.orig/net/bridge/br_ioctl.c
+++ linux-next-20200917/net/bridge/br_ioctl.c
@@ -103,7 +103,7 @@ static int add_del_if(struct net_bridge
 
 /*
  * Legacy ioctl's through SIOCDEVPRIVATE
- * This interface is deprecated because it was too difficult to
+ * This interface is deprecated because it was too difficult
  * to do the translation for 32/64bit ioctl compatibility.
  */
 static int old_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
--- linux-next-20200917.orig/net/bridge/br_vlan.c
+++ linux-next-20200917/net/bridge/br_vlan.c
@@ -140,7 +140,7 @@ static int __vlan_vid_del(struct net_dev
 	return err == -EOPNOTSUPP ? 0 : err;
 }
 
-/* Returns a master vlan, if it didn't exist it gets created. In all cases a
+/* Returns a master vlan, if it didn't exist it gets created. In all cases
  * a reference is taken to the master vlan before returning.
  */
 static struct net_bridge_vlan *
