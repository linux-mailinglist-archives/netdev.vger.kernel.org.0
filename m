Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318EF34862B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbhCYBA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhCYBAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B023561A14;
        Thu, 25 Mar 2021 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634008;
        bh=8xafaDda35xoNscLpALBYDFePrWUuoPUzuv44t23NXQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nxLHPb4yTr58sS1gPkCYHuPLVwidbZuhIVRnaWBPFqFdj6BhzrFyqwC4Xc32PYS1k
         pVVKSJpex5aFZVeBOoDWXwNZ8dn/chud7zit7UgdsUBpnOHnhFcsaqRGetuEG955i0
         Bm6hno7R35cHRQyxcLj4eMtTgCoGiIO86iXv1hWnloO1/Dw+PU+VC+KXG5sDsnL9pa
         JANxPp5Tz/AwpPvXLhpfCQ85w1eS1So5+v3IKtgl6V+BGCKG7ECOrVoTVGx5u+jh2Z
         fRHTKBt11R36nXQ/eZuaw7y5nXSfBlELQwBz0Sn2k/usu74D10oPoau6h2+wtvIxUi
         7SxPB3fs9bYMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A27B860C27;
        Thu, 25 Mar 2021 01:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/tls: Fix a typo in tls_device.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161663400866.21739.6134745873412298615.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 01:00:08 +0000
References: <20210324061622.8665-1-wanghai38@huawei.com>
In-Reply-To: <20210324061622.8665-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 14:16:22 +0800 you wrote:
> s/beggining/beginning/
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/tls/tls_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net/tls: Fix a typo in tls_device.c
    https://git.kernel.org/netdev/net-next/c/72a0f6d05292

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


