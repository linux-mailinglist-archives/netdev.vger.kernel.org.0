Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD771DA8A9
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 05:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgETDiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 23:38:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4822 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728129AbgETDiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 23:38:06 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 00B0D94C0529989C83BF;
        Wed, 20 May 2020 11:38:04 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 20 May 2020 11:37:55 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH 0/2 v3] net: ethernet: ti: fix some return value check
Date:   Wed, 20 May 2020 11:41:14 +0800
Message-ID: <20200520034116.170946-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset convert cpsw_ale_create() to return PTR_ERR() only, and
changed all the caller to check IS_ERR() instead of NULL.

Since v2:
1) rebased on net.git, as Jakub's suggest
2) split am65-cpsw-nuss.c changes, as Grygorii's suggest


Wei Yongjun (2):
  net: ethernet: ti: fix some return value check of cpsw_ale_create()
  net: ethernet: ti: am65-cpsw-nuss: fix error handling of
    am65_cpsw_nuss_probe

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 3 ++-
 drivers/net/ethernet/ti/cpsw_ale.c       | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c      | 4 ++--
 drivers/net/ethernet/ti/netcp_ethss.c    | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.25.1

