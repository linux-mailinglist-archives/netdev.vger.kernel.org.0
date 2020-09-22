Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D815A274BED
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgIVWPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 18:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIVWPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 18:15:25 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600812924;
        bh=FTbJVlukzgMDNF2QDjUwCsMpHzvC24Buc34PGrZri+o=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Upi8wJtuVt9F3y9e3vScTkoRu4RczgoorHrvcRSMNJBe1DT1j9154Uv67cDSnR3AL
         VEq4dGZuAPuBj83QIixIeJVx2J64loRmgkUdhVK0OhogPA2BaGO7o6MxtpveYi9/E4
         dZl4WMQbu6fy80kBu1KwLy9v2zKdM/exHzFyTeFw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200921184443.72952cb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200921184443.72952cb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200921184443.72952cb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master
X-PR-Tracked-Commit-Id: b334ec66d4554a0af0471b1f21c477575c8c175d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3017135c43373b06eef1eb70dfeb948b8ae159f
Message-Id: <160081292472.1950.9308616669578773827.pr-tracker-bot@kernel.org>
Date:   Tue, 22 Sep 2020 22:15:24 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 21 Sep 2020 18:44:43 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3017135c43373b06eef1eb70dfeb948b8ae159f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
