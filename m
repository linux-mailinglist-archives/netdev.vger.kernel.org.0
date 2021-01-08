Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0102EF957
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 21:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbhAHUgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 15:36:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729018AbhAHUgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 15:36:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5AAFD23A68;
        Fri,  8 Jan 2021 20:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610138165;
        bh=QUu7eXpAzhmyPvlJvP+4C2rEnP9jqJ2xjbF4o/0mHls=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cZ9DdXaNR3MpoGAIEbAnoAgU3qMtstWuCNziJHlwQXjJbz2S7tf0ZohPc+MsUV+Pb
         UXjdnf6kUcy7qtUbp2eAZIQAOSt1bV4JjhXzju2QMajVXfnwgqp5REtDdBt3Wx4NHL
         tWQLd60Zvbrep3UpEmdvCzFAgL1FmL5kzNYC2GK8NlWh/kfrk32xTzNzhvMh/duQE1
         YMXiyQatpjDSCYSCleFINtwzrxpsYIuukL4vhQTSZF9iQOJK6juD+SODGgXryHQojE
         SwIasBB5DGS/rjmYOFCzIAgbevl2F9L5G0cyzGek/CV/qi1g0SJvfopD3cRyhg/IpP
         2lG/oj2xxYN1Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 495D660597;
        Fri,  8 Jan 2021 20:36:05 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.11-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210108050059.1254762-1-kuba@kernel.org>
References: <20210108050059.1254762-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210108050059.1254762-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc3-2
X-PR-Tracked-Commit-Id: 220efcf9caf755bdf92892afd37484cb6859e0d2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6279d812eab67a6df6b22fa495201db6f2305924
Message-Id: <161013816523.21693.3675923904197834421.pr-tracker-bot@kernel.org>
Date:   Fri, 08 Jan 2021 20:36:05 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  7 Jan 2021 21:00:59 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc3-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6279d812eab67a6df6b22fa495201db6f2305924

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
