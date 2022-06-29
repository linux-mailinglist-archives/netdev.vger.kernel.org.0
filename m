Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CE95600E1
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbiF2NAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbiF2NAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4177239153;
        Wed, 29 Jun 2022 06:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4B0361DB5;
        Wed, 29 Jun 2022 13:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3663BC341CB;
        Wed, 29 Jun 2022 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656507614;
        bh=B0fKn7tLjeTmVmyeUpPT2tOM97qhyV4zCXkEgHKntlo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gJ+pIfin4PoNb47wXa91i6kq0gJQS0RycEwiE+kmvlE7+sXRJeL7+sEj+Yqlz/xWo
         DnkQP1Y+0af13xRnXccHdWQcy1iPHJS6NEnMwBVeIk4EJK7roP48jDVJXrrG6rerOo
         ADe8nUXHLhUpHWCHBhO/LbEqyThOgio4BmvTVHdsvYqAtoDqYn1ItMR+A08LgLcF/P
         e8RKAzkAGRs50yqXD8fB93yaSxo5CrE1OVOa7/KjjOdL2eDxnu9NGhuUM4vK53Bjom
         s221ePjhpHeK7dWM0NqVG3aKNsZ+LHkhJaRZCMMx3GQx8ncqn9BWfEP2md4k/H3gTD
         opGh3Uw0psxyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19EA5E49F61;
        Wed, 29 Jun 2022 13:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: tipc: fix possible refcount leak in tipc_sk_create()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165650761410.14913.4817722202906794513.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 13:00:14 +0000
References: <20220629063418.21620-1-hbh25y@gmail.com>
In-Reply-To: <20220629063418.21620-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        tung.q.nguyen@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 29 Jun 2022 14:34:18 +0800 you wrote:
> Free sk in case tipc_sk_insert() fails.
> 
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
> 
> v2: use a succinct commit log.
> 
> [...]

Here is the summary with links:
  - [v2] net: tipc: fix possible refcount leak in tipc_sk_create()
    https://git.kernel.org/netdev/net/c/00aff3590fc0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


