Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC6D47E751
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349614AbhLWSAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:00:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39012 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349590AbhLWSAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61819B82145;
        Thu, 23 Dec 2021 18:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25791C36AEA;
        Thu, 23 Dec 2021 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640282410;
        bh=jAg2uG8vXqX96z+/GGL2p4DAfFTmFOTAjFT9cLY/dsA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VtwvQfYMfqHBZAkrnMDeb3A6Q/8Dcokpvsyzd9O/EMSiumt5r99iTcLxLDk6relO1
         3gzcQi6Agn3z6MqzPvOfqqOIU9lnbgMz1zhYclSd7+RkoyWfahnxwudJYLptAQEfND
         cM4bVS76U7k1q6PG6Ns6vNncbbsG/NLpBF44G0+kM7G04IKx/oBnkjghh/u8EFNrUY
         jEQrIM3Ii3KQsumI9ct6/E7KTmtrdsqYMY0Nhe/847SOt0GAp2IpvPBD5frTd7QKWA
         4boUUsnNxoMWPFy36qzIuDNyqe1ZRkFuxNYsaEaXpIlBZUOyqFi592aCTrnLAY6h77
         VXtffiP1YGd0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 065ABEAC06B;
        Thu, 23 Dec 2021 18:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: tag_ocelot: use traffic class to map
 priority on injected header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164028241002.22568.15165201160627495157.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 18:00:10 +0000
References: <20211223072211.33130-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20211223072211.33130-1-xiaoliang.yang_1@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, marouen.ghodhbane@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Dec 2021 15:22:11 +0800 you wrote:
> For Ocelot switches, the CPU injected frames have an injection header
> where it can specify the QoS class of the packet and the DSA tag, now it
> uses the SKB priority to set that. If a traffic class to priority
> mapping is configured on the netdevice (with mqprio for example ...), it
> won't be considered for CPU injected headers. This patch make the QoS
> class aligned to the priority to traffic class mapping if it exists.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: tag_ocelot: use traffic class to map priority on injected header
    https://git.kernel.org/netdev/net/c/ae2778a64724

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


