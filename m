Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855383DAE1C
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhG2VUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhG2VUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 17:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C8ABC60F5C;
        Thu, 29 Jul 2021 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627593605;
        bh=VB10s23Vwrh07svcJzkpEtOuytvJdOwztsW68pnI4MQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U3fpd5H8hO5qqjrhzweJWjZuMSEKvFcbwNE7QasPLkWKzyuNgcRgYy+0JTZbaxTdg
         lwLYFXcNpr3dA2+ubgN7Ou884DVa0Oo6L3C4DsoF/2nM3v8IC8mo/w+1C3sfO+DGki
         Dsq52m3o7JUAOR5fznXF5tSa2p9jWGNwB8AGD//VnxCjvO3nEg7G9XebZ00j+DjFpZ
         L2kqODag8wBTPYZ9QlMbxXYFhyfyTulwE0joT4LIa1Bm6K9Y87h+NeeJQKqLDYWEXk
         4STTMu/4YnfchMgZqJer92Gjskbhyq2/UWaj54t9OEPsEaj+2cW5Mi4H7/SEC9XKJG
         4ZlOqXbrCgDNA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B4CD660A85;
        Thu, 29 Jul 2021 21:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: don't set skb->offload_fwd_mark when not
 offloading the bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162759360573.14384.4339997745044162892.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 21:20:05 +0000
References: <20210729145600.392712-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210729145600.392712-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tobias@waldekranz.com, dqfext@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 17:56:00 +0300 you wrote:
> DSA has gained the recent ability to deal gracefully with upper
> interfaces it cannot offload, such as the bridge, bonding or team
> drivers. When such uppers exist, the ports are still in standalone mode
> as far as the hardware is concerned.
> 
> But when we deliver packets to the software bridge in order for that to
> do the forwarding, there is an unpleasant surprise in that the bridge
> will refuse to forward them. This is because we unconditionally set
> skb->offload_fwd_mark = true, meaning that the bridge thinks the frames
> were already forwarded in hardware by us.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: don't set skb->offload_fwd_mark when not offloading the bridge
    https://git.kernel.org/netdev/net-next/c/bea7907837c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


