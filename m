Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4844579DC
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 01:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbhKTADM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 19:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236328AbhKTADL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 19:03:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F3B4A61AA7;
        Sat, 20 Nov 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637366409;
        bh=BW7IK7iSPHOJ7rBBa9XLsBJpRab66XXRGOvUmLV7ABc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uUU3nKBj2HGPpB94C7EfFI5kcPI87CuK0gdnb/FJt37W0/ptqm3/ND/oz2p+XZQCS
         wkiF3iuFlqLJAImQKhgN7OCdjRKgI+PBjAwtHRI49VIq4X0tzHqPeeFcV8HEZCPKXC
         6Y2fC3YLGugiDvOoERIYTEdkve6tnwGe5P7lGZbvXFUFOJM3O06vdvxVrNDfBtwaca
         4uN3EQX/jRkpgC2xsxxnIs72Tp1nz2x6gKcALVFKiU0Vn8WV5951QvBQpm060k/BLo
         WUJhYT/3Zb+Vmj8uAJyS3tfU7ujQugBYjE976OZvy2PRDinyEYblRwzXUwzRoMixU0
         JKYEdQZpZ4f6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E7973609D1;
        Sat, 20 Nov 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf 0/2] sockmap fix for test_map failure 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163736640894.19309.11324709833506052878.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Nov 2021 00:00:08 +0000
References: <20211119181418.353932-1-john.fastabend@gmail.com>
In-Reply-To: <20211119181418.353932-1-john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        andrii@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 19 Nov 2021 10:14:16 -0800 you wrote:
> CI test_map runs started failing because of a regression in the
> sockmap tests. The case, caught by test_maps is that progs attached
> to sockets are not detatched currently when sockets are removed
> from a map. We resolve this in two patches. The first patch
> fixes a subtle issue found from code review and the second
> patch addresses the reported CI issue. This was recently introduced
> by a race fix, see patches for details.
> 
> [...]

Here is the summary with links:
  - [bpf,1/2] bpf, sockmap: Attach map progs to psock early for feature probes
    https://git.kernel.org/bpf/bpf/c/38207a5e8123
  - [bpf,2/2] bpf, sockmap: Re-evaluate proto ops when psock is removed from sockmap
    https://git.kernel.org/bpf/bpf/c/c0d95d3380ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


