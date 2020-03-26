Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A249719369B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgCZDQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:16:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12135 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727575AbgCZDQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:16:32 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0A5A44BFD47746ECFF9B;
        Thu, 26 Mar 2020 11:16:29 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 26 Mar 2020
 11:16:22 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH bpf-next] bpf: remove unused vairable 'bpf_xdp_link_lops'
Date:   Thu, 26 Mar 2020 11:16:13 +0800
Message-ID: <20200326031613.19372-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel/bpf/syscall.c:2263:34: warning: 'bpf_xdp_link_lops' defined but not used [-Wunused-const-variable=]
 static const struct bpf_link_ops bpf_xdp_link_lops;
                                  ^~~~~~~~~~~~~~~~~

commit 70ed506c3bbc ("bpf: Introduce pinnable bpf_link abstraction")
involded this unused variable, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 kernel/bpf/syscall.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 85567a6ea5f9..7774e55c9881 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2252,7 +2252,6 @@ static int bpf_link_release(struct inode *inode, struct file *filp)
 #ifdef CONFIG_PROC_FS
 static const struct bpf_link_ops bpf_raw_tp_lops;
 static const struct bpf_link_ops bpf_tracing_link_lops;
-static const struct bpf_link_ops bpf_xdp_link_lops;
 
 static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 {
-- 
2.17.1


