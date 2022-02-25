Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900F84C51F0
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 00:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiBYXKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 18:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiBYXKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 18:10:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B00A1D2B78;
        Fri, 25 Feb 2022 15:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96CDA61CF4;
        Fri, 25 Feb 2022 23:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EADE5C340E8;
        Fri, 25 Feb 2022 23:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645830611;
        bh=5bixtJmcdqWFbLnn9WzL9G3H37OpVlKkSC4XpWjBuOU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NhfQGG8gaJr66jJsbGvzZcxoc+RU4ay1407pHsk6FPRz/euX3mfLPCibwmo0KIJ2R
         TAtfkIVVWZom7hA8Zy81Jfzm2pc7s5OYRkb0dwqbr6Tw4Vj2yMBj7hcpPRzlpXYth5
         tuPRA4ecuCWuLkCL8bi6Xvg20oQHfgS+Dphxn7V/qli0Jsu9eqax1mktepFmIgjdgy
         6J8m8FAckykMLvskJBCdLn9LVjhaPbQllYxkBK74GAL8aS+YKn9HxMIN391lk5aunY
         Yzl1M7MnlE297mi8FaoIzRn2IZhOx6BIZbkQOpMN/n99gmcBAccuTYXHMFXdwNrmr4
         qLNCuqH4xMMFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CEBBDEAC09A;
        Fri, 25 Feb 2022 23:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] can: etas_es58x: change opened_channel_cnt's type
 from atomic_t to u8
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164583061084.3517.5069364779371997975.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 23:10:10 +0000
References: <20220225165622.3231809-2-mkl@pengutronix.de>
In-Reply-To: <20220225165622.3231809-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        mailhol.vincent@wanadoo.fr, dan.carpenter@oracle.com
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

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Fri, 25 Feb 2022 17:56:20 +0100 you wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> The driver uses an atomic_t variable: struct
> es58x_device::opened_channel_cnt to keep track of the number of opened
> channels in order to only allocate memory for the URBs when this count
> changes from zero to one.
> 
> [...]

Here is the summary with links:
  - [net,1/3] can: etas_es58x: change opened_channel_cnt's type from atomic_t to u8
    https://git.kernel.org/netdev/net/c/f4896248e902
  - [net,2/3] can: gs_usb: change active_channels's type from atomic_t to u8
    https://git.kernel.org/netdev/net/c/035b0fcf0270
  - [net,3/3] can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready
    https://git.kernel.org/netdev/net/c/c5048a7b2c23

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


