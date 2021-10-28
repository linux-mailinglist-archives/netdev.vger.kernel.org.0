Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227AC43E29C
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhJ1Nwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhJ1Nwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 950DE6115A;
        Thu, 28 Oct 2021 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635429008;
        bh=QRfZHRiDDUSb6KzzBOq6pSbrC/HHB7QKpi//APd0BCk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BrzSnXMj6mtncgHIuZouyJfoEmaCCwh1QkHWtge4ha6WRM/9KiA7t5o7zslqitI/e
         SnII/Nmpe460XxvEduvZdLC+OV9/r9gNJ0pQ+MtCHyS1aLNmG0J/uVOXu+05tpU4zz
         wCbhK/qEjfX5Ua8wZFch5WpXNmq6R51+NOd1TiRZNK+2x8Su4xC1AQV75cFV+zPUdA
         rZqNI+66htTnvy217KmDJLIg+4pbYIfY/4SLNy+s0Bxx84j0Vl2ak3Xgel0yLOw/B9
         5h2QxMvYO6GIwCjFBIRnnr5eJOGSRlsUdE7RYEpPNElhvwDz+x3UifJ6x1QTL+xk+7
         aYyJYfysCWo6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8BB1960972;
        Thu, 28 Oct 2021 13:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ipsec-next v2] sky2: Remove redundant assignment and
 parentheses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542900856.8409.12070653312110205850.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 13:50:08 +0000
References: <20211028031551.11209-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211028031551.11209-1-luo.penghao@zte.com.cn>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo.penghao@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 03:15:51 +0000 you wrote:
> The variable err will be reassigned on subsequent branches, and this
> assignment does not perform related value operations. This will cause
> the double parentheses to be redundant, so the inner parentheses should
> be deleted.
> 
> clang_analyzer complains as follows:
> 
> [...]

Here is the summary with links:
  - [ipsec-next,v2] sky2: Remove redundant assignment and parentheses
    https://git.kernel.org/netdev/net-next/c/6a03bfbd5ead

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


