Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986A75AADAF
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbiIBLcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbiIBLbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:31:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AF7326C1;
        Fri,  2 Sep 2022 04:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AA94B82A75;
        Fri,  2 Sep 2022 11:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6FB9C43470;
        Fri,  2 Sep 2022 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662118217;
        bh=CGqOiSS0/qFFblTPDZ50LIjsyYMsTcjW/vrcS8WzGk8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RMibcfaoYXpqGtptupqzPRCtA7Way8KlStqoSSlin2aX7INJ+7wq7i1hzWUGvdEHW
         y3sfjj0dN6k//e5xbgJZ8sYCi3J3YrZtbujG6NlkGZCA+2yUqygGnTzCeRFCZS4cUl
         UjZNBrDz3vwB/jjGk6Nd62wEF4hrDXo6YhFCQNwZQTNeiCkDoZm0odpO9nb+ovLivw
         uipPWMkEckXU+c+2nsUwBZpx8vmwHE9HJMwoUlThgPPuBZiiMCdB9w8iQQJAjEHZfo
         jIhyMe7f/4xxIKGfoNEjW3ZvuFZhzjGHZx2+t+BusQrlPsAVV9SB2DoY546xLhMV+n
         ieYwo3MTPBf4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BDCB2E924E6;
        Fri,  2 Sep 2022 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: use IDs to track transaction state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166211821777.29115.5588215360001640373.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 11:30:17 +0000
References: <20220831224017.377745-1-elder@linaro.org>
In-Reply-To: <20220831224017.377745-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 31 Aug 2022 17:40:11 -0500 you wrote:
> This series is the first of three groups of changes that simplify
> the way the IPA driver tracks the state of its transactions.
> 
> Each GSI channel has a fixed number of transactions allocated at
> initialization time.  The number allocated matches the number of
> TREs in the transfer ring associated with the channel.  This is
> because the transfer ring limits the number of transfers that can
> ever be underway, and in the worst case, each transaction represents
> a single TRE.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: use an array for transactions
    (no matching commit)
  - [net-next,2/6] net: ipa: track allocated transactions with an ID
    https://git.kernel.org/netdev/net-next/c/41e2a2c054b8
  - [net-next,3/6] net: ipa: track committed transactions with an ID
    https://git.kernel.org/netdev/net-next/c/fc95d958e27d
  - [net-next,4/6] net: ipa: track pending transactions with an ID
    https://git.kernel.org/netdev/net-next/c/eeff7c14e08c
  - [net-next,5/6] net: ipa: track completed transactions with an ID
    https://git.kernel.org/netdev/net-next/c/949cd0b5c296
  - [net-next,6/6] net: ipa: track polled transactions with an ID
    https://git.kernel.org/netdev/net-next/c/fd3bd0398a0d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


