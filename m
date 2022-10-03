Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C010C5F2FF6
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 14:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJCMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiJCMAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 08:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0993335C;
        Mon,  3 Oct 2022 05:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D91A61044;
        Mon,  3 Oct 2022 12:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B770FC43141;
        Mon,  3 Oct 2022 12:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664798418;
        bh=4O2AznV2kuZSvOv3K/wFZpnIW2xPfjNQdnlEy132sv8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bto9nkjBVhGNw/24Kf4KSVJ0DR9xc0HWtDidb/AHO0mONk/XrlVDKQdFy47SUaM/0
         qtuxB2jQMzCx6viVwwtctJwOrzEEx6SK3tXMOz/xyyn5b31pXGzvb0RlEnyL/HZEj8
         d5XPHkZ2dyOCcKQ+y8ML6sXkXfMemG1JoVq6LQTYd4PeQWMUvdIzXyv2qtNyAcSafW
         /2n/w5cNt5eDleXangpNisGRsxrGuPvw1CJ/GEwKG3fI9pXnJ60TW2uSQb5/4AFM6o
         jvb3c3vWjmoV47h28yu49TZQnOCbQYIpGh6m5QpLMyv+HHhs3gkVLlqb2QDE8n5396
         vpvE53BM1jx2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92E5EE4D013;
        Mon,  3 Oct 2022 12:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: lan966x: Add police and mirror using
 tc-matchall
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479841859.31360.550157837191959952.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 12:00:18 +0000
References: <20220930083540.347686-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220930083540.347686-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk
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

On Fri, 30 Sep 2022 10:35:38 +0200 you wrote:
> Add tc-matchall classifier offload support both for ingress and egress.
> For this add support for the port police and port mirroring action support.
> Port police can happen only on ingress while port mirroring is supported
> both on ingress and egress
> 
> Horatiu Vultur (2):
>   net: lan966x: Add port police support using tc-matchall
>   net: lan966x: Add port mirroring support using tc-matchall
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: lan966x: Add port police support using tc-matchall
    https://git.kernel.org/netdev/net-next/c/5390334b59a3
  - [net-next,2/2] net: lan966x: Add port mirroring support using tc-matchall
    https://git.kernel.org/netdev/net-next/c/b69e95397c3c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


