Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4973F84CA
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 11:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241009AbhHZJuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 05:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237918AbhHZJuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 05:50:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7AF4B610C8;
        Thu, 26 Aug 2021 09:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629971405;
        bh=HmbObn9Mh4Zs6oU39fJUUCKi69qKXb0qZskEKzNY2cM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y45ExiTAZ/8x5c5quKszP5FgwOPxBzfhUoMVttJgNdJ2Tg10Wab7CJkqBOrObOFxS
         h+4jZXCwGwU4Tge6lDPrsbbteL09lVW6xLWzXFS6CO7+LRGI/9CujQmAPfVpFsx1mc
         vF0k6uX+fZz6KG7itP+5pgrAT5kgafkVKwWLk7Jkr+fMD6HTOkH6pPH1XddiBEioug
         jpzs5Q+qnjiSQ8cIQau5znd9w8s+Lx6aQvwB4iTmQ50Hs6Ksvsxa0Ccw/ZXeDyRu/n
         63yct9kqTGnUxN9D9v7A/kcwEB11lea9VafwcncVSerw058htEV/nv1Jtv7gX0v8Kv
         Y56JZBCZIcCJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6E6F4609EA;
        Thu, 26 Aug 2021 09:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] octeontx2-pf: cn10k: Fix error return code in
 otx2_set_flowkey_cfg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997140544.6566.1812675590777880112.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 09:50:05 +0000
References: <20210825063447.2383587-1-yangyingliang@huawei.com>
In-Reply-To: <20210825063447.2383587-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 14:34:47 +0800 you wrote:
> If otx2_mbox_get_rsp() fails, otx2_set_flowkey_cfg() need return an
> error code.
> 
> Fixes: e7938365459f ("octeontx2-pf: Fix algorithm index in MCAM rules with RSS action")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] octeontx2-pf: cn10k: Fix error return code in otx2_set_flowkey_cfg()
    https://git.kernel.org/netdev/net-next/c/5e8243e66b4d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


