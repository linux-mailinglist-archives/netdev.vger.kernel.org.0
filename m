Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6415D5BE95C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiITOuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiITOuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8A62E9C6;
        Tue, 20 Sep 2022 07:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A077DB82A7C;
        Tue, 20 Sep 2022 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66577C433C1;
        Tue, 20 Sep 2022 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663685417;
        bh=t736d8ZuzVTu+fHh6LkwNglQH4chrzEMr+n6SDHaahg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=piJeSZr1nea3RpUChMRfFn9df42+EliPIFiAGnp1jH1L5tSxC9+U/ctYgFhtgZtJw
         PIeFoQClIIVXXZa0kXlxV8AkkyJHP+HPXmQJx5N+bbWatHDz1Jx/JdSb2j3jS+kxb9
         xhrksNv+TvGzsrpCpFM5cDTTdHNj4grBid1DA1JG3kSeXC1Ryv6vURWTW7hppbyQFh
         eTGnOxVfoJuJL9m2x/hC+4i/i6KIFilCb2sCJP6B4fzsFbhSn/Ez6Z/agPAq83NYu1
         i+FepB/yjlxXLxnx9Zmd6zsKQ/QD6LSYf4ji3HAyYkLywxlDTm3PYYDXq/bYW+OIqZ
         FXwq43uAP3ssA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4ED4EE21EE1;
        Tue, 20 Sep 2022 14:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: a mix of cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368541731.14330.5858659115387897586.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 14:50:17 +0000
References: <20220910011131.1431934-1-elder@linaro.org>
In-Reply-To: <20220910011131.1431934-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri,  9 Sep 2022 20:11:25 -0500 you wrote:
> This series contains a set of cleanups done in preparation for a
> more substantitive upcoming series that reworks how IPA registers
> and their fields are defined.
> 
> The first eliminates about half of the possible GSI register
> constant symbols by removing offset definitions that are not
> currently required.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: don't define unneeded GSI register offsets
    https://git.kernel.org/netdev/net-next/c/5ea4285829de
  - [net-next,2/6] net: ipa: move the definition of gsi_ee_id
    https://git.kernel.org/netdev/net-next/c/bb788de30a74
  - [net-next,3/6] net: ipa: move and redefine ipa_version_valid()
    https://git.kernel.org/netdev/net-next/c/8b3cb084b23e
  - [net-next,4/6] net: ipa: don't reuse variable names
    https://git.kernel.org/netdev/net-next/c/9eefd2fb966d
  - [net-next,5/6] net: ipa: update sequencer definition constraints
    https://git.kernel.org/netdev/net-next/c/a14d593724c4
  - [net-next,6/6] net: ipa: fix two symbol names
    https://git.kernel.org/netdev/net-next/c/dae4af6bf232

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


