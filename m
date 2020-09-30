Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4C327E424
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgI3Itm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgI3Itl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 04:49:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E9BC061755;
        Wed, 30 Sep 2020 01:49:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 359CF12A1A54C;
        Wed, 30 Sep 2020 01:32:52 -0700 (PDT)
Date:   Wed, 30 Sep 2020 01:49:36 -0700 (PDT)
Message-Id: <20200930.014936.2282151597561242112.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-09-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930050027.80975-1-alexei.starovoitov@gmail.com>
References: <20200930050027.80975-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 01:32:52 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 29 Sep 2020 22:00:27 -0700

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 7 non-merge commits during the last 14 day(s) which contain
> a total of 7 files changed, 28 insertions(+), 8 deletions(-).
> 
> The main changes are:
> 
> 1) fix xdp loading regression in libbpf for old kernels, from Andrii.
> 
> 2) Do not discard packet when NETDEV_TX_BUSY, from Magnus.
> 
> 3) Fix corner cases in libbpf related to endianness and kconfig, from Tony.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thank you.
