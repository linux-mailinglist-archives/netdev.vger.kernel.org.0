Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27FD310253
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 02:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhBEBkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 20:40:37 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12424 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhBEBkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 20:40:36 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DWykK2zzvzjDZp;
        Fri,  5 Feb 2021 09:38:49 +0800 (CST)
Received: from huawei.com (10.175.104.82) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Fri, 5 Feb 2021
 09:39:45 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <bpf@vger.kernel.org>, <kpsingh@kernel.org>,
        <john.fastabend@gmail.com>, <revest@chromium.org>, <ast@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xujia39@huawei.com>
Subject: [PATCH bpf-next] bpf: clean up for 'const static' in bpf_lsm.c
Date:   Fri, 5 Feb 2021 09:52:19 +0800
Message-ID: <20210205015219.2939361-1-xujia39@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prefer 'static const' over 'const static' here

Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 kernel/bpf/bpf_lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 1622a44d1617..75b1c678d558 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -67,7 +67,7 @@ BPF_CALL_2(bpf_bprm_opts_set, struct linux_binprm *, bprm, u64, flags)
 
 BTF_ID_LIST_SINGLE(bpf_bprm_opts_set_btf_ids, struct, linux_binprm)
 
-const static struct bpf_func_proto bpf_bprm_opts_set_proto = {
+static const struct bpf_func_proto bpf_bprm_opts_set_proto = {
 	.func		= bpf_bprm_opts_set,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
@@ -88,7 +88,7 @@ static bool bpf_ima_inode_hash_allowed(const struct bpf_prog *prog)
 
 BTF_ID_LIST_SINGLE(bpf_ima_inode_hash_btf_ids, struct, inode)
 
-const static struct bpf_func_proto bpf_ima_inode_hash_proto = {
+static const struct bpf_func_proto bpf_ima_inode_hash_proto = {
 	.func		= bpf_ima_inode_hash,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-- 
2.22.0

