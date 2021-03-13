Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6B633A1BA
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 23:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhCMWk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 17:40:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233645AbhCMWkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 17:40:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 66D4B64ECC;
        Sat, 13 Mar 2021 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615675209;
        bh=U4mEveLNc7pT37vFJBW5v7n7//JmIDC1FwEV6NM+p6M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JaO8vgxlzerlPHqhf3z0G+RtNxsZ8UxmeCFhQZCc+tJe0K3F/HpzLfd/dgx+bzT27
         +Tn17srSwu097sQOFWZC4lzikh8DkvwG6ugDDQ7CTQGTfk5Sh36uYMONJlx6fhaVxl
         CO9QJlTbfMvtXWNjyml7QiD7ayswk/dfO4iNPh1qp22de0KJ5B0yHIlWHtv4oXnB+E
         pr8hahD2+BI2mr+P4Md2uGwjMaNSK7d9dZwYPgg6JBMitnXayHpmGhdjliUri0PMsg
         9cgMpcTu0lq3+r9AwPS42f1+oeGQREsRMDiTg+uivzRxsggUC5UGoNUWio18nxA1GR
         dM2CvhwN4I4Hw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 586DA60A2D;
        Sat, 13 Mar 2021 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net: dsa: hellcreek: Add support for dumping
 tables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161567520935.31370.17273766067390550042.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Mar 2021 22:40:09 +0000
References: <20210313093939.15179-1-kurt@kmk-computers.de>
In-Reply-To: <20210313093939.15179-1-kurt@kmk-computers.de>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 13 Mar 2021 10:39:35 +0100 you wrote:
> Hi,
> 
> add support for dumping the VLAN and FDB table via devlink. As the driver uses
> internal VLANs and static FDB entries, this is a useful debugging feature.
> 
> Changes since v1:
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net: dsa: hellcreek: Add devlink VLAN region
    https://git.kernel.org/netdev/net-next/c/ba2d1c28886c
  - [net-next,v2,2/4] net: dsa: hellcreek: Use boolean value
    https://git.kernel.org/netdev/net-next/c/e81813fb5635
  - [net-next,v2,3/4] net: dsa: hellcreek: Move common code to helper
    https://git.kernel.org/netdev/net-next/c/eb5f3d314180
  - [net-next,v2,4/4] net: dsa: hellcreek: Add devlink FDB region
    https://git.kernel.org/netdev/net-next/c/292cd449fee3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


