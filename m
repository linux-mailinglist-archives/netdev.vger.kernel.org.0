Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7796D653F09
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiLVLaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 06:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiLVLaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 06:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3056727163;
        Thu, 22 Dec 2022 03:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E76F2B81D2A;
        Thu, 22 Dec 2022 11:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86375C433F1;
        Thu, 22 Dec 2022 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671708616;
        bh=bgeJ1yyX8WB7ydLbguIQfUNtKGE95d5l19qml2ygD4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aGeC2co91hAzKN2lkec2Cetk4zyUa6UZ5hlHvwkUQFdrZXfW45LC9r38EmaiLtIGC
         WdMbAgrEMwdJW+yM9tkM0VqqbXGW2bZ18QN7F6QoAi8Jg/Oy/IR4Ggk6T7RIHJ0yhv
         OiXJoJRAXjPG2QCTLHRL6GH1+Tilirl0NjWIFW/SOIs6vQ9UgbBV2SDtG1KlT910sx
         h6w7jPncmN9ryyXp4fQPDEDdGSf/MPg6DddgrQbIKuWhXiL5U/QcAsnkJECldII98B
         wdI6AP9319WCC2TRxVeNX1ueBG16yOBS3MPVnFxuW+jLiPcPzvWIJqE9SWLOifj4OG
         WIu5eK90YR2jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DCB2C5C7C4;
        Thu, 22 Dec 2022 11:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: Fix configuration of the PCS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167170861644.28908.6275637888660936457.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Dec 2022 11:30:16 +0000
References: <20221221093315.939133-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221221093315.939133-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 21 Dec 2022 10:33:15 +0100 you wrote:
> When the PCS was taken out of reset, we were changing by mistake also
> the speed to 100 Mbit. But in case the link was going down, the link
> up routine was setting correctly the link speed. If the link was not
> getting down then the speed was forced to run at 100 even if the
> speed was something else.
> On lan966x, to set the speed link to 1G or 2.5G a value of 1 needs to be
> written in DEV_CLOCK_CFG_LINK_SPEED. This is similar to the procedure in
> lan966x_port_init.
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: Fix configuration of the PCS
    https://git.kernel.org/netdev/net/c/d717f9474e3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


