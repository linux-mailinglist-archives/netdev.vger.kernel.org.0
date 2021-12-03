Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC00467950
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381436AbhLCOXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:23:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51148 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381427AbhLCOXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:23:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E697562B7B;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55376C53FD5;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638541210;
        bh=yaeljxhxqATiU8N/mBSWMOV52BpsAoy5W9rf6zLD2ZM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o/LUe9CJl/9q5upDR68VqCLxQFfErYKr1pnXatyN6/CdZB/jENjRO9y3IjBLKZo4E
         hsBiXLrYLTbGOAsXmCZYcdeHrfzwZ+NSooW4AF8zASubZR/NqVyHqxRMzeeUUmLKcw
         DJG74VczjpcFbMWXZUADgvnqsA4nDQu6nvnBaAERKbzcQdlrZPu5OUiCniLdrijbS0
         rONko7XrdIndZf+Pl1CW2toj8Rz/ZFuffsDdG3mnvDHa4jgbrYN4IEoLUT0qAh8BP7
         AFwJCK2+0dntTh1dF8Mm6qQ4HiWyozuEVLw6yXvIdD2Z48XTxGFMU/Hm1ul+BopmxI
         sWwNolALPKxXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3DA5B60A90;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: bcm4908: Handle dma_set_coherent_mask error codes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163854121024.27426.13358637043446344617.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 14:20:10 +0000
References: <20211203033106.1512770-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211203033106.1512770-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fw@strlen.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  3 Dec 2021 11:31:06 +0800 you wrote:
> The return value of dma_set_coherent_mask() is not always 0.
> To catch the exception in case that dma is not support the mask.
> 
> Fixes: 9d61d138ab30 ("net: broadcom: rename BCM4908 driver & update DT binding")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
> Changelog
> 
> [...]

Here is the summary with links:
  - [v3] net: bcm4908: Handle dma_set_coherent_mask error codes
    https://git.kernel.org/netdev/net/c/128f6ec95a28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


