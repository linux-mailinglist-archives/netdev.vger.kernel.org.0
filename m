Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF9864E6AE
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 05:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiLPEaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 23:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiLPEaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 23:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4136D60374;
        Thu, 15 Dec 2022 20:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB5EC61FEB;
        Fri, 16 Dec 2022 04:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C2C8C433D2;
        Fri, 16 Dec 2022 04:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671165017;
        bh=Y8PpQegsT0Jaj/iyXfDRZJcPjMsrLgQHSLOjtoL0Fw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CyO4tvc/PRvjJjDUWHR3yVK4QpoXw7MFwLARRqm52vty0w/+4uFvi3QOuTUSv7nzZ
         Oa+YffDmRav8ynhcx4NmigfJy983ZeppyVvAh0F8ZNVrMO7Wk0gnXM+f7OarVo1xqm
         rIhewckUfS38bIuwIsLx4tbJnkfRjWF8ICrCDGBqmbGgd9sdxKMhmvWKjY5rdf3F+F
         x8E8DsQzzWCNNyGZum/2ziclWVx5mnTVr5hRknLMLnFIvzqWyNSo8qpGkyycQLJ1aU
         YQI0JV6SEdnipZHfSjcMhMLy76LZJvq3U5CyrB1tf88LtSuYaT01GgIygdgVFeeB4k
         P0hPF3u9A3JHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D946FE21EFC;
        Fri, 16 Dec 2022 04:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: dsa: mt7530: remove redundant assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167116501688.3301.2964506948018173523.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Dec 2022 04:30:16 +0000
References: <Y5qY7x6la5TxZxzX@makrotopia.org>
In-Reply-To: <Y5qY7x6la5TxZxzX@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        dqfext@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Dec 2022 03:47:59 +0000 you wrote:
> Russell King correctly pointed out that the MAC_2500FD capability is
> already added for port 5 (if not in RGMII mode) and port 6 (which only
> supports SGMII) by mt7531_mac_port_get_caps. Remove the reduntant
> setting of this capability flag which was added by a previous commit.
> 
> Fixes: e19de30d2080 ("net: dsa: mt7530: add support for in-band link status")
> Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> 
> [...]

Here is the summary with links:
  - [net,v3] net: dsa: mt7530: remove redundant assignment
    https://git.kernel.org/netdev/net/c/32f1002ed485

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


