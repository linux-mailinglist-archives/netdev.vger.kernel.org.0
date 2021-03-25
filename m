Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCC348668
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbhCYB0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhCYBZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:25:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7400661A16;
        Thu, 25 Mar 2021 01:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616635557;
        bh=ditk0YZ9Nz9fLnjmSXlaeIWjilCXf8k1m49gq4EQY3c=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=hdP3OybmDdZqN0BpyLGOGTfyFj/YztY0LRgi3kNooHSuBL+KB01WuERbOnwtHacJd
         TjjvIJEryA8iOVGBr1FdjtegSb8s5xrWhY0SV+a+b3EvkxTy1NXVsTSw1kbqbQSiLd
         Klt+xYmQ7dm10Sq/UPzvGx9K9gpXRofhg5DPO4waDGHfTA9CibsKmLXqBXKUuFKsx7
         np10wNfHJ/Nf7+hndnM7ogt+wrYq6pHSb+/KEH0thsRmaIa+tefp8vPKURMwLbjrDV
         4z1ynmhm++j9wJc8Yh2Ves4yLsDECMh4Y9w5wd9TM/u91P+yTWmnJ11qEDzJP8mkVN
         66TqnpgEYTwbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F0AF60A3E;
        Thu, 25 Mar 2021 01:25:57 +0000 (UTC)
Subject: Re: [GIT] Networking
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210324.174744.896576515419596772.davem@davemloft.net>
References: <20210324.174744.896576515419596772.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210324.174744.896576515419596772.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master
X-PR-Tracked-Commit-Id: e43accba9b071dcd106b5e7643b1b106a158cbb1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e138138003eb3b3d06cc91cf2e8c5dec77e2a31e
Message-Id: <161663555733.31000.5501620001466622462.pr-tracker-bot@kernel.org>
Date:   Thu, 25 Mar 2021 01:25:57 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 24 Mar 2021 17:47:44 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e138138003eb3b3d06cc91cf2e8c5dec77e2a31e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
