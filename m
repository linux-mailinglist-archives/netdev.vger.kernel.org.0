Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AAA39D9AD
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 12:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFGKdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 06:33:16 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:34763 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230194AbhFGKdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 06:33:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Ubb.YZi_1623061880;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ubb.YZi_1623061880)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Jun 2021 18:31:22 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     aelior@marvell.com
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] qed: Fix duplicate included linux/kernel.h
Date:   Mon,  7 Jun 2021 18:31:14 +0800
Message-Id: <1623061874-35234-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the following includecheck warning:

./drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h: linux/kernel.h
is included more than once.

No functional change.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h
index 4c7ac2b..1d5ddc2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h
@@ -7,7 +7,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/types.h>
-- 
1.8.3.1

