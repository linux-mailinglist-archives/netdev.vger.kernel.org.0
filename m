Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D516612040
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 06:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJ2Eu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 00:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJ2EuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 00:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D761E6048C
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 21:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A558B82E36
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48693C43145;
        Sat, 29 Oct 2022 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667019019;
        bh=29b5mlhyEn9PL0TwR5WarOpXf35bChg50LYkNAN/d4I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RzhAM6c0T6uHRXDqlBIl930nVm3XlG+Kp3qEGXGfSYErTvcgPn4OTKEQxYcS1TEkl
         iQyXc6gDhLi4QBoRiW62/tfswNT4ZCROTeD5pXgu5KxyBiYUK3RmT3hT4S5xkc7mpl
         cHq9+/8Tb717UBiwM8JQIYUGCVlS4abrzyAEqN4K5h8SQuHOQh8thDI+cyyT8F0tG/
         D1MA900kAT0t+UkChnLtf4RFTeCOVhZrofThQ+WD5U/U+EIK7ZNLWJzOVanpcTShF1
         qEfyrudpI7oCK5TeIkXKuA9Xd0HplPGC47I6uQBXe3gX8g8V+QHB0iIEpTyiVyigU3
         awo1VGybFeWEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34CFAC41672;
        Sat, 29 Oct 2022 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: Remove the obsolte u64_stats_fetch_*_irq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166701901920.13014.13928137103482337247.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 04:50:19 +0000
References: <20221026132215.696950-1-bigeasy@linutronix.de>
In-Reply-To: <20221026132215.696950-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 26 Oct 2022 15:22:13 +0200 you wrote:
> Hi,
> 
> This is the removal of u64_stats_fetch_*_irq() users in networking. The
> prerequisites are part of v6.1-rc1. I made two patches, one for net/ and
> the other for drivers/net. Hope that is okay.
> The spi and bpf bits are not part of the series and have been routed
> directly.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: Remove the obsolte u64_stats_fetch_*_irq() users (drivers).
    https://git.kernel.org/netdev/net-next/c/068c38ad88cc
  - [net-next,2/2] net: Remove the obsolte u64_stats_fetch_*_irq() users (net).
    https://git.kernel.org/netdev/net-next/c/d120d1a63b2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


