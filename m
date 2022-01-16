Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB1948FB3C
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 07:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbiAPGpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 01:45:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51838 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiAPGph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 01:45:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC2CC60C8B;
        Sun, 16 Jan 2022 06:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F92FC36AE7;
        Sun, 16 Jan 2022 06:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642315536;
        bh=RK6xmWL/Q3Twf8KVJ/yiNzacgiqoDi1oFGuHGnW+dnM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dMO3ZxTkiqzsLipADrEPV6ajI25VghoeWPQGXv7QIcvl4tYTD1kD8yBfYwNEQRsmG
         Aw82DirJgK99f8rh/NWSvBjKy3rWUwhpgCbXxAGpOdnueI4/wk8+diY250r5HN7cD4
         cEGBL0O2HtdsCQH8ueOsF1TeX3IaO0Q26OKfd2q/N4YShq2xZcZGYgOkKnCEkXu8vG
         Odj/loWIrTq3n/QIygbXd0Xm781cQDi5ARMhA2nKsMjGarOS67awg8y7hpYaNMoijV
         239IrHlAGkpRY41L6vPO/BtmCi5Zq4e4zWFiwbSdD61x86mcXS12+4UueZKoA3P3jS
         pVWgnumTGafeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F2D2F60796;
        Sun, 16 Jan 2022 06:45:36 +0000 (UTC)
Subject: Re: [GIT PULL] 9p for 5.17-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YeC4rCJjQhLOJGlH@codewreck.org>
References: <YeC4rCJjQhLOJGlH@codewreck.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <YeC4rCJjQhLOJGlH@codewreck.org>
X-PR-Tracked-Remote: git://github.com/martinetd/linux tags/9p-for-5.17-rc1
X-PR-Tracked-Commit-Id: 19d1c32652bbbf406063025354845fdddbcecd3a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 49ad227d54e842f436ed0122cb7c901d857b86cb
Message-Id: <164231553625.30539.16557626266973677990.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Jan 2022 06:45:36 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 14 Jan 2022 08:41:32 +0900:

> git://github.com/martinetd/linux tags/9p-for-5.17-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/49ad227d54e842f436ed0122cb7c901d857b86cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
