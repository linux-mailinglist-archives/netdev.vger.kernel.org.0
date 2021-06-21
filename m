Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988853AF62B
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhFUTcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231232AbhFUTcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8AA7A6124B;
        Mon, 21 Jun 2021 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624303805;
        bh=FHds1gTMCs52LtRg3T1vS3H2PX31kq86sX1BDl9Hd2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W/5D42jppMAUt6guwGkkT2cDE7x89xDJRS3NngrahybYEOrnUXJI+NYaNqks0oEPe
         82YOFn/ehQeeDJ2KNmsDxeJD+dH5XsCO8sRUaBeNSVJcFBMXPEaU7QY2KOSXFnODzY
         qf40nvUoZeofaVm3VjZC83mMx9O1gsVn6aJkVqfA4E3FmI/WBCXwIv3e8Aw0hncFMK
         g5kB8TS9ek1Hkw7VO4k2NwgL/cHm+St4JibNN3faZOGTVt3Fzt4QgPC6rjWcBBoQCA
         UnOafI0xEWk9MjaAdDBE88JBt//0/3P4vl3xGo2fT0g4TR/CIW9p2mWUzFllRg7dcq
         GeoroJpLO//yg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B9BA609E3;
        Mon, 21 Jun 2021 19:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower-ct: check for error in
 nfp_fl_ct_offload_nft_flow()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430380550.11970.15653260321035331562.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:30:05 +0000
References: <YM321r7Enw8sGj0X@mwanda>
In-Reply-To: <YM321r7Enw8sGj0X@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     simon.horman@corigine.com, louis.peens@corigine.com,
        kuba@kernel.org, davem@davemloft.net, yinjun.zhang@corigine.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 19 Jun 2021 16:53:26 +0300 you wrote:
> The nfp_fl_ct_add_flow() function can fail so we need to check for
> failure.
> 
> Fixes: 95255017e0a8 ("nfp: flower-ct: add nft flows to nft list")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/netronome/nfp/flower/conntrack.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next] nfp: flower-ct: check for error in nfp_fl_ct_offload_nft_flow()
    https://git.kernel.org/netdev/net-next/c/43c9a8111680

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


