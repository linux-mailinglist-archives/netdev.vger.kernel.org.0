Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7298948F47E
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiAOCkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiAOCkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:40:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C5DC061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 18:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AE2AB82A58
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 02:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F3EBC36AE7;
        Sat, 15 Jan 2022 02:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642214409;
        bh=AuJJQtN971lbFrJQOITTYIoj905z5D2SZuk7KTD9o54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dWAUVE5Bl/OIQ1yFZd2Uk40LFChdHfT7CoJTRBX0x0fXikKXiLcQAESf8WSnBpBQG
         +IPEtuJu/w5akyHyXz+Y/nsaH71qedR4zT3lrbARKtBLfO5MuHWWeZZ16GfLwEe4wj
         KC0zt4zyxUdqk2l7NuVlcfeii+00YdPq+9WSTpsE4Ak6dMF6hdUM7hqH6Y3Vp05nJW
         EnDSWouTPWGXMIAxM8O7YuxjusYVQGRU/ZHy0oaZln4t0+cQwI/j3ydZ0nUy0WUJJd
         CXpsDqf5B3S2yBjPFxY5anCFWB4O8hL0KOIikhrtqxsmn1DkYnSqRlyjrCH8I8KEw4
         9opWCfwmlnmOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33177F6079B;
        Sat, 15 Jan 2022 02:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_unix: annote lockless accesses to unix_tot_inflight &
 gc_in_progress
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164221440920.12051.12748366195299266822.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Jan 2022 02:40:09 +0000
References: <20220114164328.2038499-1-eric.dumazet@gmail.com>
In-Reply-To: <20220114164328.2038499-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 14 Jan 2022 08:43:28 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> wait_for_unix_gc() reads unix_tot_inflight & gc_in_progress
> without synchronization.
> 
> Adds READ_ONCE()/WRITE_ONCE() and their associated comments
> to better document the intent.
> 
> [...]

Here is the summary with links:
  - [net] af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
    https://git.kernel.org/netdev/net/c/9d6d7f1cb67c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


