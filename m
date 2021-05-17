Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CBF386C03
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbhEQVLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241547AbhEQVL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A0EAC61263;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621285810;
        bh=+yVJ9RBGAAnbVCAfPFsoQPYrGn3Zm8icr3JPPKWsU8A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FahoD6m/fJPKxDc9AhsNDMjBRe78IHMLVcMgSDTJiM+FheqsmOpsyUrNDzWS56UJd
         UiYMEoWr+v74r/9/9x+WDPFUv3q2gDUtbgZo+8pWZi/p4dJlKs1zPJTEakV7ASXFK0
         3CHV1sXJBiO4kyzqvaq0IqqdpdCdtlKQc5DOFdFzA7/7ACJTyrqaxgH27mX5d2SKZo
         mwiEzJhLeCKg9ghefHZ4Cwr2lbeAmazz8EQUYIC50OV4SNNbjyzglMdsFjpRcTFizd
         o7fs8K1QnHKYNM3AZoRRTDF9KazzKxDato3edbynD6GSjo/Hg2tGFikaSRbVQOe6Ej
         JXYjIs0433RPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 978D560A47;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bnxt_en: 2 bug fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128581061.6429.8518800649068439879.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 21:10:10 +0000
References: <1621063519-7764-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1621063519-7764-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat, 15 May 2021 03:25:17 -0400 you wrote:
> The first one fixes a bug to properly identify some recently added HyperV
> device IDs.  The second one fixes device context memory set up on systems
> with 64K page size.
> 
> Please queue these for -stable as well.  Thanks.
> 
> Andy Gospodarek (1):
>   bnxt_en: Include new P5 HV definition in VF check.
> 
> [...]

Here is the summary with links:
  - [net,1/2] bnxt_en: Include new P5 HV definition in VF check.
    https://git.kernel.org/netdev/net/c/ab21494be9dc
  - [net,2/2] bnxt_en: Fix context memory setup for 64K page size.
    https://git.kernel.org/netdev/net/c/702279d2ce46

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


