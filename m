Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9AE62F478
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241822AbiKRMUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241824AbiKRMUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C1C99EA9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84AE8624CE
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E43BDC433D6;
        Fri, 18 Nov 2022 12:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668774016;
        bh=3lZig8/kvM0pJmCy2ZVWphSNOhQrwvDZQrQQ+vhLQRY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=scXiLJzblLptaooSUUlHGXju+Uto7pygyWOp/dHGipf8xIVTvaBiaS+BoeI8S/MuH
         6+3ZIcQrE7YnKiyBQkEAJ2LWzV/WAoZLuRIvmKQkjcJl/da3Gwbf+OHQW4zNZeqO5i
         7IidJundnmQeeSOv9VHEg14X2cosqS/PrhzBu4ILSSIyoHtwALbdmmtaMKWWpawYPy
         nNE+z/SUGTCQo1lIG0Kf5eJ+dltr3Z9AB62OFL/5BJHcTOxSJHSia02hubIUSIY8ho
         x65ZiY+9NAPuuIaisywzzfVL2HB0N0DN6E3c3ZzFLdFmyXypThdDZ7zOgVmJQQCnms
         fUlf+FQxSov6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9014E29F44;
        Fri, 18 Nov 2022 12:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: sja1105: disallow C45 transactions on the
 BASE-TX MDIO bus
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877401681.25544.15110886067000312937.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:20:16 +0000
References: <20221116100653.3839654-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221116100653.3839654-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 16 Nov 2022 12:06:53 +0200 you wrote:
> You'd think people know that the internal 100BASE-TX PHY on the SJA1110
> responds only to clause 22 MDIO transactions, but they don't :)
> 
> When a clause 45 transaction is attempted, sja1105_base_tx_mdio_read()
> and sja1105_base_tx_mdio_write() don't expect "reg" to contain bit 30
> set (MII_ADDR_C45) and pack this value into the SPI transaction buffer.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: sja1105: disallow C45 transactions on the BASE-TX MDIO bus
    https://git.kernel.org/netdev/net/c/24deec6b9e4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


