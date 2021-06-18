Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209803AD2B5
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbhFRTWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235383AbhFRTWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 87A30613F2;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044006;
        bh=mYgWKU/yFlFwqULnKKlEddjTohRi2vp79RE6lcadDus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ya1dUiVpey5BGTaPAgG72l5NSbk68K6gUlnuPIXj4nIU8PKKmPHpMDXzOINxdXnfx
         A/bDEC+eXvijvwpWL1eMpChIlzrHUN1fvQz8oq49AFc2yokrMSATP6siskPrQNL++K
         oZRw9cYtNFFj3zSsv2wo/qlZ+CIQKwDBUgnaVsz7h50bLds0uI25eidLsBo1V3rF0u
         6DU/Vm6HlW6IfxIgpA/XR+/OtWfGHHtziyON1A+CxhX05y1UG41Pzodoa+5IMTbUcE
         NJMsfnOTnk2sN70bXfiH/CfB7DejDeN+votONz8/cQtg0QkobwID/HAuKWC7vrN3Vd
         B03WSkZX8V5KQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D71B60CDF;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bridge: remove redundant continue statement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404400650.12339.9396305686886729563.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:20:06 +0000
References: <20210618100155.101386-1-colin.king@canonical.com>
In-Reply-To: <20210618100155.101386-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     roopa@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 11:01:55 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The continue statement at the end of a for-loop has no effect,
> invert the if expression and remove the continue.
> 
> Addresses-Coverity: ("Continue has no effect")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - net: bridge: remove redundant continue statement
    https://git.kernel.org/netdev/net-next/c/040c12570e68

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


