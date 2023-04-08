Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0305F6DB88E
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDHDUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjDHDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE92C2727
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 20:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B70865149
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5ACCC433A4;
        Sat,  8 Apr 2023 03:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680924017;
        bh=YyDZ0MMgvR8xIoctbs6bBR+a3gux4ynPBucYkODL8MQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XoPS6SVPo1LCIq/U4EuhOX/ePm8NKIhI6jUWls5aS8zr7wtQ5wtjWAdSG7qTECehl
         cymwhGQrYInEOvhbvgzkOiFSRncPQldty1+P9Eh70/6k9XCkABR2bAmATFx2SUrHRw
         d5Fuh6R/IowfyMBXw3gTOq8to3aL+s0xYv309iyRkHC/8lASnMB3lQr153hBvkM6Os
         t5VGsblaGkAQlBjkQCOJSc8cnV/jpElX0rZnyVYC3lyxQ49HnW1Q23UE3dPRC4vacD
         dCO7PwgYK31C60lMCW3EI2Nvn3u95q81PxWqkVMKeiM3pSfEv0UzCLhpm/NPdr9o9m
         sdN50jKx0o9Wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B343CE4F0D0;
        Sat,  8 Apr 2023 03:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: make SO_BUSY_POLL available to all users
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168092401773.26294.3182175162184588655.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Apr 2023 03:20:17 +0000
References: <20230406194634.1804691-1-edumazet@google.com>
In-Reply-To: <20230406194634.1804691-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
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

On Thu,  6 Apr 2023 19:46:34 +0000 you wrote:
> After commit 217f69743681 ("net: busy-poll: allow preemption
> in sk_busy_loop()"), a thread willing to use busy polling
> is not hurting other threads anymore in a non preempt kernel.
> 
> I think it is safe to remove CAP_NET_ADMIN check.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: make SO_BUSY_POLL available to all users
    https://git.kernel.org/netdev/net-next/c/48b7ea1d22dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


