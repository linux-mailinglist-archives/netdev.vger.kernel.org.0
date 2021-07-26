Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7718E3D5A37
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhGZMjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 08:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233320AbhGZMjh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 08:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DCDA260F55;
        Mon, 26 Jul 2021 13:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627305605;
        bh=5eNMNsLl7BqMxBzCu5F5yofW8LBvqbxa9RRDPgzv2oM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DNRCl7RUzx4sjKeVw+TkSUvIzMpPMRMzrWrb2AUi7XM43ZhvIT+fA2vppXMQmbcP+
         jKHExr43eVRb/K913nne0JrCXTeMAj00UhoA2C9Rv9jK0GnZHJNf1WoIebTgifpFnh
         VFkHsPIXgli9Y8PAbwCZvNd0SUbbDRk3pnSGZWjuuu6xhko4BI0NXimmwTd/Tir3IU
         +E6ye+RckxfgVAU7d/DBb0FKCxKgdxacRDVfzWuK0rpjMdlQWNf+jH5gvmVjN6h5l7
         ksBZn3Pw6+2A0Jf1msoJiq5LNhSyrvGZwNOKY2pG5k28S4Yf/6mVqeDveC4yhPYZv+
         mkL4CLshXz5Gw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D055260A59;
        Mon, 26 Jul 2021 13:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/qla3xxx: fix schedule while atomic in
 ql_wait_for_drvr_lock and ql_adapter_reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162730560584.19326.4535322188871609836.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 13:20:05 +0000
References: <20210725134512.42044-1-fantasquex@gmail.com>
In-Reply-To: <20210725134512.42044-1-fantasquex@gmail.com>
To:     Letu Ren <fantasquex@gmail.com>
Cc:     GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zheyuma97@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 25 Jul 2021 21:45:12 +0800 you wrote:
> When calling the 'ql_wait_for_drvr_lock' and 'ql_adapter_reset', the driver
> has already acquired the spin lock, so the driver should not call 'ssleep'
> in atomic context.
> 
> This bug can be fixed by using 'mdelay' instead of 'ssleep'.
> 
> Reported-by: Letu Ren <fantasquex@gmail.com>
> Signed-off-by: Letu Ren <fantasquex@gmail.com>
> 
> [...]

Here is the summary with links:
  - net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset
    https://git.kernel.org/netdev/net/c/92766c4628ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


