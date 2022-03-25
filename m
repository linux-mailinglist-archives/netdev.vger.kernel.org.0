Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDF04E6C2F
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357680AbiCYBpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357579AbiCYBox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:44:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBFE9D4F8;
        Thu, 24 Mar 2022 18:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 022C4B82729;
        Fri, 25 Mar 2022 01:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BEA5C340EE;
        Fri, 25 Mar 2022 01:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648172411;
        bh=3v2bd6rKVB2eCYg9MW6NP9HAxCJIVx1Ix0gW27bXTbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z8oHpxcysqv0ZHS7Qow49u0f8/Z0gMF0jBlFvbuy4Do4CBp0pAmWXc0T2MfaXsTw3
         WDGAkLRm22rGwCZ+qUpu0A2Bd2x/q61j9gAlkwMKzrm3WCZvMlLD/YRw3HEQiMYWid
         smUsHqQfQquHt09xxGZ+K0Iw+lZxbGSCrY0tGrYKrBDr2AxYiVa0mspqIgbfelXyiL
         2WRxYrm7YlSR1kPeuC2OAWY/1hzXSchM64rBzrtoQneCOyWioGkAAxeMK2scri8WTU
         P2/Nh/w3i4gXkfz1D/kb878/WAJYe8emOwEjwlIFzX/MuwwWAjrXNPt3DV1TaAoDeL
         V5G+sM2MtOObA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B87BF0383F;
        Fri, 25 Mar 2022 01:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3] vsock/virtio: enable VQs early on probe and finish
 the setup before using them
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164817241143.12279.13966814935964027710.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Mar 2022 01:40:11 +0000
References: <20220323173625.91119-1-sgarzare@redhat.com>
In-Reply-To: <20220323173625.91119-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mst@redhat.com,
        asias@redhat.com, arseny.krasnov@kaspersky.com,
        stefanha@redhat.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        davem@davemloft.net
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Mar 2022 18:36:22 +0100 you wrote:
> The first patch fixes a virtio-spec violation. The other two patches
> complete the driver configuration before using the VQs in the probe.
> 
> The patch order should simplify backporting in stable branches.
> 
> v3:
> - re-ordered the patch to improve bisectability [MST]
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] vsock/virtio: initialize vdev->priv before using VQs
    https://git.kernel.org/netdev/net/c/4b5f1ad5566a
  - [net,v3,2/3] vsock/virtio: read the negotiated features before using VQs
    https://git.kernel.org/netdev/net/c/c1011c0b3a9c
  - [net,v3,3/3] vsock/virtio: enable VQs early on probe
    https://git.kernel.org/netdev/net/c/88704454ef8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


