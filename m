Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE752F595E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbhANDat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbhANDat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C57412368A;
        Thu, 14 Jan 2021 03:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610595008;
        bh=JJVpLDEOiUu0dOmbzikgmD74zpwFlmcyR0cyjN3I1kc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mRCQujYmv1t4LOnfNO9zpGhoj8nLFh+qxRFj/d0kBi6CQ5WYmU/GSLJYmfPFkJ/sT
         h7hIlKc9W+05fgQkfdu1GyLQVtLhjCSy6Kc0Eebr6IMDLpLnX2KmSZsehXV4DAkL6z
         mK9WPcCY4kqGjIRM65AoN+eXVxcJO101er881/L1SbE83Wcy4aUD0ih2SLPz/pu/jT
         Y5y+42Yrr16OfCzweZWWZjB6043wCm33RD2uYsyMt9qUnwM2vfxEdt9I4xw8QLGpdR
         bVnRd82gtK2APlcBMT1B3nfoa3tQCTibfHwuEoN9QDcRhD7e+xVtSR+FV3LGFugtAp
         2uZwFO7bA8ugg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B670260593;
        Thu, 14 Jan 2021 03:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dpaa2-mac: fix the remove path for non-MAC
 interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161059500874.5331.12904014554114773190.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 03:30:08 +0000
References: <20210111171802.1826324-1-ciorneiioana@gmail.com>
In-Reply-To: <20210111171802.1826324-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 11 Jan 2021 19:18:02 +0200 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Check if the interface is indeed connected to a MAC before trying to
> close the DPMAC object representing it. Without this check we end up
> working with a NULL pointer.
> 
> Fixes: d87e606373f6 ("dpaa2-mac: export MAC counters even when in TYPE_FIXED")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] dpaa2-mac: fix the remove path for non-MAC interfaces
    https://git.kernel.org/netdev/net-next/c/848c1903d35e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


