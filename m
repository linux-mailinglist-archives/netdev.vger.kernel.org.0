Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95462645D47
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiLGPKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiLGPKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81105B87E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 860EE61A73
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D76B8C433D7;
        Wed,  7 Dec 2022 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670425815;
        bh=VHBDCsJSmzg0xhhb4uYdwZabrgTaZtH2k7KBPqAy7fU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L/7EY53bN8ofZuRbWsiKukJWr5bA1f+MOCHIHXBdNI53XB8E2muX8UUBwdYecQxzd
         q7g1gM+/O0oVwhZBgMM5qj3aa4uB13UHroDhdQVsMK4fjz70UiTD2WeBpaf3VBQk3N
         RlXg1SYjjC5ONpkGyhlueN1ClnGlBTku2nuTt2rq3ak2pGCybR+0mAK/14BpXgTq14
         zhGLTse//ECOrZ+OIHkrWvM4QDqfFXWhM32QOMph9tq7IR6Qh41SxKnpU0GFXEAS39
         M5cWflFEM9LV9ClIvXl544dIfYU9QZpRmXO+/VEToEYNtD6nR/Zy00pjN9YIZ2qJvk
         K/Rj9CJ5uztXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8BB1C5C7C6;
        Wed,  7 Dec 2022 15:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] xen/netback: don't call kfree_skb() under
 spin_lock_irqsave()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167042581575.18211.14598449425594429155.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 15:10:15 +0000
References: <20221205141333.3974565-1-yangyingliang@huawei.com>
In-Reply-To: <20221205141333.3974565-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jbeulich@suse.com, jgross@suse.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 5 Dec 2022 22:13:33 +0800 you wrote:
> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled. So replace kfree_skb()
> with dev_kfree_skb_irq() under spin_lock_irqsave().
> 
> Fixes: be81992f9086 ("xen/netback: don't queue unlimited number of packages")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] xen/netback: don't call kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/9e6246518592

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


