Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3373E22A05E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgGVT73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgGVT73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 15:59:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68025C0619DC;
        Wed, 22 Jul 2020 12:59:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D032611FFC80E;
        Wed, 22 Jul 2020 12:42:41 -0700 (PDT)
Date:   Wed, 22 Jul 2020 12:59:23 -0700 (PDT)
Message-Id: <20200722.125923.1352927540127962222.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2020-07-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722032932.62060-1-alexei.starovoitov@gmail.com>
References: <20200722032932.62060-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 12:42:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 21 Jul 2020 20:29:32 -0700

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 46 non-merge commits during the last 6 day(s) which contain
> a total of 68 files changed, 4929 insertions(+), 526 deletions(-).
> 
> The main changes are:
> 
> 1) Run BPF program on socket lookup, from Jakub.
> 
> 2) Introduce cpumap, from Lorenzo.
> 
> 3) s390 JIT fixes, from Ilya.
> 
> 4) teach riscv JIT to emit compressed insns, from Luke.
> 
> 5) use build time computed BTF ids in bpf iter, from Yonghong.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thank you.
