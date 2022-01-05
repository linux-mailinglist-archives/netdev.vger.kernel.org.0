Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CC44857D4
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242656AbiAESAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242651AbiAESAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:00:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C388C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:00:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB73FB81CE9
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 18:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8ED8BC36AE9;
        Wed,  5 Jan 2022 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641405640;
        bh=vwqnVmw77Lw9sGB+IzHtHVSy9bqUFmK3hKCr2RGywo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z70FSvUKgJfxTUYAHcvprlsJ6p2Yr9VzMMeANbUJSKeUjTvgfRz/yIQJDkR2L+pWB
         Ov755O0HPCEpA1XV838Ko4hJoWBg+Su/ypD4lIZDiW6bj2nMGEkzYDJvO7tOMbjElV
         3TPWKQxdmcWvTfQRlIRQXKFGw/Pa1ujyboF7bxwKLCqL0FPuxaSV1rNv5v0VEIRP/X
         GMw6YIKa5TbcNU7hLmDnK6GDi3iHYbM+u8U6eqLHNhk/+jY+tSU0uLTpaMH4JQzavD
         dTbqaouNtPKxHv2ODJMeaGBND5Z7ul1lxzqwrito2KsnAftyRA8TKKPXat42xXzfOT
         rQjGLsOs+m5Dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7343CF7940C;
        Wed,  5 Jan 2022 18:00:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: add missing tracker information in
 qdisc_create()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164140564046.4565.17327222843959190377.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 18:00:40 +0000
References: <20220104170439.3790052-1-eric.dumazet@gmail.com>
In-Reply-To: <20220104170439.3790052-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Jan 2022 09:04:39 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> qdisc_create() error path needs to use dev_put_track()
> because qdisc_alloc() allocated the tracker.
> 
> Fixes: 606509f27f67 ("net/sched: add net device refcount tracker to struct Qdisc")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: add missing tracker information in qdisc_create()
    https://git.kernel.org/netdev/net-next/c/88248c357c2a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


