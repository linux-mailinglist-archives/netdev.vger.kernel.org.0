Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F82698BFD
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBPFa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBPFaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:30:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F7E1BFE
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 21:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BF8FB825BF
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A9B1C433A4;
        Thu, 16 Feb 2023 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676525419;
        bh=WJHJ0UYNZ+4eaVKbNaQApOMJNMXOcCc2gBKCZBINWwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sdHRvJxoYPMq398XQMhW1Ob6zoG1wQZuFyLPB9UO8B6H/KqKxJt4vKf5ncNo1L2BE
         Ova4n0LV7DtSt5MmvLZbcsXZkmJP/ZtT6krU0lUlcqPqBoiodp5XtmvlF/xupXuLgO
         IdA9rF7R3QoN5Rhz9iK2zDWou4gT9J4gkq39uNiGr/MlUsrmKDv+biVWPZJag8TOvs
         T7+gfGq2l0yLTpM0my1mhcVG3r6Jc3nJ71aFftYj9fUXIWXobSG0MvS/SvyT4uERDE
         rN4Lpzyo6y1+GySPcZCanJjrXzpa6EIStgEbepLwwdD9ZFcCTfDarey8yJL37z5k4Z
         TKkqR19t3yELA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBC04E29F3F;
        Thu, 16 Feb 2023 05:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: msg_zerocopy: elide page accounting if
 RLIM_INFINITY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167652541896.5481.16928395556634359517.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 05:30:18 +0000
References: <20230214155740.3448763-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20230214155740.3448763-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, willemb@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 14 Feb 2023 10:57:40 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> MSG_ZEROCOPY ensures that pinned user pages do not exceed the limit.
> If no limit is set, skip this accounting as otherwise expensive
> atomic_long operations are called for no reason.
> 
> This accounting is already skipped for privileged users. Rely on the
> same mechanism: if no mmp->user is set, mm_unaccount_pinned_pages does
> not decrement either.
> 
> [...]

Here is the summary with links:
  - [net-next] net: msg_zerocopy: elide page accounting if RLIM_INFINITY
    https://git.kernel.org/netdev/net-next/c/14ade6ba4120

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


