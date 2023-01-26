Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8A567C4BF
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjAZHOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbjAZHOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5469C46702;
        Wed, 25 Jan 2023 23:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08256B819AE;
        Thu, 26 Jan 2023 07:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36E8C4339B;
        Thu, 26 Jan 2023 07:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717270;
        bh=ppdyWXNHVoRCfY1wWxqhZ+vENqdZKJiMtvqIlOSU6yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MY9g9SQOKWjSyyi2TgKBpP6hHUHhzbSVjwI/JumLoLY3tpA0xpq9adp62lST3d27T
         pY7RdJx05kLgFaQ2MUu72vUCRRe7r42o9kXjq/TKeCzqirbM6JemRhSxSpJ37shcG5
         XG3dlRoIfNvbvHWquBuE4TGHG+WizRBE521xjGyHJ+N7zh2APtzVRkbfKECgKDqkvs
         kGGLpDSFejkX0CZjXMLGebDTrp9vufYfT4v1tyG+WqIdA+Bk/xE7282OK+Jo+zrt94
         JMXbQK5yVur2/YFsTZl3ymYPIXMCNRbtSmsXvODmuee0SRJor3SY3ZztfQq+C/+moJ
         Ym8CCJINxL7aw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, santosh.shilimkar@oracle.com,
        huangguangbin2@huawei.com, lipeng321@huawei.com,
        linux-scsi@vger.kernel.org, bpf@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next 05/11] net: add missing includes of linux/sched/clock.h
Date:   Wed, 25 Jan 2023 23:14:18 -0800
Message-Id: <20230126071424.1250056-6-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126071424.1250056-1-kuba@kernel.org>
References: <20230126071424.1250056-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Number of files depend on linux/sched/clock.h getting included
by linux/skbuff.h which soon will no longer be the case.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: yisen.zhuang@huawei.com
CC: salil.mehta@huawei.com
CC: james.smart@broadcom.com
CC: dick.kennedy@broadcom.com
CC: jejb@linux.ibm.com
CC: martin.petersen@oracle.com
CC: ast@kernel.org
CC: daniel@iogearbox.net
CC: john.fastabend@gmail.com
CC: andrii@kernel.org
CC: martin.lau@linux.dev
CC: song@kernel.org
CC: yhs@fb.com
CC: kpsingh@kernel.org
CC: sdf@google.com
CC: haoluo@google.com
CC: jolsa@kernel.org
CC: santosh.shilimkar@oracle.com
CC: huangguangbin2@huawei.com
CC: lipeng321@huawei.com
CC: linux-scsi@vger.kernel.org
CC: bpf@vger.kernel.org
CC: linux-rdma@vger.kernel.org
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c     | 2 ++
 drivers/scsi/lpfc/lpfc_init.c                              | 1 +
 include/linux/filter.h                                     | 1 +
 net/rds/ib_recv.c                                          | 1 +
 net/rds/recv.c                                             | 1 +
 6 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 142415c84c6b..a0b46e7d863e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2018-2019 Hisilicon Limited. */
 
 #include <linux/device.h>
+#include <linux/sched/clock.h>
 
 #include "hclge_debugfs.h"
 #include "hclge_err.h"
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 6efd768cc07c..3f35227ef1fa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0+
 /* Copyright (c) 2016-2017 Hisilicon Limited. */
 
+#include <linux/sched/clock.h>
+
 #include "hclge_err.h"
 
 static const struct hclge_hw_error hclge_imp_tcm_ecc_int[] = {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 25ba20e42825..389a35308be3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -30,6 +30,7 @@
 #include <linux/kthread.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/sched/clock.h>
 #include <linux/ctype.h>
 #include <linux/aer.h>
 #include <linux/slab.h>
diff --git a/include/linux/filter.h b/include/linux/filter.h
index ccc4a4a58c72..1727898f1641 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -14,6 +14,7 @@
 #include <linux/printk.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/capability.h>
 #include <linux/set_memory.h>
 #include <linux/kallsyms.h>
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index cfbf0e129cba..e53b7f266bd7 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -31,6 +31,7 @@
  *
  */
 #include <linux/kernel.h>
+#include <linux/sched/clock.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 5b426dc3634d..c71b923764fd 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -35,6 +35,7 @@
 #include <net/sock.h>
 #include <linux/in.h>
 #include <linux/export.h>
+#include <linux/sched/clock.h>
 #include <linux/time.h>
 #include <linux/rds.h>
 
-- 
2.39.1

