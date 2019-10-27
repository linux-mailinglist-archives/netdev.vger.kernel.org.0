Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A150E602B
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 02:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfJ0BbT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 26 Oct 2019 21:31:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfJ0BbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 21:31:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7CEF14EC3093;
        Sat, 26 Oct 2019 18:31:15 -0700 (PDT)
Date:   Sat, 26 Oct 2019 18:31:12 -0700 (PDT)
Message-Id: <20191026.183112.938505280164137212.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2019-10-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191026224006.18149-1-daniel@iogearbox.net>
References: <20191026224006.18149-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Oct 2019 18:31:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sun, 27 Oct 2019 00:40:06 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 7 non-merge commits during the last 11 day(s) which contain
> a total of 7 files changed, 66 insertions(+), 16 deletions(-).
> 
> The main changes are:
> 
> 1) Fix two use-after-free bugs in relation to RCU in jited symbol exposure to
>    kallsyms, from Daniel Borkmann.
> 
> 2) Fix NULL pointer dereference in AF_XDP rx-only sockets, from Magnus Karlsson.
> 
> 3) Fix hang in netdev unregister for hash based devmap as well as another overflow
>    bug on 32 bit archs in memlock cost calculation, from Toke Høiland-Jørgensen.
> 
> 4) Fix wrong memory access in LWT BPF programs on reroute due to invalid dst.
>    Also fix BPF selftests to use more compatible nc options, from Jiri Benc.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
