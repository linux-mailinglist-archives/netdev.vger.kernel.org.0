Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1118265A9F1
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 13:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjAAMKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 07:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjAAMKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 07:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC5E2BCF;
        Sun,  1 Jan 2023 04:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63C33B80B44;
        Sun,  1 Jan 2023 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4A4BC433F0;
        Sun,  1 Jan 2023 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672575016;
        bh=aInGmOOkvL14/uFCkax5wGfoGW9I+nHkivTy0GUUHzI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vLBfdkZw/qNqsYyRTtL8+exW6aKf2E340dEc5Dw654mvDfes3Wrl+oXH4wqujb6yh
         qzeaveSn1DQktWhCKmAx96hrZyyk2zewH8Wj2b9UC5w+RSDsrfDhZPor7QJNOeyAWe
         /pMUmTHua/pB6wblkCBu+V+1flvbAdbRRCmb779Sv7I1dCiaaelWpmH8PiPVwvu6AU
         T+5zSSubGTrUFkV9OQu95UklsvuK4Mk9J/xgeFdHFeJdyuB95jx8QBSp08aoPw3Un7
         jJcajkeu07q5JjiBYBCX89X9KKfu14caBK0PZJhSxSG2/X6yq6nSwA43rQj1Mq4gi2
         7Lknpttgp/q0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C88A6C395E0;
        Sun,  1 Jan 2023 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: use proper endpoint mask for suspend
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167257501581.16085.16985413103568586770.git-patchwork-notify@kernel.org>
Date:   Sun, 01 Jan 2023 12:10:15 +0000
References: <20221230223304.2137471-1-elder@linaro.org>
In-Reply-To: <20221230223304.2137471-1-elder@linaro.org>
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 30 Dec 2022 16:33:04 -0600 you wrote:
> It is now possible for a system to have more than 32 endpoints.  As
> a result, registers related to endpoint suspend are parameterized,
> with 32 endpoints represented in one more registers.
> 
> In ipa_interrupt_suspend_control(), the IPA_SUSPEND_EN register
> offset is determined properly, but the bit mask used still assumes
> the number of enpoints won't exceed 32.  This is a bug.  Fix it.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: use proper endpoint mask for suspend
    https://git.kernel.org/netdev/net/c/d9d71a89f28d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


