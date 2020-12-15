Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4496D2DB60E
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 22:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgLOVfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbgLOVfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 16:35:00 -0500
Subject: Re: [GIT PULL] Networking updates for 5.11
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608068038;
        bh=IxUCHXJUoQYOCUo0zxeOPK+c67O0er8jrceei/ZWrFU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=rJrey77D/AFwmSvTg1q4vGgqIwx/XHeRfYJ8FE5K+vGK9uxHWDjJyArr2hfy467rl
         Uart9vv2PI4o3xLfu+objtLKUbAOL0/d9AsnUA/WMdtQzQOlSXkW0pMsoiwQVPCQPP
         mx0Qc5Gg2RigR//grAEEpZ2oNzL/RlY/VCFzJpPx7A0ej+i7h767+Q9N5NVbidCwYC
         yGXYqE0TaP2y3PrAiKJAlar5/MJQ3OAt3yraaYB4rs2mp/fQX+LN7AVM2shsgfVGSw
         nUD+4RJCfNoTesi2jodzCQLGkOjBlpp+DbHjVbWsFcjwTu9nZrgAjfqBGr7+7/6tMo
         Kq/+jImHAPmMA==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201215072850.3171650-1-kuba@kernel.org>
References: <20201215072850.3171650-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201215072850.3171650-1-kuba@kernel.org>
X-PR-Tracked-Remote: https://lore.kernel.org/linux-next/20201126162248.7e7963fe@canb.auug.org.au/ mm
X-PR-Tracked-Commit-Id: efd5a1584537698220578227e6467638307c2a0b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d635a69dd4981cc51f90293f5f64268620ed1565
Message-Id: <160806803833.7181.2292709187456512920.pr-tracker-bot@kernel.org>
Date:   Tue, 15 Dec 2020 21:33:58 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, sfrench@samba.org,
        ebiederm@xmission.com, akpm@linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 14 Dec 2020 23:28:50 -0800:

> https://lore.kernel.org/linux-next/20201126162248.7e7963fe@canb.auug.org.au/ mm

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d635a69dd4981cc51f90293f5f64268620ed1565

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
