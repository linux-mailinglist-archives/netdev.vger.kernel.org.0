Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4764666BFCC
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjAPNaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjAPNaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37751A4A3;
        Mon, 16 Jan 2023 05:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66760B80E93;
        Mon, 16 Jan 2023 13:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A1E9C43392;
        Mon, 16 Jan 2023 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673875817;
        bh=4cAa7P8pWPuga1WEVYcg7Md/ww5MmN6hlgB/gxds2LM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d2QMLTjjM8wsbvjLOXKJjDcRuv0xbE1sB6f3cFAqSlKc7WgHGhXSnsv5QF8gkhJrg
         12mwmcXYFg4/P8bh+euy0WFFxe2eDexePmxvbxJsfR2WL5XojLzLONIMjq+0bWJs54
         ZXLxY6KOsM363F+KVLgdPYjtYbpRRQ/4shUGNjxzNEqq3NgpifFl6RuuWM33IbAIHn
         1J1RysFLcUS+hgPaCrFv5SntTYd4KpBd9rpzMMJlN9nrWaSZl4l0UHPjC+qtj6ZDj0
         yt9X9Hwseh39SGWJWQEJgJ9iP3oyDY0YF/Fm3xs+K/l1mCa/wrf4rK9aXVkUkgSKU3
         K+Vsclj0lmpvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA8A8E54D2E;
        Mon, 16 Jan 2023 13:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v10] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167387581695.2747.2480741925614672468.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 13:30:16 +0000
References: <20230113222137.2490173-1-bobby.eshleman@bytedance.com>
In-Reply-To: <20230113222137.2490173-1-bobby.eshleman@bytedance.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     bobbyeshleman@gmail.com, cong.wang@bytedance.com,
        AVKrasnov@sberdevices.ru, stefanha@redhat.com, sgarzare@redhat.com,
        mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 13 Jan 2023 22:21:37 +0000 you wrote:
> This commit changes virtio/vsock to use sk_buff instead of
> virtio_vsock_pkt. Beyond better conforming to other net code, using
> sk_buff allows vsock to use sk_buff-dependent features in the future
> (such as sockmap) and improves throughput.
> 
> This patch introduces the following performance changes:
> 
> [...]

Here is the summary with links:
  - [net-next,v10] virtio/vsock: replace virtio_vsock_pkt with sk_buff
    https://git.kernel.org/netdev/net-next/c/71dc9ec9ac7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


