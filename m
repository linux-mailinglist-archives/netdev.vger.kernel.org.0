Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8113772E2
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 18:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhEHQKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 12:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhEHQKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 12:10:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C05B3611BD;
        Sat,  8 May 2021 16:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620490187;
        bh=iebm6uA8PQV7WkeDMZxLl/j6IyUUC0ngp8SVR1pGz60=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=d7/EnYDOYt3YEebyDTeVfVD5t+UeGMdmDXMr0ydkbJQwelRIVVvUN7OmOTU3YJi4k
         2TxCG/MbOiZn+zjXz5P960F8c+Gu011iVwvwf++pY8k0l1WDqKdR6PocO9VCvjmhZh
         jz33kjSYNweIMNWI8Mmgp3MvfcyUWYf3vl3rQ6cxf2Wv73cRu6SYghPfCaxt91aC+G
         ACl8L6BiXv447OyzlPSq1jA0Lq02lSpiqXm8/Cx68bMsSb6l69N4QghUFvwIMHbP45
         xbY6ln/fEaASwdYktbVkFfAtDGLrxZkSnub70thIuKElUEed7YZKfqG+9BLGY3ueAI
         4xjZg1fw94+rA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A967D60A02;
        Sat,  8 May 2021 16:09:47 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.13-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210508005952.3236141-1-kuba@kernel.org>
References: <20210508005952.3236141-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210508005952.3236141-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc1
X-PR-Tracked-Commit-Id: 55bc1af3d9115d669570aa633e5428d6e2302e8f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fc858a5231089b972076642a86cf62481d95d82e
Message-Id: <162049018763.24889.6610704138877432590.pr-tracker-bot@kernel.org>
Date:   Sat, 08 May 2021 16:09:47 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri,  7 May 2021 17:59:52 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fc858a5231089b972076642a86cf62481d95d82e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
