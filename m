Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7193F01A5
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhHRKas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233576AbhHRKal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 06:30:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 57A9F6103A;
        Wed, 18 Aug 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629282606;
        bh=MeESI7QBGE5apzUQQdtfthS+KKDVVJ5g/Q8CpvJZfYk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O3snmf+6hA5oQxR1uT1Wn0dyDd6UkLPewi+cTqkbHQlNbWGolicOODZmi47+9A2LT
         XwEcQH8zdkAEqf394e6edIXjYouxLQTtsZKK85n9xlKtkPAi84VkoMfpE2inD++htR
         XVbsy2qHLnXTpuG31mmy1Tfw7lFNOCXHjyqInAGkq1AXcAdau9yoy3JczlqW6BsQ9V
         vRXgGcopFKxZCuhyfaJYVYTj+L79+3bkbuXjodO/67mGPtWxEPTFYXA8wa940YaDDX
         ERG+RFb8j+/diO7ZdQSA/0D7SCHr07SC993AV2qzePFH2lLkoEgVmx7kJToYo+UWVX
         YFpJZDpFscgBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4D76E60A25;
        Wed, 18 Aug 2021 10:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-pf: Allow VLAN priority also in ntuple filters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162928260631.10083.6121060060120077785.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 10:30:06 +0000
References: <1629268975-30899-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1629268975-30899-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Aug 2021 12:12:55 +0530 you wrote:
> VLAN TCI is a 16 bit field which includes Priority(3 bits),
> CFI(1 bit) and VID(12 bits). Currently ntuple filters support
> installing rules to steer packets based on VID only.
> This patch extends that support such that filters can
> be installed for entire VLAN TCI.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - octeontx2-pf: Allow VLAN priority also in ntuple filters
    https://git.kernel.org/netdev/net-next/c/ab44035d3082

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


