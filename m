Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716051F10B6
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 02:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgFHAf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 20:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbgFHAfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 20:35:24 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591576523;
        bh=YqXIFIAjqJbxE2m06PeW1zEwda5QmyEskXknR0AK2tc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=dCe0pb9wN4IXgb9qBXV8M5woV7pEWFDS/3zBk770qQy7SjJlLUDbzoeoO1G/qX1FK
         JZG5/vWd/Ng1ejmbEtt9lr4Lh9u4otySGuM4niHA6iyUr7YUVZcSWcT91btOWnLsbU
         hUk8+gR0DNMFYxl8f8V4IW3km1aH/ONYbgMz14PM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200607.172143.1367434746586532493.davem@davemloft.net>
References: <20200607.172143.1367434746586532493.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200607.172143.1367434746586532493.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
 refs/heads/master
X-PR-Tracked-Commit-Id: 4d3da2d8d91f66988a829a18a0ce59945e8ae4fb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: af7b4801030c07637840191c69eb666917e4135d
Message-Id: <159157652386.5945.6745030865102165967.pr-tracker-bot@kernel.org>
Date:   Mon, 08 Jun 2020 00:35:23 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 07 Jun 2020 17:21:43 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/af7b4801030c07637840191c69eb666917e4135d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
