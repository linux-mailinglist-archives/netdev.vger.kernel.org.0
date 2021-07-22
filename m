Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A693D1E17
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 08:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhGVFja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 01:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231211AbhGVFj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 01:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A6C360D07;
        Thu, 22 Jul 2021 06:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626934805;
        bh=F/tUym1ScJ0Ys6vN1TUBZp6/6qA5vtz2TgMDVCVJ58s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o6CDfObMBRM2nL4khAK3twoid/QreoO2iZWb5lMQ0eKl33FPQdWIuZdfA3n39Kjkn
         GuR2aPokHys60lr2ymbyklzVJDM6Dr/ZuTPdNvigUSlwzro9M4Hx/CFaHLuYvtHVA0
         bx4oDRNzgn8yUKHUy0Yojkjxy1ilSbzvCxa/eDE6F8sUs2MNQ/57ynBl+o9GXZ22lQ
         PS0kUYWGiZxBa6k97o97rF0Gaz9J3zmcu7vtTvIOxbPFcZ4XZxcS2+eZCZZSFRp+nW
         VN9gXBVNFtu2Fo/rI4xGpifYPc9BGmBi/GXLhhJNtTQHa8Tw9P9MBMz8hqf7EsMSE1
         gFGFXLiHH1DFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DF8760CFD;
        Thu, 22 Jul 2021 06:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ravb: Fix a typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162693480511.4679.18040027938338857040.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 06:20:05 +0000
References: <20210721181721.17314-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20210721181721.17314-1-biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sergei.shtylyov@gmail.com,
        geert+renesas@glider.be, andrew@lunn.ch, aford173@gmail.com,
        yoshihiro.shimoda.uh@renesas.com, s.shtylyov@omprussia.ru,
        rikard.falkeborn@gmail.com, ashiduka@fujitsu.com,
        yangyingliang@huawei.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Chris.Paterson2@renesas.com,
        biju.das@bp.renesas.com, prabhakar.mahadev-lad.rj@bp.renesas.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Jul 2021 19:17:21 +0100 you wrote:
> Fix the typo RX->TX in comment, as the code following the comment
> process TX and not RX.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - ravb: Fix a typo in comment
    https://git.kernel.org/netdev/net/c/291d0a2c1fa6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


