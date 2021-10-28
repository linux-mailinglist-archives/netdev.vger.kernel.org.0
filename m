Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD743D911
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhJ1CCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhJ1CCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 22:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0A61F611CB;
        Thu, 28 Oct 2021 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635386408;
        bh=K/kUA4LT2CL7mLQ5W2sfv3qRuczcFJRxu/F+13XxkdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YO63vXfhZ/wj3C5+lrvnAtldTsWghc1DI5IR/GlSBx0xnle8JYsn+axQh5fzGUmfx
         KtTXBfgEiSHzo4Omi/JzoM0e092s8nPjzuVu/SAqonyA3rgPqEZwUpnAkQa/G16p/5
         caAzlInw4bSWklIOVi+d6FHH4jTQB/A+R9bIOMniXYKqk1mxXmOCDlzK1dQwweeaIO
         HPU6As9nENfyxBr3+LnxGI5WlPDzFqDYW14sfX3JHoGzgnPcjHExsiGBrc7hVbb0oR
         ymjs8gkXnsTdVz00DFv8QzCgoiRwiUPUuxhirFaeW/lovY/pLshAkgzPscs2m0DPQI
         iPCDOJV4tvNww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EDE3960A88;
        Thu, 28 Oct 2021 02:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] inet: remove races in inet{6}_getname()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163538640797.25351.7961559914670845277.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 02:00:07 +0000
References: <20211026213014.3026708-1-eric.dumazet@gmail.com>
In-Reply-To: <20211026213014.3026708-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 14:30:14 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported data-races in inet_getname() multiple times,
> it is time we fix this instead of pretending applications
> should not trigger them.
> 
> getsockname() and getpeername() are not really considered fast path.
> 
> [...]

Here is the summary with links:
  - [V2,net-next] inet: remove races in inet{6}_getname()
    https://git.kernel.org/netdev/net-next/c/9dfc685e0262

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


