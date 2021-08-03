Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDD83DF706
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhHCVk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232802AbhHCVkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 64AF6610FB;
        Tue,  3 Aug 2021 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628026806;
        bh=fgJSoFERRgbkHdZY3UxNPUp19d9/G5RueZLA1Fsn2w4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i7rFM7dKGRJ6cNvTABowzzMPDzXR6xmCVheO12ZnKtlI4RPss5orGJBEXI38nBXh7
         nqZDvBDiM0AhAuAeKzQBkqfReAtANGS6rZ4xcpqATrHqOMYlTnIKo/LI2ltEVypvKr
         MHHpDj/K6K2NUN4uPHBJc03Hf9Kh5kUawjO9wo1rtKwyY1JOvuetlU0K2yG8TKe3e8
         iQi88ck8gH2vE7Dmtx+Hi/8+XHZ7Hqepn1IjC1NxztuYzmWOifV9JUpqUVIxYEcai2
         LHRKgD5ubhelMstUQA2GcJrcsi6KlTRf9YTJJk5QcW0Tb8bt5ogdJU2emoplsdR/19
         6OOENwWOX2JvA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5FBC160A44;
        Tue,  3 Aug 2021 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: tag_sja1105: consistently fail with
 arbitrary input
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162802680638.18812.14220476607927631866.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 21:40:06 +0000
References: <20210802195137.303625-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210802195137.303625-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        lkp@intel.com, dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  2 Aug 2021 22:51:37 +0300 you wrote:
> Dan Carpenter's smatch tests report that the "vid" variable, populated
> by sja1105_vlan_rcv when an skb is received by the tagger that has a
> VLAN ID which cannot be decoded by tag_8021q, may be uninitialized when
> used here:
> 
> 	if (source_port == -1 || switch_id == -1)
> 		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: tag_sja1105: consistently fail with arbitrary input
    https://git.kernel.org/netdev/net-next/c/421297efe63f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


