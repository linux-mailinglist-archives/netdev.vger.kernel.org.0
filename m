Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDAF2F7095
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbhAOCau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731908AbhAOCat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 21:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5776D23AF8;
        Fri, 15 Jan 2021 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610677809;
        bh=02Quhy0BxGmACY62netCHrLnTZ3F5SAK3JbbpEC6x98=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tVkpiHMsV7KqULtNtTweY4umxm/dLMMV1cZLyOXNf56WG1cGmbugVzxHvLRJfonVD
         mJi4wJuYidDh3H+Le3cuWlihCCOmun8pnRKDaJpJIXcj3g3az5eukHMdHTzi/24S4W
         Ns79umcZJIh7zbkIHlOp3hql5ujg472uwKpEWlW6ncXi83PaLLwcfejJ3P+UoTmXnv
         A9Lm204+egGYYX2eBmGhybxLuLYLyVjqe5drkcscbU0u/sxblnjTc4HvqRDYx//7HB
         5iF2IMjxq1q23Tf+IyimGxO4xHi5ogSnfqDWaObVra2cx0AIhRfNHx9css6Gy8USwj
         /ZRBjHhBDKJuQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 494F760593;
        Fri, 15 Jan 2021 02:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] Dissect PTP L2 packet header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161067780929.12174.13959952795690210718.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 02:30:09 +0000
References: <1610478433-7606-1-git-send-email-eranbe@nvidia.com>
In-Reply-To: <1610478433-7606-1-git-send-email-eranbe@nvidia.com>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, xiyou.wangcong@gmail.com, edumazet@google.com,
        jiri@nvidia.com, vladimir.oltean@nxp.com, jakub@cloudflare.com,
        gnault@redhat.com, richardcochran@gmail.com, andrew@lunn.ch,
        ast@kernel.org, lariel@mellanox.com, andriin@fb.com,
        gustavoars@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 12 Jan 2021 21:07:11 +0200 you wrote:
> Hi Jakub, Dave,
> 
> This series adds support for dissecting PTP L2 packet
> header (EtherType 0x88F7).
> 
> For packet header dissecting, skb->protocol is needed. Add protocol
> parsing operation to vlan ops, to guarantee skb->protocol is set,
> as EtherType 0x88F7 occasionally follows a vlan header.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] net: vlan: Add parse protocol header ops
    https://git.kernel.org/netdev/net-next/c/71854255820d
  - [net-next,v4,2/2] net: flow_dissector: Parse PTP L2 packet header
    https://git.kernel.org/netdev/net-next/c/4f1cc51f3488

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


