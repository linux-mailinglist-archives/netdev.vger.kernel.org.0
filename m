Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0DF6D192C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjCaIAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjCaIA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:00:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1BF1A974;
        Fri, 31 Mar 2023 01:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E789CCE2D89;
        Fri, 31 Mar 2023 08:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1C37C433AE;
        Fri, 31 Mar 2023 08:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680249618;
        bh=W5/T8PFfQT4Kt2TSL/5tLnyXbGGwTe53FTh2jn5ZVBY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jcWoBrIMaP0a3vkd/dl+/0K8gWXF4ownzC+VQMS5lyZOLSCud/2WcFR/EQurj15i4
         W+134QKpodbrW74WhF2FWKNHD47Zmti/tg8Xsz7hmceANiqNamlfGQY+Lc3Q+LHFSS
         qEIDxxjp+Ieg7cS1wmdkSvrcstGcR5eObvtVCH4Dta+WWjcYe8JIobCQX0Zp/50KDw
         yVVqk2QswZ4QW1vvhFd4TwzJPmnAlgR2LKMuMb15aSipUK5GIkUKyOgFtrYynuKkDr
         gGx/iklOu7hagN2xK+e4wKKOmUCr7UL9KNpneWowrcc4EWk7+Ra0TLFeoD1vtjMAmX
         k2YeyjmmPYBiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D719EC73FE0;
        Fri, 31 Mar 2023 08:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] virtio/vsock: fix leaks due to missing skb owner
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024961787.12593.9775298884302736023.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 08:00:17 +0000
References: <20230327-vsock-fix-leak-v3-1-292cfc257531@bytedance.com>
In-Reply-To: <20230327-vsock-fix-leak-v3-1-292cfc257531@bytedance.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 29 Mar 2023 16:51:58 +0000 you wrote:
> This patch sets the skb owner in the recv and send path for virtio.
> 
> For the send path, this solves the leak caused when
> virtio_transport_purge_skbs() finds skb->sk is always NULL and therefore
> never matches it with the current socket. Setting the owner upon
> allocation fixes this.
> 
> [...]

Here is the summary with links:
  - [net,v3] virtio/vsock: fix leaks due to missing skb owner
    https://git.kernel.org/netdev/net/c/f9d2b1e146e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


