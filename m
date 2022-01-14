Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FF048E92F
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbiANLaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240807AbiANLaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:30:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBBCC061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 03:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D636B825C9
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89C59C36AE5;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642159810;
        bh=qRuztHblUgTnjId+cPkUPQWcProKo9wIkKwI+K3XZWo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lhd4l7+VLSVtlHYxBHhEke28GklPhxC19EW7XpFQOsy9QCNxHOoZPGVSMH+sihQ9m
         Der3Exv/RM3OnNRYYGdBOdUmUXqUuHctI3Ukw6Tjb7qBrYxtz5chPU+C9KGgKeuvez
         RQ7FQyHlZkhmt14s6lZ9KiUMk5W/ZeZ/cgU7Evq2XwOxgmgcwZq9oQ59+7+Qol2H1Z
         bC90+yLj0IZiBJSxFbhQRQkAWTyMihm5NZNjdsOep6u66u2i+otbxX7E+Lnpyqdbq4
         1UKp/AXTOqgOuV9gQhPhsMmkkKYIaxcws3muIFZJZRqpZemrGAjtJ9xI61mALiF5E+
         GXjzspXlQx6aA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6659DF6079B;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bcmgenet: add WOL IRQ check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164215981041.30922.14283745456970743905.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Jan 2022 11:30:10 +0000
References: <2b49e965-850c-9f71-cd54-6ca9b7571cc3@omp.ru>
In-Reply-To: <2b49e965-850c-9f71-cd54-6ca9b7571cc3@omp.ru>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Jan 2022 22:46:07 +0300 you wrote:
> The driver neglects to check the result of platform_get_irq_optional()'s
> call and blithely passes the negative error codes to devm_request_irq()
> (which takes *unsigned* IRQ #), causing it to fail with -EINVAL.
> Stop calling devm_request_irq() with the invalid IRQ #s.
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> [...]

Here is the summary with links:
  - bcmgenet: add WOL IRQ check
    https://git.kernel.org/netdev/net/c/9deb48b53e7f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


