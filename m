Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A352148C678
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354305AbiALOuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239463AbiALOuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:50:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7C7C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D114B81F49
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F379C36AF3;
        Wed, 12 Jan 2022 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641999010;
        bh=Oc9scBbTndTCCSWFTnURa9QWFfAMHvgrcvB2y4ULkVY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M06phQkRWVHidklGWLSHghtVSvVTqsK11BCWnM8quDwDleEtsU7Ol/bFGYYKtI4xo
         BQfaWGpqX+vS3Byf6kQ7udzIZt5fdgTr6l3KDmMbW1yknBU0X60p8w4ceLpxQhMgIl
         ADoyNabQ9LEwf1sCTZMY81/2vWlEHVTq8qOrO5UQ0Yxb6WSdkz0ayDbuYiFeG6gnFS
         gsFNlvlNSRqjJsL+yk5bKIAXw9ND/ZolYlEAdcse8ER9HEcs2nvpkhocKA2bzv5/Z+
         c3UInUZmzWdCHc/FYKeDE68KlerEAgQPJUdtw7MghelNFX+EYoIcyL/vAB3hiuTiJu
         LTi2yziBjPEnQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 297C4F6079B;
        Wed, 12 Jan 2022 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: fix net device refcount tracking issue in
 error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164199901016.15011.7933698047417550074.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 14:50:10 +0000
References: <20220112125300.506685-1-eric.dumazet@gmail.com>
In-Reply-To: <20220112125300.506685-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Jan 2022 04:53:00 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> I left one dev_put() in br_add_if() error path and sure enough
> syzbot found its way.
> 
> As the tracker is allocated in new_nbp(), we must make sure
> to properly free it.
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: fix net device refcount tracking issue in error path
    https://git.kernel.org/netdev/net/c/fcfb894d5952

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


