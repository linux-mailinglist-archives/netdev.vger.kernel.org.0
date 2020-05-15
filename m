Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFA31D5A9A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 22:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgEOUPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 16:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgEOUPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 16:15:04 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589573704;
        bh=psEOaF8nRViEXr3vqL2+yxlMTvVEzrbSOKsUZE/DMNw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=iq9npIQjBDSw9Hcd3pdtkZ8oMIXBHhiNfB8/k/P2O7w9sM+W9btAozSq2e986D9UK
         CWPLx2TYLrkjQgSC/zjjDZuCpfQPUWOcehMIERX/FgsGpXMKCOkiR3a9xnVz5juiTZ
         oqCOlnyHrWMIIUHacmMFtK/hKb0gra413qAxirdA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200515.123900.727024514724458944.davem@davemloft.net>
References: <20200515.123900.727024514724458944.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200515.123900.727024514724458944.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
 refs/heads/master
X-PR-Tracked-Commit-Id: 8e1381049ed5d213e7a1a7f95bbff83af8c59234
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f85c1598ddfe83f61d0656bd1d2025fa3b148b99
Message-Id: <158957370419.26450.7540009470931421936.pr-tracker-bot@kernel.org>
Date:   Fri, 15 May 2020 20:15:04 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 15 May 2020 12:39:00 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f85c1598ddfe83f61d0656bd1d2025fa3b148b99

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
