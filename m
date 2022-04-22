Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE24A50C51E
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiDVXnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiDVXnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DB51D6;
        Fri, 22 Apr 2022 16:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66176B83344;
        Fri, 22 Apr 2022 23:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A4A2C385AF;
        Fri, 22 Apr 2022 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650670812;
        bh=Zz8arpoojEhk62PVqqfRPHXkmRzZTIMvITFqyc0FSig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gZTsXTfNYU/I3Jnc3wBlS4vEgsoB2jU5yDEsSXGbmN2KNwjReLJd6Obj5PHl1gFIi
         SwmIsaHCPcVv4SrQwcJTMa0L8JFxXN+lbINVgpHOOPxTJjGqj3H561dS/9v9b4QZjv
         +dXy0NsZj97hMK+Jwz8AoAmyIS+1EhiCaBLl/DE9Gm06EGsMEMEdred30GGzInwf7W
         v/eLSkK3TQc+0Hh3m3LDCJVg5tJUa8hPggTm0IWUC1/7PYx7J2MVtrUFR4l0WLlf6y
         /mfQbXfeDjkuwyZWCTVRAWU65yWEdphspWYaIGH7Gf1zVrDU2cPUr0hGH7Sb4wfcyw
         etjVjIoH1VtZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9D2EE6D402;
        Fri, 22 Apr 2022 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next v3 0/2] add ethtool SQI support for LAN87xx T1 Phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165067081195.10261.5864387127941865463.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 23:40:11 +0000
References: <20220420152016.9680-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220420152016.9680-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Apr 2022 20:50:14 +0530 you wrote:
> This patch series add the Signal Quality Index measurement for the LAN87xx and
> LAN937x T1 phy. Updated the maintainers file for microchip_t1.c.
> 
> v2 - v3
> ------
> Rebased to latest commit
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: phy: LAN87xx: add ethtool SQI support
    https://git.kernel.org/netdev/net-next/c/b649695248b1
  - [net-next,v3,2/2] MAINTAINERS: Add maintainers for Microchip T1 Phy driver
    https://git.kernel.org/netdev/net-next/c/58f373f8d787

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


