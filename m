Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545562D6B2E
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394082AbgLJWy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:54:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60792 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394234AbgLJWcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 17:32:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 715094D2ED6E8;
        Thu, 10 Dec 2020 14:31:32 -0800 (PST)
Date:   Thu, 10 Dec 2020 14:31:32 -0800 (PST)
Message-Id: <20201210.143132.1128894247417932156.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, kuba@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-12-10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201210222501.72430-1-alexei.starovoitov@gmail.com>
References: <20201210222501.72430-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 14:31:32 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 10 Dec 2020 14:25:01 -0800

> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 21 non-merge commits during the last 12 day(s) which contain
> a total of 21 files changed, 163 insertions(+), 88 deletions(-).
> 
> The main changes are:
> 
> 1) Fix propagation of 32-bit signed bounds from 64-bit bounds, from Alexei.
> 
> 2) Fix ring_buffer__poll() return value, from Andrii.
> 
> 3) Fix race in lwt_bpf, from Cong.
> 
> 4) Fix test_offload, from Toke.
> 
> 5) Various xsk fixes.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
> 
> Thanks a lot!

Pulled, thanks.
