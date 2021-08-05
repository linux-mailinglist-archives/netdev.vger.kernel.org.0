Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75173E1CD4
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242848AbhHEThQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237310AbhHEThP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 15:37:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B72B3610FB;
        Thu,  5 Aug 2021 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628192220;
        bh=9OTiKLZBzM4V3aTDBqubFToc2HxCgDB1+5CBNLusQ6U=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=IJl//HyK+bysZ6bKqZ2xZ0V8WMihOb2tjpd8YNwFNyy93xdMFpeQyT5BwVQNcLG+D
         GAdTwDGrKWjTU7Q3aAREKvk/Bz4dwFX95NCMVNnYie8CYozKt6clNPEY0D1by1lT/7
         co9Ekfz4K7ekOMqma5lZlTaSFxmVmE1W2j+9wOvlydT+aCPImBFPa0N53qjMfGqKmx
         usegYdRkTlAHQVTilZDnCCfTIb06qeJl5mn9Yp/DWQrKGtKxTflp4LungUVy3alr+M
         OJ+oytg3oxdxV36j2bJhRBN1BscsbSVHxqquUUtcmX3ZAHdjayF/0cz+j/96bkemEH
         phXhkZUUPV/RQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A833B609D7;
        Thu,  5 Aug 2021 19:37:00 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.14-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210805154335.1070064-1-kuba@kernel.org>
References: <20210805154335.1070064-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210805154335.1070064-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc5
X-PR-Tracked-Commit-Id: 6bb5318ce501cb744e58105ba56cd5308e75004d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 902e7f373fff2476b53824264c12e4e76c7ec02a
Message-Id: <162819222062.18936.3286459954059288658.pr-tracker-bot@kernel.org>
Date:   Thu, 05 Aug 2021 19:37:00 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  5 Aug 2021 08:43:35 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/902e7f373fff2476b53824264c12e4e76c7ec02a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
