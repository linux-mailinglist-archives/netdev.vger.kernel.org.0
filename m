Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D37F6C76B0
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 05:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjCXEuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 00:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjCXEuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 00:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7138A59;
        Thu, 23 Mar 2023 21:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E117FB822DE;
        Fri, 24 Mar 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87D3BC4339B;
        Fri, 24 Mar 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679633419;
        bh=rkPRmWADO4rngO21NvVXGrmyn4mvyAOTpSWrbqiat/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LdNbo7lc9ziFmvUva9jOltzyrea4eh9CKQzlckl+Kctf3cl66QrLX3QH5RIgxgZq9
         I10LvKIO5sdrnrIIGpd0L6RfXt+95jV1qlwiiqK8+OIRPLx8tBXQd6gJmcj/xpLJzD
         lI27ehdhOOYAfMzuN8iBBlPODDE4vbrHbGQUXN5UKMU/sPSX2fMcSYwwHJ1POWDRFX
         XMAtPgPbKbq1t34ejqaeSIa+7/B3FaHy4xGZ7EnBO5Iw5TgjxaM2FrVLotk2d33d7E
         sUR64eZyPo7byo92g0xaFQ56JiLjrB2TO3CY8RPWXpzAAjxyX6Cc98xkfu5t+00t2M
         oQw3Nfhxr0lag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63BE1E61B87;
        Fri, 24 Mar 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: add IPA v5.0 to ipa_version_string()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167963341940.15621.11540151537232816313.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 04:50:19 +0000
References: <20230322144742.2203947-1-elder@linaro.org>
In-Reply-To: <20230322144742.2203947-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Mar 2023 09:47:42 -0500 you wrote:
> In the IPA device sysfs directory, the "version" file can be read to
> find out what IPA version is implemented.  The content of this file
> is supplied by ipa_version_string(), which needs to be updated to
> properly handle IPA v5.0.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: add IPA v5.0 to ipa_version_string()
    https://git.kernel.org/netdev/net-next/c/0c04328ccf85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


