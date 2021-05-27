Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCB83925DF
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhE0EJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229619AbhE0EJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:09:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0E4416139A;
        Thu, 27 May 2021 04:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622088465;
        bh=UAHNB6ZiHJXtwQLZJNtBnQCJqKRczOHeWj//5hwJV9A=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=egm4w4yAsxTacI1TIdo2ufwqed4+ZIngCfvjM5QC0ajugG3sqatK5hT+N9Cu2+zyU
         REJLsPOfk1ZhRVIt14Hn0E5IY8F6mb7JpfV7bxZClnP3MSqy/eqRFp9xrhIaTdd6/Z
         yh+lrDETu3PuVSKSpQv5fxi4TyDM89OpFkguQ9HItJhcWfdDUEElWzMr/CoAEKhdy1
         Wd1j/d/LUPkXVuPv7Cbsxo2YpC2oE6vPvS2NouR0ByUfs+zozYoHPMZ7a47t0qJ74L
         ZXQi2egEg4bZgHDwpdA+VLW7ulT0UntEbIfVsZ1Wl3SCmUD7itX7eh1gpVaXCzTjq3
         z5bP/MsIIZ5xg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EFA4760A39;
        Thu, 27 May 2021 04:07:44 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.13-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210526223553.306028-1-kuba@kernel.org>
References: <20210526223553.306028-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210526223553.306028-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc4
X-PR-Tracked-Commit-Id: 62f3415db237b8d2aa9a804ff84ce2efa87df179
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d7c5303fbc8ac874ae3e597a5a0d3707dc0230b4
Message-Id: <162208846491.5553.6202887307798141598.pr-tracker-bot@kernel.org>
Date:   Thu, 27 May 2021 04:07:44 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 26 May 2021 15:35:53 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d7c5303fbc8ac874ae3e597a5a0d3707dc0230b4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
