Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008EA549806
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349540AbiFMMks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 08:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357789AbiFMMkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 08:40:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4515E74E;
        Mon, 13 Jun 2022 04:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BC3C60BA6;
        Mon, 13 Jun 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C992C36B0A;
        Mon, 13 Jun 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655118613;
        bh=M6143A5QQ5xSxiPanMUPhFz1w2V7Tzx7QqRnqCYcJwA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YSItdfyO7g24OsR7+bu6WYaKP3iu6GS5Blr6pVpHkkJdLhbNS2jUGrPrhJyADbsxp
         5BjdqOxor3+4eyz2xe6tyN/aW1s1pXAhtaC6xqICAa1Ggp40GHkQ6goIRtOdkpxsFQ
         qaMR9GYnBRjhamOHHbndoQhh9KgvMx21lbFO2FrXElLBB1SFSFzTjsed+T9bhSK82i
         JSXaSlW5WmxaGacfrWaXz2sCwXEn1byV/XQoBL68xhZpcAu1PU5CIkoh+l0QEHINAt
         EmmS8Ae7mNsB2L18zQfw+3Figws3LhMgwCyQU3vD3mu3xESUqVKkKhk01RCpYWRLH5
         OhYoLSuAygtdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 750F1E57538;
        Mon, 13 Jun 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: simple refactoring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165511861347.31385.12401818961589133505.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Jun 2022 11:10:13 +0000
References: <20220610154616.249304-1-elder@linaro.org>
In-Reply-To: <20220610154616.249304-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 10 Jun 2022 10:46:09 -0500 you wrote:
> This series contains some minor code improvements.
> 
> The first patch verifies that the configuration is compatible with a
> recently-defined limit.  The second and third rename two fields so
> they better reflect their use in the code.  The next gets rid of an
> empty function by reworking its only caller.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: verify command channel TLV count
    https://git.kernel.org/netdev/net-next/c/92f78f81ac4d
  - [net-next,2/6] net: ipa: rename channel->tlv_count
    https://git.kernel.org/netdev/net-next/c/88e03057e4df
  - [net-next,3/6] net: ipa: rename endpoint->trans_tre_max
    https://git.kernel.org/netdev/net-next/c/317595d2ce77
  - [net-next,4/6] net: ipa: simplify endpoint transaction completion
    https://git.kernel.org/netdev/net-next/c/983a1a3081bb
  - [net-next,5/6] net: ipa: determine channel from event
    https://git.kernel.org/netdev/net-next/c/7dd9558feddf
  - [net-next,6/6] net: ipa: derive channel from transaction
    https://git.kernel.org/netdev/net-next/c/bcec9ecbaf60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


