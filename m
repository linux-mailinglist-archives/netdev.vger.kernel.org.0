Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E73746D737
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbhLHPpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:45:51 -0500
Received: from mga05.intel.com ([192.55.52.43]:36518 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhLHPpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 10:45:51 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="324110517"
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="324110517"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 07:42:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="612124715"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2021 07:42:11 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B8FgAEk001219;
        Wed, 8 Dec 2021 15:42:10 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net v5 0/3] fix bpf_redirect to ifb netdev
Date:   Wed,  8 Dec 2021 16:41:45 +0100
Message-Id: <20211208154145.647078-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date: Wed,  8 Dec 2021 22:54:56 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This patchset try to fix bpf_redirect to ifb netdev.
> Prevent packets loopback and perfromance drop, add check
> in sch egress.

Please provide a changelog in the cover letter. With the links to
your previous versions ideally.
Otherwise it becomes difficult to understand what are the changes
between them.

>
> Tonghao Zhang (3):
>   net: core: set skb useful vars in __bpf_tx_skb
>   net: sched: add check tc_skip_classify in sch egress
>   selftests: bpf: add bpf_redirect to ifb
> 
>  net/core/dev.c                                |  3 +
>  net/core/filter.c                             | 12 ++-
>  tools/testing/selftests/bpf/Makefile          |  1 +
>  .../bpf/progs/test_bpf_redirect_ifb.c         | 13 ++++
>  .../selftests/bpf/test_bpf_redirect_ifb.sh    | 73 +++++++++++++++++++
>  5 files changed, 101 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
>  create mode 100755 tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh
> 
> -- 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> --
> 2.27.0

Al
