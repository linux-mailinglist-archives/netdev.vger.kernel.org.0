Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D12391199
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 09:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhEZHz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 03:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhEZHzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 03:55:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D967861440;
        Wed, 26 May 2021 07:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622015633;
        bh=aUUC72Pl92NnPpakIZdeoapX6HqqW3fo3/UTn9YqN1E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jywycRTdqH9i9cHHVIZU5oyw0RHgYeRUS7WtdQOd5Ok1GJ0uPQ5xgNBSKZupQbMI2
         KqXks+i1pyaVG3TAkkYIwAZ/GhS/tNjw8iAypXDgPjOFGs3sfA5/iJ4/djTxF2YZ5V
         avLFWpIs4G5/CN0oLz6CPI1QZrtRB+nKX/42/70w6/POgMtZBxg/VnUSwZJhZeKhUG
         IiRB7YU666v7SxlRjtdRxavDL9LZSeSmThi44vYMe36FGnbdfcBEdu3aQVjCDwQ2ND
         1BMSi/k4RqthpytzX2uE5U2K6bYCuyabk3j/rc5G/Vff4DKDnikZOcT1soUuFTcEwX
         TdGamZsrmU6qw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CABDD60BD8;
        Wed, 26 May 2021 07:53:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v12 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162201563382.30340.14252279060319552411.git-patchwork-notify@kernel.org>
Date:   Wed, 26 May 2021 07:53:53 +0000
References: <20210519090747.1655268-1-liuhangbin@gmail.com>
In-Reply-To: <20210519090747.1655268-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, toke@redhat.com,
        jbenc@redhat.com, brouer@redhat.com, echaudro@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@gmail.com, andrii.nakryiko@gmail.com,
        alexei.starovoitov@gmail.com, john.fastabend@gmail.com,
        maciej.fijalkowski@intel.com, bjorn.topel@gmail.com, kafai@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 19 May 2021 17:07:43 +0800 you wrote:
> Hi,
> 
> This patchset is a new implementation for XDP multicast support based
> on my previous 2 maps implementation[1]. The reason is that Daniel thinks
> the exclude map implementation is missing proper bond support in XDP
> context. And there is a plan to add native XDP bonding support. Adding a
> exclude map in the helper also increases the complexity of verifier and has
> drawback of performance.
> 
> [...]

Here is the summary with links:
  - [v12,bpf-next,1/4] bpf: run devmap xdp_prog on flush instead of bulk enqueue
    https://git.kernel.org/bpf/bpf-next/c/cb261b594b41
  - [v12,bpf-next,2/4] xdp: extend xdp_redirect_map with broadcast support
    https://git.kernel.org/bpf/bpf-next/c/e624d4ed4aa8
  - [v12,bpf-next,3/4] sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
    https://git.kernel.org/bpf/bpf-next/c/e48cfe4bbfad
  - [v12,bpf-next,4/4] selftests/bpf: add xdp_redirect_multi test
    https://git.kernel.org/bpf/bpf-next/c/d23292476297

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


