Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B02B315A9A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhBJAFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234510AbhBIXUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 18:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D335064DED;
        Tue,  9 Feb 2021 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612912806;
        bh=bAt1oeLCg31TysEVsK497hpE4raxaHSPdwEN+p+qx78=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=po4cmHQVexIpTiec2qvVRPD5tsIpf5E4wuukuA/zCCzjEbnve6QWDerWRTaBSCPBJ
         d4m9ZU+FdOvJbvBrbNuDe+gpRf5Y60NWg3XCgHrfCCrqvBr0wJ7m0LN73IUNj8NGXa
         0xRJ6FhKZFtDT3f7tlJXiiHu0LbbWQPxFwP46DJy818/Udj5WH2bHdx/hH134ZUMmn
         bhtVc+GZ67nrzCvHuvzu+foL3mPa0gz78tCuiLddnWxHtS2RdP2qRzlpnLk8u+INwq
         wdhxPelLUTE9/qMvnXWGC4UKX12rMKvHkBREDkou4EYBQh0hHikimWOI0+b2evBk6A
         gGgANZGwdG+wA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CAB49609E4;
        Tue,  9 Feb 2021 23:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: felix: implement port flushing on
 .phylink_mac_link_down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161291280682.19708.5764129342254978594.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 23:20:06 +0000
References: <20210208173627.3128054-1-olteanv@gmail.com>
In-Reply-To: <20210208173627.3128054-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        vladimir.oltean@nxp.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  8 Feb 2021 19:36:27 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There are several issues which may be seen when the link goes down while
> forwarding traffic, all of which can be attributed to the fact that the
> port flushing procedure from the reference manual was not closely
> followed.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: felix: implement port flushing on .phylink_mac_link_down
    https://git.kernel.org/netdev/net/c/eb4733d7cffc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


