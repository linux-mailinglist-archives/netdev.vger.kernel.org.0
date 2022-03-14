Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8674D8FFA
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 00:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240942AbiCNXB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 19:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiCNXBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 19:01:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A737A344D6;
        Mon, 14 Mar 2022 16:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2D2861471;
        Mon, 14 Mar 2022 23:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58D69C340EC;
        Mon, 14 Mar 2022 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647298811;
        bh=6s3D7XIMBCpNHthHOowBN734QnPIA/co6v6fy7MKKp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TIzJAR5ZZWmI35jMjm9aefQ85Jxjgb3ZWU4R4IQD4V0Xx6atpKRJNyTm7hQihSkPy
         TChMnBOygUPeSVn/0PBapiPTrTM4h3LSiHRlz8tSGTFc8feFi1Jvwo0q6xlq2Mfp8l
         TeeY7BNz3P0HY7R/0yoOAfYix3a+Xl5z8elTmJ8wKzP/FKOK6gGmtP3/ZREaNM7vDm
         Nsw0qJ1oZlnuYy/GXe6yVoH44CJKC/4qx9C5OLWctKAkIpEmGakX7dA5KUcydNMKTh
         KrfSvZh3fXI+8AICyuK4O3lzbgRRRYNVzwirO4sVtmx3yRW3hH6DhvD87sq4Gwtok/
         5ObGSfYCfFQyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B2BBEAC09C;
        Mon, 14 Mar 2022 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] Revert "netfilter: nat: force port remap to prevent
 shadowing well-known ports"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164729881123.32127.13615817418002949527.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 23:00:11 +0000
References: <20220312220315.64531-2-pablo@netfilter.org>
In-Reply-To: <20220312220315.64531-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sat, 12 Mar 2022 23:03:13 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> This reverts commit 878aed8db324bec64f3c3f956e64d5ae7375a5de.
> 
> This change breaks existing setups where conntrack is used with
> asymmetric paths.
> 
> [...]

Here is the summary with links:
  - [net,1/3] Revert "netfilter: nat: force port remap to prevent shadowing well-known ports"
    https://git.kernel.org/netdev/net/c/a82c25c366b0
  - [net,2/3] Revert "netfilter: conntrack: tag conntracks picked up in local out hook"
    https://git.kernel.org/netdev/net/c/ee0a4dc9f317
  - [net,3/3] netfilter: nf_tables: disable register tracking
    https://git.kernel.org/netdev/net/c/ed5f85d42290

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


