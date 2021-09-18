Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6DD4102BB
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 03:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhIRBld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 21:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhIRBl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 21:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0966061246;
        Sat, 18 Sep 2021 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631929207;
        bh=Jd545gd9fC/MP6f9949kqwGe19C8RUnQruWm7s5mbYA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tzSez8QpjnGU1s1um5/xRa4XML2Dm2bn2ExpJZqVrnUqTj4+FjU196RcERYgB1AH0
         vN68VFrkBdVmexam3Lj3oLXEybdBVrllfMXxWweYePvQoQopEB9slVMue0zd4B2Xjg
         N8RGQsHsFUYALAr7qUU1AzsAdwnaU4KnLY56ptAcRgdC1VRySfJpjTYSZhGnYvKdRl
         +04I0cU7fGKVjMeyAqITQW/QI6CzGnCDA4du54W4MySuPOoMDO2hxfApDbJ5UYswPL
         qYzA9zATiKY8oHMn2RWqW+CPUoSgUHQMGwnwb/4UAjl63wAU264d4+TCZfKyZ4K5RX
         3f7LkKanODsxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED698609D7;
        Sat, 18 Sep 2021 01:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sky2: Stop printing VPD info to debugfs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163192920696.23940.7346144050980767464.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Sep 2021 01:40:06 +0000
References: <bbaee8ab-9b2e-de04-ee7b-571e094cc5fe@gmail.com>
In-Reply-To: <bbaee8ab-9b2e-de04-ee7b-571e094cc5fe@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, mlindner@marvell.com,
        stephen@networkplumber.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 16 Sep 2021 23:40:37 +0200 you wrote:
> Sky2 is parsing the VPD and adds the parsed information to its debugfs
> file. This isn't needed in kernel, userspace tools like lspci can be
> used to display such information nicely. Therefore remove this from
> the driver.
> 
> lspci -vv:
> 
> [...]

Here is the summary with links:
  - [net-next] sky2: Stop printing VPD info to debugfs
    https://git.kernel.org/netdev/net-next/c/0efcc3f20145

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


