Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D579415E35
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240986AbhIWMVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240825AbhIWMVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DFC9061216;
        Thu, 23 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632399607;
        bh=lpaHmJdutw6QGCs+Z1MC3vR6wrPOip7ATYJeW38L4z8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R1urDZBjThH69X36nftHctH5f4985k553Jh/xTtVG7iu21b+JfBZb8H6pW9wKVV1b
         MyWq/1SakaovmTR2GWwwr6c9H9n0g1tI5f2LzWFO0GBq/2ak3Ivh+stibSNa88f9eN
         hZeaTZYCIWoJ0r2FMu7tatyFiayVEpxAb9q0htfnUXc0zZtZShcbmac+27e0VZIOyH
         MLxQV1MMPBXD1kx2KzsBQWDoSz1fklDIBge/RO7bYarfHyie+plMOmP2pTmDyR8NCE
         vjp5TxwNKMMtc7A85u0GqHcx7M00jXGQvh3zxlQu0aeC6sOsZ+Xjo7hBlavn7sWBVh
         6pUBIr+DlzZ9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D05C760AA4;
        Thu, 23 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: avoid creating duplicate
 offload entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239960784.10392.2828841075323631519.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 12:20:07 +0000
References: <20210922235548.26300-1-ilya.lipnitskiy@gmail.com>
In-Reply-To: <20210922235548.26300-1-ilya.lipnitskiy@gmail.com>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, pablo@netfilter.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 22 Sep 2021 16:55:48 -0700 you wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> Sometimes multiple CLS_REPLACE calls are issued for the same connection.
> rhashtable_insert_fast does not check for these duplicates, so multiple
> hardware flow entries can be created.
> Fix this by checking for an existing entry early
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: avoid creating duplicate offload entries
    https://git.kernel.org/netdev/net/c/e68daf61ed13

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


