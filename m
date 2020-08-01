Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A770F234EE1
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgHAAUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgHAAUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 20:20:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1321EC06174A;
        Fri, 31 Jul 2020 17:20:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7AC511E4590A;
        Fri, 31 Jul 2020 17:03:28 -0700 (PDT)
Date:   Fri, 31 Jul 2020 17:20:13 -0700 (PDT)
Message-Id: <20200731.172013.46612671169780905.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, jolsa@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-07-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731135145.15003-1-daniel@iogearbox.net>
References: <20200731135145.15003-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 17:03:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Fri, 31 Jul 2020 15:51:45 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 5 non-merge commits during the last 21 day(s) which contain
> a total of 5 files changed, 126 insertions(+), 18 deletions(-).
> 
> The main changes are:
> 
> 1) Fix a map element leak in HASH_OF_MAPS map type, from Andrii Nakryiko.
> 
> 2) Fix a NULL pointer dereference in __btf_resolve_helper_id() when no
>    btf_vmlinux is available, from Peilin Ye.
> 
> 3) Init pos variable in __bpfilter_process_sockopt(), from Christoph Hellwig.
> 
> 4) Fix a cgroup sockopt verifier test by specifying expected attach type,
>    from Jean-Philippe Brucker.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled.

> Note that when net gets merged into net-next later on, there is a small
> merge conflict in kernel/bpf/btf.c between commit 5b801dfb7feb ("bpf: Fix
> NULL pointer dereference in __btf_resolve_helper_id()") from the bpf tree
> and commit 138b9a0511c7 ("bpf: Remove btf_id helpers resolving") from the
> net-next tree.
> 
> Resolve as follows: remove the old hunk with the __btf_resolve_helper_id()
> function. Change the btf_resolve_helper_id() so it actually tests for a
> NULL btf_vmlinux and bails out:
 ...

Noted, thank you.
