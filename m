Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1CB60C893
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 11:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiJYJlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 05:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiJYJlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 05:41:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C6112751;
        Tue, 25 Oct 2022 02:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 992BB61862;
        Tue, 25 Oct 2022 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9C98C433D7;
        Tue, 25 Oct 2022 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666690817;
        bh=LRA27RkuI+pQtw9QEZ9eFS+Prw+Y3GfxxqHqaNMByEk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EAbEVQMxfYj3F5fzRPfJ6CSoV3EsNZfkP7oiWxpmY1BmUoE5b/Eo3JfohEwyRDltb
         lfr+zhKxAdtFytw/YQK6l/WW4zsb1pqzoYcFwlQcuLRnUZjIhdHSRx15dxoOZwkbjB
         aa2dHOtFLwHqdgwco+GXshj7gQ/RPVny+7gBdUDSWuQRiiWoEv8FS/mKCp4qHvCjSr
         SgdWfSBDbUQ9BlFiG4WdGJPapNxEkCsgqSmoKsrCx8SBwDYbGvpy2nNU3N/qW96Rbx
         pZb0v5EXaI4ExJedmWuQAqOEKbBz0eUeR0zTi9zWEvZ0rkjW0f3vHNt9EGVvqj2v8R
         e/LAFOuIYRMSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B705AE29F32;
        Tue, 25 Oct 2022 09:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: ipa: validation cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166669081774.5792.12091336300542106637.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 09:40:17 +0000
References: <20221021191340.4187935-1-elder@linaro.org>
In-Reply-To: <20221021191340.4187935-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 21 Oct 2022 14:13:33 -0500 you wrote:
> This series gathers a set of IPA driver cleanups, mostly involving
> code that ensures certain things are known to be correct *early*
> (either at build or initializatin time), so they can be assumed good
> during normal operation.
> 
> The first removes three constant symbols, by making a (reasonable)
> assumption that a routing table consists of entries for the modem
> followed by entries for the AP, with no unused entries between them.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: ipa: kill two constant symbols
    https://git.kernel.org/netdev/net-next/c/fb4014ac76b8
  - [net-next,2/7] net: ipa: remove two memory region checks
    https://git.kernel.org/netdev/net-next/c/2554322b3199
  - [net-next,3/7] net: ipa: validate IPA table memory earlier
    https://git.kernel.org/netdev/net-next/c/cf13919654d5
  - [net-next,4/7] net: ipa: verify table sizes fit in commands early
    https://git.kernel.org/netdev/net-next/c/5444b0ea9915
  - [net-next,5/7] net: ipa: introduce ipa_cmd_init()
    https://git.kernel.org/netdev/net-next/c/7fd10a2aca6a
  - [net-next,6/7] net: ipa: kill ipa_table_valid()
    https://git.kernel.org/netdev/net-next/c/39ad815244ac
  - [net-next,7/7] net: ipa: check table memory regions earlier
    https://git.kernel.org/netdev/net-next/c/73da9cac517c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


