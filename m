Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636B534D924
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhC2Ukf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhC2UkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 35FAB61982;
        Mon, 29 Mar 2021 20:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617050409;
        bh=c5fPop3ab3lhqC5T75SjhxwcTSFaaNAn/fSnWENGyHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K8h+TdzSUIwOGtIOTln/P9JPFG0PBZNthE7Ia5G7skjruC8XuU90OYkNy+lo7N9sn
         pfjtTECNOpv3oedUheMNR3tNwtuACOCWoftg7dreCpX5lrq83J8jurIeZ31enLy4Nv
         vnRU+pg3aKyOO0IDdUj9DOny+KzCUEKXZFcJUta7LDMSmPjhhFeXLqmgGni33+qp5k
         rUGRy2a66KhP8SnlUc6GOmozysj0dUvX15mr4txZno570EuD+4NLd9Wkq5nh/Bxez/
         +vsLg5pqJwXY+fuVqWPply8H4oovU3sQ3DJn3OQ6CPo44FXO94cBK9fJ+QvVVKEqUj
         w04JXhLukTYpA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2B53A60A49;
        Mon, 29 Mar 2021 20:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: Add entry for Qualcomm IPC Router (QRTR) driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705040917.15223.16891441257376220492.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:40:09 +0000
References: <20210329112537.2587-1-manivannan.sadhasivam@linaro.org>
In-Reply-To: <20210329112537.2587-1-manivannan.sadhasivam@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, willy@infradead.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        loic.poulain@linaro.org, ducheng2@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 29 Mar 2021 16:55:37 +0530 you wrote:
> Add MAINTAINERS entry for Qualcomm IPC Router (QRTR) driver.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)

Here is the summary with links:
  - MAINTAINERS: Add entry for Qualcomm IPC Router (QRTR) driver
    https://git.kernel.org/netdev/net/c/5954846d09e4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


