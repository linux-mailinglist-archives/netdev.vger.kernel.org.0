Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7F94388EA
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 14:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhJXMwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 08:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhJXMw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 08:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 233BD60F4F;
        Sun, 24 Oct 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635079808;
        bh=4ZT/OHhliL2xpFRvHBucE++OTesAzg+EfQ7BpPMQfoM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b5RTDbXQ3dumt/nIcZuyZTJQsrjChAUcQEDVtoJncc8+XHje539MlKMzKo8Mf34Gt
         11wGVOo/40Qv9ACKjJLIYL4muWgH26RRL6vC8NfamvblBtrqEDmUlnW1mYXwr+HAcf
         NG0LmR/B/8e0DRpX5vqlbd+hwjuCkSoCSQkN5NIJp3S5TX6IEHNEqNoVnNSQjvUhPz
         RXG0GyZqtleQOB6Ky0HSWAJZUJk+a4kyP3CSynG5gEu3DhkYjRkAnR5Lr9VZYI5cZo
         gVA+fqdDBujFKwy9Qngyzo6U/vF/tgOzn7Y9srfXfevQlVDG59b05e4WvrW0P4sESw
         yY59zNBCHdBTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 14DE660BD8;
        Sun, 24 Oct 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 1/2] dt-bindings: net: macb: Add mdio bus child node
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163507980807.1741.5240492609197431431.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Oct 2021 12:50:08 +0000
References: <20211022163548.3380625-1-sean.anderson@seco.com>
In-Reply-To: <20211022163548.3380625-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, kuba@kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, robh@kernel.org,
        devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Oct 2021 12:35:47 -0400 you wrote:
> This adds an optional mdio bus child node. If present, the mac will
> look for PHYs there instead of directly under the top-level node. This
> eliminates any ambiguity about whether child nodes are PHYs, and allows
> the MDIO bus to contain non-PHY devices.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: macb: Add mdio bus child node
    https://git.kernel.org/netdev/net-next/c/25790844006a
  - [net-next,2/2] net: macb: Use mdio child node for MDIO bus if it exists
    https://git.kernel.org/netdev/net-next/c/4d98bb0d7ec2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


