Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509C4475125
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 04:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbhLODAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 22:00:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32898 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbhLODAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 22:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5227FB81E24
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2EA8C3460B;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639537210;
        bh=xtu1Aa+9nA82BzYV3F+xLk8wH7Hqy2kgabn1i0kgOnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g/qhq/Y/A9447koHYcG1EmJ0QtHKCtfDlQ/GVO4bj6trTbI/X6CU9EnGe7uG8kdmg
         l3m1EZshniJeA90FwolOfisTuFUzCXZ9TjiWmIhpFupiTgVSxwKiuFs9qwxrtCQfaB
         rnmb/UPta0HSxsoZS/G290KJD0gZ2EEfaLWYumJ5xCDT7jdfUFiPanlgr4sjgVNbkb
         UIHrG1EF3JUJlITzPSU826Na1wzxEshbnGeNbFZ1rDwPyfIpwLjGYbGdBWiSkHOX79
         o6D9AH/+h9BQyLmEZg1mZXfSAaVHPmWbCrGCL5GOYrPevMXA0eSMVl5ypivE+XQu0w
         o7rEHcwJhHdKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C25C7609F7;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: linkwatch: be more careful about
 dev->linkwatch_dev_tracker
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163953721079.25069.11973686730721384379.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 03:00:10 +0000
References: <20211214051955.3569843-1-eric.dumazet@gmail.com>
In-Reply-To: <20211214051955.3569843-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Dec 2021 21:19:55 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Apparently a concurrent linkwatch_add_event() could
> run while we are in __linkwatch_run_queue().
> 
> We need to free dev->linkwatch_dev_tracker tracker
> under lweventlist_lock protection to avoid this race.
> 
> [...]

Here is the summary with links:
  - [net-next] net: linkwatch: be more careful about dev->linkwatch_dev_tracker
    https://git.kernel.org/netdev/net-next/c/123e495ecc25

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


