Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61883DC170
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 01:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhG3XK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 19:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhG3XKX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 19:10:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 595D860F3A;
        Fri, 30 Jul 2021 23:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627686618;
        bh=w9NvLT/heYN9xj4Ig1BaKv52ZiK0MFDCpg3ReVUUmp4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=iKYlKWRg6Cii9P2skSLuCxyut1MOHM6Pz2d1rVlLlPEry3FjtfnXNR9rFf4WwZj2J
         Hc2k6/ehpnfnd8a0s0PhXUB8N4DivlxOlltb59TzNUz66TS8dtLG31zb3ViXJuflfX
         9ASOgaDKhdwqnAd743lng7wb1/Q22Dg5hoJR97vFVVcy9f35zlXaIK99bGkrMPJPWq
         pJIW2LAoUBWIUEYndj3yZapr40n3xFh3cicCBJ5WDpCuC/R/rI6n3wtPMJveTSibCk
         i3higMiIsIiCpZVPAaDenFJEJX5cSCKjq8cXCfIfZaT6an+wmqUFjbcMmPYpdTqU8k
         sghmH6zqCLIZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47A2260A7F;
        Fri, 30 Jul 2021 23:10:18 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.14-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210730202302.2197672-1-kuba@kernel.org>
References: <20210730202302.2197672-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210730202302.2197672-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc4
X-PR-Tracked-Commit-Id: 8d67041228acf41addabdee5a60073e1b729e308
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c7d102232649226a69dddd58a4942cf13cff4f7c
Message-Id: <162768661823.18102.3433634530260932718.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Jul 2021 23:10:18 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 30 Jul 2021 13:23:02 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c7d102232649226a69dddd58a4942cf13cff4f7c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
