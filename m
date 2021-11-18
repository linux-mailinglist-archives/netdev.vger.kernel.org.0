Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CA8455B48
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344549AbhKRMNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344563AbhKRMNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 07:13:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 73BD861994;
        Thu, 18 Nov 2021 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637237410;
        bh=2dkKzG73VbZAOpjX2kBgskSPlqgDU89L/w1tzRY0S2E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qas/S5S3ArzhzZg2p1KmQ+KTVLEl3DHZUbXZWJ81NW5/OKBkXfCoKUfz5OIv12NGG
         wkeAWpLmDj44eCSZ1AEdL4cdH2n6u/y1Bov0Ip/bZGk7yVtug+lUcsHjaQIYEk71ef
         lB6Mq7YJtPBGBvqNoRSR5NzqB4zetqPUVqiAsJz1bCgo4a9hBMd0Ln3K0b72wPs847
         pT4RVT0REWaJipD59NuZOgeMaVqtgLMf7qDvDkBDRPGFYUE+BUurDCHrwTaVcTEoaI
         22P0R0Vzi3RHg3ErcjSUFI0YVCaWzWKubzPwZVTeP8BdIbIlnlZcMRZcAHakOCAWB1
         VsbxjVpeU4uRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5EE2B60A4E;
        Thu, 18 Nov 2021 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: ah6: use swap() to make code cleaner
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723741038.26371.9690981781871973240.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 12:10:10 +0000
References: <20211118061018.163920-1-yao.jing2@zte.com.cn>
In-Reply-To: <20211118061018.163920-1-yao.jing2@zte.com.cn>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yao.jing2@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 06:10:18 +0000 you wrote:
> From: Yao Jing <yao.jing2@zte.com.cn>
> 
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yao Jing <yao.jing2@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - ipv6: ah6: use swap() to make code cleaner
    https://git.kernel.org/netdev/net-next/c/4cdf85ef2371

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


