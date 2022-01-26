Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665D749CEE0
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242736AbiAZPuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbiAZPuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:50:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207B9C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 07:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D503BB81EE4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 856C5C340E6;
        Wed, 26 Jan 2022 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643212211;
        bh=nr5TKQj6iLYFWasSvqzTw6CWseMzvff3e4bPfen0jaw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JGfOE1MBK467omsV+utXHKRLzdrdtTJggONBb2+QEYqw9eESvYZlkD0UT3axTrfX8
         ZshZwSQYvy8Oqa+/hhT5Vdmlj5Zc8y+bTM9QPMd/k3ji2A1KHsxB04r6yHn9pahIG/
         Kcgw+UIjvLtnZVVUMDUPN2abfe9ySzNWi/UaSP7DWLvcb3pWF+ymDfSVxjhCZTIj/L
         k3Y/U82Pc9How4TS7AE/Z7JBfalqOqe4Xou0WjbA2NQQT4hxKEZi5LC+wpTnlEO4Yy
         IfRln8WHQCDQuVFOXL+W8OCEZ+h3pstZGxZ5VOJxhVqWH48P9y2PJbGXvZJlGZl6FI
         TqSamHBIF6jAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E9C3F6079F;
        Wed, 26 Jan 2022 15:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/6] ethernet: fix some esoteric drivers after
 netdev->dev_addr constification
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164321221144.12592.6135964602167128218.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Jan 2022 15:50:11 +0000
References: <20220126003801.1736586-1-kuba@kernel.org>
In-Reply-To: <20220126003801.1736586-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dave@thedillows.org,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Jan 2022 16:37:55 -0800 you wrote:
> Looking at recent fixes for drivers which don't get included with
> allmodconfig builds I thought it's worth grepping for more instances of:
> 
>   dev->dev_addr\[.*\] =
> 
> This set contains the fixes.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/6] ethernet: 3com/typhoon: don't write directly to netdev->dev_addr
    https://git.kernel.org/netdev/net/c/007c95120d1b
  - [net,v2,2/6] ethernet: tundra: don't write directly to netdev->dev_addr
    https://git.kernel.org/netdev/net/c/14ba66a60fbf
  - [net,v2,3/6] ethernet: broadcom/sb1250-mac: don't write directly to netdev->dev_addr
    https://git.kernel.org/netdev/net/c/7f6ec2b2f01b
  - [net,v2,4/6] ethernet: i825xx: don't write directly to netdev->dev_addr
    https://git.kernel.org/netdev/net/c/98ef22bbae78
  - [net,v2,5/6] ethernet: 8390/etherh: don't write directly to netdev->dev_addr
    https://git.kernel.org/netdev/net/c/5518c5246ba6
  - [net,v2,6/6] ethernet: seeq/ether3: don't write directly to netdev->dev_addr
    https://git.kernel.org/netdev/net/c/8eb86fc2f490

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


