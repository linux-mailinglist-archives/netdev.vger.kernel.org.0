Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5FC6B86D5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjCNAUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjCNAUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:20:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A949719F06;
        Mon, 13 Mar 2023 17:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72D40B8169D;
        Tue, 14 Mar 2023 00:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D624C4339B;
        Tue, 14 Mar 2023 00:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678753217;
        bh=zkFTdFHy/T+MW0RSaJiL3IPJSaWsM37bG5TUq7QsziE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UI33xJD9+6CrNJ1L0dqGFcXj/XHzV9mBRAd3n7U1jkOHijdh13+Bz83Gtihr8w14K
         Vz9c9aYsHSHTleizcwOScqzcUfH9fFYRTRgOIwvBgwHhNjV7gsLhvRI73fh01RAJ+2
         cuGHn/Fy+KQaw5gfCqW6IzodlZY0MzwqZ3zqSpuTRrUX/S9RkY2F1QPHcmJT1Mzfef
         14bRb/rm1kM8ERDUYdXoMd/5LgUzpmvbBKBA/+JpnNKXSMEZqxc8gu5YQxcsJw8M9k
         NY7IpKbofz4JP7l2iuvBya88IeBiYPuNWvW/7mJdrjKUMse9cE+cEBOIZ8B8lKOC+r
         yuoxgu1w1u8hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1043BE66CBA;
        Tue, 14 Mar 2023 00:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: fix a surprising number of bad offsets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167875321706.19453.17373640129934893607.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 00:20:17 +0000
References: <20230310193709.1477102-1-elder@linaro.org>
In-Reply-To: <20230310193709.1477102-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, luca.weiss@fairphone.com,
        dmitry.baryshkov@linaro.org, caleb.connolly@linaro.org,
        mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 13:37:09 -0600 you wrote:
> A recent commit eliminated a hack that adjusted the offset used for
> many GSI registers.  It became possible because we now specify all
> GSI register offsets explicitly for every version of IPA.
> 
> Unfortunately, a large number of register offsets were *not* updated
> as they should have been in that commit.  For IPA v4.5+, the offset
> for every GSI register *except* the two inter-EE interrupt masking
> registers were supposed to have been reduced by 0xd000.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: fix a surprising number of bad offsets
    https://git.kernel.org/netdev/net/c/512dd354718b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


