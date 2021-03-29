Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C0334D8FD
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhC2UUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231825AbhC2UUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E444461996;
        Mon, 29 Mar 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617049209;
        bh=q3h5hm0xFMfkdioUUwjeXmPMulD63yR+BTuNqlQt4Tc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SaWmk1MknSJofyqVMOwKz0VVpks/ZEyf7kOQb7jESSDTVZt2xZ3mCR7WIhWpNotQk
         6ZOqBcWWrRN0aVUgkloG7z8FCkJQpCBkr5hMBpwm2Tgl0dt4Eqmb75q52mkcIRluTe
         JX0e/tV557o81w0ipzYm9lcOeqMYZrD9CDd5Z+KmgQo9G8RqmM8pHrzXPUF5fZ5CvW
         u5eTbfRFM2fjcgZb/JACx1TG3dNVKftCYGJwMnwiP5/7i6Ofa61qv0n0EsqV66i5/5
         zODT+nywd+OB0d2AxIb4snK6VIM7eZNOatBLgNjpBDeTUbUfpiVeoy4rLeaQZWPOTn
         P2lYJdLYLfWZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D70B060A48;
        Mon, 29 Mar 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: mdio: Remove redundant dev_err call in
 mdio_mux_iproc_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161704920987.7047.5617063483728797576.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:20:09 +0000
References: <1616981912-13213-1-git-send-email-huangguobin4@huawei.com>
In-Reply-To: <1616981912-13213-1-git-send-email-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 09:38:32 +0800 you wrote:
> From: Guobin Huang <huangguobin4@huawei.com>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: mdio: Remove redundant dev_err call in mdio_mux_iproc_probe()
    https://git.kernel.org/netdev/net-next/c/6be836818872

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


