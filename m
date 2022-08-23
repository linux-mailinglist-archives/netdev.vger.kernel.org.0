Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB1A59CDBD
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbiHWBU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbiHWBUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C81458525
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74CC5B81A4A
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14A36C43140;
        Tue, 23 Aug 2022 01:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661217616;
        bh=8h5EoCU90RLTp4ULScVB3dG9NHazmCKI32PXGYFPz0w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S1z61/rUKWdEacteoJunTXaBwLefLRfaLtMm9wgn79EvbYAzItghNrms6MvGveLNw
         X0NX5fl4e1VZMd73U45+ZbWokxCpr9sFT4I8MF27t8XG2zYwQdqlQIMuX7er4dYF8u
         SxEEjP/gdSWTJXsJ1GaLMcQMXv9xQNPpGrEdMbxSo163uJNYxv8ub2AfxgSzc29YOR
         +zzmpneX2USO+d7MD63W1E/+jfEEYBmMBvGTqtBwzDVGJbpeZlf1StzlSOjPmRoeQ4
         wWycfEQPWq9J2jfcfdeID6en2dhjHcXIzvqONOEUfl6OIoQVjaNfiblUC6xPIaCOnw
         24cUpPO+U8NxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EAB5CE2A040;
        Tue, 23 Aug 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: tag_8021q: remove old comment regarding
 dsa_8021q_netdev_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166121761595.25281.10222367788508201284.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 01:20:15 +0000
References: <20220818143808.2808393-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220818143808.2808393-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Aug 2022 17:38:08 +0300 you wrote:
> Since commit 129bd7ca8ac0 ("net: dsa: Prevent usage of NET_DSA_TAG_8021Q
> as tagging protocol"), dsa_8021q_netdev_ops no longer exists, so remove
> the comment that talks about it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/tag_8021q.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: dsa: tag_8021q: remove old comment regarding dsa_8021q_netdev_ops
    https://git.kernel.org/netdev/net-next/c/b18e04e362c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


