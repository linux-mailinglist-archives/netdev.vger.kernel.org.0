Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3D04A5E4D
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239311AbiBAOaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:30:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43716 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239295AbiBAOaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 09:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58F6BB82E45;
        Tue,  1 Feb 2022 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16A58C340EE;
        Tue,  1 Feb 2022 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643725809;
        bh=N6/fI8OqujQZggJANj8+YfOQ+uxquuX9V44cBnf/IeQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ioNIiNe3KkGTA4wRSJZul6FFAeuILX6Govbt+l/SVbb4McYdagO7AzgAV3JDjd2Ri
         ds7ZuoemqGUPsdlOsWzvQ577IZLKw6+UNO8qjWf7XcRPhuxJYvmdS0akXSMZaGlvY4
         HLy20aDO3IgBk4bv3WYuApDGiVqfdP/QzfJYcmAhxEP1w7gKymGC5dq68HMn9nDmwi
         led5bYP0BINbnT8QivkLaDxRKApRbAEb6/4ljsbzUSFOikafoxT8SLCJfzwDK27fDx
         Y1jXXDyOPdZkxMuiu/w0GCC8A15edWSIY6jCfK9kZJ5C0H98kndynOzIx9iF8QUcfJ
         WfqMF4ncTID3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F40B8E5D07D;
        Tue,  1 Feb 2022 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164372580899.3866.12449291853184309097.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 14:30:08 +0000
References: <YffqmcR4iC3xKaRm@earth.li>
In-Reply-To: <YffqmcR4iC3xKaRm@earth.li>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, luoj@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        robimarko@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 31 Jan 2022 13:56:41 +0000 you wrote:
> A typo in qca808x_read_status means we try to set SMII mode on the port
> rather than SGMII when the link speed is not 2.5Gb/s. This results in no
> traffic due to the mismatch in configuration between the phy and the
> mac.
> 
> v2:
>  Only change interface mode when the link is up
> 
> [...]

Here is the summary with links:
  - [net,v2] net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
    https://git.kernel.org/netdev/net/c/881cc731df6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


