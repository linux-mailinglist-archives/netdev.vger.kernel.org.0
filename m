Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6B382615
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbhEQIAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2938 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbhEQIAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:13 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FkBK70v1WzCtX8;
        Mon, 17 May 2021 15:56:11 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>
Subject: [PATCH v2 20/24] net: socionext: Demote non-compliant kernel-doc headers
Date:   Mon, 17 May 2021 12:45:31 +0800
Message-ID: <20210517044535.21473-21-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/socionext/sni_ave.c:28: warning: expecting prototype for sni_ave.c(). Prototype was for AVE_IDR() instead

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index fcbb4bb31408..5eb6bb4f7b6c 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/**
+/*
  * sni_ave.c - Socionext UniPhier AVE ethernet driver
  * Copyright 2014 Panasonic Corporation
  * Copyright 2015-2017 Socionext Inc.
-- 
2.17.1

