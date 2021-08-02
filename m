Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230343DE22A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 00:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhHBWK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 18:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232094AbhHBWKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 18:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 771F360E78;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627942206;
        bh=Cl2WcD4nTC2dMOkzPaWYmUD3pw6zf6LV9KGOPOAuDXY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RR1aPSVUu9CGDohInd+8P3ShanwZ5/CY4kdRyiMb+eho6rInUDd1vDmU/+YmoyiMS
         knMnvqIzQlNSkiC9P5YMI5c5ojASNzNPzsu9pbooNJtX2JoGktvR4Xjtkhjbg6Y2Eu
         uu12ZQXM5U2h2vExG9s1PyGLgu+oh4AEIZEArIFNlZUe03bkjwlC/43dGV2gw0YxER
         W3CWzAxvBhp79mFVttBXL2nFYEAcg3CJ7uaZ8V3QUlZzCa29TSCr31WWARFuN/SYdD
         s76sQDVTWQNOYNxUKnfFvizfBRpwvzA4LlOhuPrTYyC/HU26itvgVFzzxvCVP1iGeX
         GH4TVrPIHcSXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 720A06098C;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dpaa2-eth: make the array faf_bits static const,
 makes object smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162794220646.7989.7869180322597079523.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 22:10:06 +0000
References: <20210801152209.146359-1-colin.king@canonical.com>
In-Reply-To: <20210801152209.146359-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Aug 2021 16:22:09 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array faf_bits on the stack but instead it
> static const. Makes the object code smaller by 175 bytes.
> 
> Before:
>    text  data   bss     dec   hex filename
>    9645  4552     0   14197  3775 ../freescale/dpaa2/dpaa2-eth-devlink.o
> 
> [...]

Here is the summary with links:
  - dpaa2-eth: make the array faf_bits static const, makes object smaller
    https://git.kernel.org/netdev/net-next/c/d5731f891a0c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


