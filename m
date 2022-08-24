Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4F359F5D1
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiHXJAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbiHXJAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9C450182;
        Wed, 24 Aug 2022 02:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 325D7617CA;
        Wed, 24 Aug 2022 09:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83B74C433D6;
        Wed, 24 Aug 2022 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661331615;
        bh=LJwj98O5yiaSW8Agwscn4s0qxpBKY+diZqoJzIjHWIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TOqI0rtlhWyZsIK2mruk0XiDX8P+XHv2p2bj2uHCKD9847XUZd0pIAK/QCDgEDEtG
         nF3DqTCxZHtrbjhvgSKvsYhC82pDrsjzolVshoGhX/DbsSIMIIwCyc2/P9HQN7J9lH
         h+dAABHN7OkOkVIoQ0Ga9xf2CKT2OccMz5ZTcb+JOKxlJaCETl0WAgw5drRzv25uwn
         73hsjl2tiabgl1mF8jloU6KXVHxez7dAv4YMbISO3oxKuY26EODoA7JUETprc2VKeS
         dee8lU+YYu/5+7xtqe7HKnjZ2T/jol/nPg3NJq6JRoSRuZY9BZrwj/10HlEmX2Vcaj
         rbCS9hEQToZ9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62561E2A03C;
        Wed, 24 Aug 2022 09:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 RESEND] net: neigh: don't call kfree_skb() under
 spin_lock_irqsave()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166133161539.23661.2735150323779560219.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 09:00:15 +0000
References: <20220822025346.3758558-1-yangyingliang@huawei.com>
In-Reply-To: <20220822025346.3758558-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        den@openvz.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, razor@blackwall.org
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

On Mon, 22 Aug 2022 10:53:46 +0800 you wrote:
> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled. So add all skb to
> a tmp list, then free them after spin_unlock_irqrestore() at
> once.
> 
> Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
> Suggested-by: Denis V. Lunev <den@openvz.org>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2,RESEND] net: neigh: don't call kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/d5485d9dd24e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


