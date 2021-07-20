Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346D63CFBC2
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbhGTNdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239095AbhGTN31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA08261208;
        Tue, 20 Jul 2021 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626790205;
        bh=p9VCVXxxIVemrVvV6868AGK9xupsroH0mbRQk2tNnFQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o6gAjeMtGnIMoqaGU/0R5uw7Oa75JJpFdX6Zd3zCCrTLk+NKaSmleQpf7ygrUGxP5
         VWr0SBYy6EIpGYsyOnk6f7THj65ypVow7yBV7V+GkgaZ+Nz+Z99E7x64s3uv8ujCrR
         s5kcZHKnDMwm7SdxrQFMucqeGOMoJwaK1TFoWtnUILjY9xo5a4+SdSN6EiJr0z6Vis
         g5MmkZtIoY6t7EJmYMfrijGlbUeE6KjtmowISC8VkMmPhLYYh8KbPFm70WeJILvxPw
         xhdSyyuh1Pvu6l7zgHRbQIT/j6C1AEs0cslSDal3XuhahX+qFHQDtcrV9q5mMAgLiS
         thrJHBfiv3vKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A045460CD3;
        Tue, 20 Jul 2021 14:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dt-bindings: net: fec: Fix indentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679020565.11280.13360005639657691235.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:10:05 +0000
References: <20210719232639.3812285-1-festevam@gmail.com>
In-Reply-To: <20210719232639.3812285-1-festevam@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     davem@davemloft.net, qiangqing.zhang@nxp.com, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 20:26:39 -0300 you wrote:
> The following warning is observed when running 'make dtbs_check':
> Documentation/devicetree/bindings/net/fsl,fec.yaml:85:7: [warning] wrong indentation: expected 8 but found 6 (indentation)
> 
> Fix the indentation accordingly.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] dt-bindings: net: fec: Fix indentation
    https://git.kernel.org/netdev/net-next/c/a38c02ef48a1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


