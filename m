Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27143A354E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhFJVCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhFJVCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:02:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 47D04613E7;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358807;
        bh=gQn1OCpH9FiMtSDU3KPmVf0lQwc+n6bhW0cgFyyO+fM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bkZDVSaD40TwwsjETeUAkVIV7nHIhtKyxp0XbWd9UhxvjsvFUhocyanfrWcCGDyt2
         xwzgWLp4I87cwd9F4mjnLbrLX93UIBjN9Gb6UP8R3ulqrulRBM8Oc2BTPE5x2wGkbV
         ENLlTOu9pz2KNgCq7f6tXfIgTIaO+RISTaUbsuttngRlWsbq5vO5OreEP1wpWDoWH3
         HfdwKyO08YLxHex0Blo8qGv5seaP1fZGVQ6GOPGHL33fKlDhvqk0AZkmPrl0iL4Uoq
         64/ECulNAfruEEGoE0Me0waKSZdXOf6w6wYk7dxdE7h7Bhrh2w3x8MKmFppLnCCVjR
         3moSZx2ScHkMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D31660BE2;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: stmmac: Fix mixed enum type warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335880724.5408.11064067362825446290.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:00:07 +0000
References: <20210610085354.656580-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210610085354.656580-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, qiangqing.zhang@nxp.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 16:53:54 +0800 you wrote:
> The commit 5a5586112b92 ("net: stmmac: support FPE link partner
> hand-shaking procedure") introduced the following coverity warning:
> 
>   "Parse warning (PW.MIXED_ENUM_TYPE)"
>   "1. mixed_enum_type: enumerated type mixed with another type"
> 
> This is due to both "lo_state" and "lp_sate" which their datatype are
> enum stmmac_fpe_state type, and being assigned with "FPE_EVENT_UNKNOWN"
> which is a macro-defined of 0. Fixed this by assigned both these
> variables with the correct enum value.
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/1] net: stmmac: Fix mixed enum type warning
    https://git.kernel.org/netdev/net-next/c/1f7096f0fdb2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


