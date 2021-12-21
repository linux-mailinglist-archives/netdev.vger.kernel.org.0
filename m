Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B047B8E9
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 04:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbhLUDKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 22:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbhLUDKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 22:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E904C061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 19:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 233B9B8114B
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D70A4C36AEB;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640056210;
        bh=BkzeTLwFZaY7PV8pjCcAjuPHkMcCU5VGMBEANFpbEfU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YQN9/AS2hgVg7GMLcorEZUx7bos0nTEZugcvvchIS+MQlI7aOO24R2IcSHfIH3xBl
         deSw8KhlgXWJAdoK9KxKjpaBS4ZtWr1rHFG6WfV+A+jjRIx+B9CyGUHluI3jvSVKf6
         qOVw1wCvzsevVwhWXg1Xfipx3ZNVLvw6MmNsEKUUkDmrMC2ZdmN7CEqmQ1AyhXtaN1
         gbSoXKc7c9EQoFMb4vuT9EmoYsGqpepttBND4jJf4NNKzxvVWKk7cK9uzrmrmrJqDW
         YkGwL5Nu4dSSTeG1omAcnErXF87GQRAM4TiHzeNN/1PbiTXl0BlbTOUz/2ieIj9ebh
         GykZ3gNVvj0Dg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BBFF760A24;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] docs: networking: replace skb_hwtstamp_tx with
 skb_tstamp_tx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164005621076.30905.17707858291259708394.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 03:10:10 +0000
References: <20211220144608.2783526-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20211220144608.2783526-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        patrick.ohly@intel.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Dec 2021 09:46:08 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Tiny doc fix. The hardware transmit function was called skb_tstamp_tx
> from its introduction in commit ac45f602ee3d ("net: infrastructure for
> hardware time stamping") in the same series as this documentation.
> 
> Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 
> [...]

Here is the summary with links:
  - [net] docs: networking: replace skb_hwtstamp_tx with skb_tstamp_tx
    https://git.kernel.org/netdev/net/c/a9725e1d3962

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


