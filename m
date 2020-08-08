Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AC123F5AF
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 02:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHHA40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 20:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgHHA40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 20:56:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA80C061756;
        Fri,  7 Aug 2020 17:56:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E1A612771EC0;
        Fri,  7 Aug 2020 17:39:40 -0700 (PDT)
Date:   Fri, 07 Aug 2020 17:56:24 -0700 (PDT)
Message-Id: <20200807.175624.1312811924435198437.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-08-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200807225444.6302-1-daniel@iogearbox.net>
References: <20200807225444.6302-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Aug 2020 17:39:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sat,  8 Aug 2020 00:54:44 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 11 non-merge commits during the last 2 day(s) which contain
> a total of 24 files changed, 216 insertions(+), 135 deletions(-).
> 
> The main changes are:
> 
> 1) Fix UAPI for BPF map iterator before it gets frozen to allow for more
>    extensions/customization in future, from Yonghong Song.
> 
> 2) Fix selftests build to undo verbose build output, from Andrii Nakryiko.
> 
> 3) Fix inlining compilation error on bpf_do_trace_printk() due to variable
>    argument lists, from Stanislav Fomichev.
> 
> 4) Fix an uninitialized pointer warning at btf__parse_raw() in libbpf,
>    from Daniel T. Lee.
> 
> 5) Fix several compilation warnings in selftests with regards to ignoring
>    return value, from Jianlin Lv.
> 
> 6) Fix interruptions by switching off timeout for BPF tests, from Jiri Benc.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled and build testing, I'll push out when that's done.

Thanks!
