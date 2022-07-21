Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95A357C33D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 06:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiGUEKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 00:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiGUEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 00:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F837DEE6;
        Wed, 20 Jul 2022 21:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A43619C4;
        Thu, 21 Jul 2022 04:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B491C341C6;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658376617;
        bh=hFxcJyK3vIaQmF35EpAVUxl/v6Sy15IF5TRQ64uUByQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jQQ1ebaLrvPPX/VyiRhiS8g+Rhx7oZuAMUPNcXvUlzoleo8qDmxDOEcw/89l4S0yY
         GCUlMevFvUgSsBWGep+3ess2LNM8geR3zryb32glbmsmv8SJcBP9pMFz/mZsj5UMz6
         62p/rgxhaSQ5Ckmiqe4fuz6K6Hhi23G1NAkXxGnhWXALrVNbo6aXC5Xn7QmyBswvJu
         OhmQSArlXdtcFgqISUIxIqbVpgQtdyQxTCDXsBnD9220ZdNCuM0/vxUmk1xogAnJEO
         u4pUDnpz4LSKzxMB4SVzI+zWRSzS7o7fegI7p1Ux7WiCL6LTnWBnR18tfVfR7e4Hhi
         b47lN1N6dukNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7161BE451BE;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] net: ipa: add an endpoint device attribute group
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165837661746.25559.16692832535272405224.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 04:10:17 +0000
References: <20220719191639.373249-1-elder@linaro.org>
In-Reply-To: <20220719191639.373249-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 19 Jul 2022 14:16:39 -0500 you wrote:
> Create a new attribute group meant to provide a single place that
> defines endpoint IDs that might be needed by user space.  Not all
> defined endpoints are presented, and only those that are defined
> will be made visible.
> 
> The new attributes use "extended" device attributes to hold endpoint
> IDs, which is a little more compact and efficient.  Reimplement the
> existing modem endpoint ID attribute files using common code.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] net: ipa: add an endpoint device attribute group
    https://git.kernel.org/netdev/net-next/c/d79e4164d0d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


