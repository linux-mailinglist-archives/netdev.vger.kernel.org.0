Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E0852615A
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380041AbiEMLuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345668AbiEMLuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB831F8F0B;
        Fri, 13 May 2022 04:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEBB261E7A;
        Fri, 13 May 2022 11:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 293FFC34115;
        Fri, 13 May 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652442614;
        bh=yugmZY7XqMULlQ7Zh5SgMzY+/uUNBV0Y4MAJUB4rGAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZuonmleOqUW0whDG5F3YhSyUHs/cQTQTeRHI01aavwmYzzhWYwPu5jNfCkSwOakFh
         mJbXzuhPUBB0Zn7mSLXtbqGsIOp/E3Lqw7SuMLJY3gIWNmGxymZSEEuT2wTfxnWMhC
         HO9yj3nSYFuZsKNJR/pM/ofii/VoSAcpE0O6jvcsNIZnG2ECNbDFOvrr9jSk+mAN+4
         TMbpp1m0VN883w6khTCO00J8bx5qCH7ycBACgF7qD/ERpUY5ukMHjQup3AvfyONkHu
         EGQxsef8SBSFdnSidCzqJPeVOLz6DIpP5qqFz6lJLOpVgcmZD0iaHilY1GhJSZWKuR
         Pk58BhjdanVAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0BFAAF03935;
        Fri, 13 May 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net: ipa: three bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165244261404.26306.8745512907039550643.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 11:50:14 +0000
References: <20220512151033.211592-1-elder@linaro.org>
In-Reply-To: <20220512151033.211592-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lkp@intel.com, mka@chromium.org, evgreen@chromium.org,
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 12 May 2022 10:10:30 -0500 you wrote:
> This series contains three somewhat unrelated minor bug fixes.
> 
> 					-Alex
> 
> Alex Elder (3):
>   net: ipa: certain dropped packets aren't accounted for
>   net: ipa: record proper RX transaction count
>   net: ipa: get rid of a duplicate initialization
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: ipa: certain dropped packets aren't accounted for
    https://git.kernel.org/netdev/net/c/30b338ff7998
  - [net,2/3] net: ipa: record proper RX transaction count
    https://git.kernel.org/netdev/net/c/d8290cbe1111
  - [net,3/3] net: ipa: get rid of a duplicate initialization
    https://git.kernel.org/netdev/net/c/8d017efb1eaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


