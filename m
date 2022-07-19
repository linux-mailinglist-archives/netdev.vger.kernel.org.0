Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A9C579177
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiGSDuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbiGSDuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE3EBF56;
        Mon, 18 Jul 2022 20:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5913B614F4;
        Tue, 19 Jul 2022 03:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71E0EC341CF;
        Tue, 19 Jul 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202614;
        bh=tw98uve8FR4iBK5mlQoAni5PAVg4iN3alh1fnq+p6/c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c7aEA1bvNV8nOU6u8I4L1W/LeaHJNsX2fzbCpuuSKvOTPzXvv2KRnctabYMvMltZQ
         k/0Agm6+PVYUpIYOr8PKvw0JuisXYZ1yDb/FKXc0JVYo6ipcP2jxjFaQY+e3uaxj1J
         t87Uauy+UP/C1nthqSefIY/WwVSjB3thSCybm2F7BBRNOVKrZvCQxIlLyCUeIlgNUq
         vsJXbv8zHMp3Oe1uYbKNJgaNS92E4KImRRHU4uwPe0+gpQYShtdrs+kYRpQS7dQAq9
         HUc0Bi+b04uNzueAIACeXbV3rL4l+pUijsYCvt4eCS5X2h2r33pM0pkmDG2u/GxzRB
         vivMkHxAY0fXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57CC2E451B9;
        Tue, 19 Jul 2022 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: prestera: acl: fix code formatting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820261435.2183.5191146946464960635.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:50:14 +0000
References: <20220715103806.7108-1-maksym.glubokiy@plvision.eu>
In-Reply-To: <20220715103806.7108-1-maksym.glubokiy@plvision.eu>
To:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, joe@perches.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri, 15 Jul 2022 13:38:06 +0300 you wrote:
> Make the code look better.
> 
> Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
> ---
> v2:
>  - remove changes to the copyright line
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: prestera: acl: fix code formatting
    https://git.kernel.org/netdev/net-next/c/71c47aa98c51

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


