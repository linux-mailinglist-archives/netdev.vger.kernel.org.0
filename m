Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEA4220248
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 04:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgGOCVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:21:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7852 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726458AbgGOCVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 22:21:36 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 73DC6E0FED7123AA26CD;
        Wed, 15 Jul 2020 10:21:31 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Jul 2020
 10:21:22 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <paul@paul-moore.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] cipso: Remove unused inline functions
Date:   Wed, 15 Jul 2020 10:18:46 +0800
Message-ID: <20200715021846.34096-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They are not used any more since commit b1edeb102397 ("netlabel: Replace
protocol/NetLabel linking with refrerence counts")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/net/cipso_ipv4.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/net/cipso_ipv4.h b/include/net/cipso_ipv4.h
index 428b6725b248..53dd7d988a2d 100644
--- a/include/net/cipso_ipv4.h
+++ b/include/net/cipso_ipv4.h
@@ -150,18 +150,6 @@ static inline int cipso_v4_doi_walk(u32 *skip_cnt,
 {
 	return 0;
 }
-
-static inline int cipso_v4_doi_domhsh_add(struct cipso_v4_doi *doi_def,
-					  const char *domain)
-{
-	return -ENOSYS;
-}
-
-static inline int cipso_v4_doi_domhsh_remove(struct cipso_v4_doi *doi_def,
-					     const char *domain)
-{
-	return 0;
-}
 #endif /* CONFIG_NETLABEL */
 
 /*
-- 
2.17.1


