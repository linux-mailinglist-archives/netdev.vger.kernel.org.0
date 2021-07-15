Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDB73CA4DB
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 20:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbhGOSDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 14:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236602AbhGOSC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 14:02:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8580361289;
        Thu, 15 Jul 2021 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626372005;
        bh=EPMLqhsofFZNRecEg8FQjQHn2xUEC1dJdDzwtqQGntk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FfkAWuHntaUOOiMfjiQs4BklUAqkM0kL55H0acHuzrM1k5vslL0A5Mc8q2ZJ7KBIr
         fQ6m8tsu/rlJFPmdw0p7z7tk13m3K+zuhO7pDbjS4m/H2stUQRdZkaTFvJF2B57iD4
         XUkgbWyY/6dLCt75yYMi5KWABuognfVJeow1FtEVPFpdTDrdAJ0YgKqhCKlOORoE40
         qjELqDOPhQyiscirr0teeIbq6HrUZGu8IkG7drUPItksjbYy22vMN2bHDIvyFhUzl5
         Wm0JpDp5txo4cGIBEbHvTLopGgo19IEXvkNQQagrGLEDjDxoU1nY+S4+Qf42g+BCnJ
         5rRF+BuuIwTQg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 74DAE609B8;
        Thu, 15 Jul 2021 18:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v4 0/2] bpf, sockmap: fix potential memory leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637200547.28238.17943000923023342508.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 18:00:05 +0000
References: <20210712195546.423990-1-john.fastabend@gmail.com>
In-Reply-To: <20210712195546.423990-1-john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, jakub@cloudflare.com, daniel@iogearbox.net,
        andriin@fb.com, xiyou.wangcong@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Mon, 12 Jul 2021 12:55:44 -0700 you wrote:
> While investigating a memleak in sockmap I found these two issues. Patch
> 1 found doing code review, I wasn't able to get KASAN to trigger a
> memleak here, but should be necessary. Patch 2 fixes proc stats so when
> we use sockstats for debugging we get correct values.
> 
> The fix for observered memleak will come after these, but requires some
> more discussion and potentially patch revert so I'll try to get the set
> here going now.
> 
> [...]

Here is the summary with links:
  - [bpf,v4,1/2] bpf, sockmap: fix potential memory leak on unlikely error case
    https://git.kernel.org/bpf/bpf/c/7e6b27a69167
  - [bpf,v4,2/2] bpf, sockmap: sk_prot needs inuse_idx set for proc stats
    https://git.kernel.org/bpf/bpf/c/228a4a7ba8e9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


