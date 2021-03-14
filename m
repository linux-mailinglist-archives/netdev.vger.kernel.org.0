Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD28F33A89A
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 23:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhCNWkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 18:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhCNWkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 18:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F312D64E68;
        Sun, 14 Mar 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615761609;
        bh=Y9zoTeg0O6BAuDA898mgJdVxc5rEZZDN0Yun+UEgydA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iRD/IcAVMI/m2uRcFpVTTIfwkuIu2AGHAs3vjdKZwkh0/qpHfoP3qeFJ+YjdjYEfj
         BJxFBCfj5MgY7Zft1JCD/vCrZXxNhhWNA8q9ajjZVeyUYihZCMAvTgoBzBDe3GsqKA
         egt2d+BZnVolCjnys6zParB9/UcJzB3IlgffA0GCevQ60qCTY15a0+26Pm3M17kZvI
         q94Hz1AD74o0/W86ZQk85cMfCMEZG2DRSu0sHLdx4ivDPUDzE+sIFVCcgpeAN9atz3
         BWdW1qeya05fhVKtwd3rTIjWwRj+FM8dFSzGShHZJEukxA2LyaTJ2PFQw4sNb/b1em
         cHMxYHc68UOAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DFC9360A51;
        Sun, 14 Mar 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] flow_dissector: fix byteorder of dissected ICMP ID
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161576160891.5046.7644806242984033083.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 22:40:08 +0000
References: <20210312200834.370667-1-alobakin@pm.me>
In-Reply-To: <20210312200834.370667-1-alobakin@pm.me>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     davem@davemloft.net, kuba@kernel.org, jakub@cloudflare.com,
        ast@kernel.org, andriin@fb.com, vladimir.oltean@nxp.com,
        dcaratti@redhat.com, gnault@redhat.com, wenxu@ucloud.cn,
        eranbe@nvidia.com, mcroce@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Mar 2021 20:08:57 +0000 you wrote:
> flow_dissector_key_icmp::id is of type u16 (CPU byteorder),
> ICMP header has its ID field in network byteorder obviously.
> Sparse says:
> 
> net/core/flow_dissector.c:178:43: warning: restricted __be16 degrades to integer
> 
> Convert ID value to CPU byteorder when storing it into
> flow_dissector_key_icmp.
> 
> [...]

Here is the summary with links:
  - [net] flow_dissector: fix byteorder of dissected ICMP ID
    https://git.kernel.org/netdev/net/c/a25f82228542

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


