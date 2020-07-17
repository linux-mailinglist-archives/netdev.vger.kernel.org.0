Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780AF2238DB
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgGQKAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgGQKAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:00:40 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989A7C08C5C0
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:00:39 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id g2so5706930lfb.0
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bADpGl86q6EJLZnxn8kLzjQmK/lNofsyPZihu7kJjnE=;
        b=J+d4WdPFwlQ5nyy2LpQmIGqa6R44yx9kT4TDAnrEbBqRMBV21zuTxTPkQvAZPqVtxi
         zHd7koRS4YSNRudHC3kbvTL9Md3VHJLF/uKbTS8V69D5V+WdSnJh9niBFD5YqcU+RcVv
         PoDfCXKmAqTeh3B6NyrcbuHo2vb0NN45SUwDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bADpGl86q6EJLZnxn8kLzjQmK/lNofsyPZihu7kJjnE=;
        b=AXxNB3VwHevdpA7RQLfpPMMlZSWTcfYpDQpXpAqv2QCXwuPGmhfpc3xgIQ2+8osqvk
         O2XxIqzvrM7kOABLpqDvvtqfQFdWm9qCckXCCN5fCGhdCtleFjdm6OI5L8pqARWTfGd9
         2fCVBrz7vpsxkLKKYEXje4+AGmFplAZrV3IJIYUVdG/mZmnmSNNfIt4FILrkqxzw9qot
         SBSVSbGdVbeOEPv6oI83rr+9fsxXXxcewEDSBCoXtIUc2hquvlgp6/DpbdhnltiMRgAg
         TfUJy03iU2DZOgYVtfmKZLqGsxznoms2sTq9O8I2NuFq3Ic/kN/kFnXdjrIIpyM5TdLB
         7BKw==
X-Gm-Message-State: AOAM530Aw4Bf2mOBAORk5Pc0I5R7vHU8BOZGaDjwSaKurw8DF7cH1Msa
        IXHLUGqRTTXtB6kzR6e9V5jhow==
X-Google-Smtp-Source: ABdhPJwf4U/87U6kKA/b2yinQog7obuAL+02d/opObmNNbsQFgD6Fj9HbuDt9hXVCQApTvZugmqQtA==
X-Received: by 2002:a19:ae19:: with SMTP id f25mr4464327lfc.63.1594980037894;
        Fri, 17 Jul 2020 03:00:37 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id i19sm1708411lfi.14.2020.07.17.03.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:00:37 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:00:13 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in
 CPUMAP
Message-ID: <20200717120013.0926a74e@toad>
In-Reply-To: <cover.1594734381.git.lorenzo@kernel.org>
References: <cover.1594734381.git.lorenzo@kernel.org>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 15:56:33 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Similar to what David Ahern proposed in [1] for DEVMAPs, introduce the
> capability to attach and run a XDP program to CPUMAP entries.
> The idea behind this feature is to add the possibility to define on which CPU
> run the eBPF program if the underlying hw does not support RSS.
> I respin patch 1/6 from a previous series sent by David [2].
> The functionality has been tested on Marvell Espressobin, i40e and mlx5.
> Detailed tests results can be found here:
> https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap/cpumap04-map-xdp-prog.org
> 
> Changes since v6:
> - rebase on top of bpf-next
> - move bpf_cpumap_val and bpf_prog in the first bpf_cpu_map_entry cache-line
> 
> Changes since v5:
> - move bpf_prog_put() in put_cpu_map_entry()
> - remove READ_ONCE(rcpu->prog) in cpu_map_bpf_prog_run_xdp
> - rely on bpf_prog_get_type() instead of bpf_prog_get_type_dev() in
>   __cpu_map_load_bpf_program()
> 
> Changes since v4:
> - move xdp_clear_return_frame_no_direct inside rcu section
> - update David Ahern's email address
> 
> Changes since v3:
> - fix typo in commit message
> - fix access to ctx->ingress_ifindex in cpumap bpf selftest
> 
> Changes since v2:
> - improved comments
> - fix return value in xdp_convert_buff_to_frame
> - added patch 1/9: "cpumap: use non-locked version __ptr_ring_consume_batched"
> - do not run kmem_cache_alloc_bulk if all frames have been consumed by the XDP
>   program attached to the CPUMAP entry
> - removed bpf_trace_printk in kselftest
> 
> Changes since v1:
> - added performance test results
> - added kselftest support
> - fixed memory accounting with page_pool
> - extended xdp_redirect_cpu_user.c to load an external program to perform
>   redirect
> - reported ifindex to attached eBPF program
> - moved bpf_cpumap_val definition to include/uapi/linux/bpf.h
> 
> [1] https://patchwork.ozlabs.org/project/netdev/cover/20200529220716.75383-1-dsahern@kernel.org/
> [2] https://patchwork.ozlabs.org/project/netdev/patch/20200513014607.40418-2-dsahern@kernel.org/
> 
> David Ahern (1):
>   net: refactor xdp_convert_buff_to_frame
> 
> Jesper Dangaard Brouer (1):
>   cpumap: use non-locked version __ptr_ring_consume_batched
> 
> Lorenzo Bianconi (7):
>   samples/bpf: xdp_redirect_cpu_user: do not update bpf maps in option
>     loop
>   cpumap: formalize map value as a named struct
>   bpf: cpumap: add the possibility to attach an eBPF program to cpumap
>   bpf: cpumap: implement XDP_REDIRECT for eBPF programs attached to map
>     entries
>   libbpf: add SEC name for xdp programs attached to CPUMAP
>   samples/bpf: xdp_redirect_cpu: load a eBPF program on cpumap
>   selftest: add tests for XDP programs in CPUMAP entries
> 
>  include/linux/bpf.h                           |   6 +
>  include/net/xdp.h                             |  41 ++--
>  include/trace/events/xdp.h                    |  16 +-
>  include/uapi/linux/bpf.h                      |  14 ++
>  kernel/bpf/cpumap.c                           | 162 +++++++++++---
>  net/core/dev.c                                |   9 +
>  samples/bpf/xdp_redirect_cpu_kern.c           |  25 ++-
>  samples/bpf/xdp_redirect_cpu_user.c           | 209 ++++++++++++++++--
>  tools/include/uapi/linux/bpf.h                |  14 ++
>  tools/lib/bpf/libbpf.c                        |   2 +
>  .../bpf/prog_tests/xdp_cpumap_attach.c        |  70 ++++++
>  .../bpf/progs/test_xdp_with_cpumap_helpers.c  |  36 +++
>  12 files changed, 531 insertions(+), 73 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
> 

This started showing up with when running ./test_progs from recent
bpf-next (bfdfa51702de). Any chance it is related?

[ 2950.440613] =============================================

[ 3073.281578] INFO: task cpumap/0/map:26:536 blocked for more than 860 seconds.
[ 3073.285492]       Tainted: G        W         5.8.0-rc4-01471-g15d51f3a516b #814
[ 3073.289177] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3073.293021] cpumap/0/map:26 D    0   536      2 0x00004000
[ 3073.295755] Call Trace:
[ 3073.297143]  __schedule+0x5ad/0xf10
[ 3073.299032]  ? pci_mmcfg_check_reserved+0xd0/0xd0
[ 3073.301416]  ? static_obj+0x31/0x80
[ 3073.303277]  ? mark_held_locks+0x24/0x90
[ 3073.305313]  ? cpu_map_update_elem+0x6d0/0x6d0
[ 3073.307544]  schedule+0x6f/0x160
[ 3073.309282]  schedule_preempt_disabled+0x14/0x20
[ 3073.311593]  kthread+0x175/0x240
[ 3073.313299]  ? kthread_create_on_node+0xd0/0xd0
[ 3073.315106]  ret_from_fork+0x1f/0x30
[ 3073.316365]
               Showing all locks held in the system:
[ 3073.318423] 1 lock held by khungtaskd/33:
[ 3073.319642]  #0: ffffffff82d246a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x28/0x1c3

[ 3073.322249] =============================================
