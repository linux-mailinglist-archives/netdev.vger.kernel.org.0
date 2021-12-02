Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC65465C5B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355029AbhLBDEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:04:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59480 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355038AbhLBDDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:03:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70F10B82172;
        Thu,  2 Dec 2021 03:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 339AFC53FAD;
        Thu,  2 Dec 2021 03:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638414009;
        bh=hDYWhvPof6o9IIOEXiRK5hQa70O9agXY5UfnOP66XgE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BSt2RqY1gc8wAycsu6r4KFRbU/8jKG6GSx/CsNtb5J8QoY+fjrU/5d4QFcpBdUvPk
         xotRmWsIuCjoEKa4ZgnekDnYkKNaNcovvNn7OqRwplC4UheIh72NAHCB9GEg8XfxA3
         WtBkxvXDFt16YDf2v3vc4LGLaUtioBo+AM64/Hgblz6vvJfEZaRbcgZbtvxfMfzjU7
         /FzzEPvAA3uLfxyPUmw2DiuBVuFi8C/5r5fsYZMsd88v6xGlLxr2ZFmmCzkwwnEwxY
         CI2rDp0JJ7cYWYpYhCazaSwGj6JADqMh7JcCS0Glt/HXDAhC50IREoh1xv1AIxl1yq
         eh47UF9F3+I/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18263609EF;
        Thu,  2 Dec 2021 03:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] clk: mediatek: net: qlogic: qlcnic: Fix a NULL pointer
 dereference in qlcnic_83xx_add_rings()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841400909.24500.703686292422770664.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:00:09 +0000
References: <20211130110848.109026-1-zhou1615@umn.edu>
In-Reply-To: <20211130110848.109026-1-zhou1615@umn.edu>
To:     Zhou Qingyang <zhou1615@umn.edu>
Cc:     kjlu@umn.edu, shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, sucheta.chakraborty@qlogic.com,
        sritej.velaga@qlogic.com, sony.chacko@qlogic.com,
        anirban.chakraborty@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 19:08:48 +0800 you wrote:
> In qlcnic_83xx_add_rings(), the indirect function of
> ahw->hw_ops->alloc_mbx_args will be called to allocate memory for
> cmd.req.arg, and there is a dereference of it in qlcnic_83xx_add_rings(),
> which could lead to a NULL pointer dereference on failure of the
> indirect function like qlcnic_83xx_alloc_mbx_args().
> 
> Fix this bug by adding a check of alloc_mbx_args(), this patch
> imitates the logic of mbx_cmd()'s failure handling.
> 
> [...]

Here is the summary with links:
  - clk: mediatek: net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()
    https://git.kernel.org/netdev/net/c/e2dabc4f7e7b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


