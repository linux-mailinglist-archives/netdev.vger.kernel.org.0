Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA7A47842C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 05:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhLQEkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 23:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhLQEkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 23:40:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A96C06173E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 20:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60AF362019
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A87F9C36AE2;
        Fri, 17 Dec 2021 04:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639716010;
        bh=ny3AD+mCyawMo81mcXYyGDz+fAWIu3z1+WVdSZbMOCE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QXTxEj/D6x9dzfOeYjt4JKNL9pd8OrA0bM9m5Bp0mEoX/jF5E8p6jRJWWfPv3A26t
         C1C/ES+cPIX3iR0aFCVSh4BpjpnHPe6GC9c5bzM6ejgKPdkkkDsKdc6lBGXIWY3Ek6
         V83zoHIZhyZoe0bES+CSzOdBlxDHbVAcs1gc7JoJBUoHQRbjHZRZbvxwRdj+50hsiC
         UKT3YjGfFse5olm/SVIzpiOIHeFfaPB1WrpfvU7lhagL2b0HUMtnpe5LcdV4fgO++D
         VuZhrGxG/wstaA6hfHCroOVYawqkR53Dv9BxMB6tl0XIknCAZiG9p2DSru91BkwEWc
         rR+G7vPTcKQVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8EDB160A7D;
        Fri, 17 Dec 2021 04:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: refine the use of circular buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163971601058.6242.5580381594374485707.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 04:40:10 +0000
References: <1639618621-5857-1-git-send-email-yinjun.zhang@corigine.com>
In-Reply-To: <1639618621-5857-1-git-send-email-yinjun.zhang@corigine.com>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, simon.horman@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Dec 2021 20:37:01 -0500 you wrote:
> The current use of circular buffer to manage stats_context_id is
> very obscure, and it will cause problem if its element size is
> not power of two. So change the use more straightforward and
> scalable, and also change that for mask_id to keep consistency.
> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: refine the use of circular buffer
    https://git.kernel.org/netdev/net-next/c/7ffd9041de76

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


