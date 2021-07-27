Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C6C3D73E5
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 13:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhG0LAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 07:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236169AbhG0LAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 07:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B7F6061994;
        Tue, 27 Jul 2021 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627383607;
        bh=PVTLFacFCwnSwcNcOasektA+q+5mA82eNTj1kC8B/Y8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tIApXKb5uTqMd7qVYb5pb8WBt6jM4C2I6s9EQXiKBdStxNCZzjPET7PHjR/EXlYgW
         Rw++AfIAMzUS38h9HIhZPsdm6xJzuLS0s7h3B5Bv1rEaL6ouA7+ohe1+Migv9yw62g
         KxNliLIAMqb8suWJZ33Wc0Jf5lFpGC/xcm//p+ZlkEJHVscq2ys5bda7UwnEOJns9F
         uY6KGfwsluJkMvSlrbEkILWOveVT81pXAfgIQgIBuh+Ahj+PTFeyQs0/M8BGI5FqAr
         9bdVf8nRoXdVruyEDgvmBwPszPUNclFNYyuG3a9Aa3OLYEh+OKbGTe0d+5PFvhj3Tt
         JxNmJxoJzhwmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ACA4760A56;
        Tue, 27 Jul 2021 11:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] octeontx2-af: Do NIX_RX_SW_SYNC twice
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162738360770.18831.10500755704932002629.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 11:00:07 +0000
References: <1627219492-16140-1-git-send-email-sgoutham@marvell.com>
In-Reply-To: <1627219492-16140-1-git-send-email-sgoutham@marvell.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 25 Jul 2021 18:54:52 +0530 you wrote:
> NIX_RX_SW_SYNC ensures all existing transactions are finished and
> pkts are written to LLC/DRAM, queues should be teared down after
> successful SW_SYNC. Due to a HW errata, in some rare scenarios
> an existing transaction might end after SW_SYNC operation. To
> ensure operation is fully done, do the SW_SYNC twice.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-af: Do NIX_RX_SW_SYNC twice
    https://git.kernel.org/netdev/net/c/fcef709c2c4b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


