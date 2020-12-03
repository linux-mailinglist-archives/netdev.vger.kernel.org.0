Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEADB2CCC62
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbgLCCUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387431AbgLCCUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 21:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606962006;
        bh=k2kpXagaE8QcgyXl15/fGTiJlvBhfcEv5yCvWYsFHSE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k9u5r+hK8+F+s5+3/19dPq8iUXv2gPILd/ZMUGIB5H+KlHHYHGMDdQmYamkFB2kiS
         EsoWThW26bWbk4QeBYmhr77gEmeef+nYEl8K0T7Pd3pBCAhN7+WSvOqPXdWZMecb5i
         S8HhX0Vik/C7oaH3ZNis5CYkAqm11/Obq5fEEX/iqUeBUYsmc6JyUJmkhC83qgneI/
         F6v2PInu10U75EWZDkNpP+5wEpCeA596iGYB7V/ncl8mm5Yz2Z4DXJ/pVb6fschq1j
         EbovoyOq6YuDh5yaLvPtqPKe5po4auzkIjipTh3vUwCE+An/PAanU1fcCX958bTD9q
         ZPF6D1P81o0bg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vxlan: fix error return code in __vxlan_dev_create()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160696200674.5625.12486993272321475655.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 02:20:06 +0000
References: <1606903122-2098-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1606903122-2098-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 2 Dec 2020 17:58:42 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] vxlan: fix error return code in __vxlan_dev_create()
    https://git.kernel.org/netdev/net/c/832e09798c26

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


