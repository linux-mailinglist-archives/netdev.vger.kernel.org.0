Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F782C1AB0
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 02:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgKXBKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 20:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgKXBKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 20:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606180205;
        bh=QuoN6v046wqWzfROay9p6G6nYeSMi/ZaQtcigikJdZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SeZ0hKZ1X2wprrmXIYPFnNLGWhf6ahNytJ0zgUIOyk1nogPBzkHRXuddnyBCYBQpj
         sp8BFolxt4+KExErHwIyI4awjHWVRjg9buaYuYxDoQGrzyD/1XbUGnABOaNnEJkP4h
         mZp6gJzqY9BxLuUvgWbQU9Br9ya9ZBLx56dKpfBI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: pch_gbe: Use dma_set_mask_and_coherent to simplify
 code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160618020532.30283.4433703176583925818.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 01:10:05 +0000
References: <20201121090302.1332491-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20201121090302.1332491-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, kaixuxia@tencent.com,
        mhabets@solarflare.com, mst@redhat.com,
        luc.vanoostenryck@gmail.com, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 21 Nov 2020 10:03:02 +0100 you wrote:
> 'pci_set_dma_mask()' + 'pci_set_consistent_dma_mask()' can be replaced by
> an equivalent 'dma_set_mask_and_coherent()' which is much less verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [1/2] net: pch_gbe: Use dma_set_mask_and_coherent to simplify code
    https://git.kernel.org/netdev/net-next/c/8ff39301efd9
  - [2/2] net: pch_gbe: Use 'dma_free_coherent()' to undo 'dma_alloc_coherent()'
    https://git.kernel.org/netdev/net-next/c/7fd6372e273e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


