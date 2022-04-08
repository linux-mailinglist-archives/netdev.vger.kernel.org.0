Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C094F8DFC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbiDHECR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiDHECQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:02:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C7A123BCC;
        Thu,  7 Apr 2022 21:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F91F61DBA;
        Fri,  8 Apr 2022 04:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5552C385A3;
        Fri,  8 Apr 2022 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649390413;
        bh=KJNXYjvf3CiJ9ls2gGMwgcLXJtPJh9niUiSOoSo4g2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lErLra0IOGPIlqdJJpU8CyC10HVysNYVq120JUlF3B2gytEcXrbJxVMm3noqkUF2M
         75s2hfCHB22/ZSCCz/HGPfEZz1K7sAxnWISABatnPuMgvR8TFbvJ6zWN70ii0M+Nsx
         e9sIPZV4vqFUjdZlki65XLgkyOL1hLvaQAYT14TWvdHmvm1jCKFYsoz0n9uGK9C0YO
         XUecp+N+6dbnbKHJPbGpf+Z44kqNAzqT/NuGvXPipRpJ2GUcqPCJC/MK1UMEas3bni
         WC+Hm4m4FNFoC6LbFnOjKdmHlmV4wsuR6NdnY52RpymNEvW+v4XTS0T5wPuhE+XqiU
         k9Ts5xIlgvD/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D2CEE85BCB;
        Fri,  8 Apr 2022 04:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net-core: rx_otherhost_dropped to core_stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164939041350.25172.4449990089641663933.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 04:00:13 +0000
References: <20220406172600.1141083-1-jeffreyjilinux@gmail.com>
In-Reply-To: <20220406172600.1141083-1-jeffreyjilinux@gmail.com>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     brianvv@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, bigeasy@linutronix.de, toke@redhat.com,
        imagedong@tencent.com, petrm@nvidia.com, memxor@gmail.com,
        arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffreyji@google.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  6 Apr 2022 17:26:00 +0000 you wrote:
> From: Jeffrey Ji <jeffreyji@google.com>
> 
> Increment rx_otherhost_dropped counter when packet dropped due to
> mismatched dest MAC addr.
> 
> An example when this drop can occur is when manually crafting raw
> packets that will be consumed by a user space application via a tap
> device. For testing purposes local traffic was generated using trafgen
> for the client and netcat to start a server
> 
> [...]

Here is the summary with links:
  - [net-next] net-core: rx_otherhost_dropped to core_stats
    https://git.kernel.org/netdev/net-next/c/794c24e9921f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


