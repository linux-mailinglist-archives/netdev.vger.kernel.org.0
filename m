Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADACF4DD22F
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 02:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiCRBBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 21:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiCRBBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 21:01:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB2B2571A6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38773B82155
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 01:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2896C340ED;
        Fri, 18 Mar 2022 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647565211;
        bh=sOHLlDQ80caPeJe9LD8GPnk1c79deLqRDLRz7YWNQy8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JnH7LK5XiBN820Ou77I8wnA2FyH9pbh4QhFp9i1DQwg78HLmTY3tAERzeJo+jGuAq
         EiO9WX4B85hg5SBDC2b7r/bSffwYxPL7CurjTryxQdy6nnMHYZDYZoZb/bU76AcyJf
         5sPWF3d+G0/JASmYIFPmo2hVZhSwsmMwyN9nBVeISWciLpHgpdQoaB6erQJ41lArGU
         xTrIJiQ4RruCJ+TjtCgdybCD9ERCop/gx3z8CfOTY8FMmK+xe4D4Gbu+n123BJFW6O
         FvvkuK02tBuMzSdONIoZs3esgiXbJwQxzeh1oEB1xQnIzG0YbIz/u6vROCL4G+mVvG
         aCfe1ehzSgAAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4F0EF03842;
        Fri, 18 Mar 2022 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ptp: ocp: Make debugfs variables the correct
 bitwidth
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756521167.13563.3704501599747878035.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 01:00:11 +0000
References: <20220316165347.599154-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220316165347.599154-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        kernel-team@fb.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 09:53:47 -0700 you wrote:
> An earlier patch mistakenly changed these variables from u32 to u16,
> leading to unintended truncation.  Restore the original logic.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  drivers/ptp/ptp_ocp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] ptp: ocp: Make debugfs variables the correct bitwidth
    https://git.kernel.org/netdev/net-next/c/2b341f7532d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


