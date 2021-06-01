Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AB6397C48
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhFAWLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234834AbhFAWLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 59BDB613BD;
        Tue,  1 Jun 2021 22:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622585403;
        bh=ZQtZzhZCHvlH3zsG8lYigGHLinYQM/FQsWg2DCKuyOw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tI770uRIwZ0Ybknp6QElmA1JadHnXB+PTRddb0HwptOrCJu/bMMUj/2CD6ydvW3Va
         S0/IwGmOH/7ubgKQk75VyQYt43oLdixX2ePkuf40frX/Zo2Xh6Xl02mI6wKWghGXh+
         u3q3NzAgo0w0YiW0L+/M2KtyKFYPaOFCZoJDoJxafOc51MdvU83NmE1FuEmpLu575m
         IvU1HLhQrEotm+W+7c9Om1neP8ftdClipTJuNAOaFfYTkNIpr4WHOuPDjJuHzFzh0w
         paKyha8UIpjagJvcN/5opkIO5IqdmDdOvujNlJAnNvD9LuZJ2BE5P7mWZNJOfAslvN
         U4YqN7IwSAYtA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4B84460A13;
        Tue,  1 Jun 2021 22:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: tag_8021q: fix the VLAN IDs used for encoding
 sub-VLANs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258540330.3374.1595921208880563538.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:10:03 +0000
References: <20210531102045.936595-1-olteanv@gmail.com>
In-Reply-To: <20210531102045.936595-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 31 May 2021 13:20:45 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When using sub-VLANs in the range of 1-7, the resulting value from:
> 
> 	rx_vid = dsa_8021q_rx_vid_subvlan(ds, port, subvlan);
> 
> is wrong according to the description from tag_8021q.c:
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: tag_8021q: fix the VLAN IDs used for encoding sub-VLANs
    https://git.kernel.org/netdev/net/c/4ef8d857b5f4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


