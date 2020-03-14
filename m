Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE11C18549B
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 04:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCNDwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 23:52:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCNDwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 23:52:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 371EF15A15CE8;
        Fri, 13 Mar 2020 20:52:46 -0700 (PDT)
Date:   Fri, 13 Mar 2020 20:52:45 -0700 (PDT)
Message-Id: <20200313.205245.1784180892104180860.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2020-03-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313233501.1180-1-daniel@iogearbox.net>
References: <20200313233501.1180-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 20:52:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sat, 14 Mar 2020 00:35:01 +0100

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 86 non-merge commits during the last 12 day(s) which contain
> a total of 107 files changed, 5771 insertions(+), 1700 deletions(-).
> 
> The main changes are:
 ...
> 4) Introduce a new bpftool 'prog profile' command which attaches to existing
>    BPF programs via fentry and fexit hooks and reads out hardware counters
>    during that period, from Song Liu. Example usage:
> 
>    bpftool prog profile id 337 duration 3 cycles instructions llc_misses
> 
>         4228 run_cnt
>      3403698 cycles                                              (84.08%)
>      3525294 instructions   #  1.04 insn per cycle               (84.05%)
>           13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)

This is so awesome...

 ...
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks!
