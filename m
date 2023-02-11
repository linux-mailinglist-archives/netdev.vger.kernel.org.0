Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D6F692E06
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBKDk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjBKDkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C313A082;
        Fri, 10 Feb 2023 19:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4928DB826AB;
        Sat, 11 Feb 2023 03:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DF42C4339B;
        Sat, 11 Feb 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676086820;
        bh=7ZWclToRlsx912+0GIfFf/Ov+J0+3loGpn7En6vWOXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mnBKt0DVj7UTjLVp76fjhNz3weZnNpWCJnP5ZLGKhKbJn5Gnl44JxMBB3z5kK6bcB
         gJkifeBhhsnIlfg3RfkoIgosFBcrUC/ylFDeEZbf5sKAf53oy7rMdpTtONTq4oQvOX
         MZgDe/IuOdtacWEE6zTI29z2MLvMP9tqwE3Zez5oCTfU3pk+LbY98Fh++8wZx0/G1A
         CU5y4vXTsCeiWLpBcvnIQda8gGrS+RiNsy+bof5qQplsUIuA9/NjRx3JfMmEhSw+9L
         8UdYRMAFJr2fLTaL9jHe8X5RWBeJs8W1PIVxSGdGeAJtOinDM3GpzpfeoU02STdx3k
         mKzsEEYD+75sg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8D06E29F46;
        Sat, 11 Feb 2023 03:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: libwx: fix an error code in
 wx_alloc_page_pool()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608681994.24732.14317703886025479892.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 03:40:19 +0000
References: <Y+T4aoefc1XWvGYb@kili>
In-Reply-To: <Y+T4aoefc1XWvGYb@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
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

On Thu, 9 Feb 2023 16:43:06 +0300 you wrote:
> This function always returns success.  We need to preserve the error
> code before setting rx_ring->page_pool = NULL.
> 
> Fixes: 850b971110b2 ("net: libwx: Allocate Rx and Tx resources")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Applies to net-next.
> 
> [...]

Here is the summary with links:
  - [net-next] net: libwx: fix an error code in wx_alloc_page_pool()
    https://git.kernel.org/netdev/net-next/c/183514f7c569

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


