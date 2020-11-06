Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E28C2AA068
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgKFWbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbgKFWbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:31:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701865;
        bh=PXQT/mWdXbYLTaalbXZTZAB7jwHLCayGJhBt8t+6fyQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=zph+35NwYS46cLDH2ckHrLeMurB74TDakdXNArIaSKdqFtNwNFyCYuyWSmxfxeG6T
         4vyFVnElgC70e8RXLInGYKf8A4r2pxL4dRJV0ZSQs3lpxvIMsLIOmclCO36vjLvq0+
         HeCbKJ1jnOteX8ueDHPpdq2eqSTz3ODEDSB/GqM4=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160470186554.20539.16918199477800443932.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Nov 2020 22:31:05 +0000
References: <20201105192508.1699334-1-kuba@kernel.org>
In-Reply-To: <20201105192508.1699334-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu,  5 Nov 2020 11:25:08 -0800 you wrote:
> The following changes since commit 07e0887302450a62f51dba72df6afb5fabb23d1c:
> 
>   Merge tag 'fallthrough-fixes-clang-5.10-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux (2020-10-29 13:02:52 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc3
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking
    https://git.kernel.org/netdev/net/c/41f165302414

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


