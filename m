Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F7549F57E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243222AbiA1Il5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:41:57 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17823 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243158AbiA1Ilz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:41:55 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JlWB81Ww1z9sbd;
        Fri, 28 Jan 2022 16:40:32 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 28 Jan
 2022 16:41:48 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH bpf-next v2 0/2] bpf, arm64: enable kfunc call
Date:   Thu, 27 Jan 2022 15:15:30 +0800
Message-ID: <20220127071532.384888-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The simple patchset tries to enable kfunc call for arm64. Patch #1 just
overrides bpf_jit_supports_kfunc_call() to enable kfunc call and patch #2
add a test to ensure s32 is sufficient for kfunc offset.

Change Log:
v2: 
  * add a test to check whether imm will be overflowed for kfunc call

v1: https://lore.kernel.org/bpf/20220119144942.305568-1-houtao1@huawei.com

Hou Tao (2):
  bpf, arm64: enable kfunc call
  selftests/bpf: check whether s32 is sufficient for kfunc offset

 arch/arm64/net/bpf_jit_comp.c                 |  5 ++
 .../selftests/bpf/prog_tests/ksyms_module.c   | 72 +++++++++++++++++++
 2 files changed, 77 insertions(+)

-- 
2.27.0

