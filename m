Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4085159B3
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382025AbiD3Bxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382022AbiD3Bxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:53:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029301131
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99DC7624AE
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 01:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1D75C385A7;
        Sat, 30 Apr 2022 01:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651283412;
        bh=HTD6XX8cH6KI1U5Kd5QRUoI+SUJsIpEvWY1ji8dfOZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DUGnhXo7joOLiSirXA3A2Ge69aFtXVk1YPsqABRHwlonpjpo8X3xqxAAVg6avqBA8
         aouj5vxGS/LR3aI7ivZoXloqAYfhSiIzOsyrbInsdeEmZiGSCu3oPT40rLQjp1v1dl
         GyPHH68g9cQ3T2Br0882zMRbHUCONPUMT4PTWrWsRe4cHEwsRRsaAtt0rF0LN1NvK0
         NUeS/SntnGtuy39+vaMGk1ub3foumvPXEDRZtnhN/26n8QiQ4SXhwlLppFukgexRXa
         nSldP518HouPRY6cMdmNfWD9L8fgJr4q9ubDuR7IaMBe2YNREaNz9xOA4acokoFa/N
         nA4mqwzRQwYlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C026EF03870;
        Sat, 30 Apr 2022 01:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mdio: Fix ENOMEM return value in BCM6368 mux bus
 controller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165128341178.13664.13010146182410759617.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 01:50:11 +0000
References: <20220428211931.8130-1-dossche.niels@gmail.com>
In-Reply-To: <20220428211931.8130-1-dossche.niels@gmail.com>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, noltari@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 28 Apr 2022 23:19:32 +0200 you wrote:
> Error values inside the probe function must be < 0. The ENOMEM return
> value has the wrong sign: it is positive instead of negative.
> Add a minus sign.
> 
> Fixes: e239756717b5 ("net: mdio: Add BCM6368 MDIO mux bus controller")
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: mdio: Fix ENOMEM return value in BCM6368 mux bus controller
    https://git.kernel.org/netdev/net/c/e87f66b38e66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


