Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFAF21E4F1
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 03:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgGNBEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 21:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGNBEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 21:04:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10E1C061755;
        Mon, 13 Jul 2020 18:04:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6690812987878;
        Mon, 13 Jul 2020 18:04:24 -0700 (PDT)
Date:   Mon, 13 Jul 2020 18:04:23 -0700 (PDT)
Message-Id: <20200713.180423.2061002929432189374.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2020-07-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714001746.33952-1-alexei.starovoitov@gmail.com>
References: <20200714001746.33952-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 18:04:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 13 Jul 2020 17:17:46 -0700

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 36 non-merge commits during the last 7 day(s) which contain
> a total of 62 files changed, 2242 insertions(+), 468 deletions(-).
> 
> The main changes are:
> 
> 1) Avoid trace_printk warning banner by switching bpf_trace_printk to use
>    its own tracing event, from Alan.
> 
> 2) Better libbpf support on older kernels, from Andrii.
> 
> 3) Additional AF_XDP stats, from Ciara.
> 
> 4) build time resolution of BTF IDs, from Jiri.
> 
> 5) BPF_CGROUP_INET_SOCK_RELEASE hook, from Stanislav.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thank you.
