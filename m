Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB78034D902
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhC2UUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231795AbhC2UUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB9886198F;
        Mon, 29 Mar 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617049209;
        bh=I48dCHVmRGgVEqqtC7g/IqDR+13qmSr+cx6QZmQxrqQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZYnTZpabB5Sfxt+BE2sOH3doRTgK6uThoeXJbU/I/nynZJLcCoeIyn1XhjQZre34h
         FDzM3D2mFXeyIjWjInJQ3TYe4jzPiwg7XLLpl9tpGKlxvfRLf+HHEQ1rtI2Q7kOmKu
         /N648Mn+9q7TVYb/h1g4S1SNBFh/BbC7/rS59VuAo7RQssCiIKLTAUUf6zJ3kqKVzg
         CrCHp2Q8vVYAyhU4TTIOYktMoe++Iih2oQJIaFQEwifARlN36VJ1K3dXC1SReQqiCE
         57JOLcPRiEMUm3uBGA+Sj60DFQf2jELfdBiMRa7ZJhE/erlzQdXvFwDeNEAQBVZjw1
         +ppdAK07iJNdg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CCB9560A49;
        Mon, 29 Mar 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: mscc: ocelot: remove redundant dev_err call
 in vsc9959_mdio_bus_alloc()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161704920983.7047.6144556784659434081.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:20:09 +0000
References: <1616982845-14819-1-git-send-email-huangguobin4@huawei.com>
In-Reply-To: <1616982845-14819-1-git-send-email-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 09:54:05 +0800 you wrote:
> From: Guobin Huang <huangguobin4@huawei.com>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: mscc: ocelot: remove redundant dev_err call in vsc9959_mdio_bus_alloc()
    https://git.kernel.org/netdev/net-next/c/a180be79db4a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


