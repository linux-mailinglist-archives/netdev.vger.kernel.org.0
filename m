Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332D31B5272
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgDWC0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:26:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51406 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726724AbgDWC0h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 22:26:37 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 24870E7B8AC50BD116A2;
        Thu, 23 Apr 2020 10:26:35 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Apr 2020 10:26:27 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] bpf: Make bpf_link_fops static
Date:   Thu, 23 Apr 2020 10:32:40 +0800
Message-ID: <1587609160-117806-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

kernel/bpf/syscall.c:2289:30: warning: symbol 'bpf_link_fops' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8608d6e..fcb80e1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2286,7 +2286,7 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 }
 #endif
 
-const struct file_operations bpf_link_fops = {
+static const struct file_operations bpf_link_fops = {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= bpf_link_show_fdinfo,
 #endif
-- 
2.6.2

