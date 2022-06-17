Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0953154EFDA
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiFQDuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 23:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379797AbiFQDue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 23:50:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D3E663DF;
        Thu, 16 Jun 2022 20:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9B69FCE2852;
        Fri, 17 Jun 2022 03:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED674C341C0;
        Fri, 17 Jun 2022 03:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655437827;
        bh=7s2Si8GUuMlYSlLe8xg2+g+yctYqF9/Kblkx+6BbW58=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hp+idzWuPLU5CiP4phj6ma+XSty4Bb2ur9EzV1IBtUru/FjuS74O9U7PGTJS9Lgel
         QOtrXuVwAyUlXNCoc3gXI3sssqcz1YnPkF31XR7AR0W4PM7o3bzCr8cx7MKO2MoMXA
         R+lY5TtRiPNNgcwjyT7ZjsJg8AF871Z0efXcRe+LXWDj7pmamEnAuNAho6HJSi8g0G
         MZ4RxSNvbL9bOLf61ZuvC+IJm9XvvqSNYA5LrwoH7OVab/as4ktcP1boIeLHzShuGo
         MsVh/F0UrO6xKDi5X4U2HOVyWMIsceRPxCXEXsW9cnmMfOgw3bG44eIkX7r8sE6QAs
         7xWqlU/FbRaWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D11C4E73867;
        Fri, 17 Jun 2022 03:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: ipa: more multi-channel event ring work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165543782685.2027.6817582809766832078.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 03:50:26 +0000
References: <20220615165929.5924-1-elder@linaro.org>
In-Reply-To: <20220615165929.5924-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Jun 2022 11:59:24 -0500 you wrote:
> This series makes a little more progress toward supporting multiple
> channels with a single event ring.  The first removes the assumption
> that consecutive events are associated with the same RX channel.
> 
> The second derives the channel associated with an event from the
> event itself, and the next does a small cleanup enabled by that.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: ipa: don't assume one channel per event ring
    https://git.kernel.org/netdev/net-next/c/dd5a046cbbed
  - [net-next,2/5] net: ipa: don't pass channel when mapping transaction
    https://git.kernel.org/netdev/net-next/c/8eec78319585
  - [net-next,3/5] net: ipa: pass GSI pointer to gsi_evt_ring_rx_update()
    https://git.kernel.org/netdev/net-next/c/2f48fb0edc0d
  - [net-next,4/5] net: ipa: call gsi_evt_ring_rx_update() unconditionally
    https://git.kernel.org/netdev/net-next/c/9f1c3ad65406
  - [net-next,5/5] net: ipa: move more code out of gsi_channel_update()
    https://git.kernel.org/netdev/net-next/c/81765eeac1b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


