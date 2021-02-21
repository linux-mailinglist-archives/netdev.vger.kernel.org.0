Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A428320E08
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhBUVkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhBUVks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Feb 2021 16:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7114660295;
        Sun, 21 Feb 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613943607;
        bh=LLlqcfsHxmYKYRCb4EI0tj/NUfG5wOi/VhSNNDcO/0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=amkMxveI4gvUX9HxumP7oW/UTJJaKfbf5q1k8gpCEj0wYOtSIdQUMb5r4o/RkdTUH
         57lCsHHl/l2NCS1g8IOXQIShfwwsugMyX33HtmldvEXNCLCBKhXriFcGUfpi4ZBLgk
         PjTQfpE09KgqOTpY+PNUj4rcBqT7qXGxxv9jpWBJcvchFfZdDTLuGHeadcVdpvA1s8
         lvp+/LfYGoOUuWDWsArru15VABDnOzwWyIIlkwtvkEQ9Dxr8yzzQRNv1nIzxeK5zft
         vAAQULvoV0iZuZnxEZdz6V/DiKftkI7TRET081AKyBFOvB2Ce2kGP1XUSlBKfaZUwz
         Jsb6H7CnoNtjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E28D60192;
        Sun, 21 Feb 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161394360738.30147.9858725192425932627.git-patchwork-notify@kernel.org>
Date:   Sun, 21 Feb 2021 21:40:07 +0000
References: <YC+LUJ0YhF1Yutaw@mwanda>
In-Reply-To: <YC+LUJ0YhF1Yutaw@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     sgoutham@marvell.com, cjacob@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, davem@davemloft.net, kuba@kernel.org,
        bprakash@marvell.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Feb 2021 12:56:32 +0300 you wrote:
> This code does not allocate enough memory for the NUL terminator so it
> ends up putting it one character beyond the end of the buffer.
> 
> Fixes: 8756828a8148 ("octeontx2-af: Add NPA aura and pool contexts to debugfs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()
    https://git.kernel.org/netdev/net/c/3a2eb515d136

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


