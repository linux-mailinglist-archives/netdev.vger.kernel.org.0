Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5124175BC
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345956AbhIXNbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346166AbhIXNbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CE4C6610C7;
        Fri, 24 Sep 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632490207;
        bh=cFNRdPFC3dHbor85CorhxHZU5kdjFEGurQ28u3ZJo5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lbcHLLJZHRydrJp/lxLtAD6rcCHoKgyHSoqz6hBqPowxfTpLYzkJRIq8r/AxwFLR3
         +T2TsExY9nQ9yl0TkUY8qH6wIgBqORjDY0Q7dIofTKP+4MMnPRKTCxXWSLGv/jCO/T
         tKiHxVFzY2WiP8j1qM+L00zvPeM9kROGpVW6a3vvMAaRtWDmLKZJmOKtvdz4Zzrfwp
         61FEOkBTvpOqVyLTJcPIgtpPjfsrq20w3ufCCt0ANTrGhFaFs298jtbor+illOejGy
         s0BIHt4UmOLThlV4m7H5Dcugu05nGXJZgXyskoWcKjpFooNkO4t4Ir153/7nC8hZCL
         JV0sG+yUUM2JA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C8EB160AA4;
        Fri, 24 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: tracking packets with CE marks in BW rate
 sample
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163249020781.645.17492925411599013563.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 13:30:07 +0000
References: <20210923211706.2553282-1-luke.w.hsiao@gmail.com>
In-Reply-To: <20210923211706.2553282-1-luke.w.hsiao@gmail.com>
To:     Luke Hsiao <luke.w.hsiao@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ycheng@google.com,
        brakmo@fb.com, ncardwell@google.com, edumazet@google.com,
        lukehsiao@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 23 Sep 2021 21:17:07 +0000 you wrote:
> From: Yuchung Cheng <ycheng@google.com>
> 
> In order to track CE marks per rate sample (one round trip), TCP needs a
> per-skb header field to record the tp->delivered_ce count when the skb
> was sent. To make space, we replace the "last_in_flight" field which is
> used exclusively for NV congestion control. The stat needed by NV can be
> alternatively approximated by existing stats tcp_sock delivered and
> mss_cache.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: tracking packets with CE marks in BW rate sample
    https://git.kernel.org/netdev/net-next/c/40bc6063796e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


