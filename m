Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA0915F8D8
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 22:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389855AbgBNVka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 16:40:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389355AbgBNVka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 16:40:30 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581716429;
        bh=JcHQEAivJjVB7nOyC+fgi899tgsxC/Od5LG9YHWlQFQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Zq78vLKePfslRNDSt6lfRpLyvj4HtzXESIEpbVGIgrhMbt9BJElLiyKFtw8cpksOj
         8aoPQj+5ReaoaQwe9Ml5SuLPmDB9sxsZVtFip7mtVC+V/iz9p9jk1oCBs9Kdy3IUw+
         7C9zpJVx6YSLyMT5AGWKUv4Zd+uBi7tEU1xeXAeI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200214.075409.535471157405842746.davem@davemloft.net>
References: <20200214.075409.535471157405842746.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200214.075409.535471157405842746.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: a1fa83bdab784fa0ff2e92870011c0dcdbd2f680
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2019fc96af228b412bdb2e8e0ad4b1fc12046a51
Message-Id: <158171642970.8400.17015637792175992858.pr-tracker-bot@kernel.org>
Date:   Fri, 14 Feb 2020 21:40:29 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 14 Feb 2020 07:54:09 -0800 (PST):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2019fc96af228b412bdb2e8e0ad4b1fc12046a51

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
