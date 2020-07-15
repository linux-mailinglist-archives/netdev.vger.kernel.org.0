Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E717220139
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 02:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGOACQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 20:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgGOACQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 20:02:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8BCC061755;
        Tue, 14 Jul 2020 17:02:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0A5C126D2C42;
        Tue, 14 Jul 2020 17:02:12 -0700 (PDT)
Date:   Tue, 14 Jul 2020 17:02:09 -0700 (PDT)
Message-Id: <20200714.170209.815308037647886359.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2020-07-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714225807.56649-1-alexei.starovoitov@gmail.com>
References: <20200714225807.56649-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 17:02:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 14 Jul 2020 15:58:07 -0700

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 21 non-merge commits during the last 1 day(s) which contain
> a total of 20 files changed, 308 insertions(+), 279 deletions(-).
> 
> The main changes are:
> 
> 1) Fix selftests/bpf build, from Alexei.
> 
> 2) Fix resolve_btfids build issues, from Jiri.
> 
> 3) Pull usermode-driver-cleanup set, from Eric.
> 
> 4) Two minor fixes to bpfilter, from Alexei and Masahiro.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks Alexei.
