Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D557D647CD8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiLIEK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 23:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiLIEKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 23:10:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3726ACCF
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 20:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 416EFB82642
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 04:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9ED2C433D2;
        Fri,  9 Dec 2022 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670559017;
        bh=QoIzR5Q9t+YlqJ0uV89mbO3M4jefL2tic9hNEkQpLwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LQYFTsRA2TJrG8kw1uY1lQT5t4Av8LyFp1x0Ux0SMvRmAThppfMRmlwKTelHHLnWQ
         WkDGx27uH2GKU2/z3wjKixAueNtjUQ2dFlWgXKRZ/jIZwOL9f/4HGQuvmWyp6qT+iV
         Z7+q9hoZKZFCJI76WCGlVmURmT89TeaTMYiI7CkfS8pNz9vwryFrBJ2mYmAVvvC3Db
         ANt6IordoUiuoKS3IW3SZ+3l+kNohMrST/GyBcENk1aGeEAmZY7mb1SXhf7rYOVWBl
         XGKC23z4i9jr2/wApV5qr1ZCa9IQ8bkbKQ5ALu02tCku9t4ICKgunZC7Ch7d3c3IqN
         lM0iR69wWBgRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0252C433D7;
        Fri,  9 Dec 2022 04:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: remove redundant "depends on" lines
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167055901677.13279.5278438705008476318.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 04:10:16 +0000
References: <20221207044257.30036-1-rdunlap@infradead.org>
In-Reply-To: <20221207044257.30036-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  6 Dec 2022 20:42:57 -0800 you wrote:
> Delete a few lines of "depends on PHYLIB" since they are inside
> an "if PHYLIB / endif # PHYLIB" block, i.e., they are redundant
> and the other 50+ drivers there don't use "depends on PHYLIB"
> since it is not needed.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - net: phy: remove redundant "depends on" lines
    https://git.kernel.org/netdev/net-next/c/0bdff1152c24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


