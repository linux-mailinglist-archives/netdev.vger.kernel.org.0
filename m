Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3956BE039
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjCQEkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCQEkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B3627D68;
        Thu, 16 Mar 2023 21:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D82CB81C3C;
        Fri, 17 Mar 2023 04:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9ADFEC4339B;
        Fri, 17 Mar 2023 04:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679028019;
        bh=GuSbANHANMsTyqANAtTFzxbCC5Q6L7J9KyihUnvmIWs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ToYjBPnJsOEw/JwakbUZMC/Lyfs6vMo0Oudn1DumR/IZndrvnxvQlHER3GCnPXs9f
         TPxtPl0m6KoG79soT1lDWkrCxA0aPrN+S26/QB41ymO58bFFrEQGmb9MMun61I11WW
         zRNOWmFRu9V/cRr8VWvkDOplX5jMqvrTAfrEacCcz25ESX9G1l8e0BGv+iGZUqQihd
         QmmtaiPyJMUOjXwGbz8lPCZNei2zHORVRo5x5da6z9OLACOEnhGFCghwnzORZ4N8If
         xn6q4msCx29i6L65yR2hMxKwihPxESgQwSVpCE72vscAm6iJqU7CxzzWAWU5WljhhR
         skFJRnoqks1Jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7192CE66CBF;
        Fri, 17 Mar 2023 04:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/4] net: ipa: minor bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167902801945.7493.9442486454215262056.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 04:40:19 +0000
References: <20230316145136.1795469-1-elder@linaro.org>
In-Reply-To: <20230316145136.1795469-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 09:51:32 -0500 you wrote:
> The four patches in this series fix some errors, though none of them
> cause any compile or runtime problems.
> 
> The first changes the files included by "drivers/net/ipa/reg.h" to
> ensure everything it requires is included with the file.  It also
> stops unnecessarily including another file.  The prerequisites are
> apparently satisfied other ways, currently.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/4] net: ipa: reg: include <linux/bug.h>
    https://git.kernel.org/netdev/net/c/dd172d0c2cea
  - [net,v3,2/4] net: ipa: add two missing declarations
    https://git.kernel.org/netdev/net/c/55c49e5c9441
  - [net,v3,3/4] net: ipa: kill FILT_ROUT_CACHE_CFG IPA register
    https://git.kernel.org/netdev/net/c/786bbe50e1d5
  - [net,v3,4/4] net: ipa: fix some register validity checks
    https://git.kernel.org/netdev/net/c/21e8aaca401c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


