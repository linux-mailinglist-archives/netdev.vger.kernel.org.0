Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E747D29778A
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 21:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754378AbgJWTMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 15:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754356AbgJWTMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 15:12:20 -0400
Subject: Re: [GIT PULL] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603480340;
        bh=OuwvrtQbKbjsaSImTqw4Ec2RG/I3Cvm6fRNnPtiO5IQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=v5dEFjmXVeL7rdOns/9pIKaYIpSMQ4ZpJM1Vg5v77CJsaz8yeu7LP4OKKNA2ITEJy
         NhxUyaZeNnzDcghZByVKr3fDZvHiICkCC1bDhzVTGKpMEIHP/vq63R5oU2JzX2mOi8
         nAWezzTW3jLFXjyMRByivvC8e90mAavlm9blBdow=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201022144826.45665c12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201022144826.45665c12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201022144826.45665c12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc1
X-PR-Tracked-Commit-Id: 18ded910b589839e38a51623a179837ab4cc3789
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3cb12d27ff655e57e8efe3486dca2a22f4e30578
Message-Id: <160348034019.14430.12109690390215452300.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Oct 2020 19:12:20 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 22 Oct 2020 14:48:26 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3cb12d27ff655e57e8efe3486dca2a22f4e30578

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
