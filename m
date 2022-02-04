Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B854A91EC
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 02:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356472AbiBDBQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 20:16:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43064 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351504AbiBDBQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 20:16:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C641D6198E;
        Fri,  4 Feb 2022 01:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3569AC340ED;
        Fri,  4 Feb 2022 01:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643937392;
        bh=aB9+D8EG8yLCGwvt9qYMcApSdbrEaj1GWxq4XpQ+TEU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dDQEfRpggUC0bKDkEhxvW31nantepBvl4sPJl5A+RwuS7G7M7FtKvEro/hoXDScdP
         i7CpliCUJTp3+wOpLyzlErM7vvcAmabUXiZs9EhbUFdUwN09Bndsre/gAxiDXnlIMU
         zMV+IHarp/byQ16sLKi21OKFgB5zcGtAxk780zWJmbpvAXub4eEkkhaljWfj5KfRkf
         A2zJXmmagu/IZN1Izi43NmVlEZVVVMZ/dWkQFvwHzgcx/5shaId34VMUCVfEEmTyvZ
         gkaaPn4ZIR92ivhhfotqalgeqkgbCqTaP2NdJfHgP2F/RnoWoa8XMD5oWHjfcHDYnr
         +DmsPTj5ObxZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22CAAE5869F;
        Fri,  4 Feb 2022 01:16:32 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.17-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220204000428.2889873-1-kuba@kernel.org>
References: <20220204000428.2889873-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220204000428.2889873-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc3
X-PR-Tracked-Commit-Id: 87563a043cef044fed5db7967a75741cc16ad2b1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eb2eb5161cdbd4f0acc574ef1c3ce799b980544b
Message-Id: <164393739213.12311.5728078063673083709.pr-tracker-bot@kernel.org>
Date:   Fri, 04 Feb 2022 01:16:32 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  3 Feb 2022 16:04:28 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eb2eb5161cdbd4f0acc574ef1c3ce799b980544b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
