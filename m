Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD146120BB
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 08:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJ2Gab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 02:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ2Ga1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 02:30:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1A163867;
        Fri, 28 Oct 2022 23:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80A2AB82EB6;
        Sat, 29 Oct 2022 06:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CE4CC43470;
        Sat, 29 Oct 2022 06:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667025022;
        bh=wpXi1qZG6xn4QtLmN7YWSN+v1kXuJUfAGZI4wJLWYfw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fPkjmTCzEZ3G4k7G55gmcm6G/1JtqQraEBNFRKQXpwA5Yhwh37PmOHuaqXmf0x+ip
         mVcv7dNdRMN4I43oiUnnR46TP8g3OySQBQu4VO8Zqi/xHFTxEM5btALp+4HrAX8P59
         6lsnkWiCNAT1XzZlU+paCwIsfE6ZlFyEfB7i1fgTzbZHSoTuLxtVwRhhY31U3gWypz
         LjRRE7cSD74bBkUpteNLkbRWMreGUM3UlgELeNOSBXJAf5luiPzCNjNOVYENjbBTgy
         xkrSm4RZhIzR1hs0BHiv71uozTq5mXO7y3cFAD93zo0O20hemeAekYhQBC5y9r56mo
         joyewl7yTCm6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D53B2C41672;
        Sat, 29 Oct 2022 06:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: ipa: start adding IPA v5.0 functionality
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166702502186.25217.1144022250011614264.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 06:30:21 +0000
References: <20221027122632.488694-1-elder@linaro.org>
In-Reply-To: <20221027122632.488694-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, 27 Oct 2022 07:26:25 -0500 you wrote:
> The biggest change for IPA v5.0 is that it supports more than 32
> endpoints.  However there are two other unrelated changes:
>   - The STATS_TETHERING memory region is not required
>   - Filter tables no longer support a "global" filter
> 
> Beyond this, refactoring some code makes supporting more than 32
> endpoints (in an upcoming series) easier.  So this series includes
> a few other changes (not in this order):
>   - The maximum endpoint ID in use is determined during config
>   - Loops over all endpoints only involve those in use
>   - Endpoints IDs and their directions are checked for validity
>     differently to simplify comparison against the maximum
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: ipa: define IPA v5.0
    https://git.kernel.org/netdev/net-next/c/5783c68a2519
  - [net-next,2/7] net: ipa: change an IPA v5.0 memory requirement
    https://git.kernel.org/netdev/net-next/c/5ba5faa2e271
  - [net-next,3/7] net: ipa: no more global filtering starting with IPA v5.0
    https://git.kernel.org/netdev/net-next/c/bd5524930ba7
  - [net-next,4/7] net: ipa: more completely check endpoint validity
    (no matching commit)
  - [net-next,5/7] net: ipa: refactor endpoint loops
    https://git.kernel.org/netdev/net-next/c/e359ba89a4aa
  - [net-next,6/7] net: ipa: determine the maximum endpoint ID
    https://git.kernel.org/netdev/net-next/c/5274c7158b2b
  - [net-next,7/7] net: ipa: record and use the number of defined endpoint IDs
    https://git.kernel.org/netdev/net-next/c/b7aaff0b010e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


