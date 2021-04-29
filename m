Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D5836F2C5
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 01:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhD2XBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 19:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhD2XA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 19:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CE1C16146D;
        Thu, 29 Apr 2021 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619737210;
        bh=PNRdKIVFmS42IKEbjoyYwWZFD+mtBFWjxssPsPTWwtc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BvAiMrfFYGnI+aeSZNqTtFXUd2u5QcIwnBQhM9GnBc6uGdVxRAjYFjizZju09JwjC
         H4+2gxHIjiVg2iWJoOTZ7SD0peX9pJJtOGsn1rkZK77qUBL+GENqjJEgSiyiWrtWuG
         jVlouB3jyASDpmjF3i4aR1fgarMIqbktXVBPbfjq5uPMdzzSGuGy5Np/2jyYvCdjuz
         pZaT25ZU1x7uuOBsYG99n1vDfcaoQFiMbmn1P+zTQaKCOzAsRDyxhy9BSosY+SuiKU
         nBULLYYKIXG3dcyjNWwm8cIzsyvpmFS7v3qxuHcrorBLYF419ndxXvGRkvpsbWH+L1
         7CAx0h4kDTwsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BE08760A72;
        Thu, 29 Apr 2021 23:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: Remove redundant assignment to err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161973721077.25365.3622601507477450777.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Apr 2021 23:00:10 +0000
References: <1619692705-100691-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1619692705-100691-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 29 Apr 2021 18:38:25 +0800 you wrote:
> Variable 'err' is set to -EIO but this value is never read as it is
> overwritten with a new value later on, hence it is a redundant
> assignment and can be removed.
> 
> Clean up the following clang-analyzer warning:
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1195:2: warning: Value
> stored to 'err' is never read [clang-analyzer-deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - bnx2x: Remove redundant assignment to err
    https://git.kernel.org/netdev/net/c/8343b1f8b97a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


