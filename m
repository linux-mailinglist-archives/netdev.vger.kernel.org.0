Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F68296465
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 20:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369520AbgJVSFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 14:05:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900769AbgJVSFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 14:05:17 -0400
Subject: Re: [GIT PULL] 9p update for 5.10-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603389916;
        bh=YV9UjMDfnXXtBMMESCMmr59GH3lCo7JxOlpEMrth5KU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=l9c9JjMqr8ugzTNGFRtsikEXe/x1XQcl2vmSZJaJbV87hrEiZ3O9TPrk7/9VyJDXr
         vf2URYrEDlhQ8VmArkaJfEpAi0LHBQp0CBl54BwfNRAqkqlJr7pSFgZSQkCTJ/bu4E
         grlhLmvNuy1Mu5L0V4WnCOwVMCyhowhFCk8vcIIs=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201022120826.GA28295@nautica>
References: <20201022120826.GA28295@nautica>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201022120826.GA28295@nautica>
X-PR-Tracked-Remote: https://github.com/martinetd/linux tags/9p-for-5.10-rc1
X-PR-Tracked-Commit-Id: 7ca1db21ef8e0e6725b4d25deed1ca196f7efb28
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 334d431f65f05d3412c921875717b8c4ec6da71c
Message-Id: <160338991670.20886.10086376511577798904.pr-tracker-bot@kernel.org>
Date:   Thu, 22 Oct 2020 18:05:16 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 22 Oct 2020 14:08:26 +0200:

> https://github.com/martinetd/linux tags/9p-for-5.10-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/334d431f65f05d3412c921875717b8c4ec6da71c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
