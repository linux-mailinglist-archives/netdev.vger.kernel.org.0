Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924E43FC671
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbhHaLLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241418AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 557C861051;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=Y+6H2U6arzL4lpsLD1gSJ8x8hm7obJC/W7vvwDDsiDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DVVp6X6Mdy3+vO0cPc1xAS6g0tLyKTzJAprhx3H22UcEgqmVgj4KnhpLGfuvDPcgM
         ao2Q+Z6m4K4hN2EKRi+PCkoxqCrxn5rrwsJI2fjMkb4hWANcr1VHlgn4Ncgm+7yNEx
         9C1ROJb580pQVXSzX6iTQSPBtGacxElsxvfxtMuiEvej8uypqll44turZJdxnNVZMp
         8dsdCYDUKScysf3H7VSHMUqrERnTpex4J5TmPFRiGrOTEhQj+PDcfPy4mERoo6B15t
         VPAslEKCO9y51iV5WYZ+Lynv0C4wQYH/T1GXrd27MTmuzfJTpkaAWTxhMzrw7GVElJ
         A5KoX2+rfDlMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F77C60A6C;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Use NDC TX for transmit packet data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820832.5377.15835836242101929765.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <20210830125518.20419-1-gakula@marvell.com>
In-Reply-To: <20210830125518.20419-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 18:25:18 +0530 you wrote:
> For better performance set hardware to use NDC TX for reading packet
> data specified NIX_SEND_SG_S.
> 
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 3 +++
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h | 1 +
>  2 files changed, 4 insertions(+)

Here is the summary with links:
  - [net-next] octeontx2-af: Use NDC TX for transmit packet data
    https://git.kernel.org/netdev/net-next/c/a7314371b3f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


