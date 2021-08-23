Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68F13F4949
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbhHWLBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236307AbhHWLAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E74C1613AC;
        Mon, 23 Aug 2021 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629716407;
        bh=I1mgSEVBE0q0+5kga1dl7l2Y6dCNWsFDWeBDIZKHopE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F1/V98cHiD/+kOj6MTLW+kKZRmLwEWPmBYM2zocF0V8u6nxl7AeFbuaIV+g0nhu46
         s0ffBpMWdcy7agq7oOeMaAlA3fKFiuVBreBWxAUtMPE50DYLoRgX8dgcOrOOaboAKi
         OM4OmmIwf4GM6eggGw5CoGqeI7cDwYHObOfGL7ozpiRvW5dZ/VQc7goy9EaZAYKTDj
         EXHvi6XayGh4ssu1HBWhebT6w426o9ImYUB1zY96i+tPvgK2/2skNZnJRzJ5feGAHY
         F0fxXZbF+OUu6Rw2GU9iPq1Xa//lYBeQDv3ofel/PQFoX8vkrN1Y4ZPRVKqzt9ZFgU
         uAqRTwOFpD33Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0093609ED;
        Mon, 23 Aug 2021 11:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: dsa: track unique bridge numbers across all
 DSA switch trees
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971640791.3591.3908290883435699784.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:00:07 +0000
References: <20210819175500.2276709-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210819175500.2276709-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 20:55:00 +0300 you wrote:
> Right now, cross-tree bridging setups work somewhat by mistake.
> 
> In the case of cross-tree bridging with sja1105, all switch instances
> need to agree upon a common VLAN ID for forwarding a packet that belongs
> to a certain bridging domain.
> 
> With TX forwarding offload, the VLAN ID is the bridge VLAN for
> VLAN-aware bridging, and the tag_8021q TX forwarding offload VID
> (a VLAN which has non-zero VBID bits) for VLAN-unaware bridging.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: dsa: track unique bridge numbers across all DSA switch trees
    https://git.kernel.org/netdev/net-next/c/f5e165e72b29

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


