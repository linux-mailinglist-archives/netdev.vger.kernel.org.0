Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EBEDDBC0
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 02:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfJTAfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 20:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfJTAfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 20:35:05 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571531704;
        bh=GI2CFO2+wdI/LWJsE+LLwcuFDoNsxrHW9n8uxnHxhx0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=g1S3fiE/szOMpTyJyQ6z78J2/zh/jzGxWfHbeBG8w6JDRBsF9qo7LLacgdP/RrNjY
         PFYX6aQmoAe4bcZMGzQZVbseZj2THrMKfxqv+BgApMalQYxs+tSXp5pQUoSDWc2DwR
         NIvo5p9BFjtspM+ERP+/JYl5CBqqYZl4e/62iUh4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191019.123927.593477780203351647.davem@davemloft.net>
References: <20191019.123927.593477780203351647.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191019.123927.593477780203351647.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 2a06b8982f8f2f40d03a3daf634676386bd84dbc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 531e93d11470aa2e14e6a3febef50d9bc7bab7a1
Message-Id: <157153170487.14932.5887104462724670524.pr-tracker-bot@kernel.org>
Date:   Sun, 20 Oct 2019 00:35:04 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 19 Oct 2019 12:39:27 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/531e93d11470aa2e14e6a3febef50d9bc7bab7a1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
