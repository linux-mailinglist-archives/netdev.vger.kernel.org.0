Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3334F3E1245
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbhHEKKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240360AbhHEKKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 06:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D8ED561107;
        Thu,  5 Aug 2021 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628158206;
        bh=y2e6tMoKHAD1MT+NaZEBfhZ8QsyxS+dK65cMvlQlfRw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B3MP9TH4zmHK8lyc5XUYiF8EYoNNQv7aQdgnGtqJIkUD8NWDsRrmXOzlLu6I/jFV1
         yHC3dpb4V7+wX+Fuq/Rabu5H35Dk+NnO43zYCW617uoV2hZn0ckuRE6PZqQCKtkTRr
         aQAFr4z3d2Zj5LSClW3bRfflHBAdREfOG82W79jWL6KeqH4msLDikMQvCKt0OIW2Q6
         w3oaHrB2px8565qEBlEIkaOFWpE4FZVci0UHiAPWGXPpE/w7fsgCliazHfTjXlfRrF
         TYy9cIW/BCDapQS6GVfE2gTM6hdLvn9DBcPr13GCeu3QZJj4l81z52U1QJVYQ1am1a
         Fr5aWyTkfv+kw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C880B60A48;
        Thu,  5 Aug 2021 10:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/8] NXP SJA1105 driver support for "H" switch
 topologies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162815820681.2686.14597996768431492044.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 10:10:06 +0000
References: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  4 Aug 2021 16:54:28 +0300 you wrote:
> Changes in v3:
> Preserve the behavior of dsa_tree_setup_default_cpu() which is to pick
> the first CPU port and not the last.
> 
> Changes in v2:
> Send as non-RFC, drop the patches for discarding DSA-tagged packets on
> user ports and DSA-untagged packets on DSA and CPU ports for now.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/8] net: dsa: rename teardown_default_cpu to teardown_cpu_ports
    https://git.kernel.org/netdev/net-next/c/0e8eb9a16e25
  - [v3,net-next,2/8] net: dsa: give preference to local CPU ports
    https://git.kernel.org/netdev/net-next/c/2c0b03258b8b
  - [v3,net-next,3/8] net: dsa: sja1105: configure the cascade ports based on topology
    https://git.kernel.org/netdev/net-next/c/30a100e60cf3
  - [v3,net-next,4/8] net: dsa: sja1105: manage the forwarding domain towards DSA ports
    https://git.kernel.org/netdev/net-next/c/3fa212707b8e
  - [v3,net-next,5/8] net: dsa: sja1105: manage VLANs on cascade ports
    https://git.kernel.org/netdev/net-next/c/c51300298083
  - [v3,net-next,6/8] net: dsa: sja1105: increase MTU to account for VLAN header on DSA ports
    https://git.kernel.org/netdev/net-next/c/777e55e30d12
  - [v3,net-next,7/8] net: dsa: sja1105: suppress TX packets from looping back in "H" topologies
    https://git.kernel.org/netdev/net-next/c/0f9b762c097c
  - [v3,net-next,8/8] net: dsa: sja1105: enable address learning on cascade ports
    https://git.kernel.org/netdev/net-next/c/81d45898a59a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


