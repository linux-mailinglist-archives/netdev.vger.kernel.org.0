Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EE6617FF9
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiKCOuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiKCOuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C142317AAA;
        Thu,  3 Nov 2022 07:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75E7CB828AD;
        Thu,  3 Nov 2022 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A2CEC433D6;
        Thu,  3 Nov 2022 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667487017;
        bh=8UbJGgWQ+0k15DJORAN0LQwZhQX4buwss6b2qtLMZRM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FFwzMHVW4by733yxdQKiAnhXgaPbbu3d9NByg0TEvM5MHqy4tRfyMKeRpi2pgPfVL
         8weiKr4puY8Kg4yN3nh+rWyWiQFCA1bvWxrP0hygHLWLNmqZL/SWWuO9gU9ZVc2juk
         erj09nuyfvco9JpYmUGvogsbSa24/+AuO4w6wpTn8JLpeocGHyFBoeKlJ/WK2Rl6ZF
         ylMYRCFK2ah/7SjppcxqOx6Xv96wMgDp/g1ygcEwv2QBsXEkEQmeKiHKruykn/RavI
         A7BeFpLcvWIYZWvw1ZNnjWxilFgc424j8n6SlpKc52HCbNlY89046RoI1PS9EQw3uV
         +qEltqiXodVfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2636E270DF;
        Thu,  3 Nov 2022 14:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/6] Add new PCP and APPTRUST attributes to dcbnl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166748701692.25352.5231557884677033562.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 14:50:16 +0000
References: <20221101094834.2726202-1-daniel.machon@microchip.com>
In-Reply-To: <20221101094834.2726202-1-daniel.machon@microchip.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        maxime.chevallier@bootlin.com, thomas.petazzoni@bootlin.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, joe@perches.com,
        linux@armlinux.org.uk, horatiu.vultur@microchip.com,
        Julia.Lawall@inria.fr, vladimir.oltean@nxp.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 1 Nov 2022 10:48:28 +0100 you wrote:
> This patch series adds new extension attributes to dcbnl, to support PCP
> prioritization (and thereby hw offloadable pcp-based queue
> classification) and per-selector trust and trust order. Additionally,
> the microchip sparx5 driver has been dcb-enabled to make use of the new
> attributes to offload PCP, DSCP and Default prio to the switch, and
> implement trust order of selectors.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/6] net: dcb: add new pcp selector to app object
    https://git.kernel.org/netdev/net-next/c/ec32c0c42d0a
  - [net-next,v6,2/6] net: dcb: add new apptrust attribute
    https://git.kernel.org/netdev/net-next/c/6182d5875c33
  - [net-next,v6,3/6] net: microchip: sparx5: add support for offloading pcp table
    https://git.kernel.org/netdev/net-next/c/92ef3d011e17
  - [net-next,v6,4/6] net: microchip: sparx5: add support for apptrust
    https://git.kernel.org/netdev/net-next/c/23f8382cd95d
  - [net-next,v6,5/6] net: microchip: sparx5: add support for offloading dscp table
    https://git.kernel.org/netdev/net-next/c/8dcf69a64118
  - [net-next,v6,6/6] net: microchip: sparx5: add support for offloading default prio
    https://git.kernel.org/netdev/net-next/c/c58ff3ed432d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


