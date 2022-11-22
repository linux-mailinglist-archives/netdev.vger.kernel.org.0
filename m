Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774D9633CBC
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiKVMkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiKVMkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:40:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D73912D33
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B588B81ABA
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C579AC433D7;
        Tue, 22 Nov 2022 12:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669120814;
        bh=GF4nfv6KfKKASP6rr3VsqrhAVxKOYR5Rd6E9MTTRsSY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qw8WFlFZ3zPL2fHLFBpaB+mNHgwoKhsg0mqHsOvQpSDj7qK2weC7/UHZKBmvJBilx
         wOWwc+VVyChgZi8JQ7SvLQvJYMEzF3VPCn+Nqez9ONnR4rVqMLtw5v2QOJNoTCz1mZ
         RdFkG617AZ5sHawnw8lR1rl1AXTbiJZwBkvY+b15FLk1LpHrgjJqwnNG1bQbur449J
         RWc9qT02gKF0Fr2W6+hBXZo0DmR4LuxLdZsP8cWDKP2a/hv+WePXmFzvSAvp064Mqr
         6hhbLLITqpXva4CeNMj7Vmm9hGiPgdVQ6Y636c36S3NkkQVI8EmO5USzYg7BhF4oxS
         oJsFgAKrTodsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA51EE29F42;
        Tue, 22 Nov 2022 12:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] bnx2x: fix pci device refcount leak in
 bnx2x_vf_is_pcie_pending()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166912081469.24681.569005712136215618.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 12:40:14 +0000
References: <20221119070202.1407648-1-yangyingliang@huawei.com>
In-Reply-To: <20221119070202.1407648-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com,
        manishc@marvell.com, davem@davemloft.net, edumazet@google.com,
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 19 Nov 2022 15:02:02 +0800 you wrote:
> As comment of pci_get_domain_bus_and_slot() says, it returns
> a pci device with refcount increment, when finish using it,
> the caller must decrement the reference count by calling
> pci_dev_put(). Call pci_dev_put() before returning from
> bnx2x_vf_is_pcie_pending() to avoid refcount leak.
> 
> Fixes: b56e9670ffa4 ("bnx2x: Prepare device and initialize VF database")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()
    https://git.kernel.org/netdev/net/c/3637a29ccbb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


