Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996816C4769
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjCVKUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjCVKUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119425A939;
        Wed, 22 Mar 2023 03:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0DBB61FFC;
        Wed, 22 Mar 2023 10:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0773C433D2;
        Wed, 22 Mar 2023 10:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679480418;
        bh=hGFxyred+az/fWlsQF8g7FJb3BwXQ/Rhotg83+zWI/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R3k5g/IEE7lDZL8yEq/i5ep1mBZUrVY0/67xhjebU1ZoTc3G2syT7RoUngleIrAUg
         DHvDGaB2+M/FdYT14UZXmttTSjukCP3YFrhSqck5phgRzrd7IObZcpyFKjSSUyRV/J
         WlCnC2dARVhBSpHIllIr/UGDXMkM/Bu38FPAn75VChPQpzsnEnlfut4VAeG9aCtTnC
         r9YnxFu3dSfndIgj/9g+chafjWxC49978zHBsuC+7XRHKHdqdfSY2iq8kCMp0eB7WV
         gUVgfEjg4GSG0DzqKPF7X1rGVa7zkqBOoWdLITGJO/xWaurttB/60jFXzVNvbWNHMJ
         e9GYqa2CZrkPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D433BE66C8B;
        Wed, 22 Mar 2023 10:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] virtio/vsock: check transport before skb
 allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167948041786.4306.1602330592289509193.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 10:20:17 +0000
References: <08d61bef-0c11-c7f9-9266-cb2109070314@sberdevices.ru>
In-Reply-To: <08d61bef-0c11-c7f9-9266-cb2109070314@sberdevices.ru>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bobby.eshleman@bytedance.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, avkrasnov@sberdevices.ru
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 20 Mar 2023 20:43:29 +0300 you wrote:
> Pointer to transport could be checked before allocation of skbuff, thus
> there is no need to free skbuff when this pointer is NULL.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Reviewed-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v1] virtio/vsock: check transport before skb allocation
    https://git.kernel.org/netdev/net-next/c/4d1f51551777

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


