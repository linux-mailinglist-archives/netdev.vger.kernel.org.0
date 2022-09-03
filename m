Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46A15ABE36
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 11:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiICJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 05:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiICJkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 05:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DAD550A3
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 02:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B267C610A5
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 09:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06579C433C1;
        Sat,  3 Sep 2022 09:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662198015;
        bh=M3MnJgLMLrOl+cvY1uH1vm+88wtXzYdqrv5Rrl5YSfc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EUXv1mxaPzUOTjD/OD0lBjM7j6oE9yhhIW76qK07bL6fddhbUHXpjnfQTQtAJBIB5
         jpeD3o77z19BxV/eCpXWhyM26XeLhes3R//7w5jfiOzaZDScOJ4+w688Dfd9dLl2e9
         Eai3djs7B4B/qY++eQqW3TC0yHzrMFGe6NhJj/WKa3p+CKW+nq3PNXFA4mVcJqtChL
         JomjYgPXzPGOUtmznZ28jlNLdzRZC0ID5f+0Ydvt5oUIF09mqTvUwIt8hHz5gwyMOX
         TbfaT8PNnwl8T0telxAHnx1yNV49TdBbxstI/atz3z3Salt+fWdabwo4KOokHHXLWe
         qvccCdEB/jfQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC84AE924D9;
        Sat,  3 Sep 2022 09:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] xen-netback: only remove 'hotplug-status' when the vif is
 actually destroyed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166219801483.23737.17168227064618244830.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 09:40:14 +0000
References: <20220901115554.16996-1-pdurrant@amazon.com>
In-Reply-To: <20220901115554.16996-1-pdurrant@amazon.com>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        wei.liu@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, marmarek@invisiblethingslab.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  1 Sep 2022 12:55:54 +0100 you wrote:
> Removing 'hotplug-status' in backend_disconnected() means that it will be
> removed even in the case that the frontend unilaterally disconnects (which
> it is free to do at any time). The consequence of this is that, when the
> frontend attempts to re-connect, the backend gets stuck in 'InitWait'
> rather than moving straight to 'Connected' (which it can do because the
> hotplug script has already run).
> Instead, the 'hotplug-status' mode should be removed in netback_remove()
> i.e. when the vif really is going away.
> 
> [...]

Here is the summary with links:
  - [net] xen-netback: only remove 'hotplug-status' when the vif is actually destroyed
    https://git.kernel.org/netdev/net/c/c55f34b6aec2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


