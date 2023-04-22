Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560006EB712
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjDVDaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjDVDaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E741BD4;
        Fri, 21 Apr 2023 20:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A66C63F42;
        Sat, 22 Apr 2023 03:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B40A0C433EF;
        Sat, 22 Apr 2023 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682134218;
        bh=qXQkVg3s1Pgn6+y0rxUr3E2JnkSisA+o9MAANIf7Cqo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TtBo2xsuARA7nxwLfkkWPU0HkPVRaaRGqwjbzqZYQY+mYLPWu8ROPqQ5JCkshbGs9
         7vvHxWSsz5D0zps1ul8BbNAG7o4ilqCpH5t6AVLWUBB5cf2w6+YkruHOqI26omRvO/
         wfFuxvTOzcQVUPnxOJToykk5kQUZ/UHVI/++gMwOFhwH+khco2Fi14cpmO8tj9oGo2
         +Ea0jEs92NLfh1dopBMgUvXIbsmgvADO8XgBBMnczghrRQmbLDsiOje7bDalXbWXB1
         8oZxw+9UZfFf+I5+CLCKRh06+wWFZUcSVHQUQSV3u1gafTJsJV/8K1bgt6d/Wk3srN
         2DLz70VSiR4Uw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98573E270DA;
        Sat, 22 Apr 2023 03:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/handshake: Fix section mismatch in handshake_exit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213421862.22496.15254337472403818932.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:30:18 +0000
References: <20230420173723.3773434-1-geert@linux-m68k.org>
In-Reply-To: <20230420173723.3773434-1-geert@linux-m68k.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     chuck.lever@oracle.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Apr 2023 19:37:23 +0200 you wrote:
> If CONFIG_NET_NS=n (e.g. m68k/defconfig):
> 
>     WARNING: modpost: vmlinux.o: section mismatch in reference: handshake_exit (section: .exit.text) -> handshake_genl_net_ops (section: .init.data)
>     ERROR: modpost: Section mismatches detected.
> 
> Fix this by dropping the __net_initdata tag from handshake_genl_net_ops.
> 
> [...]

Here is the summary with links:
  - net/handshake: Fix section mismatch in handshake_exit
    https://git.kernel.org/netdev/net-next/c/6aa445e39693

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


