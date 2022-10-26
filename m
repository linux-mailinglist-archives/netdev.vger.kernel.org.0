Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887FB60E389
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiJZOkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbiJZOkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DF1402FA;
        Wed, 26 Oct 2022 07:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06EB861F37;
        Wed, 26 Oct 2022 14:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60C98C433C1;
        Wed, 26 Oct 2022 14:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666795219;
        bh=ovw2EHwxGGBcPql+kEaMPRZ6w1YaGRMRQ8slwqBuAOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jDzWcJr4K7XONdUSfiOx8LJ6oAaTw01b+CTmGxqkvuy36Y3e7oTlSeoQ995TiO/Eu
         BdE+Fumd1Vzm6bOf5RfvadCSSFx8KYYK5Uy3PxQFi+rUpuLigB8ICYG0eIhfySck+P
         1k9roNjhx9MN/ZDAyLx2yr6HvdEGx9pjybRTRyGTE7UB+Du4D2FaCOIn058SkwPCgi
         OYN7qjXmtLBXKfVbbiKVYBw8qYU7gBaYLFQTgCUsouN4RR8er2wEKHymVFEJfx1zJ2
         7Y27YS/rCUEj5Dc+1BXDECsq6ku88bX7l9IjAyoScDccGEStJBl1p8ily9BupDuUfQ
         E2kB1w8CALGtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43597E45192;
        Wed, 26 Oct 2022 14:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154-next 2022-10-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166679521926.19839.1560136789859081700.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Oct 2022 14:40:19 +0000
References: <20221025102029.534025-1-stefan@datenfreihafen.org>
In-Reply-To: <20221025102029.534025-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Oct 2022 12:20:29 +0200 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for *net-next*
> 
> One of the biggest cycles for ieee802154 in a long time. We are landing the
> first pieces of a big enhancements in managing PAN's. We might have another pull
> request ready for this cycle later on, but I want to get this one out first.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154-next 2022-10-25
    https://git.kernel.org/netdev/net-next/c/34e0b9452030

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


