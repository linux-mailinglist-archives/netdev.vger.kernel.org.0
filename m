Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF510E51A
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 05:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfLBEkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 23:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbfLBEkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Dec 2019 23:40:17 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575261616;
        bh=wwZFYqm4Y+zx4fQ/TSY+/ZflzjzvfREUctnUhqPREZ0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=oLD1plyV+Rp8gmpU39brxT9uCLqnaXmG2lpz2VCPRlVKOWvzZd7UL9Lp36rOyp40+
         3sVPtITmPnGVqr+fD9lduMIxpE1VyRtZRILtVMcM5FEx7a2u0Uy3lGvZZsi/rvauM9
         Xz3fGaQ3qSH6fVGYgv4D4V40Jp69FcqKRoLDVOvc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191201.160518.50010694947236666.davem@davemloft.net>
References: <20191201.160518.50010694947236666.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191201.160518.50010694947236666.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: c5d728113532c695c894c2a88a10453ac83b0f3b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c3bfc5dd73c6f519ff0636d4e709515f06edef78
Message-Id: <157526161693.3812.2918811189399153354.pr-tracker-bot@kernel.org>
Date:   Mon, 02 Dec 2019 04:40:16 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 01 Dec 2019 16:05:18 -0800 (PST):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c3bfc5dd73c6f519ff0636d4e709515f06edef78

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
