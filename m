Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E1543711A
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 07:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhJVFMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 01:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhJVFMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 01:12:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C3A760EB2;
        Fri, 22 Oct 2021 05:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634879414;
        bh=JQldVLyGpH4Tadtb8BNRBQoBnsS4Ywo9OIhbi9nbjXU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=gzGPuyCScxij9HC9w9jSuUUgN+TMflDWjaLZP8GVvzRemhlXf2YXBMup/q78aVD5B
         T4B8eyFF1vJoiVnmSEjkFTxdFFX8VqSOKWEVqccD7nhFklkEinSTsBbZoQNK1IF313
         nnIO52EG+Y5gW/H26tasty1bZKL0ux5ET3desy0YyUwKXcaQwBJbHtZjTf5K9kNlzE
         8E5sGHgMHlYjfYzzgQ4/1g4bP9Lxad/MGaQblxLvgMQ8J1/DvAf/5x9K0cByobxwgB
         pgTR0IqeLDRBZFPYWhqov45X3MKdZE5ACW/mwb7RbPLBUz8UiV704+E2lh+Mbm42bj
         rbsY0HAlqcUSg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 255C4609E7;
        Fri, 22 Oct 2021 05:10:14 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.15-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211021153226.788611-1-kuba@kernel.org>
References: <20211021153226.788611-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211021153226.788611-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc7
X-PR-Tracked-Commit-Id: 397430b50a363d8b7bdda00522123f82df6adc5e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6c2c712767ee1d74b2234c9caaf1920808333be6
Message-Id: <163487941414.3037.6249642694421136573.pr-tracker-bot@kernel.org>
Date:   Fri, 22 Oct 2021 05:10:14 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 21 Oct 2021 08:32:26 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6c2c712767ee1d74b2234c9caaf1920808333be6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
