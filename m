Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BA02DA6B6
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgLODVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:21:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbgLODUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:20:51 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608002411;
        bh=UNq7aI/p3rKBu5FQFPrPtrcKxQ59uy3JU5i7ZP9Kgz0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KWMx6vMY6Dla7eoIT7sLGlQV0uSYhEVLxy/QpRckRGcuHqhQhAapxhFWS/1NCKA69
         lq9dvGhss/yfUTFEV/l3C48VrMiUkzPEBS+nK/WknGQ/qh1ouihTRaU8rXNNtR2j27
         GGAg31VQ1CYUIkldm4J4rW5wwi+ie6gmmxsdDTXbzXJ06TbzgliDMDD31T0uUkvDet
         DkrBKOAxwHfpxK4OBIo/9CHa/4tKAYUjl9000DPKsnZc4xe8n/NDVPIedLZi5aVkEd
         ZzPsHGi3m40ZvAkBEbBR3P7Z5YZnSjcbKtO/PwA6uMG5iOXkKFfQ+qaUj3jsd+N7Mj
         taU7EnJehLlTg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2020-12-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800241091.26355.5049066543526105105.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:20:10 +0000
References: <20201214133145.442472-1-mkl@pengutronix.de>
In-Reply-To: <20201214133145.442472-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Dec 2020 14:31:38 +0100 you wrote:
> Hello Jakub, hello David,
> 
> this is a series of 7 patches for net-next/master.
> 
> All 7 patches are by me and target the m_can driver. First there are 4 cleanup
> patches (fix link to doc, fix coding style, uniform variable name usage, mark
> function as static). Then the driver is converted to
> pm_runtime_resume_and_get(). The next patch lets the m_can class driver
> allocate the driver's private data, to get rid of one level of indirection. And
> the last patch consistently uses struct m_can_classdev as drvdata over all
> binding drivers.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2020-12-14
    https://git.kernel.org/netdev/net-next/c/b02487560740

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


