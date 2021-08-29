Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401223FAAA5
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 12:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhH2KA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 06:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhH2KA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 06:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D1B1760E94;
        Sun, 29 Aug 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630231205;
        bh=bf39DLPRpFLQLU7qP5hJ8jEJigQQ58cqA7mArihAzHI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XDOIdamjCukLyzXwBGBwUr7N4AE0LkGS5un8qP0JZWMuJTlNo74Zcb8kONKanUJ/J
         8idhdeFLCvR/KLIAqcpr33/clrbbrUe4h38k+bi71AUhmKLzUo8xASaKwhER+6tpAz
         GkO9Rd+yjwg6jnJPNXtjrYjsdOkXweR1vDdgkj5bJeeEsEDeX3QbzxSdW+gX6jX+Ck
         qmM8iTGflfe0xQHrhklYjnQqu/+YihOW+HrGhoZkIqsftM8vxG0Z4ACrLe6Q4Nm3o0
         DEny1xkkfWrjo0EZCbCggf5++dcY+VtHv6AtUKJ27Q2yUjljrKw/ab0LGIXswrjYU4
         eGl59FqixqcKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C7F2360A6A;
        Sun, 29 Aug 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fddi: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163023120581.23170.4945897183136463788.git-patchwork-notify@kernel.org>
Date:   Sun, 29 Aug 2021 10:00:05 +0000
References: <abc49c24a591b4701dd39fa76506cfdf19aff3cd.1630094399.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <abc49c24a591b4701dd39fa76506cfdf19aff3cd.1630094399.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 22:00:57 +0200 you wrote:
> In [1], Christoph Hellwig has proposed to remove the wrappers in
> include/linux/pci-dma-compat.h.
> 
> Some reasons why this API should be removed have been given by Julia
> Lawall in [2].
> 
> A coccinelle script has been used to perform the needed transformation
> Only relevant parts are given below.
> 
> [...]

Here is the summary with links:
  - fddi: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/a3ba7fd1d3bf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


