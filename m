Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB566405AF
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiLBLUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbiLBLUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:20:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDCC7F8A8;
        Fri,  2 Dec 2022 03:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 980DFB82145;
        Fri,  2 Dec 2022 11:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50E45C4347C;
        Fri,  2 Dec 2022 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669980017;
        bh=xddJ7x7rxdG1xP6l+opPk82BgIWXEMwXu5GWq4GKQkw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B2UPAhLWeqiMA1wya58Yj0ult79WMCjL5m9OpWxUaAb/Rwq76sGfYJUb8gd62zKyY
         qZbdJXyDT9oNRBzAKFKj0n0ihS0WfH4ZRNgu07YPo6OA1oXlAVhwAN4n0cW9l8mazG
         Isv/vg9OcdIZVljdc38hZlwZyvrKrdjb8XWv4BtOGqC70k899z4RWrFz99ZHDD+EML
         hcPhXEfFxpPaCCL3ps93ULXoytgij7MnO/tx5fzRX/FxXIIYcydjlbaSCJB0qyjmfT
         qeGHlF+jNa7DqeAJe/8BGqBuArojzYfyXk35l1l2dlYTqwgYDZyWp7/hXltAEEAmP6
         //9vqiQVCsJgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3917DE450B7;
        Fri,  2 Dec 2022 11:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 1/2] net: thunderbolt: Switch from __maybe_unused
 to pm_sleep_ptr() etc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166998001723.12503.5723895618150427571.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 11:20:17 +0000
References: <20221130123613.20829-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20221130123613.20829-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michael.jamet@intel.com, mika.westerberg@linux.intel.com,
        YehezkelShB@gmail.com, davem@davemloft.net, edumazet@google.com,
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 30 Nov 2022 14:36:12 +0200 you wrote:
> Letting the compiler remove these functions when the kernel is built
> without CONFIG_PM_SLEEP support is simpler and less heavier for builds
> than the use of __maybe_unused attributes.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: thunderbolt: Switch from __maybe_unused to pm_sleep_ptr() etc
    https://git.kernel.org/netdev/net-next/c/0bbe50f3e85a
  - [net-next,v3,2/2] net: thunderbolt: Use bitwise types in the struct thunderbolt_ip_frame_header
    https://git.kernel.org/netdev/net-next/c/a479f9264bdd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


