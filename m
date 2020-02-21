Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D885168907
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgBUVKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:10:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgBUVKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:10:17 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582319416;
        bh=tcqUTbXERzLhJ6IJiuGbUnJpSAGeR78e7ZABn9/QIyc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=XKc46LBq854BGlqaXgrJpdDVQGd4eSwJd8WbJJL+Dav/dE/GtBCoIa64RxhGH9Kh4
         1WVgN6v5RnYhsCsVEOV/CSQOTqofdkkR23KFmnnSBojet2FS6w2Px0KlYe1Yq0Ax/+
         795am2E/uLJYxSVtEqwteyfFtzYpxpfIN+RFGV7w=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200220.165005.109882010805629679.davem@davemloft.net>
References: <20200220.165005.109882010805629679.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200220.165005.109882010805629679.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 36a44bcdd8df092d76c11bc213e81c5817d4e302
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3dc55dba67231fc22352483f5ca737df96cdc1e6
Message-Id: <158231941648.18249.3932995613583047299.pr-tracker-bot@kernel.org>
Date:   Fri, 21 Feb 2020 21:10:16 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 20 Feb 2020 16:50:05 -0800 (PST):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3dc55dba67231fc22352483f5ca737df96cdc1e6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
