Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4255F02B1
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiI3CVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiI3CVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:21:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7498D75FF9
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 19:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10B5F618CE
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73534C43146;
        Fri, 30 Sep 2022 02:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664504467;
        bh=S484MBRtZDrtBhqswk6V2QJRmIKvq3GE5oAlO+t3aOQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NuEEX2OyoqGlQBitlgOGCN2wMTMNYjbA8v6ufV1fvf/lx9Ib4H5bgiILNGMPKNKvp
         fbXGqtN5LoW/YBYJw7NtA7HzPea3WR9RpeMBXWKXImRhDMA/kA3Ht9ROaF5Oc73mBh
         itTtaDrmBdlfCyi5vwtqW9paoBo/pVJndgNINcQAn+37wCdJXbOHI+U4qCY5LdHmGQ
         zk28F/4mI/KXvJYNSG8nnAdJcYzZdQwiChuBxY/uCx5y+nomIX68ZVysfEXTip+Ro6
         VXD9ekzy0/GBUy+P8ei8kih7LKvUHmqHwUWRI1qFIl63yGfwdOuB0OT6gokJnKGjKC
         7lHjE/JpWjERg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5FD05C395DA;
        Fri, 30 Sep 2022 02:21:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/tipc: Remove unused struct distr_queue_item
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166450446738.30186.11648995125894359889.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 02:21:07 +0000
References: <20220928085636.71749-1-yuancan@huawei.com>
In-Reply-To: <20220928085636.71749-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 28 Sep 2022 08:56:36 +0000 you wrote:
> After commit 09b5678c778f("tipc: remove dead code in tipc_net and relatives"),
> struct distr_queue_item is not used any more and can be removed as well.
> 
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  net/tipc/name_distr.c | 8 --------
>  1 file changed, 8 deletions(-)

Here is the summary with links:
  - net/tipc: Remove unused struct distr_queue_item
    https://git.kernel.org/netdev/net-next/c/8af535b6b14c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


