Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06CF5EEBA4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiI2CUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbiI2CU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:20:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0ECA1D26;
        Wed, 28 Sep 2022 19:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3D60B822C8;
        Thu, 29 Sep 2022 02:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98557C43142;
        Thu, 29 Sep 2022 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664418021;
        bh=6cn8FHaQcyYogSt4drg4rG8e23DcP74VAjMxE+GFZRY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xm8V1v0fegjtNkLKuaIBk+WlLuu+wCu5irp40airw35khoSBsOZY+XrYmcq+Lsf/5
         ZDdSWZW1IrzUfpC9syaTdr5VUViCJvsn0DTV7MBjepf6G5RQe9mLCCeP8HDp6l0SLZ
         JBm1uGNAreAAnbtob8QxGY+ceLNBq0S/uFuTdJol6zV1DA6PndS2D00znxUBo5qmCw
         h3Z0vafczOG5hM9QbzVBQr+egJOLN0+E8cceRMO6NmNQx3/q8B3JXmKDZ9T5NaWSeu
         TZxjiN3edPrbaYdG8wLno7FVC5pZ1V+dq+5eB1qC/tj55akUdkDecVjSY4gOI4VUeu
         yJMuDBsLObT0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F2DBE4D023;
        Thu, 29 Sep 2022 02:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: drop the weight argument from netif_napi_add
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441802151.18961.15973207341585394668.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:20:21 +0000
References: <20220927132753.750069-1-kuba@kernel.org>
In-Reply-To: <20220927132753.750069-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, kvalo@kernel.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 27 Sep 2022 06:27:53 -0700 you wrote:
> We tell driver developers to always pass NAPI_POLL_WEIGHT
> as the weight to netif_napi_add(). This may be confusing
> to newcomers, drop the weight argument, those who really
> need to tweak the weight can use netif_napi_add_weight().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: drop the weight argument from netif_napi_add
    https://git.kernel.org/netdev/net-next/c/b48b89f9c189

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


