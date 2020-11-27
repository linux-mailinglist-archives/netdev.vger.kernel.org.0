Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2560B2C6DAC
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731652AbgK0XbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:31:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729019AbgK0X3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 18:29:54 -0500
Subject: Re: [GIT PULL] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606519794;
        bh=0YzhjTcS5pXbtEbVFsi2m0HAzyGtA2PU+pOoBzJ/vyo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Pvl0jHaR/RE19awDGA74EtROevesaVjwvXYK8GIM7QfPHjC9ShDWnT+mkSvs3Enhz
         uioaHECRABMEXMZdDCV37MQ9KNlXmYE1sZxmGQkhDc73K0n9ucH0M39qKzb+D+77Tb
         129ol4s3Q1vJ0NEo0uuE8RFg9aafSs39FYJ6hclk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201127200428.221620-1-kuba@kernel.org>
References: <20201127200428.221620-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201127200428.221620-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc6
X-PR-Tracked-Commit-Id: d0742c49cab58ee6e2de40f1958b736aedf779b6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 79c0c1f0389db60f3c83ec91585a39d16e036f21
Message-Id: <160651979448.32137.13352759714617661612.pr-tracker-bot@kernel.org>
Date:   Fri, 27 Nov 2020 23:29:54 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 27 Nov 2020 12:04:28 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/79c0c1f0389db60f3c83ec91585a39d16e036f21

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
