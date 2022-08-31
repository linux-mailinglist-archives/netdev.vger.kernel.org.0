Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F112D5A761B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiHaGAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiHaGAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3716C33375;
        Tue, 30 Aug 2022 23:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C804F616C1;
        Wed, 31 Aug 2022 06:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B4B5C433D7;
        Wed, 31 Aug 2022 06:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661925615;
        bh=GuJ8kzLQQLbhJ2T1eBlATS4tzKVj4FiayMv6iOdMebQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cghjdnEYHMpM+qaHotf4gjFhSkQMvFqUQjfCFbG6LOrX6jcWiWYANQ5UM8ve04MK7
         qs3naM6Lky6RfV5K40GPPFdX2nmLrru7bP/ksSm2bX+5QDwDO2ssZInQYHcjpfvqYU
         BTBoeBE7nJeYPpGXUHU87mrJSercr9lJ/R6SsaIlDNnEAzfeq7bRw1LnImHboj7GSk
         ihYdeotunXyfw2Nd+DzVlhcC9iPJxTfcB+5w5LqndW4Xkq5ZmVH80wjhx3CJJMMFuv
         NE8MOFOLMuUSk7dQT/1xzMxvBrO+oM/fXRuKI4GrdYqRTjb62EZkkqBh4qa0YARtuI
         hFvtd9efUCaEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CA90E924DB;
        Wed, 31 Aug 2022 06:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: phy: micrel: Make the GPIO to be non-exclusive
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192561504.21117.7597606272151050164.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:00:15 +0000
References: <20220830064055.2340403-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220830064055.2340403-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michael@walle.cc, UNGLinuxDriver@microchip.com,
        maxime.chevallier@bootlin.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 30 Aug 2022 08:40:55 +0200 you wrote:
> The same GPIO line can be shared by multiple phys for the coma mode pin.
> If that is the case then, all the other phys that share the same line
> will failed to be probed because the access to the gpio line is not
> non-exclusive.
> Fix this by making access to the gpio line to be nonexclusive using flag
> GPIOD_FLAGS_BIT_NONEXCLUSIVE. This allows all the other PHYs to be
> probed.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: phy: micrel: Make the GPIO to be non-exclusive
    https://git.kernel.org/netdev/net/c/4a4ce82212ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


