Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6211B5FEA5C
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 10:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiJNIU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 04:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJNIUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 04:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55AD97EC3;
        Fri, 14 Oct 2022 01:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 289CF61A3E;
        Fri, 14 Oct 2022 08:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DB24C433D6;
        Fri, 14 Oct 2022 08:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665735614;
        bh=+B4PXo4lORogkaXt0TnLgHHCs7kOLGm/s+fo7d9KVZ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P/0vuIp90SsI/nah7/waLUaQDVZ+KF+uXr8HamX0DzpK+kyoRnPKqeeac/i8qXIFf
         8+Fl4hqUAsc8tnZl7h3o4w99977aL/VoKA73ZwS8M2dZWowsavJBcdjn9OerODJ7qR
         RA4DfonkmCjy4xJezSEvPjHt3tgX7pO4xTDYlBnQTQ/9W4O9S00MzkXApAYZ+XbdvU
         stEMfiG+D8Nv2p0ZkSeviMdOKlzWocgMEtI2fM6d9lm9rmPlGNPP1LLpkSrj2sxQGx
         +N0fTn2UWRLlFozKM5yAhVRMxrFk+KTHPSOIAjAdKtSbs+mqrgDvuhwYfvkp6ewFgj
         F69Tc8YLCijWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EEB2E4D00C;
        Fri, 14 Oct 2022 08:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: git://github -> https://github.com for petkan
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166573561445.14465.3335360255597249102.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Oct 2022 08:20:14 +0000
References: <20221013214636.30741-1-palmer@rivosinc.com>
In-Reply-To: <20221013214636.30741-1-palmer@rivosinc.com>
To:     Palmer Dabbelt <palmer@rivosinc.com>
Cc:     petkan@nucleusys.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        conor.dooley@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Oct 2022 14:46:36 -0700 you wrote:
> Github deprecated the git:// links about a year ago, so let's move to
> the https:// URLs instead.
> 
> Reported-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: git://github -> https://github.com for petkan
    https://git.kernel.org/netdev/net/c/9a9a5d80ec98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


