Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966FB1F859E
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 00:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgFMW2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 18:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgFMW2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 18:28:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C21CC03E96F;
        Sat, 13 Jun 2020 15:28:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5ED211F5F637;
        Sat, 13 Jun 2020 15:28:33 -0700 (PDT)
Date:   Sat, 13 Jun 2020 15:28:24 -0700 (PDT)
Message-Id: <20200613.152824.1313646855860763287.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-06-12
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200613004547.82591-1-alexei.starovoitov@gmail.com>
References: <20200613004547.82591-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jun 2020 15:28:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 12 Jun 2020 17:45:47 -0700

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 26 non-merge commits during the last 10 day(s) which contain
> a total of 27 files changed, 348 insertions(+), 93 deletions(-).
> 
> The main changes are:
> 
> 1) sock_hash accounting fix, from Andrey.
> 
> 2) libbpf fix and probe_mem sanitizing, from Andrii.
> 
> 3) sock_hash fixes, from Jakub.
> 
> 4) devmap_val fix, from Jesper.
> 
> 5) load_bytes_relative fix, from YiFei.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks a lot!
