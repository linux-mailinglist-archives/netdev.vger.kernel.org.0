Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6075BE957
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiITOuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiITOuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFDC2E9C6
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 07:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E570B820D6
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 14:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30E47C433D6;
        Tue, 20 Sep 2022 14:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663685415;
        bh=AUf4R83RHeyMCObVUdD57w7rU08Vb4dqZ93OdlFx6uU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MAmc5e1rtrSb86npqnzKlQhpNsT1fREtfsw4fHpC7SCIAZTp+hCGYiHcdpflcX2I3
         uktCl/2CxT6kOtZRxG5hhCZTCqjoWeI8fKiE7qAcSH76sXZeag5L3DZbNfiOzvpdX4
         l537A6jYMvnxr1EKwhBf8hBWTWiIfVR0peA9AfYX+6eE33+HhK4ECclQ5Dbo+yA+wo
         Y2VFc/fsvkWF1uWyDyQ7uD8LVwPiONDwO42mMQhvtmzCS3SdZ57wYwMYcUvoialvh0
         BmWTfFkL2irKxIicmyUw/16+FuiYxgfnVApIRKFfyaNarbDrrypLKw6Tl8onPe4RCm
         vWlIPTwDKfClQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FD18E21EDF;
        Tue, 20 Sep 2022 14:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] of: mdio: Add of_node_put() when breaking out of
 for_each_xx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368541505.14330.9733810110021629972.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 14:50:15 +0000
References: <20220913125659.3331969-1-windhl@126.com>
In-Reply-To: <20220913125659.3331969-1-windhl@126.com>
To:     Liang He <windhl@126.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, linmq006@gmail.com
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

On Tue, 13 Sep 2022 20:56:59 +0800 you wrote:
> In of_mdiobus_register(), we should call of_node_put() for 'child'
> escaped out of for_each_available_child_of_node().
> 
> Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
> Cc: Miaoqian Lin <linmq006@gmail.com>
> Co-developed-by: Miaoqian Lin <linmq006@gmail.com>
> Signed-off-by: Liang He <windhl@126.com>
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] of: mdio: Add of_node_put() when breaking out of for_each_xx
    https://git.kernel.org/netdev/net/c/1c48709e6d9d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


