Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE75A38138A
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhENWL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhENWLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D551A61461;
        Fri, 14 May 2021 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621030210;
        bh=0644Hxl3cYYHB0tCAJJLMMRQ/pCawIJWC/df87nRxNI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JSlwIinz1pXfaCkNRsAXc/y7savHkzu+cXu5JjkqECbHgnNG+MwgNyygEniF8YQEl
         6MjondPkOCnnuk34XqubkRloe3fBTfG6+XSIRVYz3Wz+MRuc9sOAAbwtZQ75RucWYK
         HUmrt6xhfvyqz2O+081mAU9hN2kKkWpjVK4+c9zySsIHg5geoUn/e7Uxlqi7vWhnPM
         4r1r+gynkOii7w1EbBcGMSzfyLn//bmGnYphtpTPhR6AcIMvMAonYAA8vOvKeBHuXx
         g8LpB+iqDh7vRNfTpH7L2L49EXT6YLuOWiYovyAEY+E8P87XvtmJJ0TJWzblZXYCPc
         1aYL6TZD2rH1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D00EC60A02;
        Fri, 14 May 2021 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: thunderx: Drop unnecessary NULL check after container_of
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103021084.1424.4996581481002361141.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:10:10 +0000
References: <20210513230418.919219-1-linux@roeck-us.net>
In-Reply-To: <20210513230418.919219-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 13 May 2021 16:04:18 -0700 you wrote:
> The result of container_of() operations is never NULL unless the embedded
> element is the first element of the structure. This is not the case here.
> The NULL check is therefore unnecessary and misleading. Remove it.
> 
> This change was made automatically with the following Coccinelle script.
> 
> @@
> type t;
> identifier v;
> statement s;
> @@
> 
> [...]

Here is the summary with links:
  - net: thunderx: Drop unnecessary NULL check after container_of
    https://git.kernel.org/netdev/net-next/c/fc25f9f631ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


