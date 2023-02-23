Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90B06A08ED
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbjBWMu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbjBWMuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:50:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323C84347D;
        Thu, 23 Feb 2023 04:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2CC9616E2;
        Thu, 23 Feb 2023 12:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18B5CC4339C;
        Thu, 23 Feb 2023 12:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677156618;
        bh=k/zfOZdSysmgGEOY3HCo9LWxf5CG6W36SD3TdytTxLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MwhJJX8pjGEpaxM21G2fPrsVQIo1AuEq9efCKIusZYH8K+fwcqre5oZuFYcy7w7hf
         JVpn/kQdgg1JiadFsrl1dCDJC3uqUii2JqjngHGiT0anZxYYo48cDUHRMe7UFRNkrv
         jIcU4eMfKz1QgUPU4/YaoIjFMI+KrvhGDJ5aUdxOZl7G7MQ+LIAL05U7p/T+5nIW3/
         pOzIH5a5Anc89Kycpu4nU/Jy492F9s7E7LLcr5v4RVTJRsRs6j8Vz1KlG3kaAJnnCC
         wz6cRbLH21O49PiAy0s/ETFyxUoYspu/XhYiQX1gaRoBTnHsbWJWf+25KaTfuaHsa1
         mF55OaXqYni1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 005E3E270CF;
        Thu, 23 Feb 2023 12:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v333 0/4] net: phy: EEE fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167715661799.11159.2057121677394149658.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Feb 2023 12:50:17 +0000
References: <20230222055043.113711-1-o.rempel@pengutronix.de>
In-Reply-To: <20230222055043.113711-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux@armlinux.org.uk
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 22 Feb 2023 06:50:39 +0100 you wrote:
> changes v3:
> - add kernel test robot tags to commit log
> - reword comment for genphy_c45_an_config_eee_aneg() function
> 
> changes v2:
> - restore previous ethtool set logic for the case where advertisements
>   are not provided by user space.
> - use ethtool_convert_legacy_u32_to_link_mode() where possible
> - genphy_c45_an_config_eee_aneg(): move adv initialization in to the if
>   scope.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/4] net: phy: c45: use "supported_eee" instead of supported for access validation
    https://git.kernel.org/netdev/net/c/e209519b6233
  - [net,v3,2/4] net: phy: c45: add genphy_c45_an_config_eee_aneg() function
    https://git.kernel.org/netdev/net/c/b6478b8c9330
  - [net,v3,3/4] net: phy: do not force EEE support
    https://git.kernel.org/netdev/net/c/3eeca4e199ce
  - [net,v3,4/4] net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
    https://git.kernel.org/netdev/net/c/186b1da76b72

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


