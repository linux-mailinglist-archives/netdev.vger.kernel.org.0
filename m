Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CED22DA37
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 00:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGYWaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 18:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgGYWaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 18:30:04 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595716204;
        bh=hrgUAaVY0nZ2DscyzB9qMMHobXhohMJTC365wzL9Cqw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=efGe2/VjS8IBNGG/8jRPtPPerM5PDnmc+YzGfNHm8OYi/aEBBDtmXuyGOCPHe0oaR
         eaghZePwwOnWSnajwmjYlhLjVxzwTinu1NY+Eiw81w8IfQeFJeLTMnsrpqyXoM9WqZ
         i3p/x05rBBnp6H6kfwk4bBfOXIbLr/e2VXykMlqY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200724.221204.1658413840252419526.davem@davemloft.net>
References: <20200724.221204.1658413840252419526.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200724.221204.1658413840252419526.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
 refs/heads/master
X-PR-Tracked-Commit-Id: 8754e1379e7089516a449821f88e1fe1ebbae5e1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1b64b2e2444c11b8dd2b657f8538c05cb699ed25
Message-Id: <159571620398.7388.18215185389779078820.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Jul 2020 22:30:03 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 24 Jul 2020 22:12:04 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1b64b2e2444c11b8dd2b657f8538c05cb699ed25

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
