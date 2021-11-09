Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BC1449F4D
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 01:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbhKIAMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 19:12:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhKIAMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 19:12:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D120E610E8;
        Tue,  9 Nov 2021 00:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636416607;
        bh=JamjZWibutImFEYvx1MNvVZ56By2lemhHwMB/YXOVIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K8UoBJAAsXhUmDglxudq1bP7vBxqbPCd1Yf7KvW90r7bASKrmK7dw/84Mnn3ApXXC
         tE1NOuC+WrzSJLqemMWUl2Rpj3/tOQ01eAjYiIJfesj00QXfPyATh/oH4q59IRXu0x
         SDpCXB3wPx0igqNK0AC/3DC4Z0AynV89cd0T/82I2T+4UQll5fxwTh+XmfInO8T/U8
         mvW6VdNnnphq4BebcFqfjZaXNtztSv7IXHn73zDU8ly5SbLO+t9nMDXNmRTA/iamEq
         4Z698bh33RekvAAQ53raH0ueOmSqYLyIg5hHOiMKPDZMP+1OeT/G4RDvSTwzEIEBr+
         YG91kBBeg9mXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C09B860A3A;
        Tue,  9 Nov 2021 00:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2 0/5] bpf, sockmap: fixes stress testing and regression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163641660778.28301.17812187648892119851.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Nov 2021 00:10:07 +0000
References: <20211103204736.248403-1-john.fastabend@gmail.com>
In-Reply-To: <20211103204736.248403-1-john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        joamaki@gmail.com, xiyou.wangcong@gmail.com, jakub@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed,  3 Nov 2021 13:47:31 -0700 you wrote:
> Attached are 5 patches that fix issues we found by either stress testing
> or updating our CI to LTS kernels.
> 
> Thanks to Jussi for all the hard work tracking down issues and getting
> stress testing/CI running.
> 
> First patch was suggested by Jakub to ensure sockets in CLOSE state
> were safe from helper side.
> 
> [...]

Here is the summary with links:
  - [bpf,v2,1/5] bpf, sockmap: Use stricter sk state checks in sk_lookup_assign
    https://git.kernel.org/bpf/bpf/c/40a34121ac1d
  - [bpf,v2,2/5] bpf, sockmap: Remove unhash handler for BPF sockmap usage
    https://git.kernel.org/bpf/bpf/c/b8b8315e39ff
  - [bpf,v2,3/5] bpf, sockmap: Fix race in ingress receive verdict with redirect to self
    https://git.kernel.org/bpf/bpf/c/c5d2177a72a1
  - [bpf,v2,4/5] bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding
    https://git.kernel.org/bpf/bpf/c/e0dc3b93bd7b
  - [bpf,v2,5/5] bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg
    https://git.kernel.org/bpf/bpf/c/b2c4618162ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


