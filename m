Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570B9109715
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfKYXtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:49:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfKYXtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:49:25 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9048150AE461;
        Mon, 25 Nov 2019 15:49:24 -0800 (PST)
Date:   Mon, 25 Nov 2019 15:49:22 -0800 (PST)
Message-Id: <20191125.154922.129756476952207936.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2019-11-26
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191125232416.4287-1-daniel@iogearbox.net>
References: <20191125232416.4287-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 15:49:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue, 26 Nov 2019 00:24:16 +0100

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 2 non-merge commits during the last 1 day(s) which contain
> a total of 2 files changed, 14 insertions(+), 3 deletions(-).
> 
> The main changes, 2 small fixes are:
> 
> 1) Fix libbpf out of tree compilation which complained about unknown u32
>    type used in libbpf_find_vmlinux_btf_id() which needs to be __u32 instead,
>    from Andrii Nakryiko.
> 
> 2) Follow-up fix for the prior BPF mmap series where kbuild bot complained
>    about missing vmalloc_user_node_flags() for no-MMU, also from Andrii Nakryiko.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks Daniel.
