Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E753F4647D2
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 08:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347217AbhLAHXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 02:23:04 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16329 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347164AbhLAHXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 02:23:03 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J3r713075z91SF;
        Wed,  1 Dec 2021 15:19:09 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Wed, 1 Dec
 2021 15:19:41 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v4 0/2] clean-up for BPF_LOG_KERNEL log level
Date:   Wed, 1 Dec 2021 15:34:56 +0800
Message-ID: <20211201073458.2731595-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

There are just two clean-up patches for BPF_LOG_KERNEL log level:
patch #1 fixes the possible extra newline for bpf_log() and removes
the unnecessary calculation and truncation, and patch #2 disallows
BPF_LOG_KERNEL log level for bpf_btf_load().

Comments are welcome.

Regards,
Tao

Change Log:
v4:
  * rebased on bpf-next
  * add Acked-by tags

v3: https://www.spinics.net/lists/bpf/msg48992.html
  * rebased on bpf-next
  * address comments from Daniel Borkmann:
    patch #1: add prefix "BPF: " instead of "BPF:" for error message
    patch #2: remove uncessary parenthesis, keep the max buffer length
              setting of btf verifier, and add Fixes tag.

v2: https://www.spinics.net/lists/bpf/msg48809.html
  * rebased on bpf-next
  * patch #1: add a trailing newline if needed (suggested by Martin)
  * add patch #2
 
v1: https://www.spinics.net/lists/bpf/msg48550.html

Hou Tao (2):
  bpf: clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level
  bpf: disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)

 include/linux/bpf_verifier.h |  7 +++++++
 kernel/bpf/btf.c             |  3 +--
 kernel/bpf/verifier.c        | 16 +++++++++-------
 3 files changed, 17 insertions(+), 9 deletions(-)

-- 
2.29.2

