Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA58D52298A
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 04:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbiEKCUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 22:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241084AbiEKCUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 22:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAB01F7E1A;
        Tue, 10 May 2022 19:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F391FB80E7B;
        Wed, 11 May 2022 02:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C444C385D8;
        Wed, 11 May 2022 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652235612;
        bh=eIJ4fPUoByXuETSaRKF97jSwOAi2SBfrcalrVlkk3g4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=izzoJdlZya4l1jkVTC+9UFajfSKtQLwOHzNqm7P2j56Fz8h1qwORfMTdVzUEev5ak
         Q6poJPmIxtnrM9q/b2CX8GEqWcfuMoXOsvrdELeusNsbW/VOfz9/FfOcIemODSMeFo
         HKMOcnvkyzDjIRTWxN2WszOz8Y/05/Wb77F81fpLsA2znktez41w4GbCqQ7bLGqDNp
         PffMdOLon6ItaMxdeU+wC/GUOTqV8SYb5HpRzkTG40zM0M2d2gft4lGntDWvd1IizW
         rTS7k4woCP5g1ItfZEWVjBcMgH/WKbYhE2BaS+FA+XeGkvAKjZFgXVK8GHBctHNTgb
         MyuRqSjhJ20VA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5AB48F0392B;
        Wed, 11 May 2022 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165223561236.21834.15484862812864073697.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 02:20:12 +0000
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  6 May 2022 09:06:20 +1200 you wrote:
> Convert the marvell,orion-mdio binding to JSON schema.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
> 
> Notes:
>     This does throw up the following dtbs_check warnings for turris-mox:
> 
> [...]

Here is the summary with links:
  - [v2] dt-bindings: net: orion-mdio: Convert to JSON schema
    https://git.kernel.org/netdev/net-next/c/0781434af811

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


