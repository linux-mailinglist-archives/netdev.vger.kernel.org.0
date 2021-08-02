Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EDB3DDAC0
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbhHBOUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236458AbhHBOUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 774BF61029;
        Mon,  2 Aug 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627914007;
        bh=aA+DZslmPStiTUWZaOPkeOB9KFkUCERmtFZuhkcNalA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Np54+P/Q3UY6sdUBVkzAL2jWHzmZX2A1tbgPqMJw1h4dJbgdhMxCZFS/0n1mtO1eN
         IXAcWNMbQClVXQMDMzHZ4i+/RlqWF+stlN/7esmMdAgV5PAkC1pphWAo7F6oOfCxTA
         obkaxUHc2PvdomYXKqHGwGoUdapcIVa2043Y3t/wmVb31GnI1EZ6QErT1jzeAiJ1WL
         7I1BHZSjHrn2wwh/v8LYWPK7ZMX112w4s37zAUP8np1E67WZsqQeMw637PZ2TX5N2O
         tHCckEwoaRLGCjfSe0XCErYao3CxAitJnok2ve03hOSC0Jfed8Bv4asuuPcNyEOAzZ
         yAcRUfpiBPO3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 71DBA609D2;
        Mon,  2 Aug 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cavium: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791400746.18419.15767649410545938098.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 14:20:07 +0000
References: <27c2b1a5152add2b3ecdfded40f562c5e4abed14.1627714392.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <27c2b1a5152add2b3ecdfded40f562c5e4abed14.1627714392.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 31 Jul 2021 09:10:00 +0200 you wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below. It has been
> hand modified to use 'dma_set_mask_and_coherent()' instead of
> 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.
> 
> It has been compile tested.
> 
> [...]

Here is the summary with links:
  - cavium: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/1e0dd56e962e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


