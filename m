Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911735BFD6E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiIUMAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiIUMAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3D976966;
        Wed, 21 Sep 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59F7762A90;
        Wed, 21 Sep 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3F61C43141;
        Wed, 21 Sep 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663761616;
        bh=rhaWXaBoWYJCMLyvZr/lV4NaGpgZysIMwXQeBhtisLU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mlrMbTCtfc/mHiTriH4QVgzkZnmeD08aoqMvOb0FLWYNji9UerccdI451ipJlM8nI
         EnIOvNQ1Iu2baiwyVAU3Tq3GvXJ4Z0MzTSmPUbj1kisjQh8Pu/kBpLypmInACKx3r7
         kVuosql3ZBKnDTnA4B7PdqveCJA7TPzf3jPg/N53HcHDDEX0COgfFYHKk9sI/X4/+2
         Tg3+l3X/6W5QvZztxQkfZYSVUb2PFIjKp0asZHvtoMuSy+FWxHjQCzK35NvSkXkn4e
         HTJyhSWs5mcqmbj8vwyP+Revqozxb7ng0W1gWcBQ9obULRzj8upJedc2JwIGJgBA66
         sT7htwyypiJNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DF8AE4D03D;
        Wed, 21 Sep 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/af_packet: registration process optimization in
 packet_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166376161664.20264.16952481668732388176.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 12:00:16 +0000
References: <20220915010835.1761211-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220915010835.1761211-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
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

On Thu, 15 Sep 2022 09:08:35 +0800 you wrote:
> Now, register_pernet_subsys() and register_netdevice_notifier() are both
> after sock_register(). It can create PF_PACKET socket and process socket
> once sock_register() successfully. It is possible PF_PACKET socket is
> creating but register_pernet_subsys() and register_netdevice_notifier()
> are not registered yet. Thus net->packet.sklist_lock and net->packet.sklist
> will be accessed without initialization that is done in packet_net_init().
> Although this is a low probability scenario.
> 
> [...]

Here is the summary with links:
  - [net-next] net/af_packet: registration process optimization in packet_init()
    https://git.kernel.org/netdev/net-next/c/63b7c2ebcc1d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


