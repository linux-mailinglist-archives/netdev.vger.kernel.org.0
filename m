Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9134D400B49
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 14:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhIDMLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 08:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234198AbhIDMLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Sep 2021 08:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CB96861056;
        Sat,  4 Sep 2021 12:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630757405;
        bh=/VFOJSeSZrSvxsBdyRd/+3bUuYlEWW2sfz8PdUhiDec=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kHi/XRz7M0GeHNRu5MHVZ2I7K3fNZO5JdX0XN0CDTiplDYGlCw180DkELIWcut6DT
         GU0cpU9t/iMm+Z7Eoxp4EK7WPIHXwomHui+Uci7UeRojk1bQKQKUWlFZKUtxgnh6SK
         DBVjtNult17zGgHsxsiBQHKkiguZRK1xzHrMJC2qs2XffMFDOjvCty+UWqt8+YVOBD
         3jxUUBd3fPChOuznhnPOm9no7MSD7A+s4Q+8MmG2JXdtvuk34NHdb+FzDuRefC/3gN
         UhPSJ7O9ZgulG3rQxtgiHhROkNbBacHexopJJxm5JkWSi1uAKMJ/dTGPeTwTFv9egY
         XeAEx7NYAfmSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF92E60A17;
        Sat,  4 Sep 2021 12:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] octeontx2-af: Add a 'rvu_free_bitmap()' function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163075740577.14004.1501295822330235080.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Sep 2021 12:10:05 +0000
References: <37f3e7e21a1c0f29244b807e5b995b2abeec6c3e.1630738450.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <37f3e7e21a1c0f29244b807e5b995b2abeec6c3e.1630738450.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, skori@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat,  4 Sep 2021 09:34:41 +0200 you wrote:
> In order to match 'rvu_alloc_bitmap()', add a 'rvu_free_bitmap()' function
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 5 +++++
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h | 1 +
>  2 files changed, 6 insertions(+)

Here is the summary with links:
  - [1/2] octeontx2-af: Add a 'rvu_free_bitmap()' function
    https://git.kernel.org/netdev/net/c/d863ca67bb6e
  - [2/2] octeontx2-af: Fix some memory leaks in the error handling path of 'cgx_lmac_init()'
    https://git.kernel.org/netdev/net/c/ecbd690b52dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


