Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C6A396D07
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhFAFv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232963AbhFAFvr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4B49A613AF;
        Tue,  1 Jun 2021 05:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622526606;
        bh=cwg187BJdGvTdqYbd6sZbXsPyY7wlA2owvOfevF5+q8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jugd9cFPjT0/UQaeb7i3P6A3t9KYZpJYTH7QU2Sl84DPBZS+OcAvPbLnY4mSKxhAw
         cR2r0xOngvENng2vgpe7toY2hlcAeHuohaXDXlUoMLXvKHuQKVFredh79P7gzymOcn
         qgHXe7YE8GfeunWU67hYWDH8o0RBb+wA4YiwcTicwgpi/oCM+V8k2j6P8SCwSYRRKq
         mxrCvLbcfbd4jGH6ZIqOImUyNKG0xnAc2JjRBHR8VLyE7ye/FWTXnjS4wcn34aXw1Q
         DL15NgWKwwNFb7bSp///sSBVJfUso2BmDlf2IqYUjeqplryB5IuaxEQai0kLdC8rm3
         qJl2qSqn2zaHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 455C060BCF;
        Tue,  1 Jun 2021 05:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfc: hci: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252660627.4642.7911515813513605902.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:50:06 +0000
References: <20210531020019.2919799-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210531020019.2919799-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 10:00:19 +0800 you wrote:
> Fix some spelling mistakes in comments:
> occured  ==> occurred
> negociate  ==> negotiate
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/nfc/hci/command.c   | 2 +-
>  net/nfc/hci/core.c      | 2 +-
>  net/nfc/hci/llc_shdlc.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] nfc: hci: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/01709d0977d4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


