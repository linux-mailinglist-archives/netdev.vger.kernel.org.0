Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AAE51CEC8
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387911AbiEFBYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387849AbiEFBX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:23:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E567E6C
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 449C0B82E5C
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01630C385B1;
        Fri,  6 May 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800015;
        bh=E7Bi8Veehhhx/ncpucCAmmPmMseCen7QYCbEASf65o4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y4x36el//IAWW0x4Lt7kYKIlwHuVAQNZvY/Nds3uXmaidG6WjNHe4QtmXQOUPpMvV
         sjIlBY1ryoW//eG2kB9p8P/IyVbvVLY+qgrry57uKl8EVezkVEqn9tbogzmbo1I5UG
         Th1DkDQ/io2B7ZGCM6Ryax7jhzyXftwc+r6oCJRDTlCZLzFKyFr37EoWXN6hbWVz7C
         +vFcKtzs90HygDomXc+bAfUIQ+IPvsJzLmb/29Fv9KWrAErtQth6KuXrUmp5mUYJJ8
         CXiqiY78cO1jMIFflR1K2ND48E1Tgp/Nf08YQLTbgEG7oRnVxJSsHf6uf3b10GDLj9
         rPDT8LvcTYAxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC01EF0389E;
        Fri,  6 May 2022 01:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Make msg_zerocopy_alloc static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180001489.16316.16283301329072162332.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:20:14 +0000
References: <20220504170947.18773-1-dsahern@kernel.org>
In-Reply-To: <20220504170947.18773-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
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

On Wed,  4 May 2022 10:09:47 -0700 you wrote:
> msg_zerocopy_alloc is only used by msg_zerocopy_realloc; remove the
> export and make static in skbuff.c
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  include/linux/skbuff.h | 1 -
>  net/core/skbuff.c      | 3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: Make msg_zerocopy_alloc static
    https://git.kernel.org/netdev/net-next/c/c67b627e99af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


