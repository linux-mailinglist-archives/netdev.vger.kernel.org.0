Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BF136715B
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244760AbhDURaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244681AbhDURan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 597936145F;
        Wed, 21 Apr 2021 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619026210;
        bh=oKYnH2gsKoQbVYXzSxJCYULxUPFnJ24wTgRD9TyXuT0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V5PsviPTpwXStpsmsJIEV5zm8HNVlITlZL4m5Imt2loluqNJ++kxG5E4HoZ+b/sFn
         2Z/MLKlXOYxjlO6nGr5PWSWk1sBo6B4GsFX1T18p1AamOw0aHKZtusOaXGaXs9R46J
         NOoz4sqIA9q6TY9K9PqxTEe0e/rq4iL0PjxVLDQfW4SQ/8NzKs279d/xupIV5sTxBA
         GtcN75HowtrceeczF8Bokq1vZHP43vhc59KIwuCXiYj2UTGRGGHCx5cvbU+S/ULcyr
         8xFAKrxEI5ABpsHVaMzE+L/qljO8D7FMnBy7yAC75x04YDwF2HMVm0bRqQkbY9wzsc
         yRMTPnbAWytcA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 515A060A39;
        Wed, 21 Apr 2021 17:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] Add support for CN10K CPT block
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902621032.9844.14587772703604794442.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 17:30:10 +0000
References: <20210421092302.22402-1-schalla@marvell.com>
In-Reply-To: <20210421092302.22402-1-schalla@marvell.com>
To:     Srujana Challa <schalla@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        sgoutham@marvell.com, lcherian@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        pathreya@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Apr 2021 14:52:59 +0530 you wrote:
> OcteonTX3 (CN10K) silicon is a Marvell next-gen silicon. CN10K CPT
> introduces new features like reassembly support and some feature
> enhancements.
> This patchset adds new mailbox messages and some minor changes to
> existing mailbox messages to support CN10K CPT.
> 
> v1-v2
> Fixed sparse warnings.
> 
> [...]

Here is the summary with links:
  - [v2,1/3] octeontx2-af: cn10k: Mailbox changes for CN10K CPT
    https://git.kernel.org/netdev/net-next/c/e4bbc5c53a8f
  - [v2,2/3] octeontx2-af: cn10k: Add mailbox to configure reassembly timeout
    https://git.kernel.org/netdev/net-next/c/ecad2ce8c48f
  - [v2,3/3] octeontx2-af: Add mailbox for CPT stats
    https://git.kernel.org/netdev/net-next/c/2e2ee4cd0ab5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


