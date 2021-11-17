Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F316E453EB5
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhKQDDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhKQDDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:03:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E255D61A8D;
        Wed, 17 Nov 2021 03:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637118010;
        bh=I7JNyxu9JF9tZxgD93jHSOkSexNFYfxthKYuVz192uY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jNugVIXpgHQCnKn/bvDwfBlEz2T4QWo92O2is34YirhcIi8NwTyrY0UPuVSvcw5I+
         D54O2Yyv1ouOAU7FG6F3UtAMQVUuNAfokvmB9wIBtSmSxV6lPa+s9ZSmrmqYdoX7mR
         MVFRa7dbXzANRDCPKZPuzKwRzV39p1EI44Ow/+fUQ+zYvlurIcd+yqLeVUOotNjFRm
         GSJz+mjs9DB7cQ7w/v9OwEmN9zRpgSj/uyWA3U3r+YJD3ky3EqjNgZB+A5sJLXXOVN
         1q3Aaq6uE6kKKuIp4gD2fPhqyB+CVi1iU/CQUqfrHa1Xq4UVnLeWjqZBCpn6Y0X0G7
         6EzGM2DU8DGjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D3F3260A0C;
        Wed, 17 Nov 2021 03:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-11-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711801086.22897.17305544383277385490.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:00:10 +0000
References: <20211116160845.157214-1-johannes@sipsolutions.net>
In-Reply-To: <20211116160845.157214-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Nov 2021 17:08:44 +0100 you wrote:
> Hi,
> 
> We've already got a couple of fixes for this cycle, and in
> particular the radiotap one has been bothering users.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-11-16
    https://git.kernel.org/netdev/net/c/f5c741608b8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


