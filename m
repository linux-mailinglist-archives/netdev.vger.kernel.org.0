Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0FE6BDDC4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCQAkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCQAkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E578A6286E;
        Thu, 16 Mar 2023 17:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85FCFB823D7;
        Fri, 17 Mar 2023 00:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DC9EC4339C;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013618;
        bh=75oaCYvGR2CTHuzfa5UFenHTfeTczd1EmYlP7SUIEZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Crv96How8tnguKuZUUHfoy9JaFoxkGL/VCn4/dePrCT53XjX1z70Ttuh1ZrHevIQd
         mn/4WTFrvhQ6HlEAJypZAFbhu/NwJzebmUwkM0sxgEneCG+NKl8j4s0yHplTkVqh0p
         t9a8j9EqN+plBNMJl5t4a5/nRqPaeyQG3PCP470CmeGvPaqz5unxa8ynFYnwyrvB53
         FrMlxPk0ccpuhCFggtNoeFKi9rk+ZKnkY0EdwFAJMnM9unjB9LdYbxkUeemBzzR+2W
         5yKKGUhciq6iWv6CAWxyvAW3tQYG7ly+Ov6AqThFDpQpNYy1Gj/3bh6+EtxMXAD4BB
         P35gegd2NYERQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FEE8C43161;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] i825xx: sni_82596: use eth_hw_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901361806.32704.3683617702440941642.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:40:18 +0000
References: <20230315134117.79511-1-tsbogend@alpha.franken.de>
In-Reply-To: <20230315134117.79511-1-tsbogend@alpha.franken.de>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 14:41:17 +0100 you wrote:
> Copy scrambled mac address octects into an array then eth_hw_addr_set().
> 
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  drivers/net/ethernet/i825xx/sni_82596.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net] i825xx: sni_82596: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net/c/f38373345c65

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


