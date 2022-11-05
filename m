Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2AD61A737
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 04:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiKEDKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 23:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKEDKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 23:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A0012A9C
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 20:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0E0B62394
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 03:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A29BC433D7;
        Sat,  5 Nov 2022 03:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667617817;
        bh=JQcJMzO0ZHvVMc7Dr3fhL46gUiypz6V+APdJXzQAaNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o+cazX/lEZw6afeXn4PEO05sFJDCotzqtqTrwOO3sutzSSWa3vkxJNVl3h56H7Yty
         wHKdES5tkV+FokV5/wzuUyzq3mIUKiIuA4PpxgX28moBMZPbcR4GdgfaLBHk6Buskl
         YXWt1It6+LZnNsHpQRglUlqp4OjMIpPJt+Kxjs8mvnikAsP96xdCZxJu1VmJXRnhF7
         q+giyMZrNp5ERTKMr7Gbl90KLAJFgReRnG7dNe/HJpaRvx9j4ip7NZyx6OQsPrvyOW
         JbWP/fH8TxOFiAVxN9maSiHhLXGaWc8qj/RhgpCfUnpEClIggAhkqKao+CrImPDDyn
         DzXbiqQQZqnXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F826E29F4C;
        Sat,  5 Nov 2022 03:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] sfc: add basic flower matches to offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166761781705.20771.9065271264242447801.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Nov 2022 03:10:17 +0000
References: <cover.1667412458.git.ecree.xilinx@gmail.com>
In-Reply-To: <cover.1667412458.git.ecree.xilinx@gmail.com>
To:     <edward.cree@amd.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 3 Nov 2022 15:27:26 +0000 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Support offloading TC flower rules with matches on L2-L4 fields.
> 
> Changed in v2:
>  * changed CHECK macro to not hide control flow.  Annoyingly, gcc complains
>    if we don't use the result of the OR-expression we're using to get short-
>    circuiting behaviour (ensuring we only report the first error), so we
>    have to have an if-statement that's semantically redundant.
>  * added explanation to patch #1 of why these checks aren't vital for
>    correctness (and thus don't need to have a Fixes tag or go to net).
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] sfc: check recirc_id match caps before MAE offload
    https://git.kernel.org/netdev/net-next/c/f0b59ad11e29
  - [v2,net-next,2/5] sfc: add Layer 2 matches to ef100 TC offload
    https://git.kernel.org/netdev/net-next/c/6d1c604d1098
  - [v2,net-next,3/5] sfc: add Layer 3 matches to ef100 TC offload
    https://git.kernel.org/netdev/net-next/c/c178dff3f92d
  - [v2,net-next,4/5] sfc: add Layer 3 flag matches to ef100 TC offload
    https://git.kernel.org/netdev/net-next/c/5ca7ef293866
  - [v2,net-next,5/5] sfc: add Layer 4 matches to ef100 TC offload
    https://git.kernel.org/netdev/net-next/c/5d1d24da00db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


