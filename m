Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ECC26BAD9
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgIPDr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIPDry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:47:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D95C061788;
        Tue, 15 Sep 2020 20:41:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72F5713BCDB9A;
        Tue, 15 Sep 2020 20:24:32 -0700 (PDT)
Date:   Tue, 15 Sep 2020 20:41:16 -0700 (PDT)
Message-Id: <20200915.204116.696016203663349960.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-09-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916020316.18673-1-alexei.starovoitov@gmail.com>
References: <20200916020316.18673-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 20:24:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 15 Sep 2020 19:03:16 -0700

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 12 non-merge commits during the last 19 day(s) which contain
> a total of 10 files changed, 47 insertions(+), 38 deletions(-).
> 
> The main changes are:
> 
> 1) docs/bpf fixes, from Andrii.
> 
> 2) ld_abs fix, from Daniel.
> 
> 3) socket casting helpers fix, from Martin.
> 
> 4) hash iterator fixes, from Yonghong.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Alexei.
