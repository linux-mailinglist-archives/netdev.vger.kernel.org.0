Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB11F3B97B5
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhGAUjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234145AbhGAUjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 16:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5B89C613FE;
        Thu,  1 Jul 2021 20:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625171791;
        bh=uAGKDLcEpEB+FZaOra0XEmDgRe7TPzAvexrUW3Dyxdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lwjcMh5+QIq4ORFJk5THYscHd+ITl+Q/INV4XvhK2Cax+5/gqxEAQ5wNSCCFBKNxa
         zGkaqyLBdf/QwKSZtwsVQkokRpNoWktHsWvgmXdO50sKF9iKf0mrA63wXkpz4KCRZ6
         Hx8qttcmxghjlS/IIUvI3Tm1nu9vhXVokGXs2JSJWMorNzgJ/Q0wxVH66w032icLmE
         XlCttT3op7C5lLDRPiTt5wViWR3KVpTfp/J9tWyWth/QpVzLcv4BO4a2jS7AYhaAB7
         wS5d9Nlg0u9TIk8nw14NSyDoa00FH6mS23Bhu4wPjmmflmncwSJXxmHE5xRA2rIrMB
         UuTNY6yvWgIBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4EE8F60CD0;
        Thu,  1 Jul 2021 20:36:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH, resend] net: remove the caif_hsi driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517179131.24244.3097164117146882726.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 20:36:31 +0000
References: <20210701081509.246467-1-hch@lst.de>
In-Reply-To: <20210701081509.246467-1-hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, gregkh@linuxfoundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Jul 2021 10:15:09 +0200 you wrote:
> The caif_hsi driver relies on a cfhsi_get_ops symbol using symbol_get,
> but this symbol is not provided anywhere in the kernel tree.  Remove
> this driver given that it is dead code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/net/caif/Kconfig    |    9 -
>  drivers/net/caif/Makefile   |    3 -
>  drivers/net/caif/caif_hsi.c | 1454 -----------------------------------
>  include/net/caif/caif_hsi.h |  200 -----
>  4 files changed, 1666 deletions(-)
>  delete mode 100644 drivers/net/caif/caif_hsi.c
>  delete mode 100644 include/net/caif/caif_hsi.h

Here is the summary with links:
  - [resend] net: remove the caif_hsi driver
    https://git.kernel.org/netdev/net/c/ca75bcf0a83b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


