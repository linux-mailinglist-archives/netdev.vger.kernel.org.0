Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155E955142B
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240720AbiFTJUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239813AbiFTJUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FD01145D
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7C03613F7
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 09:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C133C341C6;
        Mon, 20 Jun 2022 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655716812;
        bh=piGOdpjTSkTj1/FVG74Xk0OvXhUimdwO9j79NVy92PQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kRzkNNK104T1cQPNcLu9NEbQnDIDTZf/UVclva0x4UsEio0v1PexBUzjtPolt8+OD
         NpPvoDEcu8C63msKweX4F56GnCGD+gtHDvFDBpxz3qQfN0OxOq9WiLJ1NTnrlDt7bp
         YAIHvlyX1fpbyI0tDyEPi70Lrzn0rB8tKOs7IlMAsiOtPZ5f8v96PwI+afd28GVWuO
         8a3hFU+Uket5MIFTFiKZr5aYFZWKnu72ilSVUUWa/ixFjtl71nO0dvNhGKyN4xXRrP
         VeinV06iOx4D1tBJl/eALfWlSbhclCwL8+t8WRUmV/TIg8A2P62d4OQSLxmv4D/HUb
         9hC+bsVySjsjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EFAAE7386C;
        Mon, 20 Jun 2022 09:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] erspan: do not assume transport header is always set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165571681212.11783.14209641637971197346.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Jun 2022 09:20:12 +0000
References: <20220620083506.3274878-1-eric.dumazet@gmail.com>
In-Reply-To: <20220620083506.3274878-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com, u9012063@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 20 Jun 2022 01:35:06 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Rewrite tests in ip6erspan_tunnel_xmit() and
> erspan_fb_xmit() to not assume transport header is set.
> 
> syzbot reported:
> 
> [...]

Here is the summary with links:
  - [net] erspan: do not assume transport header is always set
    https://git.kernel.org/netdev/net/c/301bd140ed0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


