Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0F339948B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFBUbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhFBUbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 16:31:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD0BC613DE;
        Wed,  2 Jun 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622665804;
        bh=r+9r/R8bkDrMf0Ep3Iix6lsb1k3vQjnQITbPfpA20zs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=flhyUEld7oO6Z3fKZVB16h1l9u1hQMfGIoGxhtUq2v84TBFHlF3U4P8DQ9zvutQF3
         ix94q11NPqiOO37Bilv6cfDPs8lCRZN2q+o03yeaYjM/A60kKCl5BynCeRZc2YLBOY
         bWvDwSZa3wceDg7yKbdO76LyEbsvt9P2Un7urCM9XrsbxiQpu7bVEwqPCwMEHz6tBx
         Xd4wncCbavlwyfOB1YAgWuzLbtChnScG9ksyOQEezzj7hHb2OMu0MFzIgMTSQAiQ+X
         gknPnOcLQPrKsUP5y+PxVT9dKnoXzacbnP+ejjefBT76gkO04dUC7rjTxXHUZz1V/J
         4uvWL9moDJCPw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9720160CE0;
        Wed,  2 Jun 2021 20:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipconfig: Don't override command-line hostnames or
 domains
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162266580461.6825.9058005036577204617.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 20:30:04 +0000
References: <3914b427de4886dee28dedbfc1fdf7aa64b612e9.1622597775.git.josh@joshtriplett.org>
In-Reply-To: <3914b427de4886dee28dedbfc1fdf7aa64b612e9.1622597775.git.josh@joshtriplett.org>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 1 Jun 2021 18:38:41 -0700 you wrote:
> If the user specifies a hostname or domain name as part of the ip=
> command-line option, preserve it and don't overwrite it with one
> supplied by DHCP/BOOTP.
> 
> For instance, ip=::::myhostname::dhcp will use "myhostname" rather than
> ignoring and overwriting it.
> 
> [...]

Here is the summary with links:
  - net: ipconfig: Don't override command-line hostnames or domains
    https://git.kernel.org/netdev/net/c/b508d5fb69c2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


