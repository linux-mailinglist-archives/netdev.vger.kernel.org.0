Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB98A23DDEF
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbgHFRUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgHFRTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 13:19:45 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596734385;
        bh=MWTsTuM14LK//ribvpf+b3znnXVCM8wVoaOXrxSSE9o=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=0rIZaA56cXdR2p8cTW/SYKouSmGz6+ieQvmbRK7fCsVaxGPhJUZnYpuDCmMUBwlmq
         zIlQSO13lVSjFdWAopfhGX60F9RW1kpppmiBhADIsEUytVM+QeVzMSJ/h6LolZSecp
         nzdYGLIR/Dp7VZEgnkelM2w01TV9pf61pY+pMwJ8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200805.185559.1225246192723680518.davem@davemloft.net>
References: <20200805.185559.1225246192723680518.davem@davemloft.net>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200805.185559.1225246192723680518.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git refs/heads/master
X-PR-Tracked-Commit-Id: c1055b76ad00aed0e8b79417080f212d736246b6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 47ec5303d73ea344e84f46660fff693c57641386
Message-Id: <159673438516.17279.6122070644524538248.pr-tracker-bot@kernel.org>
Date:   Thu, 06 Aug 2020 17:19:45 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 05 Aug 2020 18:55:59 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/47ec5303d73ea344e84f46660fff693c57641386

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
