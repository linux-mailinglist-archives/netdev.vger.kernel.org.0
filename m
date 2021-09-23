Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76CA4164C3
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242676AbhIWSCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241698AbhIWSCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 14:02:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8BEC36109E;
        Thu, 23 Sep 2021 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632420047;
        bh=NlaHKbE9ny8jgGnU+f7CgGmNEIVgLtc/wiKQ1iiRMgw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tRGzHSh0ftD5V8QXNWPXNUd2hla7iJhd396gWrhIX5PIsbAciwOHq7q7mnhUXyqFD
         Sd0R3PbZufoZLow2J+FR8+1jnyu78kpbtpX7mUeMJc2m6vWLWZi171lNlARGuKBrP+
         JzLgOUkALBWiyp7UZvtyCKmp2h+pq2UNYtS7fLv7N4G3OfY80YfNwT2jc7J0z6L5ix
         ehC3gZGdCdg2pjAFsoqyzDpw9vnK2wUHKtpI1bTZN8kBf8LocLIFIGOUpF1/r3BLCN
         IquqLbqe7I4BFUTBGTzKDyta+S5hiDJUy77xiNZ84PynsgL0i+xjPPRnDLgGFWZs/E
         v3M4d3sKCvpvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7958560A3A;
        Thu, 23 Sep 2021 18:00:47 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.15-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210923170935.1703615-1-kuba@kernel.org>
References: <20210923170935.1703615-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210923170935.1703615-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc3
X-PR-Tracked-Commit-Id: 4d88c339c423eefe2fd48215016cb0c75fcb4c4d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9bc62afe03afdf33904f5e784e1ad68c50ff00bb
Message-Id: <163242004743.474.1026376673123772933.pr-tracker-bot@kernel.org>
Date:   Thu, 23 Sep 2021 18:00:47 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 23 Sep 2021 10:09:35 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9bc62afe03afdf33904f5e784e1ad68c50ff00bb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
