Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB9D3D131A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240165AbhGUPT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240160AbhGUPT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 30B936124B;
        Wed, 21 Jul 2021 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626883205;
        bh=5h90NX7Xz+GL0IU3xKjeijQvkf9vex/ctIrzqDebn7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Uo79j6VBGpl2fMDZY4DO29oL6iRbRokd/oG+pFEd3hZpx1caWI46znJzq4knNTLnN
         HMnugucTQU/w7X349sB2mD1GLXaDvaD8u66gx+udOtwqrQ1LSNkRDILP5dpMMWjApt
         SzadlxQkXV3/lmFMPMmiuieSeMfwfkB/nNJvr7nRoemdryeYamQiroP1GSqCLOPYap
         /ryQui+y20gLZKiDaf1vS1qiCFoMplKnFoIRwnoo06hPdMQeXxHTBDCWcctFZKgfId
         A9ReA5kZoLjVT2B+VHmlpHgwxeiu6cKOCAab5IqboAi5QgftDqpNzZJ8NrzjzPMCX2
         ibi4YnVWf0djA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 270DF609B0;
        Wed, 21 Jul 2021 16:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ibmvnic: Remove the proper scrq flush
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688320515.24738.5658217547450087381.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 16:00:05 +0000
References: <20210721023439.1018976-1-sukadev@linux.ibm.com>
In-Reply-To: <20210721023439.1018976-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, ricklind@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Jul 2021 19:34:39 -0700 you wrote:
> Commit 65d6470d139a ("ibmvnic: clean pending indirect buffs during reset")
> intended to remove the call to ibmvnic_tx_scrq_flush() when the
> ->resetting flag is true and was tested that way. But during the final
> rebase to net-next, the hunk got applied to a block few lines below
> (which happened to have the same diff context) and the wrong call to
> ibmvnic_tx_scrq_flush() got removed.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ibmvnic: Remove the proper scrq flush
    https://git.kernel.org/netdev/net/c/bb55362bd697

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


