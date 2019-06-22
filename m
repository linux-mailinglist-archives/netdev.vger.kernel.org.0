Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB484F3DD
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 07:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfFVFaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 01:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfFVFaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 01:30:05 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561181404;
        bh=ysIxSKPyAHz/KZQK86Z6EfINleVifNb4GDxhmtFnXiQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=PmEGgAaeDn3dDdeHklUJT2jmniCGuC2+5XLr2wC6jKIK2dDWmbhY3oiI+nY8lDLBO
         bDDs8yfqAl/iVyou+5Nw7gAyjoNqPQAFblMrp1fbO+bQ2ghzBAacUJQqrsTH0e+kID
         yfXwMV8SkBcDe1W71uMW+mv02KHF7EvKRb6+ZoAA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190621.212137.1249209897243384684.davem@davemloft.net>
References: <20190621.212137.1249209897243384684.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190621.212137.1249209897243384684.davem@davemloft.net>
X-PR-Tracked-Remote: (unable to parse the git remote)
X-PR-Tracked-Commit-Id: b6653b3629e5b88202be3c9abc44713973f5c4b4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c356dc4b540edd6c02b409dd8cf3208ba2804c38
Message-Id: <156118140484.25946.9601116477028790363.pr-tracker-bot@kernel.org>
Date:   Sat, 22 Jun 2019 05:30:04 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 21 Jun 2019 21:21:37 -0400 (EDT):

> (unable to parse the git remote)

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c356dc4b540edd6c02b409dd8cf3208ba2804c38

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
