Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19826495F9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfFQXfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728817AbfFQXfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:35:06 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560814505;
        bh=3ihbqGCs7+aS+s5AQNG7ishmcO7blXDpEySSy8BsQSE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=eCBlVxOsYFQL0ZG1VdwpzmVF0wmM4jKuqD9eJdga0a+jGPSDuibD8RvLTwAKKsLwA
         BH3Xx9VpHT4e7ELzfXXmeNsiNIDAw/7MFOsNvfh8FAgbqca3M36t/hymwpeW0BlAKH
         GqUYWqar3fsuQi7see1AvvYoxqtbtTrZPlBoJblM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190617.111738.2016163932115402710.davem@davemloft.net>
References: <20190617.111738.2016163932115402710.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190617.111738.2016163932115402710.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git refs/heads/master
X-PR-Tracked-Commit-Id: 4fddbf8a99ee5a65bdd31b3ebbf5a84b9395d496
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: da0f382029868806e88c046eb2560fdee7a9457c
Message-Id: <156081450584.13377.14001316439156235841.pr-tracker-bot@kernel.org>
Date:   Mon, 17 Jun 2019 23:35:05 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 17 Jun 2019 11:17:38 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/da0f382029868806e88c046eb2560fdee7a9457c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
