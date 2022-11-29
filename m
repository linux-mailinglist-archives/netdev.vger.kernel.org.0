Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2F863B7B9
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbiK2CUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbiK2CUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9C42AC73;
        Mon, 28 Nov 2022 18:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4AA16153E;
        Tue, 29 Nov 2022 02:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16695C4314B;
        Tue, 29 Nov 2022 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669688417;
        bh=rk0r4aU5kfwuQEX4wGCmf5eLCcx795wJwurnFCh4sqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MVJfLD2BNSNsaL66CAEcg/6djJKNQPuR8ZWjd42lIniC0iN4e+xHg3AafpeXDW02d
         r1m+Ym5CLHlxTTq00Q6cZcW/OJ3d8OVGO08pN3t7NqNyIcjG5qMkEQJrcAn4uNYN5D
         o9Mpu7qojsRmxoC1lhqBYcLwb4spOf669DPkv0zPGQQYFy+/D4BwqXFZHZods1wBqT
         CrTD/szg2hZ7UhPqVyGtv5TRojHSi7YVdKHbLuVUAz0zls+LHXoyrskL8jP9cM/aIW
         pVjdfVDkTlIKZTdrpgvKggxz9HYwjVRScmsin93Ed8KqFs3ZxZqzn+7jTwfbBBBcnL
         FKVBm10jP1REg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1707E4D017;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: hsr: Fix potential use-after-free
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968841692.21086.15703748887586034418.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 02:20:16 +0000
References: <20221125075724.27912-1-yuehaibing@huawei.com>
In-Reply-To: <20221125075724.27912-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arvid.brodin@alten.se, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 25 Nov 2022 15:57:24 +0800 you wrote:
> The skb is delivered to netif_rx() which may free it, after calling this,
> dereferencing skb may trigger use-after-free.
> 
> Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: correct Fixes tag
> 
> [...]

Here is the summary with links:
  - [v2,net] net: hsr: Fix potential use-after-free
    https://git.kernel.org/netdev/net/c/7e177d32442b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


