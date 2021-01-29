Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D495A308539
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 06:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhA2FbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 00:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231882AbhA2Fav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 00:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9AE1464DFF;
        Fri, 29 Jan 2021 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611898210;
        bh=/CaMe/Uz3lm+kWNMJL6QAHYZ1FnVRTXt1EPSi0pZW2s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EzMX3XPWZ73E1m8fyc0unX2GxzCOM/xvHMvRttH674AEqMvUqJa0d8marnYijOQso
         BKOYmcuwAgjeuocRNmeaus0Qfo7J8on6yemtW1twUXSMe/Jgi3dhMvcGFyN9xB4bmy
         EQcd5samaF3uycJ0qq4QMnmI1zw+T6mLReT1fOJMJNmbroPoS/u5WM8Rg/7QTNmYCo
         CNGClD89y5vY8oTjgobxOMarfX44tfVEIofSQs8ebLOG5oHgcLjokRARk+TW62UXaK
         ZZsyczMWIzlh+OnRXlHznsTHBgyCbAOpQWX4NZGKYlHR6EghA9CDKSgSa4KffOkUmO
         jB13PnWAAGhXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8417D65324;
        Fri, 29 Jan 2021 05:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] octeontx2-af: Fix 'physical' typos
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161189821053.14150.10259154876941489288.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 05:30:10 +0000
References: <20210127181359.3008316-1-helgaas@kernel.org>
In-Reply-To: <20210127181359.3008316-1-helgaas@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, davem@davemloft.net, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        bhelgaas@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 12:13:59 -0600 you wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Fix misspellings of "physical".
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
> Thanks, Willem!
> 
> [...]

Here is the summary with links:
  - [v2] octeontx2-af: Fix 'physical' typos
    https://git.kernel.org/netdev/net-next/c/46eb3c108fe1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


