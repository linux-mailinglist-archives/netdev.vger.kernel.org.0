Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61CE4F9F5C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbiDHVwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiDHVwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:52:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0386F26AE2C
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 14:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB74DB82DA7
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 720F1C385AE;
        Fri,  8 Apr 2022 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649454613;
        bh=75RrDwli0nL4yB61Sz3uYag5cgQlIzsquuHNaT2YYpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DjjJ9JvXF9HJE+90Gpe9zjdErdd3eUGdrVyzdWzcZdFHP3c2lHnKZYlrVQxozRKv4
         vwzv1IARyIeyPIi/xbdWjLmLUIuT/Qndp/JsNTIvLeSZIGfdssXWbMV3mKULiG26dV
         0rZmmpG+XI40QjYjyokqu89XNZEtKBbGYKGBisyn0+6MVSpXmjbmbdbMtLw3HaOMGw
         VOYbOKgYp+Kms7Pnx7uCi70TLzNO9+8Toainx4JkoUMeZbQ/6ycVoEtKmGVX3/M+cT
         x9VxM7ZvRz5RYZkHgTetPRNbM8WTT7TtDdCF7JF98a4VrxskpUjuKCSiQSnrjVkExZ
         E3+9nliIjQ5fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5CA17E8DD5E;
        Fri,  8 Apr 2022 21:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: use hardware tx timestamps for more than PTP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164945461337.21125.4012626733423993560.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 21:50:13 +0000
References: <510652dc-54b4-0e11-657e-e37ee3ca26a9@gmail.com>
In-Reply-To: <510652dc-54b4-0e11-657e-e37ee3ca26a9@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
        ihuguet@redhat.com
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

On Thu, 7 Apr 2022 16:24:02 +0100 you wrote:
> From: Bert Kenward <bkenward@solarflare.com>
> 
> The 8000 series and newer NICs all get hardware timestamps from the MAC
>  and can provide timestamps on a normal TX queue, rather than via a slow
>  path through the MC. As such we can use this path for any packet where a
>  hardware timestamp is requested.
> This also enables support for PTP over transports other than IPv4+UDP.
> 
> [...]

Here is the summary with links:
  - [net-next] sfc: use hardware tx timestamps for more than PTP
    https://git.kernel.org/netdev/net-next/c/bd4a2697e5e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


