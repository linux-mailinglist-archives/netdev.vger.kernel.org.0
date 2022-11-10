Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676F3624D5E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiKJWAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbiKJWAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1DD45A2E
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9739DB823BB
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 22:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D566C433D7;
        Thu, 10 Nov 2022 22:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668117615;
        bh=XM3xA2v55R1GJObc+5L9ND9dKTXvnGoFuYhpvpgFTgw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kyosb1UIdOVK9vpVgtpB6k0oc1z7cX6IbLo6soO2W4DFsySWiGaj3FHiKUMTKCESc
         d/46vGM9WZSz9JAbt8BhiVAH+k3hGapxrZPn2uMJpns/k2neeWbtlVelM/3abawlQB
         nRt9wbLrYlFRXqT/Fm4AASo7eTRysRoJsYvhTuYwW4vrKxB+fdV9bJ4DghAZCOTfxC
         cQojQJUy4X43366dV4q0fdaPO3IXreg4FgEul7KANxkOX4nKV1AFW8sI/25sTqvlE8
         GJgJGeuyhYdoizmYSPXEbwxUGRAzGdYEsdHaTpToK5AqKG5dLSW3CIj31KWLu+owDB
         mw/tqANlA6pOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 109B6E270C5;
        Thu, 10 Nov 2022 22:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: Move Vivien to CREDITS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166811761506.7291.12130190592249416243.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 22:00:15 +0000
References: <20221109231907.621678-1-f.fainelli@gmail.com>
In-Reply-To: <20221109231907.621678-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Nov 2022 15:19:07 -0800 you wrote:
> Last patch from Vivien was nearly 3 years ago and he has not reviewed or
> responded to DSA patches since then, move to CREDITS.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  CREDITS     | 5 +++++
>  MAINTAINERS | 2 --
>  2 files changed, 5 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] MAINTAINERS: Move Vivien to CREDITS
    https://git.kernel.org/netdev/net/c/6ce3df596be2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


