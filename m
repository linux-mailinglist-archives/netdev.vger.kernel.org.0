Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1817A4F64B6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbiDFPvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236703AbiDFPvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF05D354D3D
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 06:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5318060BA1
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E00AC385A8;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649250613;
        bh=Jx0U8ulZNSrvN/c60ZWWgKpjEsz8saoHuA8qLqcCris=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wu1BQmYtwwfEqo4pKKwwLIpcTK602f7O+lIJoWwsOk2IwhiXGA40SXt01uYzowtBV
         o8RTUTzkh0kwA5fXsluzcNxU6SSvDbHt47u2SsjODEZaudp/U/P89xjqkP1QC2bkvN
         XsSyF1kIWo7KgNsXvru8YpjhqV89Zf/4ui/GtVNPCJXWdMb8B8ZEpEfRT+pEfHK7nk
         KW7AO67HZmFIPVKGja/d9MOrhWMGodIOINiuQWp/bDYvgLeGDxaICvf2r1oHcC3VTp
         /wJRaqQ4QSO/ycIr6a3onOiyxlDARElEnvqjSbA/pRD6FEdyyA3bGE1ZYBy3b99uFm
         YD3Ysj9cMNrbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 802B9E8DBD1;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: fix a race in rxrpc_exit_net()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925061352.5679.14514170581640848740.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 13:10:13 +0000
References: <20220404183439.3537837-1-eric.dumazet@gmail.com>
In-Reply-To: <20220404183439.3537837-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, dhowells@redhat.com,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        syzkaller@googlegroups.com
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

On Mon,  4 Apr 2022 11:34:39 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Current code can lead to the following race:
> 
> CPU0                                                 CPU1
> 
> rxrpc_exit_net()
>                                                      rxrpc_peer_keepalive_worker()
>                                                        if (rxnet->live)
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: fix a race in rxrpc_exit_net()
    https://git.kernel.org/netdev/net/c/1946014ca3b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


