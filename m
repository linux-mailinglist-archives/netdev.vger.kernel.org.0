Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199F9545C26
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 08:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245460AbiFJGUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 02:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbiFJGUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 02:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1E138B
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 23:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DDEA61ED8
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 06:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9107EC3411B;
        Fri, 10 Jun 2022 06:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654842013;
        bh=02V4SN6liUnzb8LuvpphZ1yA0DHup2yY23WRsYr2ljk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F4AYr+fBdY5/ZZeghEcc8yueo56vWu46o6j2KnUndaGIKu6l6nzA0VV7ae/pjlSOR
         wwZN/MjQyWTjIeBp+5lBphwPR0Vwqa7Um+jK7v7g8igufEyY/RodR2WXk9EjB3cmMr
         Qp/rTCNg52DIGkoy5hwYfiaXbRlbA4HZA5nyS1NprTDOlMV3UKLaNPh061Y2xA9xsj
         8pGuyfSrNp3mWETYp3+DFam9JipoCFRLRSzqNrPJCd6hgY7kNduG4H3EcOV2lyQFfp
         U14rjkygJwcExqf/saQR1nAzT+dAisrQj7ERC+D157agBP/nl3/CPIF8lNOMVDmdm2
         jHLEyPvxZ++NA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 717A6E737EA;
        Fri, 10 Jun 2022 06:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 0/2] bonding: netlink errors and cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165484201346.1106.1962248931865543911.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 06:20:13 +0000
References: <cover.1654711315.git.jtoppins@redhat.com>
In-Reply-To: <cover.1654711315.git.jtoppins@redhat.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Jun 2022 14:14:55 -0400 you wrote:
> The first patch attempts to set helpful error messages when
> configuring bonds via netlink. The second patch removes redundant
> init code for RLB mode which is already done in bond_open.
> 
> v2:
>  * rebased to latest net-next
>  * fixed kernel doc header for __bond_opt_set
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] bonding: netlink error message support for options
    https://git.kernel.org/netdev/net-next/c/2bff369b2354
  - [net-next,v2,2/2] bonding: cleanup bond_create
    https://git.kernel.org/netdev/net-next/c/2fa3ee93d13c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


