Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4AB48A631
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 04:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346892AbiAKDUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 22:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245368AbiAKDUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 22:20:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C37EC06175B;
        Mon, 10 Jan 2022 19:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0785D6145E;
        Tue, 11 Jan 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC024C36AE5;
        Tue, 11 Jan 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641871214;
        bh=B+EixSkI7PqRDdRbQKDUsuGaEGfRsOdkcVIw/vDHSsM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dCyCvzurWlSgRmU5SrRdfTAsnZeK/JZec9cWEdZd56eowurKFmRMXGewXglW35/MX
         XGW/NPiMxPGJJhDdnROcQ0pGQcRoHV66aPF0jevYpsJe+6nnGplBxniuXGvzUny6Jd
         4064ZAIOmFDfgASyj2eR0IGQGVA9q34LvR+bTvYV2Z7n5w4NTQXlgDdGv6BDthoFV3
         xT8CDGHI5FoVlzgWCwEB1qGzXRLBfVkGH5wTHOVsDD5qhKsuw/XWU3Xz43mRbnmvrV
         PYmpALpAQoE9x4VFXkItZOIY/J1ORJpoqpN50HayqVKHTa95/Y+Ne+TnbMk/+t2X2L
         fKyJP63o6Hztg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABD8EF6078C;
        Tue, 11 Jan 2022 03:20:14 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.17
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220110025203.2545903-1-kuba@kernel.org>
References: <20220110025203.2545903-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220110025203.2545903-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/5.17-net-next
X-PR-Tracked-Commit-Id: 8aaaf2f3af2ae212428f4db1af34214225f5cec3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8efd0d9c316af470377894a6a0f9ff63ce18c177
Message-Id: <164187121467.31430.8403117107070911480.pr-tracker-bot@kernel.org>
Date:   Tue, 11 Jan 2022 03:20:14 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun,  9 Jan 2022 18:52:03 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/5.17-net-next

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8efd0d9c316af470377894a6a0f9ff63ce18c177

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
