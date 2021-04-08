Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D852357CE2
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 09:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhDHHAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 03:00:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16078 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHHAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 03:00:35 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FGBtC36MHz1BGNq;
        Thu,  8 Apr 2021 14:58:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 15:00:16 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <aelior@marvell.com>, <GR-everest-linux-l2@marvell.com>
CC:     <netdev@vger.kernel.org>, Tian Tao <tiantao6@hisilicon.com>,
        Zhiqi Song <songzhiqi1@huawei.com>
Subject: [PATCH] net: qed: remove unused including <linux/version.h>
Date:   Thu, 8 Apr 2021 15:00:41 +0800
Message-ID: <1617865241-42742-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
---
 include/linux/qed/qed_ll2_if.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/qed/qed_ll2_if.h b/include/linux/qed/qed_ll2_if.h
index 2f64ed7..ea273ba 100644
--- a/include/linux/qed/qed_ll2_if.h
+++ b/include/linux/qed/qed_ll2_if.h
@@ -12,7 +12,6 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/skbuff.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/qed/qed_if.h>
-- 
2.7.4

