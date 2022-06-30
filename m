Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A80560FD4
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 06:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiF3EAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 00:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiF3EAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 00:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6E82BB2C;
        Wed, 29 Jun 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32BB1B8283B;
        Thu, 30 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DEBF7C341CD;
        Thu, 30 Jun 2022 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656561614;
        bh=FiZadh8ifGbZ5voaDFksNA95qAzHSHfz7Mzo/JeB5t0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rk88ythk5q0Wid3jrXM0OpPTxiauJOvE7iz9gxDL7IV2YHCG/4Drjx9bKJkWIOL3g
         dN9UY0svS3kIdUDsCkINb1gnloUZdBA3vB7efGwAnDhlQ3r48tXk6XFAm4RThSdBeb
         TxD/zsJcE+zhEDJg95ra1V2OxQc4PFTxHievTrogZX5OLwKRCSduc4xrTBMGSDE4Rf
         DdYNgW5jggojqJcHwLnhW4PbFhPc3PDks7ilMJeZHbO00NGdJjOVEEU+jFDSuzfYRp
         Y18ocagLm/gB9VD2WnlbtpWbsGwqF7WtzjFvArZX6iwDFSo77/RnzeOpwGHqOm8gUH
         WmEZDMC2wuoFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC2F4E49F65;
        Thu, 30 Jun 2022 04:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/1] net: phy: ax88772a: fix lost pause advertisement
 configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656161376.1686.5072161115183676220.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 04:00:13 +0000
References: <20220628114349.3929928-1-o.rempel@pengutronix.de>
In-Reply-To: <20220628114349.3929928-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lukas@wunner.de
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Jun 2022 13:43:49 +0200 you wrote:
> In case of asix_ax88772a_link_change_notify() workaround, we run soft
> reset which will automatically clear MII_ADVERTISE configuration. The
> PHYlib framework do not know about changed configuration state of the
> PHY, so we need use phy_init_hw() to reinit PHY configuration.
> 
> Fixes: dde258469257 ("net: usb/phy: asix: add support for ax88772A/C PHYs")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [net,v3,1/1] net: phy: ax88772a: fix lost pause advertisement configuration
    https://git.kernel.org/netdev/net/c/fa152f626b24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


