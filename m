Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB15421BF03
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgGJVIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgGJVIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:08:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F41C08C5DC;
        Fri, 10 Jul 2020 14:08:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD8E2128657B0;
        Fri, 10 Jul 2020 14:08:01 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:08:01 -0700 (PDT)
Message-Id: <20200710.140801.424974554237166792.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-07-09
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200710024824.16936-1-alexei.starovoitov@gmail.com>
References: <20200710024824.16936-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jul 2020 14:08:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu,  9 Jul 2020 19:48:24 -0700

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 4 non-merge commits during the last 1 day(s) which contain
> a total of 4 files changed, 26 insertions(+), 15 deletions(-).
> 
> The main changes are:
> 
> 1) fix crash in libbpf on 32-bit archs, from Jakub and Andrii.
> 
> 2) fix crash when l2tp and bpf_sk_reuseport conflict, from Martin.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Alexei.
