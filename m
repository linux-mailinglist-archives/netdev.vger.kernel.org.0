Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9D43B77FE
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbhF2Smd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235159AbhF2Smc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 14:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A2F2261DAB;
        Tue, 29 Jun 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624992004;
        bh=Ldswn1J1dGOqNagkK8SPWgBFiyLf/uswfa7+BOqTHh4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WOsLI2cMi2xEGb06Ehlf1SUKnJZW3GUOsPpv1M5MO8h2VfpBNtKx6XZTGztZq2bCE
         qCCgcUIDblwh74VEUOK4nWvfxqw3yyp7RbaomrknUmliTsxi5/thFK/CP9T8lV6nC/
         EMYXK/coAs1fwFKhMhPoEHbDBh2wodFAVtUyLhPrdzqRxXSxghcwYWezHO1ib0KH79
         hj+KFUu7trudkp/De/QVAy5KmRoGLFyAEFyYLx+IZl+Qvo2cObCUUu7ovWakI9YKAE
         VcUSOe6abc9OeAXigk+FimDwpjyLeWLb1weqNKanbGTOR0mq1GRb3q0JRH/Pdl+Uyl
         TWOngMge4lqyQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 97E9860BCF;
        Tue, 29 Jun 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Trivial print improvements in
 ndo_dflt_fdb_{add,del}
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162499200461.24074.9067139214830183799.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Jun 2021 18:40:04 +0000
References: <20210629002926.1961539-1-olteanv@gmail.com>
In-Reply-To: <20210629002926.1961539-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 29 Jun 2021 03:29:24 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> These are some changes brought to the informational messages printed in
> the default .ndo_fdb_add and .ndo_fdb_del method implementations.
> 
> Vladimir Oltean (2):
>   net: use netdev_info in ndo_dflt_fdb_{add,del}
>   net: say "local" instead of "static" addresses in
>     ndo_dflt_fdb_{add,del}
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: use netdev_info in ndo_dflt_fdb_{add,del}
    https://git.kernel.org/netdev/net-next/c/23ac0b421674
  - [net-next,2/2] net: say "local" instead of "static" addresses in ndo_dflt_fdb_{add,del}
    https://git.kernel.org/netdev/net-next/c/78ecc8903de2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


