Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D602C54EFD5
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379749AbiFQDu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 23:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbiFQDu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 23:50:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA335663D5;
        Thu, 16 Jun 2022 20:50:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 844DA61DB4;
        Fri, 17 Jun 2022 03:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA7FFC3411F;
        Fri, 17 Jun 2022 03:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655437826;
        bh=BAcp9FUsQi9xuCXmijE5PbuibpmT+AhY9VykDC3fgWM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YV7Ioth+UOJeZ2Cm7x1FGgwGzBEnZHJ0nhv1M2GhzDCJ7UXt4Uqk1XIIIUi0c1ZhA
         NFJ81wu2FrfrUI2R8PypFjHwyqUA8PWihHac+mIdkCfYaQTxB/24FHQBghM9YQXNVq
         q9RiDD22XuX4skYEXDBB/S5zgvdl5AQLUj2ClQuKX5Vy14dqR+arrguxtv0ZdTkcwI
         qWpC05FrFn0f9AgWUbH/iZYimx1a1IGuC4l5eiNpHuKp5OZVvHlFHnfrrD+oU261+0
         2c8zFXNR82Zj5T/ydt2DDvkEb0cmFlgLjaT28hlNWzRNTaMNJFrDn7OZD3efwUkoru
         PpuiAmzIbqy1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB82BE73858;
        Fri, 17 Jun 2022 03:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/5] net: dsa: realtek: rtl8365mb: improve
 handling of PHY modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165543782676.2027.9336019448501477656.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 03:50:26 +0000
References: <20220615225116.432283-1-alvin@pqrs.dk>
In-Reply-To: <20220615225116.432283-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     hauke@hauke-m.de, linus.walleij@linaro.org, alsi@bang-olufsen.dk,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Jun 2022 00:51:10 +0200 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> This series introduces some minor cleanup of the driver and improves the
> handling of PHY interface modes to break the assumption that CPU ports
> are always over an external interface, and the assumption that user
> ports are always using an internal PHY.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/5] net: dsa: realtek: rtl8365mb: rename macro RTL8367RB -> RTL8367RB_VB
    https://git.kernel.org/netdev/net-next/c/5eb1a2384066
  - [net-next,v3,2/5] net: dsa: realtek: rtl8365mb: remove port_mask private data member
    https://git.kernel.org/netdev/net-next/c/b325159d0044
  - [net-next,v3,3/5] net: dsa: realtek: rtl8365mb: correct the max number of ports
    https://git.kernel.org/netdev/net-next/c/ca5ecd4246d4
  - [net-next,v3,4/5] net: dsa: realtek: rtl8365mb: remove learn_limit_max private data member
    https://git.kernel.org/netdev/net-next/c/b3456030f54b
  - [net-next,v3,5/5] net: dsa: realtek: rtl8365mb: handle PHY interface modes correctly
    https://git.kernel.org/netdev/net-next/c/a48b6e44a9e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


