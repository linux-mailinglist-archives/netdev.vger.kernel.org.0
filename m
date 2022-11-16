Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ECF62B257
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 05:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiKPEaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 23:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKPEaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 23:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2663C13FA2;
        Tue, 15 Nov 2022 20:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEF9961838;
        Wed, 16 Nov 2022 04:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03EDAC433D7;
        Wed, 16 Nov 2022 04:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668573015;
        bh=2kZ4aJoGsZm6LAq4RGp2IrLNG7oJ12Koj7oq+oS4yOc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iumxwTlO40SCWvBmf2vr3zrKPuw43/+tY0JS5s/cKRL9QPjpibYaUcFlX3GMhCkv5
         Qh0H8mVUaHRjtozRV3eT+FbMAmvYQJ/ft3h9oFniDBHYGvWoOELJURwIPuw6xBeOlN
         vhBXzQo4cyxhOOPU3RKXo/9P+DJVQh2+nCC50fi3vQ6Ob0BvDcjX3oPkaZuvM+jUFo
         WQVe/URMND5vrzSc3cwpfxACMoroAMb5BSkxd94prJ6J/Y6T0ws99W3tVVrETmtcFv
         Qcr2i224gXWqUreHGIFLMQ/vD2fbFW8NT/FznbkgY1Xa4NT66o3bwx2QOnISI4z8F3
         czHq9S+x91QXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D42A6E21EFE;
        Wed, 16 Nov 2022 04:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/x25: Fix skb leak in x25_lapb_receive_frame()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166857301485.26862.5354209271873264892.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 04:30:14 +0000
References: <20221114110519.514538-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20221114110519.514538-1-weiyongjun@huaweicloud.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     ms@dev.tdt.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew.hendry@gmail.com,
        mattjd@gmail.com, weiyongjun1@huawei.com,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
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

On Mon, 14 Nov 2022 11:05:19 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> x25_lapb_receive_frame() using skb_copy() to get a private copy of
> skb, the new skb should be freed in the undersized/fragmented skb
> error handling path. Otherwise there is a memory leak.
> 
> Fixes: cb101ed2c3c7 ("x25: Handle undersized/fragmented skbs")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net/x25: Fix skb leak in x25_lapb_receive_frame()
    https://git.kernel.org/netdev/net/c/2929cceb2fcf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


