Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDC6646832
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiLHEUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiLHEUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39ED6C730
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 20:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7387F61D4B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C15DEC433B5;
        Thu,  8 Dec 2022 04:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670473215;
        bh=LPObMEvNSMzd9fGo1UAB0xYq4dvWtVq8Iq4rsWb2f+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MrANOTNuRg49nwWA8Ef87MGe2eTrT2OLrHI7o5wJbsWBD+glMx2sfqh9m8ARo+9GV
         rfeFTlizVri8ig7oCdhD1nvnnrRgHmrwJn9dWv50fTto3+F6SoGZZFnrKsIQBCTj3N
         TaDk2/ocxc7WYp8NN1mhA6Bc5CnDqbi6/t3Oj8NjZcvAu4f+QBdO6sBeOqm3RWIuaA
         sCbYdJGF/xQzgpUnNp5nqqBx5AMgpmx18UH00GToKCI1zQAeYPkR/bOU9r06AgawqV
         RsoOtM1A8LwAaB5prEvcPlVlVEFYC51+ZvClNJl+GKCG1s0ToEM7gY4LcwJ/vH8+Fe
         BKdClr5/dRDwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C94BE270CF;
        Thu,  8 Dec 2022 04:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: plip: don't call kfree_skb/dev_kfree_skb() under
 spin_lock_irq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167047321563.25577.15022254650562516270.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 04:20:15 +0000
References: <20221207015310.2984909-1-yangyingliang@huawei.com>
In-Reply-To: <20221207015310.2984909-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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

On Wed, 7 Dec 2022 09:53:10 +0800 you wrote:
> It is not allowed to call kfree_skb() or consume_skb() from
> hardware interrupt context or with interrupts being disabled.
> So replace kfree_skb/dev_kfree_skb() with dev_kfree_skb_irq()
> and dev_consume_skb_irq() under spin_lock_irq().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: plip: don't call kfree_skb/dev_kfree_skb() under spin_lock_irq()
    https://git.kernel.org/netdev/net/c/7d8c19bfc8ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


