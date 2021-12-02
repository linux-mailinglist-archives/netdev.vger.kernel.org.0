Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1098C466A7F
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 20:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357980AbhLBThW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 14:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357706AbhLBThV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 14:37:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C38C061757;
        Thu,  2 Dec 2021 11:33:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01CA1627E8;
        Thu,  2 Dec 2021 19:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59CCAC00446;
        Thu,  2 Dec 2021 19:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638473637;
        bh=aX5cHLwYJklM0jbjaAkX3L8eXFwLTVCGnqF7OxJBdcc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=eXGZCo+tfLE4CfYpkWkOWvIgC3v8eitiAMISLzxxSlmtrV8vPDwey3SlLaTWgPPF8
         vXknfK1UPmkF/dGlrAOVI2D1faFFvrT2nT+TmOLOQ4zxMp2w+pzzr5/p0Ta3/+kTmI
         cs5wF1i+bole0t/GQK/aYMFZ0T/2XXxu6pz7F6JX+x5p6ZceTNWTGOywy6QmolqNlV
         Z6ONwpW41O0LTCg6wI5PywG5l7wS7iPtZCGcxYIU6g98zqkdJ+NCIxkqOtejsv9JI2
         PBLRcci1o5li/CFv+MPD7/T8O/4zAkohWWWlCWJrKWK4+Ri13c0BcN0BGOC5BamLkQ
         kjMgDs3oR8EvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 35DFE609E7;
        Thu,  2 Dec 2021 19:33:57 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.16-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211202155158.791350-1-kuba@kernel.org>
References: <20211202155158.791350-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211202155158.791350-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc4
X-PR-Tracked-Commit-Id: 88362ebfd7fb569c78d5cb507aa9d3c8fc203839
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a51e3ac43ddbad891c2b1a4f3aa52371d6939570
Message-Id: <163847363716.31731.16344662560558983887.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Dec 2021 19:33:57 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  2 Dec 2021 07:51:58 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a51e3ac43ddbad891c2b1a4f3aa52371d6939570

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
