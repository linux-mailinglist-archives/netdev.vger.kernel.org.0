Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B0D48647E
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238969AbiAFMkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:40:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33196 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbiAFMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0B12B8210C
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D03DC36AF6;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641472811;
        bh=MChYf56gQkdYOk91u078J/ntW4mIvvzkVDAjtYw2mR4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pkph2wURPMne7+li4Dce+gPcDrfcYboqb1uoPRgnDu0v6KUooGw3VJjBOsqXoC7/9
         oK/PB+nAItHKZgmRutxeOcqUW3f0/6tCiTZciVyWrdyBNDa5QZC6O4lQU5q6kcLrUv
         T38aTpQ5KRo/lKmytZjFRsf+zE+XnB+PUqgQIE3I7aa5/BgUpsbJBVOOB1p3Areoiq
         1EbphWAD//14AQzxNd5O2G+mc5zDAvoQTyDN0Su68gT+Lkw3sF67aj8ggDvzJAQtia
         OLG39k1Wx+2lryRCqrVn/+wuo3DYLXEWg8/8hwtvN9U46BJI9asVcQJ1LCDEHEJtBP
         c458ldylmf0Aw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 849A8F79405;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: dsa: don't enumerate dsa_switch and
 dsa_port bit fields using commas
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147281153.4515.15333453604803456481.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:40:11 +0000
References: <20220105221150.3208247-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220105221150.3208247-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Jan 2022 00:11:49 +0200 you wrote:
> This is a cosmetic incremental fixup to commits
> 7787ff776398 ("net: dsa: merge all bools of struct dsa_switch into a single u32")
> bde82f389af1 ("net: dsa: merge all bools of struct dsa_port into a single u8")
> 
> The desire to make this change was enunciated after posting these
> patches here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220105132141.2648876-1-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: don't enumerate dsa_switch and dsa_port bit fields using commas
    https://git.kernel.org/netdev/net-next/c/63cfc65753d6
  - [net-next,2/2] net: dsa: warn about dsa_port and dsa_switch bit fields being non atomic
    https://git.kernel.org/netdev/net-next/c/1b26d364e4e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


