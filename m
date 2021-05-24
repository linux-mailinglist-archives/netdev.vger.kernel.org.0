Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A07A38F4C4
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhEXVLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:32866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhEXVLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D6F9961414;
        Mon, 24 May 2021 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621890616;
        bh=GKPmJ2ZJ/61stphdwxIXyW9qdl7QVO7uYTAKCN3hreQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L+bMHU5ps9QoyhV2YoCV0Re46/r9FpkTMPoVyPOv44f6KCguqQRDbE3CWPj7aMiUX
         UQv2E5vSmYW1ND1PJJuxAXHYfJv29NSkNGprKZArZ4JZtw7Aimp8U0hhH8evEuxmwp
         XTGokHiWqT7Pd+Mv4oSC6iySIN2YkqfcfMZ6uAJZflAZf/ZdTamSuXQNvWIOYxUIab
         b6VwiM/NaHaiwFjx8xzguq3jkAkbhYRlbcg/pLdr8Tzh/zZ6/svHWNq9gZ5d1Kblhs
         WclaMnObtgYoNNCJaBOqzRDteOHFPXt5RROkz1HSCi0ZuEwP6kY/FMHXsJD8e3FVox
         gb085IRkhszsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CFC13609ED;
        Mon, 24 May 2021 21:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] SJA1105 DSA driver preparation for new switch
 introduction (SJA1110)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162189061684.7619.14779165415576141402.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 21:10:16 +0000
References: <20210524131421.1030789-1-olteanv@gmail.com>
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 24 May 2021 16:14:12 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series contains refactoring patches which are necessary before the
> support for the new NXP SJA1110 switch can be introduced in this driver.
> 
> As far as this series is concerned, here is the list of major changes
> introduced with the SJA1110:
> - 11 ports vs 5
> - port 0 goes to the internal microcontroller, so it is unused as far as
>   DSA is concerned
> - the Clock Generation Unit does not need any configuration for
>   setting up the PLLs for MII/RMII/RGMII
> - the L2 Policing Table contains multicast policers too, not just
>   broadcast and per-traffic class. These must be minimally initialized.
> - more frame buffers
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: dsa: sja1105: parameterize the number of ports
    https://git.kernel.org/netdev/net-next/c/542043e91df4
  - [net-next,2/9] net: dsa: sja1105: avoid some work for unused ports
    https://git.kernel.org/netdev/net-next/c/f238fef1b3de
  - [net-next,3/9] net: dsa: sja1105: dimension the data structures for a larger port count
    https://git.kernel.org/netdev/net-next/c/82760d7f2ea6
  - [net-next,4/9] net: dsa: sja1105: don't assign the host port using dsa_upstream_port()
    https://git.kernel.org/netdev/net-next/c/df2a81a35ebb
  - [net-next,5/9] net: dsa: sja1105: skip CGU configuration if it's unnecessary
    https://git.kernel.org/netdev/net-next/c/c50376783f23
  - [net-next,6/9] net: dsa: sja1105: dynamically choose the number of static config table entries
    https://git.kernel.org/netdev/net-next/c/fd6f2c257b0b
  - [net-next,7/9] net: dsa: sja1105: use sja1105_xfer_u32 for the reset procedure
    https://git.kernel.org/netdev/net-next/c/f78a2517cf73
  - [net-next,8/9] net: dsa: sja1105: configure the multicast policers, if present
    https://git.kernel.org/netdev/net-next/c/38fbe91f2287
  - [net-next,9/9] net: dsa: sja1105: allow the frame buffer size to be customized
    https://git.kernel.org/netdev/net-next/c/1bf658eefe38

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


