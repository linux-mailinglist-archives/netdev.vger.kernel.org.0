Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE3324E157
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgHUTzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbgHUTzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 15:55:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9435AC061573;
        Fri, 21 Aug 2020 12:55:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A3B6128911D4;
        Fri, 21 Aug 2020 12:38:28 -0700 (PDT)
Date:   Fri, 21 Aug 2020 12:55:08 -0700 (PDT)
Message-Id: <20200821.125508.1308628373006121882.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-08-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200821194949.71179-1-alexei.starovoitov@gmail.com>
References: <20200821194949.71179-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Aug 2020 12:38:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 21 Aug 2020 12:49:49 -0700

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 11 non-merge commits during the last 5 day(s) which contain
> a total of 12 files changed, 78 insertions(+), 24 deletions(-).
> 
> The main changes are:
> 
> 1) three fixes in BPF task iterator logic, from Yonghong.
> 
> 2) fix for compressed dwarf sections in vmlinux, from Jiri.
> 
> 3) fix xdp attach regression, from Andrii.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thank you.
