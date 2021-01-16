Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648C02F8AA2
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbhAPCAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAPCAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 21:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A64DB23A50;
        Sat, 16 Jan 2021 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610762408;
        bh=Fh5Q8ebg3FGnmrxc7EDS5+BPPSd9BHAH4ubjO53G9oY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bNcVyPjcCfYU8BstcIGqso8yXRFGTYo/e06euMtEBoCzBLYmm/FJ4L3CtF2gYTzCL
         Bd/z52IQLLYa2Qmb2QfKMMKo3H45vQ7PHkPxxKq11Mja/pcFKROqDHYoGLPfYnEjps
         pGwhczgpJTVOU6GwKVWLy9HdbKCAezpWk6ZcmRrFqlKqXz0IRzpyrpAXynpRZs4Flv
         8etO+mBkNqP3D1kOFllxSFfQXz7TijCiFcakKxwHqBelrkppEnlaM/Dt3rqpg1Ctog
         bK/9WwaKbvD2rsynWlcbRMwT+A8NYs6j/NJGdWN844fZcke0FMx8ZZbiH9m15iE450
         fwFNjYnIx5cyw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 9932960593;
        Sat, 16 Jan 2021 02:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] neighbor: remove definition of DEBUG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161076240862.31907.2486465185269577079.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 02:00:08 +0000
References: <20210114212917.48174-1-trix@redhat.com>
In-Reply-To: <20210114212917.48174-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        liuhangbin@gmail.com, viro@zeniv.linux.org.uk, jdike@akamai.com,
        mrv@mojatatu.com, lirongqing@baidu.com, roopa@cumulusnetworks.com,
        weichen.chen@linux.alibaba.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 14 Jan 2021 13:29:17 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Defining DEBUG should only be done in development.
> So remove DEBUG.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> 
> [...]

Here is the summary with links:
  - neighbor: remove definition of DEBUG
    https://git.kernel.org/netdev/net-next/c/e794e7fa1963

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


