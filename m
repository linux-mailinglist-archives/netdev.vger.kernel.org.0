Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7AF2F6FFF
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 02:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbhAOBax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 20:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731513AbhAOBaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 20:30:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CBD8923A5A;
        Fri, 15 Jan 2021 01:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610674211;
        bh=VyN83IN9vcsyIOsgjz3YnIdzFOkl9n28RVkiyZkBqlA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n8AKpnbv6l98PLU/BFqsK6kkJeCIwOqcXdYw8QzGgZcEqCld/uA14Iy/YAMCBtdra
         G9H2eywRvEbfPspZvePyp4nr7yQccv/XLzW0VqH9qGiBaWxwZzesXEQzi80wxCbsQf
         pLIOnPDy4THZLVBgKOFN+cnk5lvulLPR/CnwlLIgwamt33f/lD/s6sNzZ/T5jSoONh
         N2BEZeneOoLGE/6PvttdP8os9G3HKJCf8oDPr8awEhVX6mDXu9HUswNebO1ry86r5H
         c6NDlsM8z8W4CsxKDRZlduahIf2ABY4HrtSihGKP9OP/odmB8DVU/Q5+quQPGTZG2y
         GpKCXjFXr/GRg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id BE84F6017C;
        Fri, 15 Jan 2021 01:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mlxsw: pci: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161067421177.20666.5506474617106384086.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 01:30:11 +0000
References: <20210114084757.490540-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20210114084757.490540-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 14 Jan 2021 09:47:57 +0100 you wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'mlxsw_pci_queue_init()' and
> 'mlxsw_pci_fw_area_init()' GFP_KERNEL can be used because both functions
> are already using this flag and no lock is acquired.
> 
> [...]

Here is the summary with links:
  - mlxsw: pci: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/bb5c64c879e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


