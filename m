Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE9D31A8F7
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhBMAvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:51:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhBMAu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:50:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0537864EAA;
        Sat, 13 Feb 2021 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613177419;
        bh=J2BTZtrf8H6YIk6pNZwHutyul8XVpEIKwcWt0basveE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sNIl5NQ5b9kp23Ulmdwyy/esPCAu7UQgXqdHE+H0/hgG2lJ6S3BliD69k1APQXte8
         UevhU9s40y0POHFY2i5MseQCq5X7J5D78cMmjRsaW5dE3nJ8fNZ82hLuCkQBJxizBC
         pd98/99i10UclhO7x2uST63Bc2Q1+/9uYeo6D0jQJTClQoRS5aX282Ebcbrd7j/0gB
         9zRBi+wEK18CA6C/oDSCUlWcRGfHts2xbOofmAsCeKcjh0AaK5qTa7A4NvoKXPzNMi
         pyw4QHsxsu0YsroVOwohKYsz86BD7tcyMgtFGDPQWD3W+4Wuq1djzqyXIaU56I8U3/
         CfSNIRs3iSwkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F051E60A2F;
        Sat, 13 Feb 2021 00:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND net-next] rxrpc: Fix dependency on IPv6 in udp tunnel config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317741897.7081.11501991395463776624.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 00:50:18 +0000
References: <20210212104814.21452-1-vfedorenko@novek.ru>
In-Reply-To: <20210212104814.21452-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     kuba@kernel.org, dhowells@redhat.com,
        willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 13:48:14 +0300 you wrote:
> As udp_port_cfg struct changes its members with dependency on IPv6
> configuration, the code in rxrpc should also check for IPv6.
> 
> Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] rxrpc: Fix dependency on IPv6 in udp tunnel config
    https://git.kernel.org/netdev/net-next/c/295f830e53f4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


