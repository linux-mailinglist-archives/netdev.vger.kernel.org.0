Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF905AE24E
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbiIFIUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiIFIUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0252CE18;
        Tue,  6 Sep 2022 01:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01DCC61356;
        Tue,  6 Sep 2022 08:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 530F7C433D6;
        Tue,  6 Sep 2022 08:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662452414;
        bh=0/tjQgZt9x1iVBDGh4Ieqye/Cnstr1SYPVZd/+Hvtmc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BPU+Q075RyB4Z2HBJkOODJL3fw9eOiR/oaulKF5+IV2Wd0dEOUa10e44k9YiM/sAT
         9HfmLB27RtwGFxPFDyXva8gZZGNbDmw8lfRaFwqTmW+r7rezhxDu1KycN7TWacF0Qy
         3YHT185ym1FdYsiW3jEokF9WWTo2ELhCWfhNSw84SczzE5nZuwLoi8kaLSkTHOAU5G
         yMVSIQ4OqUotMao1czcSFeI0L56C6be3ubWDbuoGzcO6Hcic21lqEofrGD1b1DDdWb
         JsaroOBn7Gm9raRTW46xKcITejdmg4OkND33uWiUjuPGfnZ3+Lwe58pviFfTA5ClFf
         Md2jEoe6oV4nA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35897C73FED;
        Tue,  6 Sep 2022 08:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: lan966x: Extend lan966x with RGMII support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166245241421.2791.6529424706598839722.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Sep 2022 08:20:14 +0000
References: <20220902111548.614525-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220902111548.614525-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        UNGLinuxDriver@microchip.com, maxime.chevallier@bootlin.com
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 2 Sep 2022 13:15:48 +0200 you wrote:
> Extend lan966x with RGMII support. The MAC supports all RGMII_* modes.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> v1->v2:
> - use phy_interface_set_rgmii instead of setting each individual
>   variant
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: lan966x: Extend lan966x with RGMII support
    https://git.kernel.org/netdev/net-next/c/d5edc797ef03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


