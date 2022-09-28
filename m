Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A835ED2DA
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 04:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiI1CAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 22:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiI1CAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 22:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681AC1616DC;
        Tue, 27 Sep 2022 19:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 171F7B81E8A;
        Wed, 28 Sep 2022 02:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8332FC433B5;
        Wed, 28 Sep 2022 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664330418;
        bh=K9wGYgDQSpMBMNRwO1WdxfQCLk+Z8J96sQHNM9ote5M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Srxu27F6Z+A9lO7n6x00h9CFcGCoE/wSAmP1O0HUdBeipDdqLb1Xm6Zbm1NG1l5Nf
         NGLElRvf4suiwx5ONikcDX3ogaM0urIb2PovTmpJBW3kd1zaD6R3EAQwQdiJBpOcM7
         SCsvSqj9piQYgw7GF8ftYeWs6k06JGQtqERhMNZERxZ2rmwj1v+zJsitOJ9Q3dorSN
         93PqTH63KvETyXafWOpeM+HbyirZvYMASw8IqYRypKllsUcsozoBvqKHhY6DjrBV5T
         2YG9iXKQ91sCKtNxrHHvHHDaXvNRS9C4VhmoIKKiYL8V7a0Z1uF7auv8b0mJOfh72o
         JVN7LboC9gMSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64A57E4D035;
        Wed, 28 Sep 2022 02:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] net: ipa: generalized register definitions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166433041840.32421.1858136173918846349.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 02:00:18 +0000
References: <20220926220931.3261749-1-elder@linaro.org>
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 26 Sep 2022 17:09:16 -0500 you wrote:
> This series is quite a bit bigger than what I normally like to send,
> and I apologize for that.  I would like it to get incorporated in
> its entirety this week if possible, and splitting up the series
> carries a small risk that wouldn't happen.
> 
> Each IPA register has a defined offset, and in most cases, a set
> of masks that define the width and position of fields within the
> register.  Most registers currently use the same offset for all
> versions of IPA.  Usually fields within registers are also the same
> across many versions.  Offsets and fields like this are defined
> using preprocessor constants.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net: ipa: introduce IPA register IDs
    https://git.kernel.org/netdev/net-next/c/98e2dd71a826
  - [net-next,02/15] net: ipa: use IPA register IDs to determine offsets
    https://git.kernel.org/netdev/net-next/c/6bfb753850d3
  - [net-next,03/15] net: ipa: add per-version IPA register definition files
    https://git.kernel.org/netdev/net-next/c/07f120bcf76b
  - [net-next,04/15] net: ipa: use ipa_reg[] array for register offsets
    https://git.kernel.org/netdev/net-next/c/82a06807453a
  - [net-next,05/15] net: ipa: introduce ipa_reg()
    (no matching commit)
  - [net-next,06/15] net: ipa: introduce ipa_reg field masks
    https://git.kernel.org/netdev/net-next/c/a5ad8956f97a
  - [net-next,07/15] net: ipa: define COMP_CFG IPA register fields
    https://git.kernel.org/netdev/net-next/c/12c7ea7dfd2c
  - [net-next,08/15] net: ipa: define CLKON_CFG and ROUTE IPA register fields
    (no matching commit)
  - [net-next,09/15] net: ipa: define some more IPA register fields
    (no matching commit)
  - [net-next,10/15] net: ipa: define more IPA register fields
    (no matching commit)
  - [net-next,11/15] net: ipa: define even more IPA register fields
    (no matching commit)
  - [net-next,12/15] net: ipa: define resource group/type IPA register fields
    (no matching commit)
  - [net-next,13/15] net: ipa: define some IPA endpoint register fields
    (no matching commit)
  - [net-next,14/15] net: ipa: define more IPA endpoint register fields
    (no matching commit)
  - [net-next,15/15] net: ipa: define remaining IPA register fields
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


