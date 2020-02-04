Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE53151B6D
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 14:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgBDNkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 08:40:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727190AbgBDNkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 08:40:15 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580823614;
        bh=eINyf+5B6qjpdApA+n8ka6WgwixmB1VJ12RxVeeYjtc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=yyBx+7KB2Lw2TrTmPOU0B0Yr0tyPpsbUNv/EldkzTuwPweMYb2O9sHJZUAXGkW5OX
         TXnG4Jx9G1Zoq/eOxWOVtSBWuh9kzP9OWe78QgEIYSWOC3ALx+13XPjgE0LX5zCUg/
         38ZzRmfYY4//L2rpYlEevlrF5kyEOHlX3Q8GK5V8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200204.132503.783799057091958363.davem@davemloft.net>
References: <20200204.132503.783799057091958363.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200204.132503.783799057091958363.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: bd5cd35b782abf5437fbd01dfaee12437d20e832
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 33b40134e5cfbbccad7f3040d1919889537a3df7
Message-Id: <158082361438.32178.6990435504902073112.pr-tracker-bot@kernel.org>
Date:   Tue, 04 Feb 2020 13:40:14 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 04 Feb 2020 13:25:03 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/33b40134e5cfbbccad7f3040d1919889537a3df7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
