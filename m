Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E46172DB0
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgB1AuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbgB1AuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:50:07 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582851007;
        bh=qVDH0oTYSSaAhTwApWiGQfGpunzVUaAViEyLZbMoFA8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=EA90lQvuFqia5wIMqdYaDuMETYBEL9Em8sugl/xRTr0b27xiMR63nw+O+MHZqZv4b
         tCkGrG4cUszOge1M4Uz2wT4CQ7jgeRjiW7dyzd/b+1ZanT5dHHtHdkmHT3lJAAzVYj
         uYiAtVaVioEQ6lXvppkIF2RiI5wl0aYnjPVX/p7k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200227.141220.1878875210756855090.davem@davemloft.net>
References: <20200227.141220.1878875210756855090.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200227.141220.1878875210756855090.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 3ee339eb28959629db33aaa2b8cde4c63c6289eb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7058b837899fc978c9f8a033fa29ab07360a85c8
Message-Id: <158285100699.4310.8834147667462962687.pr-tracker-bot@kernel.org>
Date:   Fri, 28 Feb 2020 00:50:06 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 27 Feb 2020 14:12:20 -0800 (PST):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7058b837899fc978c9f8a033fa29ab07360a85c8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
