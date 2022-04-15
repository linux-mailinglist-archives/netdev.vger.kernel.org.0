Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E935028B5
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 13:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352637AbiDOLMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 07:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352602AbiDOLMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 07:12:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9329B9D049;
        Fri, 15 Apr 2022 04:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 063D762290;
        Fri, 15 Apr 2022 11:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BE73C385A5;
        Fri, 15 Apr 2022 11:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650021011;
        bh=sx89VIanL7V+eAxyzjwVIJ9mBIJ+mWVSdpYjAdbgMvc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u4HvkiPkezUH1Wdh/oWxLJohG4WAGdiYXQTWucWyBgsd4wedMZc16leXdlIi3lEDJ
         dKIIlaJ1+Z5DC+G4bTWwvsDLmPdt68AT9hm7KH2xo1g3lQix1BmEoIhYPoTRbnrhDR
         x4YaOrrrwz/EOpEbyknTDaHxbYBkeTYvko5gsG567lWBhy+zO6eo5H0bDgKeGBY3/a
         sJ/87uxne6eSa8BgBBLg/uieMssDYyoRe9XOWgcuSFVpO6g7D6ZQuqLI4Yzh9akdDi
         EpaSAR9TFUJpTmqnNcmyTevLPIhpPASl+smJEuyU57DCBVRXNeMI5RNtAagQQBXtu/
         xdwal0vBLA28w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32E3FE8DBD4;
        Fri, 15 Apr 2022 11:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: restore alpha order to Ethernet devices in config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165002101120.2718.15136405620933665044.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 11:10:11 +0000
References: <20220414160315.105212-1-stephen@networkplumber.org>
In-Reply-To: <20220414160315.105212-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, tsbogend@alpha.franken.de,
        shacharr@microsoft.com, vegard.nossum@oracle.com,
        d.michailidis@fungible.com, l.stelmach@samsung.com,
        decui@microsoft.com, haiyangz@microsoft.com,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Apr 2022 09:03:12 -0700 you wrote:
> The displayed list of Ethernet devices in make menuconfig
> has gotten out of order. This is mostly due to changes in vendor
> names etc, but also because of new Microsoft entry in wrong place.
> 
> This restores so that the display is in order even if the names
> of the sub directories are not.
> 
> [...]

Here is the summary with links:
  - net: restore alpha order to Ethernet devices in config
    https://git.kernel.org/netdev/net/c/da367ac74aec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


