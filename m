Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4FD4DCB1F
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbiCQQVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236351AbiCQQVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:21:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B0721417F;
        Thu, 17 Mar 2022 09:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBC4BB81F26;
        Thu, 17 Mar 2022 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BA6EC340EF;
        Thu, 17 Mar 2022 16:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647534010;
        bh=HgDSJ7s434vEqvyKuZwzC5GRxOLi5zUyTlJCtSasKXQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VIVlWWr3XVQ91PlWEsqU5ZA93XV6bWAAmLFTSycJGmO4LG62ai61uowBr6Y9s9Vfg
         n8kHARfH79FhRwtRG+ReS1qGYGmuwJyH44h23/Y8DXqj8dSntK2dmmWQTBYObgt6i7
         IvzmWZvAgp2ZLeAHYtqdGyoJbA+X2dumjFgZqmem5MAgyop3UdBsqz/P2LA33gWl2h
         czA9G3pvFUeVjpweqTpy1mSKEuUnBvZZ60G4fc+WXytpdwG8ZP9kY4CIw3GESXGzk3
         w+qs7wv/nZ8ks42s9cACX6QO3IgY+z63+U6/6r4TKH8NFHswQ/g1ObPEmq9fFKFPTp
         Fl8OX7UFw89cA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48562E6D3DD;
        Thu, 17 Mar 2022 16:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: mscc: Add MODULE_FIRMWARE macros
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164753401029.12859.6997997137028972129.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 16:20:10 +0000
References: <20220316151835.88765-1-juergh@canonical.com>
In-Reply-To: <20220316151835.88765-1-juergh@canonical.com>
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        juergh@canonical.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 16:18:35 +0100 you wrote:
> The driver requires firmware so define MODULE_FIRMWARE so that modinfo
> provides the details.
> 
> Signed-off-by: Juerg Haefliger <juergh@canonical.com>
> ---
>  drivers/net/phy/mscc/mscc_main.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - net: phy: mscc: Add MODULE_FIRMWARE macros
    https://git.kernel.org/netdev/net/c/f1858c277ba4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


