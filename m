Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131F03CFBC9
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbhGTNeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:34:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239098AbhGTN31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B69706120E;
        Tue, 20 Jul 2021 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626790205;
        bh=eqmvxaVUDoF2SK7S5vHY5TVj8wvy42LCEKEaYJEdJeI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gpv+8pvcaqhJKxaCRSwuzzdhCGQILGsEpdBwDvynY/qteXKn2fXmPtt3gk2ojAZe7
         RehmhIOreWWWZHUD3pA/CwMuiBp1SaYCl4hTBBKVhmuTV+LA2OrFNTLd+Fe661XaO4
         6fItYhfGhlxJI336Jpg4rPABybi+C6Zt0gyKwmhGGKJ0AgxWwseVpDfTVz7XbgwMR4
         Hjx5rxYHEFgvBOQbXh9GpdMHPWv4y0qJd66hfnLSIaHmcH2JyicHC2LVLVX9ot0iC0
         ATcgyKCe7A7Q8vT90qIkQ+PEvEXnQ8iQC6R97MqFlcaKYQ2Vt1JOiM4+OB+6p8jEAr
         kV+xwLYQJrzXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB3BF609DA;
        Tue, 20 Jul 2021 14:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: fix IPA v4.11 interconnect data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679020569.11280.14794218136259939124.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:10:05 +0000
References: <20210719202333.3067361-1-elder@linaro.org>
In-Reply-To: <20210719202333.3067361-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 15:23:33 -0500 you wrote:
> Currently three interconnects are defined for the Qualcomm SC7280
> SoC, but this was based on a misunderstanding.  There should only be
> two interconnects defined:  one between the IPA and system memory;
> and another between the AP and IPA config space.  The bandwidths
> defined for the memory and config interconnects do not match what I
> understand to be proper values, so update these.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: fix IPA v4.11 interconnect data
    https://git.kernel.org/netdev/net-next/c/0ac262713444

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


