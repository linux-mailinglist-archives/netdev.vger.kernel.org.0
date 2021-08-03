Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE01A3DED31
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbhHCLuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235545AbhHCLuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 635F460F56;
        Tue,  3 Aug 2021 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991406;
        bh=MAc/ugaKBGgHBxd6X8DQM3qO4mzZBrs4eg1hYKZTRDU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ho4G3eHtSam25D8fwzbGCrLZMXsQjnjVbknW8SRPWlw1HB5IsBWJWolPaKFpSOtRf
         bAl284xqjrWH4+pzuso3j4rm7I18dRAiRwSjCtXdKe0+TB0FHyw7Dd1Z36V8dSBRbH
         fQ2zGtG9l+uPzoWTWa/KFXAiVEWP1fjSKzh1R4/15xIfJ9NcF9mvcykHwrTPkqe8Hi
         LDnabZtrol+58Rc4LJOPaUt6BVXEaxc0x4TP32TAyWrN4Xjed7pidKG/rd9FTX4w1G
         8FE40ldImgSRcPVaq6fiv77MAFBDuvpajBqYVFCL3HUJz4iI+u14+FTb6/BDAip6Kr
         K1KHxmLaVQM6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 54AFE60075;
        Tue,  3 Aug 2021 11:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] bnxt_en: Increase maximum RX ring size when
 jumbo ring is unused
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162799140634.31863.17683221532905359941.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 11:50:06 +0000
References: <1627915959-1648-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1627915959-1648-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  2 Aug 2021 10:52:37 -0400 you wrote:
> The RX jumbo ring is automatically enabled when HW GRO/LRO is enabled or
> when the MTU exceeds the page size.  The RX jumbo ring provides a lot
> more RX buffer space when it is in use.  When the RX jumbo ring is not
> in use, some users report that the current maximum of 2K buffers is
> too limiting.  This patchset increases the maximum to 8K buffers when
> the RX jumbo ring is not used.  The default RX ring size is unchanged
> at 511.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] bnxt_en: Don't use static arrays for completion ring pages
    https://git.kernel.org/netdev/net-next/c/03c7448790b8
  - [net-next,2/2] bnxt_en: Increase maximum RX ring size if jumbo ring is not used
    https://git.kernel.org/netdev/net-next/c/c1129b51ca0e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


