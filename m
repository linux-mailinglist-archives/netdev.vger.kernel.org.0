Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B5732244B
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 03:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhBWCvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 21:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhBWCvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 21:51:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 87E4D64E4D;
        Tue, 23 Feb 2021 02:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614048640;
        bh=aUP1AbpGJL1EPIYne0C5OUEg/IZJm24XGApkTToPXRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LtWAOsPm3fWHqNY0bNbArzdAdG5ICRTyiJhk5AM2+XGJGWQZcgvycfFfAc9vVtlRP
         e0uFaLyCmW5uYA7e7OvvMVc3Ko45zm6SCLVLJHWTNeyBWz1guHnw6tsVgARepMsnU7
         l9/lEeFSezgL04f/MHjXWVY5Ibq0it69jC9i3oLBVWTRdwvae4wJrNFcUyYfd2vTsx
         cK1ucNHjWW6T2TpXU8frf9VWhvczr6t3xJeh0FKFMborbqlJjPmpSDHwRQ8Tc5Rh6U
         meufjx4nxWVIJOdbaWerOktjVqe7qoiZbr/2gs9z1FZp7xnFxOfiZrPp9nm5kCHg8r
         vJPaLkZAlRPlg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7BE3F60A10;
        Tue, 23 Feb 2021 02:50:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dpaa_eth: fix the access method for the dpaa_napi_portal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161404864050.30785.6758358504606281208.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 02:50:40 +0000
References: <20210218182106.22613-1-camelia.groza@nxp.com>
In-Reply-To: <20210218182106.22613-1-camelia.groza@nxp.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, davem@davemloft.net, s.hauer@pengutronix.de,
        brouer@redhat.com, madalin.bucur@oss.nxp.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Feb 2021 20:21:06 +0200 you wrote:
> The current use of container_of is flawed and unnecessary. Obtain
> the dpaa_napi_portal reference from the private percpu data instead.
> 
> Fixes: a1e031ffb422 ("dpaa_eth: add XDP_REDIRECT support")
> Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] dpaa_eth: fix the access method for the dpaa_napi_portal
    https://git.kernel.org/netdev/net/c/433dfc99aa3e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


