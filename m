Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D213732244D
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 03:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhBWCv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 21:51:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhBWCvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 21:51:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7FE3864DD0;
        Tue, 23 Feb 2021 02:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614048640;
        bh=TgE1aeLrAigPkjiXgB9ehpXReG7pbTpsPPmojpzetC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F3zNfueiGXY2eKTYrN5PSRSwDIgRORy8vW0ZNLNBW1vG/HU2H/yRzRdM1HWOnVI0Q
         AS1zkRRq8a5+ZKzkJSQj4A37SDDRsh/7/Z240S9+f5lu459K+Ujyy2dRJyWeuQbUQ0
         MhpEIWKB9ru6HPm6wdtD3UX/myOHAU2u96oRzSyczynN9Rct3BcnYcAV0wjTwsjrPF
         +X5SsyrSCii3BpJRxXCrFpKClyPRCpbIGnIrP+He+e+jOvfEGafCEF7v1anquaIZ+Z
         gedZhCj5Pc8YAqh1CGYNLb/eCR6Mf5HX/SOXUv6+eKdskQeXau475k8mOsHFro5zoS
         e7FzrZYL0jQeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 71E65609DB;
        Tue, 23 Feb 2021 02:50:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: mvpp2: skip RSS configurations on loopback port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161404864046.30785.4575781644892944950.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 02:50:40 +0000
References: <1613652123-19021-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1613652123-19021-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Feb 2021 14:42:03 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> PPv2 loopback port doesn't support RSS, so we should
> skip RSS configurations for this port.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvpp2: skip RSS configurations on loopback port
    https://git.kernel.org/netdev/net/c/0a8a800027f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


