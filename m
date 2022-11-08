Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D162201F
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiKHXKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiKHXKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E2E1D32A;
        Tue,  8 Nov 2022 15:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 597CC617DB;
        Tue,  8 Nov 2022 23:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6DADC433C1;
        Tue,  8 Nov 2022 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667949015;
        bh=BUIad6ZY4RJnNyNfGzLtmoCClzP6cuBxHkB0Ra7AX6Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fuH8TIh9GC7W+/nLQ1VauHSE6CfTM+lBzpbJfb8H24Da+2yKMEmoC1lOK7qUFU4cf
         45WHQTZhjkX6VVHSTZ4q8lbsTRa7kxVVLLxMpdlX51RqrNFoxc0goNjqlhFEeKxMAr
         YrjYa4WT16xC+iK6sG8YFPvj1nUgJIO04OOOsdhtC8ahnDSC5DHgMFSV5sGDPcmXm5
         MHckQlZ6CCmhV8Z9aonBafUuukPzQ6vZIA9viC6N/K+3Hy80p0eY6+SuW7X1CrkYiC
         dxkld8fiHWX3Ro4N7/Q1/I5MgZAYxPBrd4dFtoKxEryg3YSB5GsvSAgMwp0bXBuF7r
         nQPm5ieDxRrGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E1CAE270D3;
        Tue,  8 Nov 2022 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] lib: Fix some kernel-doc comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166794901557.27874.17243575572420623222.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 23:10:15 +0000
References: <20221107062623.6709-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20221107062623.6709-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, fw@strlen.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Nov 2022 14:26:23 +0800 you wrote:
> Make the description of @policy to @p in nla_policy_len()
> to clear the below warnings:
> 
> lib/nlattr.c:660: warning: Function parameter or member 'p' not described in 'nla_policy_len'
> lib/nlattr.c:660: warning: Excess function parameter 'policy' description in 'nla_policy_len'
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2736
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [-next] lib: Fix some kernel-doc comments
    https://git.kernel.org/netdev/net-next/c/8e18be7610ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


