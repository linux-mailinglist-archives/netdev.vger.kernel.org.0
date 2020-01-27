Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C6014A52C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgA0NcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:32:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0NcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:32:04 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 314FF155EF394;
        Mon, 27 Jan 2020 05:32:02 -0800 (PST)
Date:   Mon, 27 Jan 2020 14:31:59 +0100 (CET)
Message-Id: <20200127.143159.304887488057743776.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2020-01-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200127130618.24926-1-daniel@iogearbox.net>
References: <20200127130618.24926-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 05:32:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Mon, 27 Jan 2020 14:06:18 +0100

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 20 non-merge commits during the last 5 day(s) which contain
> a total of 24 files changed, 433 insertions(+), 104 deletions(-).
> 
> The main changes are:
> 
> 1) Make BPF trampolines and dispatcher aware for the stack unwinder, from Jiri Olsa.
> 
> 2) Improve handling of failed CO-RE relocations in libbpf, from Andrii Nakryiko.
> 
> 3) Several fixes to BPF sockmap and reuseport selftests, from Lorenz Bauer.
> 
> 4) Various cleanups in BPF devmap's XDP flush code, from John Fastabend.
> 
> 5) Fix BPF flow dissector when used with port ranges, from Yoshiki Komachi.
> 
> 6) Fix bpffs' map_seq_next callback to always inc position index, from Vasily Averin.
> 
> 7) Allow overriding LLVM tooling for runqslower utility, from Andrey Ignatov.
> 
> 8) Silence false-positive lockdep splats in devmap hash lookup, from Amol Grover.
> 
> 9) Fix fentry/fexit selftests to initialize a variable before use, from John Sperbeck.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks Daniel.
