Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF883472F8D
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbhLMOkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbhLMOkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F18BC061574;
        Mon, 13 Dec 2021 06:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78A6D61122;
        Mon, 13 Dec 2021 14:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D67D1C34603;
        Mon, 13 Dec 2021 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639406408;
        bh=RPDqcfcKUnhDXD8xb6F15PCIowJnZcHYofXEFb1eH4Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CWtqLbO7uG5bRF0ZkGcPLS2rHAgRN5JY05N6YC0JeTQ7YANaRag7ZzC6JUBU9Uvnk
         EJ+DhLRjFhVDpjDV6+O78DCBOK2DqDD+mikheNiq+7iz/sU4qqix0uI1WmpVM1Pz4j
         KowXSP3/XAjI/fLoi1lfLKTDft6Iv3xdpnwt1ouc9eZ3Ov5dfxMu5aO2plS7nBggjM
         cpuXRTLlvKJmw4poG8L8fF3JwhmCvypbeg/l1dosGwqUZs86bMELq7wnaCs1NSRk5F
         GjnABVmwuit53gFrP184QEHUUov3baTIsjE1u3KSWjw7Ua4NOK7K4WiQu0Vh0P6/KM
         9SfrBQ5QxHEag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC66F6098C;
        Mon, 13 Dec 2021 14:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bcmgenet: Fix NULL vs IS_ERR() checking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940640876.17097.7671264988439271438.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 14:40:08 +0000
References: <20211211140154.23613-1-linmq006@gmail.com>
In-Reply-To: <20211211140154.23613-1-linmq006@gmail.com>
To:     =?utf-8?b?5p6X5aaZ5YCpIDxsaW5tcTAwNkBnbWFpbC5jb20+?=@ci.codeaurora.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Dec 2021 14:01:53 +0000 you wrote:
> The phy_attach() function does not return NULL. It returns error pointers.
> 
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: bcmgenet: Fix NULL vs IS_ERR() checking
    https://git.kernel.org/netdev/net/c/ab8eb798ddab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


