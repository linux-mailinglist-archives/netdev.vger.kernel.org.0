Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C33D43FD6E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhJ2Nkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:40:36 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26134 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhJ2Nkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 09:40:35 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hgk386MJLz1DHwC;
        Fri, 29 Oct 2021 21:36:04 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 21:38:03 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 29 Oct
 2021 21:38:02 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 0/2] clean-up for BPF_LOG_KERNEL log level
Date:   Fri, 29 Oct 2021 21:53:19 +0800
Message-ID: <20211029135321.94065-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
v2:
  * rebased on bpf-next
  * patch #1: add a trailing newline if needed (suggested by Martin)
  * add patch #2
 
v1: https://www.spinics.net/lists/bpf/msg48550.html

Hou Tao (2):
  bpf: clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level
  bpf: disallow BPF_LOG_KERNEL log level for sys(BPF_BTF_LOAD)

 include/linux/bpf_verifier.h |  6 ++++++
 kernel/bpf/btf.c             |  3 +--
 kernel/bpf/verifier.c        | 16 +++++++++-------
 3 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.29.2

