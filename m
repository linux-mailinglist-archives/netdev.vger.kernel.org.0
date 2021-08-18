Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63C23F0E0F
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhHRWUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234106AbhHRWUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 18:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 976826103A;
        Wed, 18 Aug 2021 22:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629325205;
        bh=bqPkbAeTMqgeqxawU9F02qdmd7fXTAn8RsMvsk4nVng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YDFrl/kA78wWRsT/USYoTIzatOADCn8Te2TSCb3wTIPS1M+s4zL8TUytpMysB3svg
         uwvDqdlWt1nbf0Z3N5xirv+DBFnZacxD6J93k/jMSf6ZI+y2AQOsMhP8oyDH3IVRS4
         MOLXEwSCkd8L0HU++50VQhTzDGxpG3aksZVbCDlk0ZdWz1MKeqRMpub1c7YOFNlSJD
         LkYwjVJuVIqBqnCpQwljUbXSzDm173yB6ZJiq1MthG3aMdZhpnDJdqUf+agrH21BNj
         Z2FR5qoi0UsSpPLIMDGCzVl5i3Xr0oVaX+wufYBHnjVbJvYBEzd1L5Rz4HgImvZRYN
         YPu39E07qTqQA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A688609EB;
        Wed, 18 Aug 2021 22:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx4: Use ARRAY_SIZE to get an array's size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162932520556.31273.6111065884005742758.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 22:20:05 +0000
References: <20210817121106.44189-1-wangborong@cdjrlc.com>
In-Reply-To: <20210817121106.44189-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     kuba@kernel.org, davem@davemloft.net, tariqt@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 20:11:06 +0800 you wrote:
> The ARRAY_SIZE macro is defined to get an array's size which is
> more compact and more formal in linux source. Thus, we can replace
> the long sizeof(arr)/sizeof(arr[0]) with the compact ARRAY_SIZE.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net/mlx4: Use ARRAY_SIZE to get an array's size
    https://git.kernel.org/netdev/net-next/c/19b8ece42c56

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


