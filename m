Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4DB3897C8
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhESUVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229625AbhESUVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6D4AB613B5;
        Wed, 19 May 2021 20:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621455615;
        bh=8g5eYBivg5IznIEAFIca9LAGXET2r1Xl8EQ+5RN/FhA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i6WjeXJ388iTn/zg3rN2ijLNAtEWXG93n2+Bn+H9aSGmm8EZNE1CSj4wjb/PoY+8y
         H2kEiSOV8vcM3dYVjGza6F2ByKt77V8tSGDsHZvFkrA+3p+zXVDEXXadfMRiF0EOXx
         r9BbuC4JtGeLkacJraOJGDIJMRI4kDl9sp4YzX6j58UtjE8p7YK2Rb/jmbvmrvfU5G
         broYV/aEK9RoGOcCsc//1YK4E+UxDTBI1Mz7xClU4wtxwCmpuVQRXa5RKNDWFfHOnw
         CoOePdJpt4xghGgpua6sZEc50zl+oRfLNAKs9+BYynYuPTE8IG79UH29j3szw1JH1x
         3cPiWE3B/0wNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 60C0A60CD2;
        Wed, 19 May 2021 20:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: qrtr: ns: Fix error return code in
 qrtr_ns_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145561539.14289.12444383566241954680.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 20:20:15 +0000
References: <20210519155852.2878479-1-weiyongjun1@huawei.com>
In-Reply-To: <20210519155852.2878479-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     mani@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com,
        manivannan.sadhasivam@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 15:58:52 +0000 you wrote:
> Fix to return a negative error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: c6e08d6251f3 ("net: qrtr: Allocate workqueue before kernel_bind")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: qrtr: ns: Fix error return code in qrtr_ns_init()
    https://git.kernel.org/netdev/net-next/c/a49e72b3bda7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


