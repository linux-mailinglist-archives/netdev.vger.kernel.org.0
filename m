Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBBF57104A
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 04:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiGLCht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 22:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiGLChs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 22:37:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70838E4C7;
        Mon, 11 Jul 2022 19:37:46 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LhlGt72WJzcfdB;
        Tue, 12 Jul 2022 10:35:34 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 10:37:45 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 10:37:44 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next 0/3] Use lightweigt version of bpftool
Date:   Tue, 12 Jul 2022 11:08:10 +0800
Message-ID: <20220712030813.865410-1-pulehui@huawei.com>
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

Currently, samples/bpf, tools/runqslower and bpf/iterators use bpftool
for vmlinux.h, skeleton, and static linking only. We can  use lightweight
bootstrap version of bpftool to handle these, and it will be faster. 

Pu Lehui (3):
  samples: bpf: Fix cross-compiling error by using bootstrap bpftool
  tools: runqslower: build and use lightweight bootstrap version of
    bpftool
  bpf: iterators: build and use lightweight bootstrap version of bpftool

 kernel/bpf/preload/iterators/Makefile | 13 +++++++++----
 samples/bpf/Makefile                  | 16 +++++++++++-----
 tools/bpf/runqslower/Makefile         | 10 ++++++++--
 3 files changed, 28 insertions(+), 11 deletions(-)

-- 
2.25.1

