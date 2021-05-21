Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93A038CFED
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhEUVbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhEUVbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:31:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B893613EC;
        Fri, 21 May 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621632610;
        bh=UkPX/wyZjLWdM7eglEmA3nsElY7vmH714oTDcx6wsHA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UJdMprTV3dmWDd0u1vIr8gdn89IJ9g13HdX8GSTT4wHeVAldte/cg8I1TbmnML3vB
         bLe4FpxTsjAO+lod0KLRiEN4XbpG3a7zhUi8H4aNj3ua8Rz+jCdBdAdLynK9Cna954
         poGT+GdrK3uIn8R51J481e087BHMkg4TCWpOZQnqXERJO5MvknhJ0/zRQu+cbjp0Ea
         oc4ruE7J3515sKZVX8MiN/FwJ3IM0S2b1tbNKxwnp0QPXFQZZYfPJWo6FjS/NLYtdA
         Jstokc9AlbkZchsAnOgQVNFtHaBDOmNPzEVw83TBiUNkc2g+B4WK7bcQzY2i+VO2cp
         gmrqFGKuKkDDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A768609FE;
        Fri, 21 May 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: remove Ioana Radulescu from dpaa2-eth
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163261036.6211.1335997893079456067.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:30:10 +0000
References: <20210521210100.2858070-1-ciorneiioana@gmail.com>
In-Reply-To: <20210521210100.2858070-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 22 May 2021 00:01:00 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Remove Ioana Radulescu from dpaa2-eth since she is no longer working on
> the DPAA2 set of drivers.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: remove Ioana Radulescu from dpaa2-eth
    https://git.kernel.org/netdev/net/c/29bf1993fdba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


