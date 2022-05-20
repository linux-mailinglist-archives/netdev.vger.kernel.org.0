Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A9252EA0E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 12:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348221AbiETKkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 06:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239447AbiETKkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 06:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D22A14D25;
        Fri, 20 May 2022 03:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9348161D5C;
        Fri, 20 May 2022 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D76DBC385AA;
        Fri, 20 May 2022 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653043212;
        bh=g6zNZqVbanCPTDs5cIvElaN3qts4ZfAe5SNVVWewXK4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dg42xwN8jDWAMZnCUdafc3zcBW0p9yYWKnPHScJJVU139Q2lwrMnVqviZChl22jDT
         YjGIPE6vqoPb090mlc1fYgYxv6wM4FSvBXjSMzk706TkHhzk/GIdLkWm7Z+stxP3x8
         7Mdxx9/U/ZJhOw0l4hdSD5tT0H1bXCwATTxXxPANGEPHxocG9n9839xHvH5aC21urs
         tFOEpwvmpzdKanG7FXnknNMPfDav+XO66GqY2SxHf7m6HxOXUKn7nN2j1Gxk/tCCIQ
         /FZxDiMn3YKbzpnVrMVZYroNUYEASB5Lu7KQGAG0OYC36iJ38EsW9HzSKxSsiWDpQu
         fNuOh4uGs+cvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8C94F03935;
        Fri, 20 May 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: ipa: a mix of patches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165304321275.19589.18261388904544139086.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 10:40:12 +0000
References: <20220519151217.654890-1-elder@linaro.org>
In-Reply-To: <20220519151217.654890-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 May 2022 10:12:10 -0500 you wrote:
> This series includes a mix of things things that are generally
> minor.  The first four are sort of unrelated fixes, and summarizing
> them here wouldn't be that helpful.
> 
> The last three together make it so only the "configuration data" we
> need after initialization is saved for later use.  Most such data is
> used only during driver initialization.  But endpoint configuration
> is needed later, so the last patch saves a copy of that.  Eventually
> we'll want to support reconfiguring endpoints at runtime as well,
> and this will facilitate that.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: ipa: drop an unneeded transaction reference
    https://git.kernel.org/netdev/net-next/c/c15f950d1495
  - [net-next,2/7] net: ipa: rename a GSI error code
    https://git.kernel.org/netdev/net-next/c/c9d92cf28c0c
  - [net-next,3/7] net: ipa: ignore endianness if there is no header
    (no matching commit)
  - [net-next,4/7] net: ipa: open-code ether_setup()
    https://git.kernel.org/netdev/net-next/c/75944b040bbc
  - [net-next,5/7] net: ipa: move endpoint configuration data definitions
    https://git.kernel.org/netdev/net-next/c/f0488c540e8a
  - [net-next,6/7] net: ipa: rename a few endpoint config data types
    https://git.kernel.org/netdev/net-next/c/cf4e73a1667e
  - [net-next,7/7] net: ipa: save a copy of endpoint default config
    https://git.kernel.org/netdev/net-next/c/660e52d651ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


