Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43C469C6AD
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjBTIae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjBTIab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:30:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463F612BE4;
        Mon, 20 Feb 2023 00:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B149760D28;
        Mon, 20 Feb 2023 08:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 161D5C4339B;
        Mon, 20 Feb 2023 08:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676881818;
        bh=Rt6cnH9QsbT3TsQk9trBoGK32nGRu7V/MSBozAFhEEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VdCiswkTaTKfH2ZQ6anQdE7YgZ81BmTRI/NhRoa+Si1R7/BE7lLqb9kbqQAi8Y5NI
         pJNElDdZZIBzDeODyrgANkHxAqxYBESwlwE7kDMC5pahAtOE/HzS+/OPm6J7YCJGtp
         l+T7LTxRAnaao4oyvPRZgRBZ0MzfllWyjiyxpOCwYMFYK/gBIQwr/oRFJh32SROqkX
         Ec2TzoxWujqqH9EAcHXh3R9P2XBFhbfxW38jPVloy1vHaJPE7iprvKT5xMdlS7aqMA
         eTnvSphZd4aXFmDfAMq4cB03PdQ802GQ1o1zF4TC5FXk473HzpyWVw4UmJtb8+Dsma
         a4LrFy9yzbZiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBE62C43161;
        Mon, 20 Feb 2023 08:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] qede: fix interrupt coalescing configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688181796.23180.14471359113445943019.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 08:30:17 +0000
References: <20230216115447.17227-1-manishc@marvell.com>
In-Reply-To: <20230216115447.17227-1-manishc@marvell.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, aelior@marvell.com,
        stable@vger.kernel.org, bupadhaya@marvell.com, davem@davemloft.net
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
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Feb 2023 03:54:47 -0800 you wrote:
> On default driver load device gets configured with unexpected
> higher interrupt coalescing values instead of default expected
> values as memory allocated from krealloc() is not supposed to
> be zeroed out and may contain garbage values.
> 
> Fix this by allocating the memory of required size first with
> kcalloc() and then use krealloc() to resize and preserve the
> contents across down/up of the interface.
> 
> [...]

Here is the summary with links:
  - [net] qede: fix interrupt coalescing configuration
    https://git.kernel.org/netdev/net/c/908d4bb7c54c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


