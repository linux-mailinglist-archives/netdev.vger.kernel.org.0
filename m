Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5445A46F40A
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 20:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhLITjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 14:39:25 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47408 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLITjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 14:39:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D144CE27F4;
        Thu,  9 Dec 2021 19:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 113F7C341CB;
        Thu,  9 Dec 2021 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639078546;
        bh=3Y6sSFhQC6zE/Ent9Dbju/+ZfZjUqmHxioM8+U3W42U=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=f2WlktgMywCTKzyIIcW2CS6FmU8GJMWn1v1ZLvvhkjI8+QgyuBd+KRy2Pc3F/5FSU
         dRijOqESZz/F08TOgFMipp3kAFFMq6y6boMXd56AqpEgY2595LvI7JrhVEB/DrlWEE
         5vNKcdWo5BkI6qDzBtAMcgMMID3FmW47fVWjgfhkTz1uHhDFwtqcQowYUqb4sSIgy/
         PzreDnftvNnvoUVnvFcet9IJeo5JrXb8QYDIihyEtPwMmJqz7PhK+K9QLmbmXsT3zO
         dR+B3vTc+atkmj3lIb2Lkl7WqFIBRJNqI1oNniHeaHDUVdOCctfJeHIS2ZcR60iPnS
         BJdDJtbAHMA3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EDAEB60A37;
        Thu,  9 Dec 2021 19:35:45 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.16-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211209172032.610738-1-kuba@kernel.org>
References: <20211209172032.610738-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211209172032.610738-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc5
X-PR-Tracked-Commit-Id: 04ec4e6250e5f58b525b08f3dca45c7d7427620e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ded746bfc94398d2ee9de315a187677b207b2004
Message-Id: <163907854596.11961.15478565326988801668.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Dec 2021 19:35:45 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-can@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  9 Dec 2021 09:20:32 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ded746bfc94398d2ee9de315a187677b207b2004

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
