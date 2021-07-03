Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB23D3BAA47
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 23:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhGCVCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 17:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhGCVCh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 17:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 40B766143D;
        Sat,  3 Jul 2021 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625346003;
        bh=WoWguSRhGBMvcUlMNs/AZVamBMjLTGpu4FybcALivro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MCSdOaRdmWbUvFzX8NH7JrTMa4Z7EKDnDeaY/cJaUHSqRKXwBVreemMutGmZ5clMM
         0y9sN/AUlL+m2Ec0jhGdtTxDgP/IF8Sb2hTkZ7kv/Uk8gN1pamxsdsRAtaLA6r2k6e
         hSw7VZjEMR0PrIR5B9LJK/QlRmJfuInrBY+UczDRpddjolzqLHWtqFHJ0tN22Fh5px
         Khycf0cNxkGsmS31/YUKrITN3rjylfBP/470tsZQY31cTO4c5ovTuwMTHVLfrS/eHm
         Gvlc/lufOhkO6f2uuUhFTnfFiDtxv7O9Or/oZ0mjnpYBYNetn6RiVDyBFHbJMXDJEq
         b9/yiVdne0YTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E1EE60A27;
        Sat,  3 Jul 2021 21:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: always set skb_shared_info in
 mvneta_swbm_add_rx_fragment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162534600318.4273.9755451701338177610.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Jul 2021 21:00:03 +0000
References: <ddbed54495f68d75857d3ff7ab43d15a1274c3b0.1625339666.git.lorenzo@kernel.org>
In-Reply-To: <ddbed54495f68d75857d3ff7ab43d15a1274c3b0.1625339666.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, linux@armlinux.org.uk,
        thomas.petazzoni@bootlin.com, brouer@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  3 Jul 2021 21:17:27 +0200 you wrote:
> Always set skb_shared_info data structure in mvneta_swbm_add_rx_fragment
> routine even if the fragment contains only the ethernet FCS.
> 
> Fixes: 039fbc47f9f1 ("net: mvneta: alloc skb_shared_info on the mvneta_rx_swbm stack")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [net] net: marvell: always set skb_shared_info in mvneta_swbm_add_rx_fragment
    https://git.kernel.org/netdev/net/c/6ff63a150b55

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


