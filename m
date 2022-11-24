Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD4463752F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKXJaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKXJaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B66A11E714
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFC4362063
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21F06C433C1;
        Thu, 24 Nov 2022 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669282217;
        bh=PH1jpg2y2S6ODjG7tLCf8irSTcvm5+Qkpj88BRLfTOg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hurIaMLcwajypbzPprly93fSeFeEmaebs5RqFenzt81RZOBHrUvJUUz6cIEscwciJ
         9rWawFrnRzWOZvL97LvPrpxCcUPMfETPB99j3rN2Ga2ZsEwmHi//D9ryirUP6CBu93
         WJS7xLefAHKFudN9Hfa3AO/IManabWlAIAA51M86+upPSbHt4ffvLOmPCXk3zEziJE
         HzTwMv6j6shPdlwhkjFdDYRcaBEZcGKMDeCynIdQQVAyssjGL7g1jSPPVip9L0rNiX
         jZDPlraWtVGs3Jkb46J5GrDGPTItUe16LZnuZRwOOg3dye4c+dF4cDtkIp9eUKIxz7
         8QESvq7ngP4+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0752CE29F52;
        Thu, 24 Nov 2022 09:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: thunderx: Fix the ACPI memory leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166928221702.11330.17581352042035302885.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 09:30:17 +0000
References: <20221123082237.1220521-1-liaoyu15@huawei.com>
In-Reply-To: <20221123082237.1220521-1-liaoyu15@huawei.com>
To:     Yu Liao <liaoyu15@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, david.daney@cavium.com,
        tomasz.nowicki@linaro.org, rrichter@cavium.com,
        liwei391@huawei.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 23 Nov 2022 16:22:36 +0800 you wrote:
> The ACPI buffer memory (string.pointer) should be freed as the buffer is
> not used after returning from bgx_acpi_match_id(), free it to prevent
> memory leak.
> 
> Fixes: 46b903a01c05 ("net, thunder, bgx: Add support to get MAC address from ACPI.")
> Signed-off-by: Yu Liao <liaoyu15@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: thunderx: Fix the ACPI memory leak
    https://git.kernel.org/netdev/net/c/661e5ebbafd2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


