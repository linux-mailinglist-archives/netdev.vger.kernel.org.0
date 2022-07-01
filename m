Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774D056319F
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbiGAKk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbiGAKkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064A37B370;
        Fri,  1 Jul 2022 03:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 970356246F;
        Fri,  1 Jul 2022 10:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5585C341D4;
        Fri,  1 Jul 2022 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656672017;
        bh=+XrApsa1jVLGVuXVbtVUV2WhBjGNdM1lBHY2j5n+GDk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fve3xVL5e+zc06wiv8SfZqssrL+ro3lAWh/OCfklxxu/YuC8M1usEMNcUQzp0c/Z0
         IgoqChZDwODrgtZ0xwamrud7Y/h5Rdq78ltbcfXoVAiXgp9k8jbRj8gt1xObvJCgT8
         YzG38j4EgryHkvXeIngskEVyLsc1mL3coH+YwEFqpJIuCi6ElnByovBXmLr+Jl+dfQ
         gloI4s2hTjsxzsLiJP7BBfF7SocFAG9Nv4UIiJr2kgJ5GNiW6WR1EoHEhXrndi55xb
         8hBChaWdoeTFnIBjQ2htT2C9GlBsMkBDV2701mfLmI+ahn70CYMJH7lfEgngU3+Njf
         Ovy5GmviEdVfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B672E49FA1;
        Fri,  1 Jul 2022 10:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mellanox/mlxsw: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165667201756.26485.9541138901183243656.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 10:40:17 +0000
References: <20220630074221.63148-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220630074221.63148-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, idosch@nvidia.com, petrm@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Jun 2022 15:42:21 +0800 you wrote:
> Delete the redundant word 'action'.
> Delete the redundant word 'refer'.
> Delete the redundant word 'for'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c | 2 +-
>  drivers/net/ethernet/mellanox/mlxsw/core_env.c              | 2 +-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c        | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - mellanox/mlxsw: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/627838275a54

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


