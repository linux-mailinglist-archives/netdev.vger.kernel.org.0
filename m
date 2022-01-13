Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B03348D864
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbiAMNAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiAMNAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:00:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1177BC06173F
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 05:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A5D9CE2022
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 13:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1E6CC36AE3;
        Thu, 13 Jan 2022 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642078811;
        bh=wAnyhFFuNrTXNv7kmq9uDJcykkkek8gLL0dGYgFY/pY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mi8OqN2A8VvdoYJ6Bxpc7Hmh9wb1/8bgLs5zUTX/eOs3uzNAVQvg1qhF13UMaMl2l
         MHcpOezCwnYVzNls3sDkJdQwywP6JGEeAr8NAbgWgBelybnt4qEordrzdWM/hbNxu+
         v5iE7uu/L/dU5XD/PiV3mi53sPzHiRp14kpglbOqPg3Yn/4me2VkEt7797tkBozA49
         UnDnPvVUZ3VtoO4ZPA5qKkCLmRfro//o78kvVISaHbuk/9+JlOTdMQOFjBg2dDYdl4
         srSqwS4UrclOXXI5NFfk+rFBwq1c+dnenTsXBpIO1w7gIL4uCzePQjzqnK0hs5f5Ld
         5oRpu52iTDLqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9B23F6079A;
        Thu, 13 Jan 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: don't let phylink re-enable TX PAUSE
 on the NPI port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164207881165.26897.8899828696941600247.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Jan 2022 13:00:11 +0000
References: <20220112202127.2788856-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220112202127.2788856-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, xiaoliang.yang_1@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Jan 2022 22:21:27 +0200 you wrote:
> Since commit b39648079db4 ("net: mscc: ocelot: disable flow control on
> NPI interface"), flow control should be disabled on the DSA CPU port
> when used in NPI mode.
> 
> However, the commit blamed in the Fixes: tag below broke this, because
> it allowed felix_phylink_mac_link_up() to overwrite SYS_PAUSE_CFG_PAUSE_ENA
> for the DSA CPU port.
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: don't let phylink re-enable TX PAUSE on the NPI port
    https://git.kernel.org/netdev/net/c/33cb0ff30cff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


