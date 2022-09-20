Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5DE5BF0FC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiITXUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiITXUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ABF6EF2E;
        Tue, 20 Sep 2022 16:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0359C62E64;
        Tue, 20 Sep 2022 23:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C5A9C433C1;
        Tue, 20 Sep 2022 23:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663716018;
        bh=cwJ91/WCrSqTfzYkTEPlmknGrSqqPyLSdr6saopSYNw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q4ayZyunP0HUG3GLBjwhmug6rWwQZlpQfj6bJl2tSKCkkeOP0JZSSZ1rvyUN7tjUT
         VPYjwAb7MDLAzlJtbu+0zkg2np0VcHDiKIqTAmBzwccC3eQX6eOWPCfjOlUx1oLMsT
         JGWnHa0/HZHv1uT/nvPw+vUgvp3ot5pl1CElRcFYyYo+2k/q8Y2rJsRD6QgE4aGzGw
         CeN4A6HD4scY1qw6L6YELy8KbzqFqqqvcf9xKlJB2JDaKN+umqweEOkbsQhXRVEmPx
         Gf7kezX49uGNr7gmuTu+IY/ZTt2xf1lDSVt3d10e20sWXFJ4LNaxNj2voBm9mpRfdN
         EFtZImUcSjSvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B081E21EE0;
        Tue, 20 Sep 2022 23:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] Add a secondary AT port to the Telit FN990
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166371601817.30252.999968040305837655.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 23:20:18 +0000
References: <20220916144329.243368-1-fabio.porcedda@gmail.com>
In-Reply-To: <20220916144329.243368-1-fabio.porcedda@gmail.com>
To:     Fabio Porcedda <fabio.porcedda@gmail.com>
Cc:     mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, mani@kernel.org, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dnlplm@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 16 Sep 2022 16:43:27 +0200 you wrote:
> In order to add a secondary AT port to the Telit FN990 first add "DUN2"
> to mhi_wwan_ctrl.c, after that add a seconday AT port to the
> Telit FN990 in pci_generic.c
> 
> Fabio Porcedda (2):
>   net: wwan: mhi_wwan_ctrl: Add DUN2 to have a secondary AT port
>   bus: mhi: host: pci_generic: Add a secondary AT port to Telit FN990
> 
> [...]

Here is the summary with links:
  - [1/2] net: wwan: mhi_wwan_ctrl: Add DUN2 to have a secondary AT port
    https://git.kernel.org/netdev/net-next/c/0c60d1657d3d
  - [2/2] bus: mhi: host: pci_generic: Add a secondary AT port to Telit FN990
    https://git.kernel.org/netdev/net-next/c/479aa3b0ec2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


