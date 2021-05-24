Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A88838F465
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhEXUbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232676AbhEXUbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 16:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E19B6140E;
        Mon, 24 May 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621888210;
        bh=sGDoJTSLdMdSFrsyXpub/XY9JJN4423rmBMnzSh+BHM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sFEtMatV/cWOgUyaF7XQ40ax9dWs8n1wW4lDstuViMMu1YI1KUiT4Wug07a3YzXk9
         LRbVrF5xupvzWNEvnYGyB5TSLt13uWicbZbfbBuZn/q8RcrnCqLeaIYD2r5XtA5Py8
         gCH+5YVT4OlnbgBOny6TU2RRdhSyfadcL8KfCFw/c5R1nbS0H0P3iBwz2UBbUv4rN8
         Q0u3FMoBbjgX+CB/G1MjZqVlYbZAldmvJkHqM0LroqfS8kVNKJmdTT8d49ZuA/o/kv
         DnoUW6hUbvMLOhFYM9Z9iZYMzhV/ZlSBpyr4LcJOnEpSGU6OdS9nH1qPVa18+5Zjuz
         evWzjb6rUwGoA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F4A460A0B;
        Mon, 24 May 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] Fixes for SJA1105 DSA driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162188821018.23443.13579915003852297105.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 20:30:10 +0000
References: <20210524092527.874479-1-olteanv@gmail.com>
In-Reply-To: <20210524092527.874479-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 12:25:21 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series contains some minor fixes in the sja1105 driver:
> - improved error handling in the probe path
> - rejecting an invalid phy-mode specified in the device tree
> - register access fix for SJA1105P/Q/R/S for the virtual links through
>   the dynamic reconfiguration interface
> - handling 2 bridge VLANs where the second is supposed to overwrite the
>   first
> - making sure that the lack of a pvid results in the actual dropping of
>   untagged traffic
> 
> [...]

Here is the summary with links:
  - [net,1/6] net: dsa: sja1105: fix VL lookup command packing for P/Q/R/S
    https://git.kernel.org/netdev/net/c/ba61cf167cb7
  - [net,2/6] net: dsa: sja1105: call dsa_unregister_switch when allocating memory fails
    https://git.kernel.org/netdev/net/c/dc596e3fe63f
  - [net,3/6] net: dsa: sja1105: add error handling in sja1105_setup()
    https://git.kernel.org/netdev/net/c/cec279a898a3
  - [net,4/6] net: dsa: sja1105: error out on unsupported PHY mode
    https://git.kernel.org/netdev/net/c/6729188d2646
  - [net,5/6] net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic
    https://git.kernel.org/netdev/net/c/ed040abca4c1
  - [net,6/6] net: dsa: sja1105: update existing VLANs from the bridge VLAN list
    https://git.kernel.org/netdev/net/c/b38e659de966

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


