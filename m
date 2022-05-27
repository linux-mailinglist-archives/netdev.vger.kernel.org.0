Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7444A535F26
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 13:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244990AbiE0LUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 07:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244684AbiE0LUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 07:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1E012698E;
        Fri, 27 May 2022 04:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B95F61CB6;
        Fri, 27 May 2022 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A012FC34113;
        Fri, 27 May 2022 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653650412;
        bh=MeNcJ1RMkgY4m5ptE96b0P/31qMrByU6sk4dUWYsWzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ejlNXm9cWWA8D+vbjsmOZrlO6qZpvsduQp4q9HB/3wj5AKIf3gvM2ZbnIvYNdzUMz
         wkpTX3H4COpzRn19KL8cEsVYl/JX6N2nDCKSJ0qW45dSTZ3gRpM3DOP7jFq2iI+WkD
         GLzw4BjA1cUWl3TbmdrIfzCe0ZYke1y/u3rpv8JpyVK4Mn7/2H7fXyxobYQgQcXO7u
         5GG86ZLUI5A+Qab8f425Vx+mJIzzDvt45Orlgfk5aYZ4xQK+XipeZ7KU93TMrOrSqR
         wRdiK28FGdspL7jW5FQ1Qb735UBryDAINbxg4olQ9KQckt6akj+Qz3ABVzzx608aoG
         5Z8zQWKKjyIiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83594F03947;
        Fri, 27 May 2022 11:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan743x: PCI11010 / PCI11414 fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165365041252.2876.15372602203233940410.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 11:20:12 +0000
References: <20220527041728.3257-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20220527041728.3257-1-Raju.Lakkaraju@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com,
        Ian.Saturley@microchip.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 27 May 2022 09:47:28 +0530 you wrote:
> Fix the MDIO interface declarations to reflect what is currently supported by
> the PCI11010 / PCI11414 devices (C22 for RGMII and C22_C45 for SGMII)
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 32 +++++++++++++------
>  1 file changed, 22 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [net-next] net: lan743x: PCI11010 / PCI11414 fix
    https://git.kernel.org/netdev/net/c/79dfeb2916d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


