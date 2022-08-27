Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AE45A33EC
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240516AbiH0CuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiH0CuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F51D2748
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 19:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87590B83388
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 02:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49C6AC433D7;
        Sat, 27 Aug 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568614;
        bh=Nrc9nTQQCzx7O8mANA3G6JscHttNB7G431wzmiSSm1I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D1BOo5a0Yf5GsEK6CWhsVa01VShLfbvpyqHZ1YetMukmEWAN56gIhc0x6OZjtusZJ
         a3jKIIMx/FbVz6MVuhCLcrZIG7v4YJgWu2Wh3tRSabUKQ1vnUymKf6gD7AtRWeMwTr
         /aOGZEP62MGcQODbd/EB4QI9mWDbu/2kYx+OQvtoVl51wkly67sFObawGEZtDTdqgq
         /UJ7HfSUjonrftkiD3FB3m6Yfn10sz2qQ08Gi2XK4jKkngKRQd3JhBrKAh4Lm2HxiZ
         LHtzTA6Bm7heMovbhcUEq6+nufSEGD93Aqh04R2jX85WPRduIWSrcVypn0xOEwt6cO
         A3327k/7IeePw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27E80C0C3EC;
        Sat, 27 Aug 2022 02:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: flower: fix ingress police using matchall filter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156861415.29832.15380945210474674931.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:50:14 +0000
References: <20220825080845.507534-1-simon.horman@corigine.com>
In-Reply-To: <20220825080845.507534-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        tianyu.yuan@corigine.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Aug 2022 10:08:45 +0200 you wrote:
> From: Tianyu Yuan <tianyu.yuan@corigine.com>
> 
> Referenced commit introduced nfp_policer_validate in the progress
> installing rate limiter. This validate check the action id and will
> reject police with CONTINUE, which is required to support ingress
> police offload.
> 
> [...]

Here is the summary with links:
  - [net] nfp: flower: fix ingress police using matchall filter
    https://git.kernel.org/netdev/net/c/ebe5555c2f34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


