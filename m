Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9B83590A3
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 01:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhDHXum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 19:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhDHXuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 19:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9FEFD61151;
        Thu,  8 Apr 2021 23:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617925827;
        bh=2JlhfwIB/58iqBfRSWb1k3/1NO9RNdoyS4Muh51MZjc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WVmP6RqGGr7+5q7YBZLEOsjFz8jY0Xm7Dn5q4g/+/1G1Q0FBCuN+dkBH9VRsyh0T1
         KiW4jiuXDvD4/VWIZHMZj3mu2leXnbOUCbL/wkoef6jB/UyZL9Ku7FmrVfVy40E73L
         /GtZJ9SbVrfKTQPK5iCOd6oTHep9wFKk9wTo5r82rl40cLOxQ6XYv0FRXV9KH6KYhB
         psPcjqtn9ayY66ga8LeIxRo8q/a+4PQpxGJg44NbsNdpaUihgASe60U5Nlpk/hNqh4
         ooYGZra/s8fGIcIvUtgvm5tPuyFLLW/pUl3wSSUsqTG2kxExb5r2cvgkSrlNJPMD9q
         VK+zwImukfn0A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8FE7C60A71;
        Thu,  8 Apr 2021 23:50:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] lantiq: GSWIP: two more fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161792582758.13386.16229197706913381095.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 23:50:27 +0000
References: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Apr 2021 20:38:26 +0200 you wrote:
> Hello,
> 
> after my last patch got accepted and is now in net as commit
> 3e6fdeb28f4c33 ("net: dsa: lantiq_gswip: Let GSWIP automatically set
> the xMII clock") [0] some more people from the OpenWrt community
> (many thanks to everyone involved) helped test the GSWIP driver: [1]
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: dsa: lantiq_gswip: Don't use PHY auto polling
    https://git.kernel.org/netdev/net/c/3e9005be8777
  - [net,v2,2/2] net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits
    https://git.kernel.org/netdev/net/c/4b5923249b8f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


