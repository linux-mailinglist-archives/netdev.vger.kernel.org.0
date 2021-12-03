Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443EC467971
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381470AbhLCOdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381472AbhLCOdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:33:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C838C061354;
        Fri,  3 Dec 2021 06:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6AF6B82791;
        Fri,  3 Dec 2021 14:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A631C53FCB;
        Fri,  3 Dec 2021 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638541810;
        bh=jb4/SXmr4FVq55HSvvuia7odYbDr3Bi+XgTf+63xMEQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZodpQVmSGHPGiI0zzvCo0007zGR0bvmm76b5dHCTXWlmSEqsoPdCmWJX0ZXqFmVrL
         hWlHjmHExsyFVCHUU4/D4ywQf2nBLNsQz8nIDCrc40p4SqiE95e/2awn09hKEe4OCC
         mvKl7Z7Xis/0cf9Rjez9PWIWHyOZK4bp89BJc7fDzX/2f13hos9mnfrrHzRhsAzOZN
         3tSvpPlbvorMM9kiVseC/cjpENpUqwXXy2C81xnlqOmRCN/QDMGjGj0HG+n3WATsiU
         lzK0IbWx8eIvSyiAjFxoYxYUCuUGTjpL3kJy2y/1HE+123uew1x9lXc07cAVHE6Lhq
         QHHllAMSl5v4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5418A60C76;
        Fri,  3 Dec 2021 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: prestera: acl: fix return value check in
 prestera_acl_rule_entry_find()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163854181033.31528.17749126497261103268.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 14:30:10 +0000
References: <20211203070418.465144-1-yangyingliang@huawei.com>
In-Reply-To: <20211203070418.465144-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        tchornyi@marvell.com, vmytnyk@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 3 Dec 2021 15:04:18 +0800 you wrote:
> rhashtable_lookup_fast() returns NULL pointer not ERR_PTR().
> Return rhashtable_lookup_fast() directly to fix this.
> 
> Fixes: 47327e198d42 ("net: prestera: acl: migrate to new vTCAM api")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: prestera: acl: fix return value check in prestera_acl_rule_entry_find()
    https://git.kernel.org/netdev/net-next/c/f6882b8fac60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


