Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7860FE877
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKOXJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:09:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42444 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfKOXJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:09:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::642])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 344F314EC3979;
        Fri, 15 Nov 2019 15:09:10 -0800 (PST)
Date:   Fri, 15 Nov 2019 15:09:06 -0800 (PST)
Message-Id: <20191115.150906.1714221627473925259.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2019-11-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115221855.27728-1-daniel@iogearbox.net>
References: <20191115221855.27728-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 15:09:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Fri, 15 Nov 2019 23:18:55 +0100

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 1 non-merge commits during the last 9 day(s) which contain
> a total of 1 file changed, 3 insertions(+), 1 deletion(-).
> 
> The main changes are:
> 
> 1) Fix a missing unlock of bpf_devs_lock in bpf_offload_dev_create()'s
>    error path, from Dan.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
