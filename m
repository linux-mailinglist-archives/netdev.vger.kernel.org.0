Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D790D7059A
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 18:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbfGVQkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 12:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731045AbfGVQkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 12:40:24 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563813623;
        bh=H+NQvOM1+dDQd6srXFzkEL4AA3rhFJ6uWFwuT/ZncSk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=queB2YVKxFIiW6pJCpnc2ecNKWNV6ksh/i/PWjDeAH2JZGWnFTaNjDLZJ50aw/hQg
         lt+O17zvFumI4m8sx1L04vJ3dvJbxBMfB/HvJCrbcrhIVKGqUkh05wN1+BN/M9ntBY
         urvyT4qBixvKZDzjpT/gqqwGlnSjh4d1treN4Dw8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190721.211321.455757135945724538.davem@davemloft.net>
References: <20190721.211321.455757135945724538.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190721.211321.455757135945724538.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git refs/heads/master
X-PR-Tracked-Commit-Id: b617158dc096709d8600c53b6052144d12b89fab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 83768245a3b158b96d33012b22ab01d193afb2da
Message-Id: <156381362388.340.10037090759727982516.pr-tracker-bot@kernel.org>
Date:   Mon, 22 Jul 2019 16:40:23 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 21 Jul 2019 21:13:21 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/83768245a3b158b96d33012b22ab01d193afb2da

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
