Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5D62B139A
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgKMBAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:00:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:32972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgKMBAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 20:00:11 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605229210;
        bh=p9/dChOtSCS2nF7GfJqb6/Suf9Gahf/20WvXgZE6LgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FfRtW5zqI4BuILLAE1uWu6MpfQRloUoNV8OQu2nHVa6RKjrrjM8j6Rt3m6PT/ZKsI
         bSiZubLJpaUOyHxmPq+nSIZGhus/6SWJfeiaO1BVqLg0r/4IbLxX2lxiRLhUmxJVq7
         hTm8q4U1kaqpCp8pE1+VDMN+GqGWEaM2H+4rfmuw=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160522921071.20000.12770202355609491498.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 01:00:10 +0000
References: <20201112190245.2041381-1-kuba@kernel.org>
In-Reply-To: <20201112190245.2041381-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu, 12 Nov 2020 11:02:45 -0800 you wrote:
> The following changes since commit bf3e76289cd28b87f679cd53e26d67fd708d718a:
> 
>   Merge branch 'mtd/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux (2020-11-06 13:08:25 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc4
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking
    https://git.kernel.org/netdev/net/c/db7c95355538

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


