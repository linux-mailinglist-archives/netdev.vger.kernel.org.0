Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10CD3A8909
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFOTCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhFOTCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 15:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1194260233;
        Tue, 15 Jun 2021 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623783604;
        bh=ude39hIxq49TflpRGJ66Qi5iNJUMs+vDTLBbbYYp1yE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qHU+a+el32mwuxfku0ywbEOyXgMpowc5g6kG4kmRzPYUCPsatvBD6BOPrrXWFfM5r
         fWnG1DH59uqRKnUdhYe/cXom3m8kEaIRV6Dsmwy9rmNDbaQYXOWwE+ZJo2g3pqiPrP
         bzLj9wgVvXVXko8eQM/BS4DDhqX+HBlvvSU9LndhRQw/PdFctBkKSDRBe/MWWTVmCy
         6gWnoGN2tyE9cFRwUbZDh9cg/jOBvCql8PCjYUsV1STzHHEoTczE1tAo0XTfwldoIh
         IIbzV9zKzpZwsfCEacBYjQANvT0l//PAKStEX81APQ9UCWyYR4wG+XDS/lkYCNBIHv
         kEIurbeKpFScw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01095609D8;
        Tue, 15 Jun 2021 19:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: iosm: Fix htmldocs warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378360399.14059.5179537402082270786.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 19:00:03 +0000
References: <20210615130822.26441-1-m.chetan.kumar@intel.com>
In-Reply-To: <20210615130822.26441-1-m.chetan.kumar@intel.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com, sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 18:38:22 +0530 you wrote:
> Fixes .rst file warnings seen on linux-next build.
> 
> Fixes: f7af616c632e ("net: iosm: infrastructure")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
> ---
>  Documentation/networking/device_drivers/wwan/iosm.rst | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net: wwan: iosm: Fix htmldocs warnings
    https://git.kernel.org/netdev/net-next/c/925a56b2c085

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


