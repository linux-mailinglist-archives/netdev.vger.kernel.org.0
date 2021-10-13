Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1604442C811
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 19:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238642AbhJMRxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 13:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238581AbhJMRwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 13:52:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E6CEA61139;
        Wed, 13 Oct 2021 17:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634147409;
        bh=YsLFWvEAy9/OfmsaHqNBq1eLcC6QVTEmmlyn4n/5tt8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T618gsGHObWppNOK4MApmx1qZWZsGS3N7UYV27w758++YHTQHdcMxm5FHf6hfz8XD
         TBjFkOzPcUuQMstYbMFThlVsHLddo6qjtpkwQ8cwiqbQPMR9e3DXMaPFcMhTrv2Yv7
         Om4P4dhk/dk+j+/tkn8tYl2k5TtjQqnmgQTC98SZc0aj9t0r7NyVo2MNorVw4tc7T0
         CVkNJCu9iA2E6QhIVD6IjLFkcjuVFF7zoAMcZ3oTc9QeCxuQdVqM08iGe4TxbRL1ir
         ON3OmPlRwOteJ2TlG0+lgyUbW9pOA/xRm47ZbKIH7NKZkeIkPXTLLFtr2Cmc/Wj7P5
         2Lal6kucIyv3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D41A36095D;
        Wed, 13 Oct 2021 17:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: remove single-byte netdev->dev_addr writes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163414740886.22760.3689438642876876023.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 17:50:08 +0000
References: <20211012142757.4124842-1-kuba@kernel.org>
In-Reply-To: <20211012142757.4124842-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sre@kernel.org,
        m.grzeschik@pengutronix.de, balbi@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 07:27:57 -0700 you wrote:
> Make the drivers which use single-byte netdev addresses
> (netdev->addr_len == 1) use the appropriate address setting
> helpers.
> 
> arcnet copies from int variables and io reads a lot, so
> add a helper for arcnet drivers to use.
> 
> [...]

Here is the summary with links:
  - [net-next] net: remove single-byte netdev->dev_addr writes
    https://git.kernel.org/netdev/net-next/c/13b5ffa0e282

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


