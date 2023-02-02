Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B462688045
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjBBOkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjBBOkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA798B7DC;
        Thu,  2 Feb 2023 06:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1089161B8D;
        Thu,  2 Feb 2023 14:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 639F0C4339C;
        Thu,  2 Feb 2023 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675348817;
        bh=hefmgxWkP5BXpNz0IwCOCVrIKYFxyb05KsrnUYM6zLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TMsCRPggYShlyWXR36L3bU5y9OmVPlz4LZTW8kzgyz8t1RbXP+koIF3tx/H9Ms3n3
         2YkLafltK7eI5I+xcvO0NDGk49S/3SIliFgzjI38J1rEVNiLx9BwYz6Z9qnwGG5awF
         WkobJ2SHOzEB5j/rCnfUP5K7XF7Ti9OMy726IHoFgIVrd6ZhzELVophFMKwDl56/BG
         UIuqeHuy38qOF06Oj+jtu5b9TB0E8F1JLb4xXYuVfE8bQiR1+oB7W5/c1BMs2Tf+jq
         /V++3D9k3tvkeuaT5v/URUV859TongqDGz1yEJ8wZu3gytMlDvp8UFlw3l2Nkh/Po6
         jBHndSBPAfiIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49204E21EEC;
        Thu,  2 Feb 2023 14:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: Use sysfs_emit() to instead of sprintf()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167534881729.17586.13807179422963728944.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 14:40:17 +0000
References: <20230201081438.3151-1-liubo03@inspur.com>
In-Reply-To: <20230201081438.3151-1-liubo03@inspur.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 1 Feb 2023 03:14:38 -0500 you wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  net/dsa/master.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: dsa: Use sysfs_emit() to instead of sprintf()
    https://git.kernel.org/netdev/net-next/c/b18ea3d9d214

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


