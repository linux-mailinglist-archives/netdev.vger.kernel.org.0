Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F51036C88D
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhD0PUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235659AbhD0PUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 11:20:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18F1C613DD;
        Tue, 27 Apr 2021 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619536809;
        bh=1e0mPnnMjryx1f9oudkshjmALg+enVvnYure3wgpTTI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o9U1K1r7gI8S6KOiIC3LP5q2oi5EmFrvPz0f7oECB0SdKjHEvL/OHQuPUYHAyapr5
         3kxIbpavuKXtwvJ5WgSxzfQeuKcyHzFMFCnXkHIGwgJrCUqq3Z8RKvoQRzb59QazFk
         Rb1bPMJH9EN1Fc5HN4/1ypKMPuaSq7DIrBQ8jfUhzcNy/mLPWsY6SvyCGxXte3j2b0
         yp1pBTyG1lc8HzsnalYO8DDf5cW1A/frkbazWEx0P8N5q2LWBD7jw1kWgb3iQmfCvz
         WdTSVSujuFWNmGdtDUsgpHbouenuDaCr8KiQAabmL0fpoWlq6BEwNv4itAyMM3sPI+
         f9MRJnrTq78XQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E26160A24;
        Tue, 27 Apr 2021 15:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 bpf-next] cpumap: bulk skb using netif_receive_skb_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161953680905.17663.9277373252426307991.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 15:20:09 +0000
References: <c729f83e5d7482d9329e0f165bdbe5adcefd1510.1619169700.git.lorenzo@kernel.org>
In-Reply-To: <c729f83e5d7482d9329e0f165bdbe5adcefd1510.1619169700.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, song@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 23 Apr 2021 11:27:27 +0200 you wrote:
> Rely on netif_receive_skb_list routine to send skbs converted from
> xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
> The proposed patch has been tested running xdp_redirect_cpu bpf sample
> available in the kernel tree that is used to redirect UDP frames from
> ixgbe driver to a cpumap entry and then to the networking stack.
> UDP frames are generated using pkt_gen. Packets are discarded by the
> UDP layer.
> 
> [...]

Here is the summary with links:
  - [v4,bpf-next] cpumap: bulk skb using netif_receive_skb_list
    https://git.kernel.org/bpf/bpf-next/c/bb0247807744

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


