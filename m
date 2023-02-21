Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20F869D7BE
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbjBUAuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbjBUAuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:50:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEB71DB94;
        Mon, 20 Feb 2023 16:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91B55B80E64;
        Tue, 21 Feb 2023 00:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F760C4339C;
        Tue, 21 Feb 2023 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940620;
        bh=sRCKDwlANSbWqblUv24AyfBa6MylsEILD/UBW4QL2aY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fTJ50VW0Ir+L1/msIhAX9LK/XfNXHyWAQ2ZX3mbiO9D0oraYWr4e7knf2u7ZFWIJz
         ZuvLm0711VeP31Bk24PWDW0KiVsMK4Jyqz5pCeZmuVJt0Q0d1+59WWgY0sGQp3mUBd
         b/1oJe3AkK122Vqd+Dg7wE78aMlULY75ZwyhrkfJ5U4rX/rC4Q9BYmGOZ8EIPmj8+U
         aI8CJMkAj2OpS8AX1W1rK3enismqzm+Wu4GnIUsea79rlvXB5RGhVLzx0K5u4jNkTh
         Y5UYiOJLz3uwTZ6meSYLUBJIMuTjNyzYNXxJ3kUxmLmhogtLwFbS/WqAiVJ3ykTBvr
         BQ1NqDkXoeoKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FC54C691DE;
        Tue, 21 Feb 2023 00:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next] sfc: fix builds without CONFIG_RTC_LIB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167694062019.10450.8199913841986761865.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 00:50:20 +0000
References: <20230220110133.29645-1-alejandro.lucero-palau@amd.com>
In-Reply-To: <20230220110133.29645-1-alejandro.lucero-palau@amd.com>
To:     Lucero@ci.codeaurora.org, Palau@ci.codeaurora.org,
        Alejandro <alejandro.lucero-palau@amd.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
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

On Mon, 20 Feb 2023 11:01:33 +0000 you wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Add an embarrassingly missed semicolon plus and embarrassingly missed
> parenthesis breaking kernel building when CONFIG_RTC_LIB is not set
> like the one reported with ia64 config.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202302170047.EjCPizu3-lkp@intel.com/
> Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> [...]

Here is the summary with links:
  - [v4,net-next] sfc: fix builds without CONFIG_RTC_LIB
    https://git.kernel.org/netdev/net-next/c/5f22c3b6215d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


