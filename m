Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B71824503F
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 02:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgHOAWa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Aug 2020 20:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgHOAW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 20:22:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50AAC061385;
        Fri, 14 Aug 2020 17:22:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 222ED127853A9;
        Fri, 14 Aug 2020 17:05:42 -0700 (PDT)
Date:   Fri, 14 Aug 2020 17:22:17 -0700 (PDT)
Message-Id: <20200814.172217.1557201812197439081.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-08-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815000544.25793-1-daniel@iogearbox.net>
References: <20200815000544.25793-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 17:05:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sat, 15 Aug 2020 02:05:44 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 23 non-merge commits during the last 4 day(s) which contain
> a total of 32 files changed, 421 insertions(+), 141 deletions(-).
> 
> The main changes are:
> 
> 1) Fix sock_ops ctx access splat due to register override, from John Fastabend.
> 
> 2) Batch of various fixes to libbpf, bpftool, and selftests when testing build
>    in 32-bit mode, from Andrii Nakryiko.
> 
> 3) Fix vmlinux.h generation on ARM by mapping GCC built-in types (__Poly*_t)
>    to equivalent ones clang can work with, from Jean-Philippe Brucker.
> 
> 4) Fix build_id lookup in bpf_get_stackid() helper by walking all NOTE ELF
>    sections instead of just first, from Jiri Olsa.
> 
> 5) Avoid use of __builtin_offsetof() in libbpf for CO-RE, from Yonghong Song.
> 
> 6) Fix segfault in test_mmap due to inconsistent length params, from Jianlin Lv.
> 
> 7) Don't override errno in libbpf when logging errors, from Toke Høiland-Jørgensen.
> 
> 8) Fix v4_to_v6 sockaddr conversion in sk_lookup test, from Stanislav Fomichev.
> 
> 9) Add link to bpf-helpers(7) man page to BPF doc, from Joe Stringer.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
