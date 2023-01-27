Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF2467DAED
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbjA0AuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjA0AuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AE1470B5
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35077619E9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 00:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87164C433D2;
        Fri, 27 Jan 2023 00:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674780618;
        bh=vr3P9n4GvuDivyyrJpfyxzDw/FpDWLI5154czKjeOss=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jDLpuS+rIxNiNc+2qm7i+95aBC898pJ95HmM1A+TIniSwKxaNK7ADrOcBRMf3u0Wv
         L4aN1PX06M9tMRftCvT1w6HXKmPZRvMJxjT5udA4LqhNQHpf5oSodahL/O1LGADShD
         Chp3dDWc4RJDVaFKIeTG22eMUPaoWDyZXlHzaVAdktf+q3KITlz8J6fCvhmTc7LMqV
         rhk9MkG/C3eT2eeN2QZES59xUI2NEaBVohE5P1jZ7b+E6wUAJP8AVDxfyNBdwAPerd
         yS/B8UtJmtGiUj3dCHIh3R/cskofHksuy6W9TTlNRagxVYOSjV3wjWyPnp/+zljXZU
         Sbxv/5puG+QRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70589E54D28;
        Fri, 27 Jan 2023 00:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] tools: ynl: prevent reorder and fix flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167478061845.17988.1874064617167835667.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Jan 2023 00:50:18 +0000
References: <20230126000235.1085551-1-kuba@kernel.org>
In-Reply-To: <20230126000235.1085551-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 Jan 2023 16:02:32 -0800 you wrote:
> Some codegen improvements for YAML specs.
> 
> First, Lorenzon discovered when switching the XDP feature family
> to use flags instead of pure enum that the kdoc got garbled.
> The support for enum and flags is therefore unified.
> 
> Second when regenerating all families we discussed so far I noticed
> that some netlink policies jumped around. We need to ensure we don't
> render code based on their ordering in a hash.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] tools: ynl: support kdocs for flags in code generation
    https://git.kernel.org/netdev/net-next/c/66fa34b9c2a5
  - [net-next,2/3] tools: ynl: rename ops_list -> msg_list
    https://git.kernel.org/netdev/net-next/c/b49c34e217c6
  - [net-next,3/3] tools: ynl: store ops in ordered dict to avoid random ordering
    https://git.kernel.org/netdev/net-next/c/3a43ded081f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


