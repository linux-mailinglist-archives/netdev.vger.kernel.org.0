Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A456B128
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 05:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbiGHD5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 23:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbiGHD5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 23:57:05 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020DD74DED;
        Thu,  7 Jul 2022 20:57:03 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LfKDK5RWyzkXGC;
        Fri,  8 Jul 2022 11:54:57 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 11:57:02 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 11:57:01 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Grant Seltzer <grantseltzer@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next] bpf, docs: Remove deprecated xsk libbpf APIs description
Date:   Fri, 8 Jul 2022 12:27:36 +0800
Message-ID: <20220708042736.669132-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since xsk APIs has been removed from libbpf, let's clean
up the bpf docs simutaneously.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 .../bpf/libbpf/libbpf_naming_convention.rst         | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/Documentation/bpf/libbpf/libbpf_naming_convention.rst b/Documentation/bpf/libbpf/libbpf_naming_convention.rst
index f86360f734a8..c5ac97f3d4c4 100644
--- a/Documentation/bpf/libbpf/libbpf_naming_convention.rst
+++ b/Documentation/bpf/libbpf/libbpf_naming_convention.rst
@@ -9,8 +9,8 @@ described here. It's recommended to follow these conventions whenever a
 new function or type is added to keep libbpf API clean and consistent.
 
 All types and functions provided by libbpf API should have one of the
-following prefixes: ``bpf_``, ``btf_``, ``libbpf_``, ``xsk_``,
-``btf_dump_``, ``ring_buffer_``, ``perf_buffer_``.
+following prefixes: ``bpf_``, ``btf_``, ``libbpf_``, ``btf_dump_``,
+``ring_buffer_``, ``perf_buffer_``.
 
 System call wrappers
 --------------------
@@ -59,15 +59,6 @@ Auxiliary functions and types that don't fit well in any of categories
 described above should have ``libbpf_`` prefix, e.g.
 ``libbpf_get_error`` or ``libbpf_prog_type_by_name``.
 
-AF_XDP functions
--------------------
-
-AF_XDP functions should have an ``xsk_`` prefix, e.g.
-``xsk_umem__get_data`` or ``xsk_umem__create``. The interface consists
-of both low-level ring access functions and high-level configuration
-functions. These can be mixed and matched. Note that these functions
-are not reentrant for performance reasons.
-
 ABI
 ---
 
-- 
2.25.1

