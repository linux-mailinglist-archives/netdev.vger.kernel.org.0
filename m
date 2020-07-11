Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F6421C206
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 06:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgGKEPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 00:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgGKEPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 00:15:03 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594440903;
        bh=xsvZZhUiDO4BSdrPaNrfOOTdrynDJsAfhoST29CYk3k=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=IqjWXLFPsutU4pU19J4IphNUfxgPxyxDimK3Pk6dosQ/qbh4FW8yY17FBpKJddcC7
         qo9U0loO9OpTPXGYelgZkH1NzwnQ+5VLzhhz1Ih05GyqaQvZXCaSINmbIOR8ALci2h
         Seu0/FLrVpwDkt/mlyTczuAqghNda3LYARBf5LJI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200710.165815.1749029533411123245.davem@davemloft.net>
References: <20200710.165815.1749029533411123245.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200710.165815.1749029533411123245.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 1195c7cebb95081d809f81a27b21829573cbd4a8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5a764898afec0bc097003e8c3e727792289f76d6
Message-Id: <159444090319.5420.4883542853034701813.pr-tracker-bot@kernel.org>
Date:   Sat, 11 Jul 2020 04:15:03 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 10 Jul 2020 16:58:15 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5a764898afec0bc097003e8c3e727792289f76d6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
