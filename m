Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B45D33FAA7
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 22:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhCQVue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 17:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230341AbhCQVuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 17:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CBF764F41;
        Wed, 17 Mar 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616017809;
        bh=ePsnxYxjNuvHnyCfR+GP/xpqFXmfv1m9DaD11RMkJzg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HPqBLHY9S71lGeDx3rWOgOiHiM6pdfaAGWOCVqeR5Q4yaE5WrCMU7yrZfA3wK+H6r
         HzDP9GUktdUNj1EDdxDY/2TE7bcCnEH7Dh9aG9BDQHaF0NnztAQzcKxQ92nI+F2IZQ
         aSIV0rIjXgnwrETeA8juvLHmv9egebuwY4UmAy5m2NGHHb4+pRwDVrzfsVx3DdMgzb
         tm5Y0Jbswsw1ef4FvFuWGeCoSKfYDTM0rqy5D20z4/k9C/L/oldR0/Am+XA6y9EuO6
         guQvGFruMNRJEHJTmBrhqwVTZ5LQZwbLUUYziwORm9Fs+lBCkOc+3qV5opMB+7musi
         +NRD4tYICSJVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 923E660A6B;
        Wed, 17 Mar 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ethernet/broadcom:remove unneeded variable: "ret"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161601780959.9052.7682040234724827494.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 21:50:09 +0000
References: <20210317122933.68980-1-dingsenjie@163.com>
In-Reply-To: <20210317122933.68980-1-dingsenjie@163.com>
To:     None <dingsenjie@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 20:29:33 +0800 you wrote:
> From: dingsenjie <dingsenjie@yulong.com>
> 
> remove unneeded variable: "ret".
> 
> Signed-off-by: dingsenjie <dingsenjie@yulong.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [v2] ethernet/broadcom:remove unneeded variable: "ret"
    https://git.kernel.org/netdev/net-next/c/f0744a84f361

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


