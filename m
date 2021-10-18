Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68233431A45
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhJRNC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231774AbhJRNCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4994960C4B;
        Mon, 18 Oct 2021 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634562007;
        bh=8HpdSPeUYR+bML378L0bFpqjKwq0oStTcn5xlWmu8Qk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iNNrm+1/rbkPSH3wTyI/jcsZLjX++FhDkgEMmee6XlKcgZ8LjnHSay5+K7KY6/hCr
         KzgibhT8OeenKXqEPiMxHEThrd5H6rAuQcUgzp+v50UqdZClEcVPMG2f3ghe5mo6zh
         nIqwAepG5RkhY7YvtGwcvtlAEY5V6g1ZG2hQu+YauW63PB05EthuVNSUMyLOT8EzkZ
         W9iohnGvNp8l4wEAOYDoQE5BhAl2M8ElsMZrWQOUEXUDYuC7BChSEfGxGLfG9gnNvg
         cd6SNG6IlDj0K8n3rLirV6NaIl800A8fDfAfj2lvPfy1UCNcLe5qfL12XT3ntmlVp6
         f/T38P4fstAnw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D152609AD;
        Mon, 18 Oct 2021 13:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/tls: add SM4 algorithm dependency for tls selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163456200724.664.6690713814812446135.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 13:00:07 +0000
References: <20211018064201.75308-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20211018064201.75308-1-tianjia.zhang@linux.alibaba.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuhangbin@gmail.com,
        oliver.sang@intel.com, philip.li@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 14:42:01 +0800 you wrote:
> Kernel TLS test has added SM4 GCM/CCM algorithm support, but SM4
> algorithm is not compiled by default, this patch add SM4 config
> dependency.
> 
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - selftests/tls: add SM4 algorithm dependency for tls selftests
    https://git.kernel.org/netdev/net/c/d49fe5e81517

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


