Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4138F862
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhEYC6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:58:45 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5767 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhEYC6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:58:43 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FpzDJ6CHHzlXsP;
        Tue, 25 May 2021 10:53:36 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 10:57:12 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 10:57:11 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 0/1] bpf: fix spelling mistakes
Date:   Tue, 25 May 2021 10:56:58 +0800
Message-ID: <20210525025659.8898-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The files being checked:
kernel/bpf/
include/linux/bpf*.h


Zhen Lei (1):
  bpf: fix spelling mistakes

 include/linux/bpf_local_storage.h |  2 +-
 kernel/bpf/bpf_inode_storage.c    |  2 +-
 kernel/bpf/btf.c                  |  6 +++---
 kernel/bpf/devmap.c               |  4 ++--
 kernel/bpf/hashtab.c              |  4 ++--
 kernel/bpf/reuseport_array.c      |  2 +-
 kernel/bpf/trampoline.c           |  2 +-
 kernel/bpf/verifier.c             | 12 ++++++------
 8 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.25.1


