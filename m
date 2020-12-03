Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890A22CE135
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgLCVzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbgLCVzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 16:55:09 -0500
Subject: Re: [GIT PULL] Networking for 5.10-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607032468;
        bh=Lo7lrm+mn84w8svm5yg/I/G8i8Iv7PH55ylXthuHHLY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=HCRkXoUAEKx9xialrv10p3FMTmwmfR6P7NvQVemu/6WBJ0No60jEUzuCQwiwCV9fa
         gTE9m5mJ4vRCRkTJvgCNuF1lJ6rZap0NtfEREkICWiB7hpV+K2EFAKq5QWfIjvSajv
         sss/eKoX0raOQTV2Ky/d7/nGzorjc1AleeE2QedILyx2kBYmpc6/VZTkWo6enITy9p
         XoINuKZRxFzEA2PUlrPLJAeZRTuP/Aobgo3wnrAZZgyjyh8K9Jc3PexiH1ZVAwQywE
         gly7+oAouCpT7+lvvXrUttzW8BtvXz7zJltVDIX+pUBrBb4f6ZPfU3PPMnKnRKuimu
         IyNPAWdIXgYUw==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201203204459.3963776-1-kuba@kernel.org>
References: <20201203204459.3963776-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201203204459.3963776-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc7
X-PR-Tracked-Commit-Id: 6f076ce6ab1631abf566a6fb830c02fe5797be9a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bbe2ba04c5a92a49db8a42c850a5a2f6481e47eb
Message-Id: <160703246842.16480.7501069381542589789.pr-tracker-bot@kernel.org>
Date:   Thu, 03 Dec 2020 21:54:28 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  3 Dec 2020 12:44:59 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bbe2ba04c5a92a49db8a42c850a5a2f6481e47eb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
