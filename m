Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EC52B2917
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgKMXUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:20:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKMXUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 18:20:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605309604;
        bh=pjD4WumMpIpzGjUkarRpilVJz60a8WXk9Tp2oePvLww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TkR9UrXKr+pFoxGe9BApWQMd9mrtMzvzxoS3M1PTY+sPPIzZ4/ZtRXppAg31xykYb
         dxKMzZ/jH2pl8TjugwrgI9Mfg4N6jS/JLqWgKmdNUikMYjPszBQSo274DIEphyTUFA
         /9G5gYhGRvDubmmdpz2joU0FPEbZJebu3mX0ZPlg=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix error return code in
 prestera_pci_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160530960467.2715.18262980777619754390.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 23:20:04 +0000
References: <20201113113236.71678-1-wanghai38@huawei.com>
In-Reply-To: <20201113113236.71678-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, oleksandr.mazur@plvision.eu,
        vadym.kochan@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Nov 2020 19:32:36 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 4c2703dfd7fa ("net: marvell: prestera: Add PCI interface support")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: prestera: fix error return code in prestera_pci_probe()
    https://git.kernel.org/netdev/net/c/8c07205aea36

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


