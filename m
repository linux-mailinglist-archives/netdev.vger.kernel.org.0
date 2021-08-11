Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE303E930B
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhHKNuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231971AbhHKNui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 09:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 44D2460FD9;
        Wed, 11 Aug 2021 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628689806;
        bh=lSL3dflXDcop78QQbgt5YREWZaF7eJtgc9q4xMZ4ZAo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GO4Lngxbaue2jMZrVr40APuB5ACNKPykvShclPuoVHQaFpCgwDEBWC5zto+QsOB9t
         QeFTv7cCk9REBVZzVriReVCeD0wgkKANWd1FBKtLPuIYD3OHhd5TgIzixUDtvGiX8G
         z0VOximqHlzw6MUpOWwfhc3aCeZ2CJrDqGmy79hTGgYd3CaXXFCBR6kwaVvTDRcQqu
         /v+44jI3zomLfhG86Qf7+E8eYopVHIZEJQeBRp/WpgU2oz4DXUOQIYw2SNY/TI+4XF
         rkOex3NCI6qNKOZGVZbTgh2XTPsL2fYf9sL5lhlYW3lR1ZAKuuVMsvqWdAix685xp1
         PV1Cdi4uXAXBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37B60609AD;
        Wed, 11 Aug 2021 13:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] DSA tagger helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162868980622.21914.6083734913988771919.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 13:50:06 +0000
References: <20210810131356.1655069-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210810131356.1655069-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, linus.walleij@linaro.org, dqfext@gmail.com,
        john@phrozen.org, sean.wang@mediatek.com, Landen.Chao@mediatek.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 10 Aug 2021 16:13:52 +0300 you wrote:
> The goal of this series is to minimize the use of memmove and skb->data
> in the DSA tagging protocol drivers. Unfiltered access to this level of
> information is not very friendly to drive-by contributors, and sometimes
> is also not the easiest to review.
> 
> For starters, I have converted the most common form of DSA tagging
> protocols: the DSA headers which are placed where the EtherType is.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] net: dsa: create a helper that strips EtherType DSA headers on RX
    https://git.kernel.org/netdev/net-next/c/f1dacd7aea34
  - [v2,net-next,2/4] net: dsa: create a helper which allocates space for EtherType DSA headers
    https://git.kernel.org/netdev/net-next/c/6bef794da6d3
  - [v2,net-next,3/4] net: dsa: create a helper for locating EtherType DSA headers on RX
    https://git.kernel.org/netdev/net-next/c/5d928ff48656
  - [v2,net-next,4/4] net: dsa: create a helper for locating EtherType DSA headers on TX
    https://git.kernel.org/netdev/net-next/c/a72808b65834

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


