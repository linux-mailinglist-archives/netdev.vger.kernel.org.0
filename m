Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C11297978
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 01:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758440AbgJWXB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 19:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758431AbgJWXB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 19:01:26 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603494086;
        bh=TxA3WnHhq5EwG2OIhSC59C3XM5I/OAa7M69E6u83CLU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B+1MZg6x+kQpE6TfwrPPxiu1/nZkxGXqX2XyztRICqiBUgRkFC+Bj/S46bs99RgNn
         llLP2qy6sShDr8yj+/ZFmfzV0GZsPNWFin1FyuKwDjNdr1PfOdt/yzn406k5GFl3G2
         3ZvomTLXAQ8HVWdn6CDtIScrRqfpxtOPyBifMMEA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160349408591.25602.7882024733775862361.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Oct 2020 23:01:25 +0000
References: <20201022144826.45665c12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022144826.45665c12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Oct 2020 14:48:26 -0700 you wrote:
> Hi Linus!
> 
> Latest fixes from the networking tree. Experimenting with the format
> of the description further, I'll find out if you liked it based on how
> it ends up looking in the tree :)
> 
> The following changes since commit 9ff9b0d392ea08090cd1780fb196f36dbb586529:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking
    https://git.kernel.org/netdev/net/c/3cb12d27ff65

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


