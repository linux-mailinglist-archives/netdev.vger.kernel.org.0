Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C619C47CFFA
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 11:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244162AbhLVKaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 05:30:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37846 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239978AbhLVKaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 05:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E28C261981;
        Wed, 22 Dec 2021 10:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47614C36AEB;
        Wed, 22 Dec 2021 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640169010;
        bh=uauer/JJni/mt5IiembrFlaZ7RqqEMjSXCHafkbby8Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W1aaSN9E3QZtRdC+NfBXthyQOcI/WHQ4AFwL8/meTaituEnQz4Zr/kwMhytT8PdzO
         kx2al6GCm96ETa/ZkLGkKkh5wRR23QWTQSchiWIoNrWKvoBk8u8T9T3yiBl1srOgPo
         shimwGR+eTgrcT5iCf6EpMmYbm4bZg66TaTnSqsQCOL9KlvImb5lxa0K6QJmfOH+N2
         6jrGe0OBOswuFbgdKD6//e4HyOJnOYrHMApvSW4bnR64VQLZvyTzpB0bh5b0r3hl2p
         cbp/Ct6i0u8WDsc/3gx2ULkQ4AocyQSDmdklElGzQHLxtrv9+js7N4l7nvE9S+EoL4
         BkqQDc/M3QORg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19313609CC;
        Wed, 22 Dec 2021 10:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ks8851: Check for error irq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164016901009.30322.13875317764595642496.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 10:30:10 +0000
References: <20211222075944.1142953-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211222075944.1142953-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, marex@denx.de,
        trix@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Dec 2021 15:59:44 +0800 you wrote:
> Because platform_get_irq() could fail and return error irq.
> Therefore, it might be better to check it if order to avoid the use of
> error irq.
> 
> Fixes: 797047f875b5 ("net: ks8851: Implement Parallel bus operations")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - net: ks8851: Check for error irq
    https://git.kernel.org/netdev/net/c/99d7fbb5cedf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


