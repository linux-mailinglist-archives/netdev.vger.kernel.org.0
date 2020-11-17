Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD302B6DB5
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgKQSuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgKQSuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 13:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605639005;
        bh=2+6raDxGhfkWRc5phxnrpZVoWjGGX8EaEVs2MAoMxyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gxJY/zwZi2jMygUI3MabLtByFy3dCW004Xb584wxMmkVx3daYR9NkiOrijoFmfUW2
         xqWqMdmDE4jIP0B+ldtaqjRK/4qo1oo6ZvokEQ0PMdFOwHDF7krBn0y+TnsNx5MGp4
         htDNnb+Gy7ZDzXF2Z/9NnBhIYK8/wEaXBzIvpjDk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] qed: fix error return code in qed_iwarp_ll2_start()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160563900507.10412.7675676667561122479.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 18:50:05 +0000
References: <1605532033-27373-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1605532033-27373-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, Michal.Kalderon@cavium.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 16 Nov 2020 21:07:13 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 469981b17a4f ("qed: Add unaligned and packed packet processing")
> Fixes: fcb39f6c10b2 ("qed: Add mpa buffer descriptors for storing and processing mpa fpdus")
> Fixes: 1e28eaad07ea ("qed: Add iWARP support for fpdu spanned over more than two tcp packets")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] qed: fix error return code in qed_iwarp_ll2_start()
    https://git.kernel.org/netdev/net/c/cb47d16ea210

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


