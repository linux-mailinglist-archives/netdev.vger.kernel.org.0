Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA2F3F2499
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 04:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbhHTCIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 22:08:22 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:14248 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbhHTCIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 22:08:21 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GrQ4h1x9Dz1CYjc;
        Fri, 20 Aug 2021 10:07:16 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 10:07:41 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 10:07:41 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/2] Some minor optimization for page pool
Date:   Fri, 20 Aug 2021 10:06:33 +0800
Message-ID: <1629425195-10130-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Use relexed atomic for release side accounting
Patch 2: Minor optimize for page_pool_dma_map() function

Yunsheng Lin (2):
  page_pool: use relexed atomic for release side accounting
  page_pool: optimize the cpu sync operation when DMA mapping

 net/core/page_pool.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.7.4

