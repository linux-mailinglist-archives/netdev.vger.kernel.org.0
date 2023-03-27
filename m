Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34636C9C70
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjC0HlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbjC0Hks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:40:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA98EC3;
        Mon, 27 Mar 2023 00:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83AFA61011;
        Mon, 27 Mar 2023 07:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD720C4339B;
        Mon, 27 Mar 2023 07:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679902839;
        bh=0TEk3ZqWXnxKuH/Fw6PufZL4vXFQjTfxwUoYTmilE6k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h1eQTJYwHRbb0dxZLl+zbMue6/IRHI8vO6L8MHPxTjMcOgyacc9uJ3vGD8xTHzwZW
         MYEQ2B7dKK1vNcBIfBvozCIWTQd7oeHzHv8aJI0h98ATSCFN/y1SOo5XRGTKAH5k/h
         e96I81aHzlLKoR24oHxvKU/ei5cGBO0DLJliB0qUEbhDEjtcEdXzrDH6LVKeWYE5+A
         8HRt12CjW8hxIb5l5UQ9CAZ0tKeyW6UmGv1fhzt/DKZQMvY3mmpourITgV5XIuVRqB
         AYJa4EG7478kzeyisPB+3yR79+UxJ+gIIEVq1hQ9I/hKzmPDWlZ1exKYRwY1mKe3zl
         09l3oHpZAVK8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9428E4D029;
        Mon, 27 Mar 2023 07:40:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/8] octeon_ep: deferred probe and mailbox
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990283975.16393.10243925958413218334.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 07:40:39 +0000
References: <20230324174704.9752-1-vburru@marvell.com>
In-Reply-To: <20230324174704.9752-1-vburru@marvell.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        aayarekar@marvell.com, sedara@marvell.com, sburla@marvell.com,
        linux-doc@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 10:46:55 -0700 you wrote:
> Implement Deferred probe, mailbox enhancements and heartbeat monitor.
> 
> v4 -> v5:
>    - addressed review comments
>      https://lore.kernel.org/all/20230323104703.GD36557@unreal/
>      replaced atomic_inc() + atomic_read() with atomic_inc_return().
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/8] octeon_ep: defer probe if firmware not ready
    https://git.kernel.org/netdev/net-next/c/10c073e40469
  - [net-next,v5,2/8] octeon_ep: poll for control messages
    https://git.kernel.org/netdev/net-next/c/24d4333233b3
  - [net-next,v5,3/8] octeon_ep: control mailbox for multiple PFs
    https://git.kernel.org/netdev/net-next/c/7c05d3d06c23
  - [net-next,v5,4/8] octeon_ep: add separate mailbox command and response queues
    https://git.kernel.org/netdev/net-next/c/577f0d1b1c5f
  - [net-next,v5,5/8] octeon_ep: include function id in mailbox commands
    https://git.kernel.org/netdev/net-next/c/f25e596755b4
  - [net-next,v5,6/8] octeon_ep: support asynchronous notifications
    https://git.kernel.org/netdev/net-next/c/baa987988777
  - [net-next,v5,7/8] octeon_ep: function id in link info and stats mailbox commands
    https://git.kernel.org/netdev/net-next/c/0718693fb36c
  - [net-next,v5,8/8] octeon_ep: add heartbeat monitor
    https://git.kernel.org/netdev/net-next/c/5cb96c29aa0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


