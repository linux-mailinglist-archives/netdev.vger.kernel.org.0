Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A25A5A32D7
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbiH0AAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiH0AAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B437A27143;
        Fri, 26 Aug 2022 17:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69296B8334D;
        Sat, 27 Aug 2022 00:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 260ABC433D7;
        Sat, 27 Aug 2022 00:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661558415;
        bh=kmpN9J1gfmCEeL8ftwlH2mqA3XlLfaa49oHRSbXJlXw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kvCmFmKfBwX+KJzMgQRcBLV+ctvRvVOwdErakUp8/7DhngeEb+58A1WpWeXqXDpMR
         roGB80GW4gtrQS7GGAH3N+lfcgZoeeGNDJh4OK2PJ8fGicOvbRuBF77UPDJGRufLqM
         4K72E7FkSR43SI85m2DOsWOVKevwm3k4fi1a5r/udkMpGNm+blImDVdXVxChTFOb1o
         PHHxcvJe50h1/W6+6Zm7oRperCNtbRqeMf4sUo7CaXp7imVRZVcmq3bOa0+X5St670
         s37kOMcsCLEHK2YeRlW6OWYYoMyHd7nU0+Je1Rb+pc3oRVzstSZeXfDMTAfkncJ5ux
         QvZsOrmJGLIkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8AFBC0C3EC;
        Sat, 27 Aug 2022 00:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: support RGMII cmode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166155841494.20542.16295149435804772174.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 00:00:14 +0000
References: <20220822144136.16627-1-marcus.carlberg@axis.com>
In-Reply-To: <20220822144136.16627-1-marcus.carlberg@axis.com>
To:     Marcus Carlberg <marcus.carlberg@axis.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@axis.com,
        pavana.sharma@digi.com, kabel@kernel.org, ashkan.boldaji@digi.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Aug 2022 16:41:36 +0200 you wrote:
> Since the probe defaults all interfaces to the highest speed possible
> (10GBASE-X in mv88e6393x) before the phy mode configuration from the
> devicetree is considered it is currently impossible to use port 0 in
> RGMII mode.
> 
> This change will allow RGMII modes to be configurable for port 0
> enabling port 0 to be configured as RGMII as well as serial depending
> on configuration.
> 
> [...]

Here is the summary with links:
  - [v3] net: dsa: mv88e6xxx: support RGMII cmode
    https://git.kernel.org/netdev/net-next/c/1d2577ab0f05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


