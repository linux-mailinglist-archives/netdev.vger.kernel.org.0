Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B9263E9F3
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLAGkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiLAGkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C98666C83;
        Wed, 30 Nov 2022 22:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD128B81E53;
        Thu,  1 Dec 2022 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BAFBC433B5;
        Thu,  1 Dec 2022 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669876819;
        bh=T+76SBZBPCjQ8Txv2yasn/Em9TAm8dlVwV7h8aRw79I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hEjOtXrcz2t3Bkk4v0lU4K7t6WQfizF5dnNPXm2xAcC6m/XtIwG8x1MckQdBCBdb3
         U7M6/AFmTIPy22NYObZiEPG6ztMdiWSc86jMsHiGHGxIRhu+IZh8uEC2O3a0+10Vnq
         zLsd3RPrZfnXJ133lzsiVawpEZCbbzN9aYCe3pnLVEJ4dtGW+IoLTb0p5osy+1QLu8
         t19T+UPbKRwhx6PLM8ON277jZWttsW+/u3WL8skH5AEAckoY07jCpES5K/A/rPDRox
         cLQhwDRZJRcq6m9PmKxREI5nGXfIlam83lYuvzHiupRspjWzPOEc0GeNDahzx/78+i
         Bv0OJdCnWkIEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CC2AE21EF1;
        Thu,  1 Dec 2022 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [v3][net-next][PATCH 0/1] net: phy: Add link between phy dev and mac
 dev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987681924.1827.10288099850004190883.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 06:40:19 +0000
References: <20221130021216.1052230-1-xiaolei.wang@windriver.com>
In-Reply-To: <20221130021216.1052230-1-xiaolei.wang@windriver.com>
To:     Xiaolei Wang <xiaolei.wang@windriver.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, 30 Nov 2022 10:12:15 +0800 you wrote:
> Compared with v2, the comment of phydev->devlink is added, and the net-next tree is specified
> 
> If the external phy used by current mac interface is
> managed by another mac interface, it means that this
> network port cannot work independently, especially
> when the system suspends and resumes, the following
> trace may appear, so we should create a device link
> between phy dev and mac dev.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/1] net: phy: Add link between phy dev and mac dev
    https://git.kernel.org/netdev/net-next/c/bc66fa87d4fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


