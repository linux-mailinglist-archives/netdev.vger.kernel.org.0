Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477EC37EE9D
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348092AbhELVzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1390993AbhELVVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6402061264;
        Wed, 12 May 2021 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620854410;
        bh=VmOZv9p56pL3wba3dxCNrn4hX2NTFN2PN34AgaXiFaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H3n5jUat6WIe2QIh/hA3zVSFq4TrsKatpSfPaIOXtlF7S+DB9yihQ7XEoymAZegmD
         rNzjj6w2LF+imwiAKbW9H0eOvgNQoJtSsODVxxleUUvAA8PnMpgTFgepk0iIeAYxt9
         Jkog7lWJ1G7x593tnfdrhke3Cq5BCIFHwKYVbNkd+XYW20Cm7nuvwdQ/MAoyakV/oz
         vQSWHcxOW0xw5m7ppyXAqmFIUV2mUDf9gsRf6X2ZfWQD3K26JbcDzkAtHOQJvlbT1v
         ftmO3/osCiK1KxsjnKGkPZhb2qyWVTBjD6ux6EihtGZwPznvUQRDVBCC0xzLmLgxzA
         XaEulbmXjHQIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 55C1560A23;
        Wed, 12 May 2021 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-05-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085441034.10928.2548564810445954372.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:20:10 +0000
References: <20210512071050.1760001-1-mkl@pengutronix.de>
In-Reply-To: <20210512071050.1760001-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed, 12 May 2021 09:10:49 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of a single patch for net/master.
> 
> The patch is by Norbert Slusarek and it fixes a race condition in the
> CAN ISO-TP socket between isotp_bind() and isotp_setsockopt().
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-05-12
    https://git.kernel.org/netdev/net/c/364642ae80d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


