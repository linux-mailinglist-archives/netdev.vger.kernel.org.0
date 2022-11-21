Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72AA631EEC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiKULAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKULAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8B69E965
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D964161006
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35710C433B5;
        Mon, 21 Nov 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669028416;
        bh=4+WrNBGYeIgEcJBiRiEv2doglLpZv8ND4bYQ2fECigs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hcyRmE97WNPIUKZ587g5HimI1cnEExTw9qKRTb4fCGmanLRcgmROalgf2IiYb6vrG
         UQvRTf7YcxnscZp13BJCQuPfauJ0MIXsCelPXPupPqdJjC98BEcw1+xvKmUFLOq6er
         0y0KK+uD9mZ4NpFS8pOyRzvdgJ7A6X3FKORKH9iDgOziFPYowFxGrYCk9y5D0eIUWf
         7x1XFUQhV4MLIi52HcpU+EQTWGfd6j6diCLR6Hr3xs1qyHx0XOBKdXzVV11hbvO2hk
         uJdEdip7FmsvaeoRBvEbO3g03WUdS6fCvrPgX7txm9fhrnYXCef2Cqsh5/NIfsInkO
         Mp+gq5LqKrrAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 135E6E29F40;
        Mon, 21 Nov 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/2] Handle alternate miss-completions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166902841607.19060.3962341390969710942.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 11:00:16 +0000
References: <20221117162701.2356849-1-jeroendb@google.com>
In-Reply-To: <20221117162701.2356849-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 08:26:59 -0800 you wrote:
> Some versions of the virtual NIC present miss-completions in
> an alternative way. Let the diver handle these alternate completions
> and announce this capability to the device.
> 
> The capability is announced uing a new AdminQ command that sends
> driver information to the device. The device can refuse a driver
> if it is lacking support for a capability, or it can adopt it's
> behavior to work around OS specific issues.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/2] gve: Adding a new AdminQ command to verify driver
    https://git.kernel.org/netdev/net-next/c/c2a0c3ed5b64
  - [net-next,v5,2/2] gve: Handle alternate miss completions
    https://git.kernel.org/netdev/net-next/c/a5affbd8a73e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


