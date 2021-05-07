Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C28376A7D
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhEGTIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 15:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhEGTIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 15:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 66DE46128B;
        Fri,  7 May 2021 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620414461;
        bh=+yNJeqTSMLW1B9FHkjFBmUcQC2ERctPY73JKrLUpXP0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KYFeRvJK2vnVUqCxJzv6f9vWRIiv+9J1QqXPhSmLN5/lpQ9Yh36J63bux/1eR3yD8
         nwKwSkYTKJCB1c9ejlKWjnKfQmw9pgkKfVQNtdlIZm0qcVedsCs7w1KvLtZyJZw//B
         izI+iUc7MNKNoeHJlYXhovxfvwFxJbqPR4MYiOjIK9QLYbgBCpzJfHBckfOlbaTVvE
         sOGaHnHQr8WJCtii8tITJmCxI8S2Uiu/GEPCY6367uw6xP88hkEcPU8rvvd+3HftkI
         UI40b+dge61ksnAZIiHBR9bVVAbsoAzMNd/mCkMSHlT1B8zkhHJkbycF1Ckf2eKGzi
         6KfT9La5CmkFw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 60F7460A0C;
        Fri,  7 May 2021 19:07:41 +0000 (UTC)
Subject: Re: [GIT PULL] 9p update for 5.13-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YJUnYXZBd1hpwW6G@codewreck.org>
References: <YJUnYXZBd1hpwW6G@codewreck.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <YJUnYXZBd1hpwW6G@codewreck.org>
X-PR-Tracked-Remote: https://github.com/martinetd/linux tags/9p-for-5.13-rc1
X-PR-Tracked-Commit-Id: f8b139e2f24112f4e21f1eb02c7fc7600fea4b8d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e22e9832798df81393d09d40fa34b01aea53cf39
Message-Id: <162041446139.12532.7193999623381072586.pr-tracker-bot@kernel.org>
Date:   Fri, 07 May 2021 19:07:41 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 7 May 2021 20:41:21 +0900:

> https://github.com/martinetd/linux tags/9p-for-5.13-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e22e9832798df81393d09d40fa34b01aea53cf39

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
