Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE24D40DABE
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239924AbhIPNL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239837AbhIPNL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BD6C561185;
        Thu, 16 Sep 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631797806;
        bh=32FmVJ7t16F2cStrYoDCWVIRxEMzith3vGLIRaGQTLs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jNHYWKbskGsX5xHAOazjNkgNE6gLFKUmgUYtHdtnOF6hFhDmcuVP+2DDUs8vPFY8s
         cYzFVDaKoWmnfP9JnrTwlTMt2GtdLh7Kl+8TyPRzmuPzK8+MFxwyxO20zLQsH99Aca
         qGyVMDMBsd7VeajDiXBXRhSUIxizOviOKME45JjLVQcAkJMMBrvkrXVMnnEwxHNlSS
         2AoQQ0aWQeM7VIAfVR8BLP/tnd/FppsWDxTKHlza6mZUVpie9OmAitvT7CTjSbk/AG
         W7xNmIixPz1aKRT2iwNH7EvOSV74fq2E1HoqA6k6iwEO+0xlVAGKif6QL9PXiZyh0a
         lzhhq62HGaYIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A4EE360A9E;
        Thu, 16 Sep 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wan: wanxl: define CROSS_COMPILE_M68K
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179780666.1674.15846779905460998420.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 13:10:06 +0000
References: <20210912212321.10982-1-kilobyte@angband.pl>
In-Reply-To: <20210912212321.10982-1-kilobyte@angband.pl>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     davem@davemloft.net, kuba@kernel.org, masahiroy@kernel.org,
        dhowells@redhat.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 12 Sep 2021 23:23:21 +0200 you wrote:
> It was used but never set.  The hardcoded value from before the dawn of
> time was non-standard; the usual name for cross-tools is $TRIPLET-$TOOL
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  This is neither the host nor target arch, thus it's very unlikely to be
>  set by the user.  With this patch, it works out of the box on Debian
>  and Fedora.
> 
> [...]

Here is the summary with links:
  - net: wan: wanxl: define CROSS_COMPILE_M68K
    https://git.kernel.org/netdev/net/c/84fb7dfc7463

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


