Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB5A6D1929
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjCaIAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjCaIAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A27B743
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6E5262481
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 08:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 371BAC433B3;
        Fri, 31 Mar 2023 08:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680249618;
        bh=+hJCPn95vBf2ZQHRzXfqfye7BMJ+ICYDpBa6honoU6k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EscSXB26hpoydFrNdWs6auA5atOq02Txl9hj5GHocvlwyZhNnmlgZeYXNTgn94ql+
         MtIOGgfWQBYkvsMw44obrpxHvWhU/jVBn2IHS6mdHvwsoiDGPjl/C3BOQZ4DbkWDG+
         KxV+9k/G/URY154jGXcxHJJkNF4v/d811bxRMlSO0FdOvhaMZ0fXsm5ldtBtM3WNI3
         zEK8wzdNfQkFdav8x35/WPiTk5fhhfKtOznYJpt6Ou+hH7htfQvH007jSFQSWHDqEu
         dkgw7PcLbXdS6QQd4LWfhq/xXsB54/mhoEc3fSUsCe9VrYhv/fOvw1pJwZP9zixrY4
         aglMHikwYNl0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23AFDC73FE0;
        Fri, 31 Mar 2023 08:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] macvlan: Fix mc_filter calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024961814.12593.1746365574776871917.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 08:00:18 +0000
References: <ZCP6rRY+gargYJit@gondor.apana.org.au>
In-Reply-To: <ZCP6rRY+gargYJit@gondor.apana.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 29 Mar 2023 16:45:33 +0800 you wrote:
> On Wed, Mar 29, 2023 at 08:10:26AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> >
> > Here is the summary with links:
> >   - [1/2] macvlan: Skip broadcast queue if multicast with single receiver
> >     https://git.kernel.org/netdev/net-next/c/d45276e75e90
> >   - [2/2] macvlan: Add netlink attribute for broadcast cutoff
> >     https://git.kernel.org/netdev/net-next/c/954d1fa1ac93
> 
> [...]

Here is the summary with links:
  - macvlan: Fix mc_filter calculation
    https://git.kernel.org/netdev/net-next/c/ae63ad9b2cc7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


