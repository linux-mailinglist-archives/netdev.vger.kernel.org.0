Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768E5420B2F
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhJDMv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhJDMvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:51:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE97E61264;
        Mon,  4 Oct 2021 12:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633351807;
        bh=gJH9Av8EAPXoGFoRHboMux7+C/gT05/kA6g8tzMW//M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uaRdYSf+M2S+UOxxPEqP+UODA61/jCz4vilE2IvyF5Hh/M7dncIezXLy5I0XevKDf
         JQyFNa2P39eXKgvbd1gZZhZ3n2ExCvw+llXkimXNG44W5A/L1AVRkI6B0pn3A5OyE1
         YnckCS7GhEXMISPsOI0+cy/sEuHAeZmKUgSbGcXe67h2TlDUIOJFHO0b4j3EUR5W5c
         zQh3IJom+fNJlYEp43nN8mJy6BpiFDldmaIsKZ2LRcGi32TnSMpk0+IwshAssPgEuR
         xAdlVKZsE17/GQgXm/02Dona+chpXnjHAP7K8lUv13zKCCg5XbdVgveSCyUbg+Hc5/
         d0h9wbzdohX+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0A0E609D8;
        Mon,  4 Oct 2021 12:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dsa: tag_dsa: Fix mask for trunked packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163335180691.12531.12060090662130362387.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Oct 2021 12:50:06 +0000
References: <20211003155053.2241209-1-andrew@lunn.ch>
In-Reply-To: <20211003155053.2241209-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, tobias@waldekranz.com,
        vladimir.oltean@nxp.com, f.fainelli@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  3 Oct 2021 17:50:53 +0200 you wrote:
> A packet received on a trunk will have bit 2 set in Forward DSA tagged
> frame. Bit 1 can be either 0 or 1 and is otherwise undefined and bit 0
> indicates the frame CFI. Masking with 7 thus results in frames as
> being identified as being from a trunk when in fact they are not. Fix
> the mask to just look at bit 2.
> 
> Fixes: 5b60dadb71db ("net: dsa: tag_dsa: Support reception of packets from LAG devices")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [net] dsa: tag_dsa: Fix mask for trunked packets
    https://git.kernel.org/netdev/net/c/b44d52a50bc6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


