Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B1C4BC95C
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242624AbiBSQkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:40:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242608AbiBSQkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:40:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A401D178B;
        Sat, 19 Feb 2022 08:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4295860BA6;
        Sat, 19 Feb 2022 16:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90BB3C340ED;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645288811;
        bh=sU8Rz7APMKrkq9JR0hWZKKxLKQZub2GIuh95bEvOIZI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gAvsSFRHQlZmCtwFDfdGojwHL8TGO6BKyy/4ho7DmrU4MLq/9hAfssfX9jkDRwNVL
         dtRzlF1Xqrb4ysM1kAYMyCpD675vShHcQh4ia3+64kYDuCUN2eBDbBnVXCdLJfONkv
         jCnKOZyroGgjuvEebjYkcJyxM0NIG/icJlaqYpmCJ/b1zzlysMLqQRYgoOfCq2HkpP
         lFG8VUmGEbo5go+NPTo9AIkqEenxEAEygiFpD07vTu/RRgdiTqA8uCJ9n+iUSYSRiN
         dfRTT9bSGvCeJREUHLbvznGUkax18Gb4ldfWNip0kaKmfRbUC1hDa4LGdUuP3koW4G
         +WGjVHCNR2XjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73185E7BB08;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: prestera: flower: fix destroy tmpl in chain
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164528881146.6364.519355923426975783.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 16:40:11 +0000
References: <1645177190-6949-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1645177190-6949-1-git-send-email-volodymyr.mytnyk@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, taras.chornyi@plvision.eu,
        mickeyr@marvell.com, serhiy.pshyk@plvision.eu, vmytnyk@marvell.com,
        tchornyi@marvell.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Feb 2022 11:39:49 +0200 you wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> Fix flower destroy template callback to release template
> only for specific tc chain instead of all chain tempaltes.
> 
> The issue was intruduced by previous commit that introduced
> multi-chain support.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: prestera: flower: fix destroy tmpl in chain
    https://git.kernel.org/netdev/net-next/c/b3ae2d350ddf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


