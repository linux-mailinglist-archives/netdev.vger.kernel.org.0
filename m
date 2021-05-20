Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC6838B346
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbhETPbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232955AbhETPbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:31:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 19C896124C;
        Thu, 20 May 2021 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621524611;
        bh=ScDNUZaX1wyarXHpnxN7Faiwnu/DvZ68k3dp26rKGYg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mQ+cVxKaLQwnR3iqpoezNx+8ayZzQQp6m7EcMqr2RIFtA35l+PeCFzdvBcvnmj8FS
         z/c2/6YGhx34WEOOa5WteOqsMI8DBL6xV3f9bpJKk7SjjNvznEBE+9hiZ+6+3B6Rv3
         sGirR2LDZ+YIrV6W8VJuH636bl3K3l9/CizffTHCDrDPQe839OQX5b7N+vjRM5jktJ
         OPRx0udqRiReLpZR9TG6LfxbKU8AHzhBUIjxwofcWM492/fS8PnzzsXENro6iSoy/+
         LxrQ4ev2BSXBQEmc6Dopoe6JZ6RyDr1Ck6A6bAOUlDUvLO805FU5Yu9/Dig9pEZC3B
         jba8xnzpXUFIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0AC1E60A0B;
        Thu, 20 May 2021 15:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PACTH ethtool-next v3 0/7] ethtool: support FEC and standard stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162152461104.25423.14740939825188205500.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 15:30:11 +0000
References: <20210503160830.555241-1-kuba@kernel.org>
In-Reply-To: <20210503160830.555241-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (refs/heads/master):

On Mon,  3 May 2021 09:08:23 -0700 you wrote:
> This series adds support for FEC requests via netlink
> and new "standard" stats.
> 
> Changes from v2:
>  - update headers
>  - fix --disable-netlink build
>  - rename equivalency groups to alternatives
> Changes from v1:
>  - rebase on next, only conflicts in uAPI update
>  - fix the trailing "and" in patch 6
> Changes compared to RFC:
>  - improve commit messages
>  - fix Rx vs Tx histogram in JSON
>  - make histograms less hardcoded to RMON
>  - expand man page entry for -S a little
>  - add --all-groups (last patch)
> 
> [...]

Here is the summary with links:
  - [PACTH,ethtool-next,v3,1/7] update UAPI header copies
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=eb2d0a980c46
  - [PACTH,ethtool-next,v3,2/7] json: improve array print API
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=8a6250926b52
  - [PACTH,ethtool-next,v3,3/7] netlink: add FEC support
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=38cd721796f8
  - [PACTH,ethtool-next,v3,4/7] netlink: fec: support displaying statistics
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=8145f9521b75
  - [PACTH,ethtool-next,v3,5/7] ethtool: add nlchk for redirecting to netlink
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=67a9ef551661
  - [PACTH,ethtool-next,v3,6/7] netlink: add support for standard stats
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=f8d2bc2ccd8b
  - [PACTH,ethtool-next,v3,7/7] netlink: stats: add an --all-groups option
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=02255f29f38d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


