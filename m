Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D0D3A6ECC
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhFNTWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234212AbhFNTWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:22:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3DFCA61042;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623698404;
        bh=85IWey3+lXJIdMbIth3GdXO8nyYfRPhVNRs95tsu/qM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TkrT3f13m3pvkiBtuY94WmN4ajlKC3jAFLBURaufO2sfSDyyXkxqnTHhbhGrs9l1u
         REKNpRfD2JEgnki/qRmk3OO4V0m+EGTuETykc3zzbB17iX0QbKl5j739lnR95CEWxB
         8X58gWag00RheDN76BdezVcN+BiRX4n6hPxjbMFj70jecxu/6Hix/tnnIOYFMDyETj
         65T8YCBv59QKD5C2D1yWhyXWv2GBeDMS9S/0WxAkiACm5v8SgKx2GJBMgRDy9Xcjpr
         aYQb52Mi35PgegumOZWkZsF3RbJoFuXbYla98Ai472b1PCX71D8XhYlV1FE16+TYul
         4QTIDqMUCXOfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2B3DD609E7;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netxen_nic: Fix an error handling path in
 'netxen_nic_probe()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369840417.27454.3247486724427017414.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:20:04 +0000
References: <bb27f74af33b2b5eb238598fbd8aaafa51ccb50c.1623502316.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <bb27f74af33b2b5eb238598fbd8aaafa51ccb50c.1623502316.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        amit.salecha@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 12 Jun 2021 14:53:12 +0200 you wrote:
> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
> must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.
> 
> Fixes: e87ad5539343 ("netxen: support pci error handlers")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - netxen_nic: Fix an error handling path in 'netxen_nic_probe()'
    https://git.kernel.org/netdev/net/c/49a10c7b1762

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


