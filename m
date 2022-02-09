Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45D44AF311
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiBINkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbiBINkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:40:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB200C0612BE;
        Wed,  9 Feb 2022 05:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6188FB821AB;
        Wed,  9 Feb 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F20A0C340F0;
        Wed,  9 Feb 2022 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644414010;
        bh=HWEAu+STtdRsqLfSf1qNlMrv6jFrO1gMU5XBn5i6RLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BqSgcWOahL5we71RfYJADvXO0jnL6vdCKetpXzrv2GJQZvJdq3nrG3TABO8Dg2lLP
         0ZfsVhh+g8ir3mY443Tr/wZ0EPhumQcQoNQ+eSWrYy6w9Dm63M/v3g/0iGNiqxMV21
         oLB/zIu2rFYTGmuLeVmuZdIz8JFkWEsHeYiKpazQpGlGUAkzgCKNKZFU36W2fJXs9y
         L81InoH2fygLyCmUKsY60QYJ1Iy1ZqJliDC/baNH4iltg5pGbo8plW8arc6J6nSlQW
         //a9nkS7HNW5rVkigjWSHsKiuD4ilDa3V0t2EHc51qxiZd3hxOlUJfVWT5aPmPK+Hq
         WlVVktos7O0rA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD6C4E5D07D;
        Wed,  9 Feb 2022 13:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ax25: fix UAF bugs of net_device caused by rebinding
 operation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441400990.27404.8523744997637933787.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 13:40:09 +0000
References: <20220209125345.86638-1-duoming@zju.edu.cn>
In-Reply-To: <20220209125345.86638-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, dan.carpenter@oracle.com,
        jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 20:53:45 +0800 you wrote:
> The ax25_kill_by_device() will set s->ax25_dev = NULL and
> call ax25_disconnect() to change states of ax25_cb and
> sock, if we call ax25_bind() before ax25_kill_by_device().
> 
> However, if we call ax25_bind() again between the window of
> ax25_kill_by_device() and ax25_dev_device_down(), the values
> and states changed by ax25_kill_by_device() will be reassigned.
> 
> [...]

Here is the summary with links:
  - ax25: fix UAF bugs of net_device caused by rebinding operation
    https://git.kernel.org/netdev/net/c/feef318c855a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


