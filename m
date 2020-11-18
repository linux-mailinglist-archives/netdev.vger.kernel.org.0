Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F4F2B8443
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKRTAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgKRTAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605726005;
        bh=r2gyf7xxFD0horszLR1CBycCapevG4ZjY6FEsxqO2Ds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=xnAqeuOiJ1Jh0jf+4Ew5aieKfTY4AS3+bB0ULUzcsSEi/ggpECJashxFw06sUEDZN
         5ZWDfifkE8SsWxL0yRJ4V3BMpdcr4xT5XG9tr5pBbTSO7aNdR7upEiWGgMx2WpHeEl
         lYWmO7NgXJNU6+2Cb9M6lvnI1wRSC1fKvezV73yc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ah6: fix error return code in ah6_input()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160572600552.13455.2538453699619946801.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Nov 2020 19:00:05 +0000
References: <1605581105-35295-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1605581105-35295-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Nov 2020 10:45:05 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] ah6: fix error return code in ah6_input()
    https://git.kernel.org/netdev/net/c/a5ebcbdf34b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


