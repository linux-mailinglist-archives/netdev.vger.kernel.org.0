Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913292B8467
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgKRTKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgKRTKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:10:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605726605;
        bh=6GgW/U3n+PWiHOHNSe9TcCso3MWiDZx4E3P0xNwqko8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gpq90BQf6i8Uq9w2lLm8K/BHQj4LHGHDmGjCOZn3olNq/laqui1HoUoRvSACpIJNk
         gMZBMWnZksNYWeqxwrqtN/eN5zb+jsyrgPM/qBYO8tTKDkhCgINyzE8zKibqEoflKZ
         WzKCYkO2QEQqOXx1sCWJMYeAp1VgC+TZoBcmcpvI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] atl1c: fix error return code in atl1c_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160572660572.17971.13195778405702294005.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Nov 2020 19:10:05 +0000
References: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, davem@davemloft.net,
        kuba@kernel.org, hkallweit1@gmail.com, yanaijie@huawei.com,
        christophe.jaillet@wanadoo.fr, mst@redhat.com, leon@kernel.org,
        jesse.brandeburg@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Nov 2020 10:55:21 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 85eb5bc33717 ("net: atheros: switch from 'pci_' to 'dma_' API")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] atl1c: fix error return code in atl1c_probe()
    https://git.kernel.org/netdev/net/c/537a14726582

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


