Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CC948F9B0
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 23:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiAOWkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 17:40:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46686 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiAOWkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 17:40:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6232B60F89;
        Sat, 15 Jan 2022 22:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB962C36AEF;
        Sat, 15 Jan 2022 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642286409;
        bh=Qx7Mbou3OUJYVeFc8vcOaRUy+O0fyL6IWMuhV13wurM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A4Odjf9MV0BIBOOj5Zkz4nD8JegwqQxr4d34G76MgNSSvSz/Krqfon68q21DEYiau
         jr0FR5Yu1MD4VFY8PT6w6UlmdNQktEVqeqT9mt0rTTi3I/cIvonTCl80wwvf4DjFZv
         Bew96mMAEfMK/0RNGRU296mssYSxeY8wyuq9N6R63pskBH4s3F5wDgOQ2l1eW4Pbs5
         09Hxi9mX0wyx59qvMvhuwfE9WH/oM87C3Wg8O9+Qv3INsgD4DDbFpPE50X2Ywo0XfJ
         KsD99Oei/agZ8hwUFqJbzNfLUVDb3cqNGrAIoxNTXM8qDFub37OOoARb/PiapfskVf
         TxZ4LKNnbXwJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 980F3F6079F;
        Sat, 15 Jan 2022 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix error checking in
 mtk_mac_config()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164228640961.24744.3226248987693729352.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Jan 2022 22:40:09 +0000
References: <20220115174918.297002-1-trix@redhat.com>
In-Reply-To: <20220115174918.297002-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, nathan@kernel.org, ndesaulniers@google.com,
        opensource@vdorst.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 15 Jan 2022 09:49:18 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this problem
> mtk_eth_soc.c:394:7: warning: Branch condition evaluates
>   to a garbage value
>                 if (err)
>                     ^~~
> 
> [...]

Here is the summary with links:
  - [v2] net: ethernet: mtk_eth_soc: fix error checking in mtk_mac_config()
    https://git.kernel.org/netdev/net/c/214b3369ab9b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


