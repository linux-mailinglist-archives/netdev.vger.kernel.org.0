Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F7BA78F1
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 04:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfIDCmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 22:42:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5745 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726770AbfIDCmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 22:42:16 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EDCC07904D833413A145;
        Wed,  4 Sep 2019 10:42:14 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 10:42:06 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <anna.schumaker@netapp.com>,
        <trond.myklebust@hammerspace.com>
CC:     <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] net: Use kzfree() directly
Date:   Wed, 4 Sep 2019 10:39:09 +0800
Message-ID: <1567564752-6430-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the help of Coccinelle. We find some place to replace.

@@
expression M, S;
@@

- memset(M, 0, S);
- kfree(M);
+ kzfree(M); 

zhong jiang (3):
  ixgbe: Use kzfree() rather than its implementation.
  sunrpc: Use kzfree rather than its implementation.
  net: mpoa: Use kzfree rather than its implementation.

 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 9 +++------
 net/atm/mpoa_caches.c                          | 6 ++----
 net/sunrpc/auth_gss/gss_krb5_keys.c            | 9 +++------
 3 files changed, 8 insertions(+), 16 deletions(-)

-- 
1.7.12.4

