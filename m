Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F7064C2F3
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 05:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbiLNEAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 23:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbiLNEAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 23:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB05A14038
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 20:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4129A617D2
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8469FC433F0;
        Wed, 14 Dec 2022 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670990418;
        bh=+F6ORVTvXXTNW/GyWoBKAT07N4cGKUFFBJ6Gbme1UtQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gp5tL9MM0J+b7+u8iOwYReVXnUNWvUga5yKosl0AzItJmSaYoJ9c3CUXIfHJEJGuv
         PFG57LRwtncV89It+siGKtE2BGqurYozgRB7EHw1uDvfJzZyqnyvy4aQDQgykT64ll
         z3Aclv1Ua+DvZNk5mp5uS+XcScYWdI4aZcSunBHLrwsKXTEPy6ok5xrseJykbuxHrM
         3GqntQ8qlxcPjFspIxTNzrgO0n9wX4Nuwgc0X3ozPs6XVdUp/BC5m/UqfUUSl19Yld
         oVOF19uJvWrIlyrGOb3sjCSQZFlwZS3yLPS+L/c4Pc5XiZHkrij7ICD9hrbfLZK6U5
         CSzDPoGzzdxyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5BB12E4D029;
        Wed, 14 Dec 2022 04:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] mISDN: don't call dev_kfree_skb/kfree_skb() under
 spin_lock_irqsave()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167099041836.9337.2731638909527627370.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Dec 2022 04:00:18 +0000
References: <20221212084139.3277913-1-yangyingliang@huawei.com>
In-Reply-To: <20221212084139.3277913-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, davem@davemloft.net,
        kuba@kernel.org, jiri@resnulli.us
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Dec 2022 16:41:36 +0800 you wrote:
> It is not allowed to call kfree_skb() or consume_skb() from hardware
> interrupt context or with hardware interrupts being disabled. This
> pachset try to avoid calling dev_kfree_skb/kfree_skb()() under
> spin_lock_irqsave().
> 
> v1 -> v2:
>   Use skb_queue_splice_init() to move the 'squeue' to a free queue, then purge it.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/ddc9648db162
  - [net,v2,2/3] mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/f0f596bd75a9
  - [net,v2,3/3] mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/1232946cf522

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


