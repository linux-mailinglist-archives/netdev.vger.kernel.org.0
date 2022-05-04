Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E8751931A
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244844AbiEDBEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244837AbiEDBEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:04:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5582983B
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D441ACE23C7
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 01:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22B7DC385B1;
        Wed,  4 May 2022 01:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651626034;
        bh=mD08h2ErefXE+ARL3dej/k7FI+lBuSNhYUc0bSMrIJA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HVqHO7sqMPQNQu6oHs15F7zF1YwWZ2MhQEnFol8gf0IxHPPfKDxtTmNGBmhozCmGM
         SOEYYZeqq70c718/5Kbctr4cYyTihP5pfYpqyyjlesmcNMKwbE13oOYNlzRNnBveYq
         H9wP3vZAFBa6S+8uqiTS9QZ42NhN1sEgTT2LPsMzNnpwCWL0kW1z6sNkE/NAec35ii
         7VHRsOokmWh7Oppmr1B98mq43IPUfxtO9Bc1RrZY9gJ2nDZ1ffrpED1k56bXG9XJoM
         2Uya5NBu/FeNfCsAcQVgNyl5mM3Sauk1j7QcqDpOu/2d0rwYpuoIdKbh7FGZd+SEhK
         EyahavHXFxG5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D27EE8DD77;
        Wed,  4 May 2022 01:00:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdev: reshuffle netif_napi_add() APIs to allow
 dropping weight
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165162603405.2155.5003501730095404278.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 01:00:34 +0000
References: <20220502232703.396351-1-kuba@kernel.org>
In-Reply-To: <20220502232703.396351-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  2 May 2022 16:27:03 -0700 you wrote:
> Most drivers should not have to worry about selecting the right
> weight for their NAPI instances and pass NAPI_POLL_WEIGHT.
> It'd be best if we didn't require the argument at all and selected
> the default internally.
> 
> This change prepares the ground for such reshuffling, allowing
> for a smooth transition. The following API should remain after
> the next release cycle:
>   netif_napi_add()
>   netif_napi_add_weight()
>   netif_napi_add_tx()
>   netif_napi_add_tx_weight()
> Where the _weight() variants take an explicit weight argument.
> I opted for a _weight() suffix rather than a __ prefix, because
> we use __ in places to mean that caller needs to also issue a
> synchronize_net() call.
> 
> [...]

Here is the summary with links:
  - [net-next] netdev: reshuffle netif_napi_add() APIs to allow dropping weight
    https://git.kernel.org/netdev/net-next/c/58caed3dacb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


