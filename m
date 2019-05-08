Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED94217068
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 07:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfEHFkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 01:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbfEHFkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 01:40:14 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557294013;
        bh=J496PWk1eLGWsHPf7iV/SSEef+bsxWodQCQSPUDL6cg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=bNAJHHYdEqBu2OGgoG9/In+g/lqVBDug+Mcg7eejNvaNkOsttAL/F/qOaxBo0LMU7
         axfgTFF3ptyM9RvhUFA9Mw1qUahDsAZTCn+z3D8pL32YQe1vXHPfod9+5RB0bKVFYg
         5LGumFlToV0pfWIrpsTYBsRzaiqG0GcsFRxD0R0k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190507.180102.1682734091447758139.davem@davemloft.net>
References: <20190507.180102.1682734091447758139.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190507.180102.1682734091447758139.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
 refs/heads/master
X-PR-Tracked-Commit-Id: a9e41a529681b38087c91ebc0bb91e12f510ca2d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 80f232121b69cc69a31ccb2b38c1665d770b0710
Message-Id: <155729401378.2342.9111999010699801294.pr-tracker-bot@kernel.org>
Date:   Wed, 08 May 2019 05:40:13 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 07 May 2019 18:01:02 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/80f232121b69cc69a31ccb2b38c1665d770b0710

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
