Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457B03AF5FF
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhFUTWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231518AbhFUTWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1EF426135A;
        Mon, 21 Jun 2021 19:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624303205;
        bh=5h/JTYuu+ee8W6bD2Exd1he3+J6TBvc/xljPEnpSyyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OUrn7XHmBQUodsWXXQztG1sK3DuTZZp4zOlCTnnz3nS6dYvblOc42pKqn9msxlnCp
         x+oT7LEc20MYtnj25WncfJYo51GKfTYHWItVNIM8bPoJJvXfvGwIqhhS+YwIR6nc5g
         GRMAVLgTBc8cP7n+EtmajuUBfmpuJj0qn3KwsRV/a/P54Kt67/91RoTOmwORWP2lG7
         zI4C7ZDBJxEHY4V5Uz7oWKYzsqWfF4L00zeK36WWoPRB4f7e7FabVSza8fezFY71Wl
         Vs/O1qd45eboYBwTvCzGqzlKxthF6pn8VgnnI1Uwb2X3UzVipEnb/wEaLXtMCbM1Y1
         HQu5aWro2BvWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 137306094F;
        Mon, 21 Jun 2021 19:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: iosm: remove an unnecessary NULL check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430320507.6988.18060097000636332929.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:20:05 +0000
References: <YM32XksFPUbN2Oyi@mwanda>
In-Reply-To: <YM32XksFPUbN2Oyi@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 19 Jun 2021 16:51:26 +0300 you wrote:
> The address of &ipc_mux->ul_adb can't be NULL because it points to the
> middle of a non-NULL struct.
> 
> Fixes: 9413491e20e1 ("net: iosm: encode or decode datagram")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: iosm: remove an unnecessary NULL check
    https://git.kernel.org/netdev/net-next/c/d5fff4629bea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


