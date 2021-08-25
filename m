Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110933F6C66
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 02:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhHYAAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 20:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhHYAAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 20:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CD28061360;
        Wed, 25 Aug 2021 00:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629849605;
        bh=EPtNGh4XBzgLqNlVWIazw4sdwinUKrJ9CJgECghoCKQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sgB4nRPUjr9y+Fozb70woFWUlU8jbK6GIGcCwyTCBlFNwFpNKyMtZtZyk4gjnI/Th
         w4x0moVGdtBzsXvBc8sBavqzYXxX1GNfhLaruoqaSwaKvB0KC0k3bc9uvuTXlmva78
         MpR4ysk0kwGHCx7RH90ndVfl/joEBIu3aC7VETSw1yez26jdRaVRkAaTqT6PhSqGRQ
         axc0oL2fshF6+mLdOi+o7QuMc+vnkDphtvi5yef2vQb/XfsIaMr3t9Xc5SToYpsn5r
         0vZZ4lfJfanYVPuF18ljo5G66hc5CQhjUowcNa2MqnIuD316W6dydRWFzgfNm5ZdGW
         Ip9e5uPe3dUcg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BFB986097B;
        Wed, 25 Aug 2021 00:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/net: Use kselftest skip code for skipped tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162984960578.4140.4440536748186545093.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 00:00:05 +0000
References: <20210823085854.40216-1-po-hsu.lin@canonical.com>
In-Reply-To: <20210823085854.40216-1-po-hsu.lin@canonical.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        skhan@linuxfoundation.org, petrm@nvidia.co,
        oleksandr.mazur@plvision.eu, idosch@nvidia.com, jiri@nvidia.com,
        nikolay@nvidia.com, gnault@redhat.com, simon.horman@netronome.com,
        baowen.zheng@corigine.com, danieller@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 23 Aug 2021 16:58:54 +0800 you wrote:
> There are several test cases in the net directory are still using
> exit 0 or exit 1 when they need to be skipped. Use kselftest
> framework skip code instead so it can help us to distinguish the
> return status.
> 
> Criterion to filter out what should be fixed in net directory:
>   grep -r "exit [01]" -B1 | grep -i skip
> 
> [...]

Here is the summary with links:
  - selftests/net: Use kselftest skip code for skipped tests
    https://git.kernel.org/netdev/net-next/c/7844ec21a915

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


