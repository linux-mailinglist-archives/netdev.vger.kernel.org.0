Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2C83D2B97
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhGVRTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 13:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:32916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229906AbhGVRTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 13:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 99D6961380;
        Thu, 22 Jul 2021 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626976827;
        bh=Q1VqzHpSJ8tygysZ3SRO//ZxAxo1wdyk8kKF95CIhf4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jYFJJESkXzM1yNYYbdOJ95cXdFiJeMOIcSyZb3+7MqXBarDROQOhbumcpawnd6Dum
         gsEvMyxz9PgfsBwkN5ki3RPmOcc9AYrUAt4zBi1pqawJRlRp/WK4cOG+uy+3enlIg1
         HIQl8K30wzfYQ6SQAdij7rC9i8+WB5xp9s5ItqqvsJ8XGhnFL2QElEHB3fEyne9P3Y
         2zpkfKR/Tbq9sWYvsrH2bAfbYtbAZfAmjuC1R/xQ44qwUz61Fz0uCtMcCM5zmvugkK
         HrxEVSt2yitwR1dd2hibMGB7muXzTGNQJGAfWLTi6tpur4GOFSL+Jxoousnrq/Vgr0
         VIDTXY0E+MhxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 888B3600AB;
        Thu, 22 Jul 2021 18:00:27 +0000 (UTC)
Subject: Re: [GIT] Networking
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210722.061139.1666314878301149027.davem@davemloft.net>
References: <20210722.061139.1666314878301149027.davem@davemloft.net>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210722.061139.1666314878301149027.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master
X-PR-Tracked-Commit-Id: 7aaa0f311e2df2704fa8ddb8ed681a3b5841d0bf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4784dc99c73c22cd4a24f3b8793728620b457485
Message-Id: <162697682750.6012.8374445031240977744.pr-tracker-bot@kernel.org>
Date:   Thu, 22 Jul 2021 18:00:27 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 22 Jul 2021 06:11:39 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4784dc99c73c22cd4a24f3b8793728620b457485

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
