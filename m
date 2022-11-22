Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6558F633498
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 06:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiKVFA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 00:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKVFAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 00:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BFE2B18B;
        Mon, 21 Nov 2022 21:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53773B81981;
        Tue, 22 Nov 2022 05:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB9CCC433D7;
        Tue, 22 Nov 2022 05:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669093222;
        bh=Nw9mFixIF/Xa0Jyd7h5JrAq/FwFUkDEwGJxSoeOW1iM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQNUrNa0EEvmgMqZri94xt7ErkXdPiMkj/ieDejdYEwPkrbJcrzcv28cji5fo1Xmm
         GVO5kUZFBCO2kdY3E37qKTJd7df1d0jj2PNVmkms8mShL1RS5yaojqw/fgONXfx6SL
         ycpPpVEvP0M23JsVfQ3OXFARoUzXEeeW8lddB+pow8yJ7D6+ml7SsZ6mC4xGBN66C0
         LwocVB8YcC1twnFYsHmVGpr0jXBH6xDcrejubnkjhkwkRN4pAEpgnesGRT/4QYWSjF
         j7ALdZtay0ZyrTJE2v5LFUViNhLfYTk3RvrFqiX338tyecjU+Pu8EsXTxY0yc85Pwv
         s0RUIVaj3k5+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD2AAE29F3F;
        Tue, 22 Nov 2022 05:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: check skb_linearize() return value in
 tipc_disc_rcv()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166909322182.4259.9413800654731726777.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 05:00:21 +0000
References: <20221119072832.7896-1-yuehaibing@huawei.com>
In-Reply-To: <20221119072832.7896-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
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

On Sat, 19 Nov 2022 15:28:32 +0800 you wrote:
> If skb_linearize() fails in tipc_disc_rcv(), we need to free the skb instead of
> handle it.
> 
> Fixes: 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address hash values")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/tipc/discover.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] tipc: check skb_linearize() return value in tipc_disc_rcv()
    https://git.kernel.org/netdev/net/c/cd0f64211622

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


