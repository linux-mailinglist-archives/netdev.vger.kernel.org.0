Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A52E1A3D6C
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 02:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgDJAjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 20:39:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37160 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgDJAjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 20:39:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36D491210A443;
        Thu,  9 Apr 2020 17:39:43 -0700 (PDT)
Date:   Thu, 09 Apr 2020 17:39:39 -0700 (PDT)
Message-Id: <20200409.173939.976560022955495468.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-04-10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200410002947.30827-1-daniel@iogearbox.net>
References: <20200410002947.30827-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 17:39:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Fri, 10 Apr 2020 02:29:47 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 13 non-merge commits during the last 7 day(s) which contain
> a total of 13 files changed, 137 insertions(+), 43 deletions(-).
> 
> The main changes are:
> 
> 1) JIT code emission fixes for riscv and arm32, from Luke Nelson and Xi Wang.
> 
> 2) Disable vmlinux BTF info if GCC_PLUGIN_RANDSTRUCT is used, from Slava Bacherikov.
> 
> 3) Fix oob write in AF_XDP when meta data is used, from Li RongQing.
> 
> 4) Fix bpf_get_link_xdp_id() handling on single prog when flags are specified,
>    from Andrey Ignatov.
> 
> 5) Fix sk_assign() BPF helper for request sockets that can have sk_reuseport
>    field uninitialized, from Joe Stringer.
> 
> 6) Fix mprotect() test case for the BPF LSM, from KP Singh.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
