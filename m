Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752A74BB7D4
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbiBRLKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:10:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234486AbiBRLKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:10:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49C92B463D;
        Fri, 18 Feb 2022 03:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC7261E92;
        Fri, 18 Feb 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99F37C340F5;
        Fri, 18 Feb 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645182610;
        bh=8trFcDUhtlUpctFyScTR5rgwUsyTvacl3QaCl6MCWCY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pfxk2uR9VspOg+2/Rcsh4LYmQwXOdpJiwcfhUcFLxeFK9LByqXRFe/p5bvtMAwAKA
         GLUBSC95k/bLu0PrN6dNK88YrSZIZ2QkvJvTk/GpVYNNh4rbIN2zXnTbVPYUhVJzzQ
         /0S1CtsF/qudSvF8Zabglt+A4UT2Oq+M31bK9fSuW9pPG8FgDeDJW0VjTVd2Rvi2VO
         qfHmKhIG1PtyPkuAata42dgZkEJENIp2fZ/65ABrir7wcWRJH7feKJjHFXsCSlbWAP
         +De/Bu4YVbNqps5h5sR2wBG3lRWVreLHX8YpNndmqk7jO6vEpfwzKbA09dib51irkb
         8ajbN8jLb6xzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F279E7BB07;
        Fri, 18 Feb 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net-sysfs: add check for netdevice being present to
 speed_show
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518261051.25032.3217186042817184528.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:10:10 +0000
References: <20220217015518.62719-1-sureshks@redhat.com>
In-Reply-To: <20220217015518.62719-1-sureshks@redhat.com>
To:     Suresh Kumar <surkumar@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, suresh2514@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Feb 2022 07:25:18 +0530 you wrote:
> From: suresh kumar <suresh2514@gmail.com>
> 
> When bringing down the netdevice or system shutdown, a panic can be
> triggered while accessing the sysfs path because the device is already
> removed.
> 
>     [  755.549084] mlx5_core 0000:12:00.1: Shutdown was called
>     [  756.404455] mlx5_core 0000:12:00.0: Shutdown was called
>     ...
>     [  757.937260] BUG: unable to handle kernel NULL pointer dereference at           (null)
>     [  758.031397] IP: [<ffffffff8ee11acb>] dma_pool_alloc+0x1ab/0x280
> 
> [...]

Here is the summary with links:
  - net-sysfs: add check for netdevice being present to speed_show
    https://git.kernel.org/netdev/net/c/4224cfd7fb65

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


