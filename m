Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D073A6ECE
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhFNTWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234229AbhFNTWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:22:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 594FA61356;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623698404;
        bh=w9nkzA0FtqkCBvZlJQPMHx5/VmZeYLcstDHH7eQrsB0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GyhO/vk0V1FTnJSRYdweY+GnfUoT9PtRSNZ1FlU+mT4VnaBNI2AmPdbi4D3l9RSaO
         RsKwrZ3ovzk5SXcaMuKyx/HaAsDHDLLKLRUMSzOe22/mJIX5wzYUuaTxhdXIByK//V
         jlhdVmCCAxpYrqggYcKsQJbpw50UmiEtFEAQ8Eu5K7kqxseJkL4yxoZtfVLr4mbISn
         Max0b8MiJ6VUXbYY0zzhpAtBeR8PVpAAv+FD8Uy9Tpp26Fsutb2+IUemu9NO1EauGy
         W5o4xqOX99bG8Tkfb8MJbNyLm5ZxPfKevA3noGYfqi0Xh5uwEZgfaBD3f2SEzIHEEX
         oLIaVNfIAkUtw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4CFC360977;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: Fix an error handling path in 'qlcnic_probe()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369840431.27454.11306229186572767869.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:20:04 +0000
References: <2b582e7e0f777ad2a04f9d0568045bee1483a27f.1623501317.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <2b582e7e0f777ad2a04f9d0568045bee1483a27f.1623501317.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        amit.salecha@qlogic.com, sucheta.chakraborty@qlogic.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 12 Jun 2021 14:37:46 +0200 you wrote:
> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
> must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.
> 
> Fixes: 451724c821c1 ("qlcnic: aer support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - qlcnic: Fix an error handling path in 'qlcnic_probe()'
    https://git.kernel.org/netdev/net/c/cb3376604a67

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


