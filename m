Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0391940DB82
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbhIPNmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:42:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19989 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240272AbhIPNme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 09:42:34 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H9J663nnnzbmYp;
        Thu, 16 Sep 2021 21:37:02 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 16 Sep 2021 21:41:09 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 16 Sep
 2021 21:41:09 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH 0/3] add support for writable bare tracepoint
Date:   Thu, 16 Sep 2021 21:55:08 +0800
Message-ID: <20210916135511.3787194-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The patchset series supports writable context for bare tracepoint.

The main idea comes from patchset "writable contexts for bpf 
raw tracepoints" [1], but it only supports normal tracepoint
with associated trace event under tracefs. Bare tracepoint
is more light-weight and doesn't have the ABI burden of
normal tracepoint, so add support for it in BPF.

Any comments are welcome.

[1]: https://lore.kernel.org/lkml/20190426184951.21812-1-mmullins@fb.com

Hou Tao (3):
  bpf: support writable context for bare tracepoint
  libbpf: support detecting and attaching of writable tracepoint program
  bpf/selftests: add test for writable bare tracepoint

 include/trace/bpf_probe.h                     | 19 +++++++--
 tools/lib/bpf/libbpf.c                        |  4 ++
 .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 +++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 +++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
 .../selftests/bpf/prog_tests/module_attach.c  | 40 ++++++++++++++++++-
 .../selftests/bpf/progs/test_module_attach.c  | 14 +++++++
 7 files changed, 101 insertions(+), 6 deletions(-)

-- 
2.29.2

