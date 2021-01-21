Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFC32FE2A9
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbhAUGWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbhAUGUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 01:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id ACDFD2396D;
        Thu, 21 Jan 2021 06:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611210008;
        bh=3OUlOwnyM/Lq6dcSDU7VFLAgwB1L2BEv2nrFHtIfGZI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gmkaysQdC+C8KtxfnWCiL2l1hwazNyxA0OR4MXtwUbkKsDwt8HFJt7qqyMhqsA21m
         Co+mJDRLp/cpuhF8jjEhJImipHZ04+ocPkEl+ALKr6yYCvkgzDt4L7Gvqnvml8tGPw
         RntRHXrv+hcH+bFN1+ZlD0OtZisD1gip1VEewKcLUzRQrpvznrmezLzPD9BIOSl0AS
         +zgBGLkh5VBugmE8sTD3CyHnmYRmspReCGGYa7lLGKB4b9iPQwlPTHvgdhkuQtF7Nz
         yO9BUqkZrE/CWYTwDpiAAnnZhVzET3QdbjvQkf+Nzg3oq+q5L101IdWTALM8IAvnLI
         e5bVBLDm0o9Bg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 9F67660591;
        Thu, 21 Jan 2021 06:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: fix the RX delay validation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161121000864.22302.2434343187659178869.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 06:20:08 +0000
References: <20210119202424.591349-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20210119202424.591349-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        martijn@martijnvandeventer.nl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 19 Jan 2021 21:24:24 +0100 you wrote:
> When has_prg_eth1_rgmii_rx_delay is true then we support RX delays
> between 0ps and 3000ps in 200ps steps. Swap the validation of the RX
> delay based on the has_prg_eth1_rgmii_rx_delay flag so the 200ps check
> is now applied correctly on G12A SoCs (instead of only allow 0ps or
> 2000ps on G12A, but 0..3000ps in 200ps steps on older SoCs which don't
> support that).
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwmac-meson8b: fix the RX delay validation
    https://git.kernel.org/netdev/net-next/c/9e8789c85dee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


