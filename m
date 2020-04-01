Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2960019A318
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 02:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbgDAAzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 20:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732189AbgDAAzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 20:55:12 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585702512;
        bh=cCxA4kOBR/muUbPPJR0gWBvHIzhpu/YIxXA6bXrfZY0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=jlGiitGRIju7S/pDOasPx5RXxGZGx5PNiFRlky6pKTnj14aao+RTfHVSAuhuGABLJ
         py7YoCq8ufXuNEMVaf6MQUpBH5DDBMJzHteIzm0Y2lqB9E1sG3rfOtKkY9pMVH9n8A
         TwVX8IxSgjcPCQZNqu3t+y6tvIMO8uR/9TVCObn4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200331.135506.1590104250990736553.davem@davemloft.net>
References: <20200331.135506.1590104250990736553.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200331.135506.1590104250990736553.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 7f80ccfe996871ca69648efee74a60ae7ad0dcd9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 29d9f30d4ce6c7a38745a54a8cddface10013490
Message-Id: <158570251205.17032.17573828736249786641.pr-tracker-bot@kernel.org>
Date:   Wed, 01 Apr 2020 00:55:12 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 31 Mar 2020 13:55:06 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/29d9f30d4ce6c7a38745a54a8cddface10013490

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
