Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACEC35485F
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 23:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242636AbhDEVuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 17:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242331AbhDEVuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 17:50:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 88756613CA;
        Mon,  5 Apr 2021 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617659408;
        bh=roulerN48odcwlfYZEmuFOlA7eA5p6knvAW8ZjnUQco=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X6zMgS1n3Unb2TpviriWR6F9cm9+WtjhELb6RRXZ6uGzYrD656OVoxBzd6a1jM1Uy
         txIvQKqvlq8Ixgu/eESYPWYdnh5j7JaWjT1wfjo+FuphDI5ITqkkZzqief5KO6l4VE
         9A8IkgigshsNdOAszSGvKRsaXlPXe8AwFg1h4qBn9IT1dJJojFYTL9nHbZHm0zfyj5
         XOV24lGBSb/bn7gEpgyY7TpfDcujfLTomPvclK7VMJDa7J505tW4yhObJIClFkCuOV
         kYwoRvutLczGgBaJiVI66vpBJAV3aP0iTl3++JxchzIL+f4JcZ5j0Ag1Qiv4g3AR1F
         ekHM3lxI8BQHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D6A760A00;
        Mon,  5 Apr 2021 21:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: nfc: Fix spelling errors in net/nfc module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161765940850.17352.15885512138081985656.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 21:50:08 +0000
References: <20210405105435.15747-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210405105435.15747-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 5 Apr 2021 18:54:35 +0800 you wrote:
> These patches fix a series of spelling errors in net/nfc module.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/nfc/digital_dep.c | 2 +-
>  net/nfc/nci/core.c    | 2 +-
>  net/nfc/nci/uart.c    | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net: nfc: Fix spelling errors in net/nfc module
    https://git.kernel.org/netdev/net-next/c/d3295869c40c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


