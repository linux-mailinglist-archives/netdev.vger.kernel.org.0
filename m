Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771C8284079
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgJEUP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729575AbgJEUP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 16:15:27 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601928927;
        bh=vF1iCLPX6KOHrJYwCAlhiNyjTAkLM/nXMqQeBfVMoR0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=srItwxhg949qXPgASs2yG16Oa85yK01+3kCmoxqYQHzA/39ED4eRKzm1ckbso4wTA
         VITFXOs/Mqc3yA1zfc+aGQPTBwvzxlKbZ+G3UVew3qLQ3JLk0cQmG4/N9OoRlK71rQ
         C/262HIi+uZAmz4grjyVl0hlvX5Q9DY40Y5Ere/k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201004.220755.151782290115881232.davem@davemloft.net>
References: <20201004.220755.151782290115881232.davem@davemloft.net>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201004.220755.151782290115881232.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master
X-PR-Tracked-Commit-Id: 4296adc3e32f5d544a95061160fe7e127be1b9ff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 165563c05088467e7e0ba382c5bdb04b6cbf0013
Message-Id: <160192892739.5040.2903748314010433828.pr-tracker-bot@kernel.org>
Date:   Mon, 05 Oct 2020 20:15:27 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 04 Oct 2020 22:07:55 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/165563c05088467e7e0ba382c5bdb04b6cbf0013

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
