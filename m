Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C460157F717
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiGXUuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 16:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGXUuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 16:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110005F58
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 13:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A73D460FD3
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 20:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 041FCC341C0;
        Sun, 24 Jul 2022 20:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658695813;
        bh=Da/scRiVqybU/1Q+afvIP/6egzZsk6brHN0v0YpNfT4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ueYvvMhMmWPrn2Oi4FphHI8yW3sgFYL5s1KkKMgiJJvU34HJ8Fn6sAXpFNpHKgx8I
         +GYwRuW5DIGkdnu/h1ML79c15bfKksEkfx7VQwmt0X6Sqpm4HpBdD3qaTRsFpoBhed
         C4B2N93zlUe5mczOsC/S7Br8ZDQMK2XnPcKnl2wgTu+OR/xbjmqsxLwYXHQU5GmU5F
         2o/+bse8d45NFtzVb0xtwbFB6WLMnSbOdTy3jcMCNmDjgMx5r3AMCYnPl6w+/5CziN
         m4eTjYEydkN1bQyjJmN+Gl73lY41vv8GsPrqsEo+C2iTuRx7lv372krl39NGXtnvvx
         tWDQbjKYR1sZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBB0FF83691;
        Sun, 24 Jul 2022 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/tls: Remove the context from the list in
 tls_device_down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165869581289.26749.17069670764303732595.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Jul 2022 20:50:12 +0000
References: <20220721091127.3209661-1-maximmi@nvidia.com>
In-Reply-To: <20220721091127.3209661-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, tariqt@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 21 Jul 2022 12:11:27 +0300 you wrote:
> tls_device_down takes a reference on all contexts it's going to move to
> the degraded state (software fallback). If sk_destruct runs afterwards,
> it can reduce the reference counter back to 1 and return early without
> destroying the context. Then tls_device_down will release the reference
> it took and call tls_device_free_ctx. However, the context will still
> stay in tls_device_down_list forever. The list will contain an item,
> memory for which is released, making a memory corruption possible.
> 
> [...]

Here is the summary with links:
  - [net] net/tls: Remove the context from the list in tls_device_down
    https://git.kernel.org/netdev/net/c/f6336724a4d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


