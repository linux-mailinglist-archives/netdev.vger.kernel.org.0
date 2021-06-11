Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7093A47CD
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 19:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhFKRWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 13:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhFKRWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 13:22:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55409613D3;
        Fri, 11 Jun 2021 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623432003;
        bh=MA2lcCOuu3zfhXLuZ6Am1wN/we7fSb27PySnpQZnDGk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E6m8U3vw1+eiAjlCkKG6dNAuZv1Xa9etWwy4Gatpu76oXesnHNhTumQ0l4wmT/wYw
         PkMrNd6lDagQtQI7JFRKKPHTHdOjMDE7ITNlBNS00y1Jv2vRsIpXIxyn4FMMcFP6DM
         VMs+enYN+qruq1ztLJEw8ctlUcCCaS9MRuTGll8SO3tRqcTHnmEr3HFRWcYkIjFaqH
         3AyoDYIl0CBNHrUSqMGw97c5Ntu/ea4bFyeabMR32SolhXSsDqDPZRX5gad/Qncx+r
         cxpxMWot0hX2LeC2eSpqOlnOwPMbDLvwO52UCSQBsnVphWcG4DbQqvXH/MrhUod0CV
         UmYuCgkE4Y6QA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4917F609E4;
        Fri, 11 Jun 2021 17:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: phy: dp83867: perform soft reset and retain
 established link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162343200329.24975.13801688120814687092.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 17:20:03 +0000
References: <20210610004342.4493-1-praneeth@ti.com>
In-Reply-To: <20210610004342.4493-1-praneeth@ti.com>
To:     Bajjuri@ci.codeaurora.org, Praneeth <praneeth@ti.com>
Cc:     andrew@lunn.ch, geet.modi@ti.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 9 Jun 2021 19:43:42 -0500 you wrote:
> From: Praneeth Bajjuri <praneeth@ti.com>
> 
> Current logic is performing hard reset and causing the programmed
> registers to be wiped out.
> 
> as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
> 8.6.26 Control Register (CTRL)
> 
> [...]

Here is the summary with links:
  - [v2] net: phy: dp83867: perform soft reset and retain established link
    https://git.kernel.org/netdev/net/c/da9ef50f545f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


