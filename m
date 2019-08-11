Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D35E89493
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 23:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfHKVtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 17:49:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34960 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfHKVty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 17:49:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14BA0155075C6;
        Sun, 11 Aug 2019 14:49:54 -0700 (PDT)
Date:   Sun, 11 Aug 2019 14:49:53 -0700 (PDT)
Message-Id: <20190811.144953.272254761097299399.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2019-08-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190811195834.3430-1-daniel@iogearbox.net>
References: <20190811195834.3430-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 14:49:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sun, 11 Aug 2019 21:58:34 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> The main changes are:
> 
> 1) x64 JIT code generation fix for backward-jumps to 1st insn, from Alexei.
> 
> 2) Fix buggy multi-closing of BTF file descriptor in libbpf, from Andrii.
> 
> 3) Fix libbpf_num_possible_cpus() to make it thread safe, from Takshak.
> 
> 4) Fix bpftool to dump an error if pinning fails, from Jakub.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
