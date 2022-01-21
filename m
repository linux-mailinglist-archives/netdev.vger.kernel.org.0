Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998CB4959A7
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378600AbiAUGAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:00:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51020 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiAUGAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:00:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9443616BA
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0A2AC340F0;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642744813;
        bh=mR3QKfnq3FiQ0KVFJnVcVSgIcFbyEqg9QH4fjz0Y77g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bFZKNOD7DHphcFXGKVK0Gm5Ez16Q/sj4aWyzQLGvStyBGpARxQdXNCAGdcnbWzh/+
         mQ5yxRRM8GySgkHWF/SUs2dZPOa+hi+1voiLIuyC7JPwEsD2VV35CsopAEUUakXKFj
         Y2c0J8ZK5CN9cS+BcTjmX+EAiUkhyFPX7pVBVb+CrEz3fXVYeI5RpUe/bgCJwu2mUs
         K4Y1Dhhf/Y/a0vwPztMC1myEXdpfN8OFBWj26YrHhNxN1PQ7dih7p25jgMZppvaI3R
         nfrbYoy4C5NsC9I1wm+40rcMpikO1lIcUyCTMCWg/dq1hKpgEObz0McgOYBhVeCkYA
         THtubZo7UxOEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A577AF60795;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: Add a stub for sk_defer_free_flush()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164274481366.1814.11557709515055426618.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Jan 2022 06:00:13 +0000
References: <20220120123440.9088-1-gal@nvidia.com>
In-Reply-To: <20220120123440.9088-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, tariqt@nvidia.com, saeedm@nvidia.com,
        lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Jan 2022 14:34:40 +0200 you wrote:
> When compiling the kernel with CONFIG_INET disabled, the
> sk_defer_free_flush() should be defined as a nop.
> 
> This resolves the following compilation error:
>   ld: net/core/sock.o: in function `sk_defer_free_flush':
>   ./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'
> 
> [...]

Here is the summary with links:
  - [net] tcp: Add a stub for sk_defer_free_flush()
    https://git.kernel.org/netdev/net/c/48cec899e357

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


