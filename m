Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5105C41AF0B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbhI1Mbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240534AbhI1Mbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3042160F21;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632832208;
        bh=X/1cIcspPfMYZ9awN/uAvipU4rTmCTnffKCxnPMxjwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o44Q9qgPm5Um9B5DJAGXFptxy2HV8jeo1W3YEbsWPduwv0MH6cGq2d9qkvjJ3EMLl
         +AnoqzD3HDtAkHx4FtTfiE6x+LczNFnlVLnlQErpYORqxkrEeU5V7qnW6BRWcekYmB
         hSi2DMU8OSRhYY7QOHzvAwagN/alcGHtQWQTk/tteCs/fKgSdONr+XuZLWZWfeFQcP
         oj0zmUXbaa4waj5+myBH1dABxrasZuSotjatgO527OPj8KLOpGPN9VrBugPwu+S+hQ
         JTI99DuGIki+Km1PRFHUy5mFlw9ayU4XoKVEer9OKDvpkg1eXXeV9GRt97Tjvo9j4c
         UMhAwC7tovBRg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 253DE60A59;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sun: SUNVNET_COMMON should depend on INET
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283220814.6805.7628425135389205973.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:30:08 +0000
References: <20210927214823.13683-1-rdunlap@infradead.org>
In-Reply-To: <20210927214823.13683-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aaron.young@oracle.com, rashmi.narasimhan@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 27 Sep 2021 14:48:23 -0700 you wrote:
> When CONFIG_INET is not set, there are failing references to IPv4
> functions, so make this driver depend on INET.
> 
> Fixes these build errors:
> 
> sparc64-linux-ld: drivers/net/ethernet/sun/sunvnet_common.o: in function `sunvnet_start_xmit_common':
> sunvnet_common.c:(.text+0x1a68): undefined reference to `__icmp_send'
> sparc64-linux-ld: drivers/net/ethernet/sun/sunvnet_common.o: in function `sunvnet_poll_common':
> sunvnet_common.c:(.text+0x358c): undefined reference to `ip_send_check'
> 
> [...]

Here is the summary with links:
  - [net] net: sun: SUNVNET_COMMON should depend on INET
    https://git.kernel.org/netdev/net/c/103bde372f08

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


