Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADA442C80F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 19:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJMRw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 13:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238587AbhJMRwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 13:52:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE6686101D;
        Wed, 13 Oct 2021 17:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634147409;
        bh=IZeFrVdWbAYBZzaGR0H8tYz4WAt3WC2Jbn/zCasSH5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rSzoqi+gRU/0r3BFwFnC5HkSJZbR8JoJMf8iAf/NrqamgawRBYbay9q4lonMJ+koX
         XIS4A4LHkSDuDF+m6smeuaP+WflUPzvWWfGVheEkN442erwXlKMK/qgZ6ZCB0oUAlU
         E5YCtb8MfMz5BcSlUREzwlZYGx90wWL1/uyIT7vfCX8SYWKPkOHNkEJnWMuNVQtgtx
         YZPkF7EeeEkbe0y43be4jNX8O1gyNmnDGNCn7SadVFQyW/767XOR+X+Y3H4PwvQYrw
         JKTsh1q+D8F3xVE/KuMUgIEQ8N9tPp8UQVbngUczKwrplsTGiAV0Nnj7KUQ0OcPMgN
         2lz+/dpwxiIgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC1A660A47;
        Wed, 13 Oct 2021 17:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: constify dev_addr passing for protocols
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163414740889.22760.934375186118967771.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 17:50:08 +0000
References: <20211012155840.4151590-1-kuba@kernel.org>
In-Reply-To: <20211012155840.4151590-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ralf@linux-mips.org,
        jreuter@yaina.de, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        jmaloy@redhat.com, ying.xue@windriver.com,
        linux-hams@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 08:58:34 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> netdev->dev_addr will be made const to prevent direct writes.
> This set sprinkles const across variables and arguments in protocol
> code which are used to hold references to netdev->dev_addr.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ax25: constify dev_addr passing
    https://git.kernel.org/netdev/net-next/c/c045ad2cc01e
  - [net-next,2/6] rose: constify dev_addr passing
    https://git.kernel.org/netdev/net-next/c/db95732446a8
  - [net-next,3/6] llc/snap: constify dev_addr passing
    https://git.kernel.org/netdev/net-next/c/2ef6db76bac0
  - [net-next,4/6] ipv6: constify dev_addr passing
    https://git.kernel.org/netdev/net-next/c/1a8a23d2da4f
  - [net-next,5/6] tipc: constify dev_addr passing
    https://git.kernel.org/netdev/net-next/c/6cf862807234
  - [net-next,6/6] decnet: constify dev_addr passing
    https://git.kernel.org/netdev/net-next/c/1bfcd1cc546e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


