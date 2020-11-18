Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71092B733C
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgKRAkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727514AbgKRAkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 19:40:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605660006;
        bh=eG++Teymcbn8d08FjfeOzwIt/Dgoql9v2L3PraeXXtA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UR9siwn+UWW+yvk9K6UO1qfgQ7bve7u8CLD9qpo7nJ4Ux+PhNUmSGTqGF48TVW57W
         LSPaamZwg+Q9JHEkcgerZAE1HDBV0DWkamW2tu1FRw3ZXWSpCvfz0KEJF+M7FlslvB
         Uyt8G+T1noB7uDObOm15Ld8sJ/nM/0NpcLzzqkc0=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] qed: fix ILT configuration of SRC block
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160566000627.20766.10416783880536054730.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Nov 2020 00:40:06 +0000
References: <20201116132944.2055-1-dbogdanov@marvell.com>
In-Reply-To: <20201116132944.2055-1-dbogdanov@marvell.com>
To:     Dmitry Bogdanov <dbogdanov@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        irusskikh@marvell.com, aelior@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 16 Nov 2020 16:29:44 +0300 you wrote:
> The code refactoring of ILT configuration was not complete, the old
> unused variables were used for the SRC block. That could lead to the memory
> corruption by HW when rx filters are configured.
> This patch completes that refactoring.
> 
> Fixes: 8a52bbab39c9 (qed: Debug feature: ilt and mdump)
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net] qed: fix ILT configuration of SRC block
    https://git.kernel.org/netdev/net/c/93be52612431

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


