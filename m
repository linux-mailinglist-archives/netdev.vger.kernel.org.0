Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063A6520FD7
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbiEJIoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236464AbiEJIoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:44:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5552A1509;
        Tue, 10 May 2022 01:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DBD76142A;
        Tue, 10 May 2022 08:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E24F1C385A6;
        Tue, 10 May 2022 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652172013;
        bh=Gg4GBOVhcfWY8hOjf9chedymoD585NYunojoJKazB2c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YVK+1yMjndGd+gwoK2oYsuXxEglU/A0jU+xMZcFmbavabGe1uc+T2saUIT6HHjLKb
         Pq2Mmf+CLhal68cxG0FGeIkSV5ykFKZv2dt1r6a1sXz7CMumjfE1ZLJAjpGBmfThv6
         NhEYn3clEiL2VeDbxEzPMsfIzDqYvGrAu6Yw8ISjR7OMmyvh3fDqFFNlqpePrcR5GH
         UPWpz4FzA28RYlCKPMguQ6td/pZxjhGkSoOp4Z/+WHjfT5YIbMI725QGvk/O+5ZEXK
         CO8a9PqVY4CnLaBJ5r7+XfxXUwObx96LjqTz9R3i6fJ8M36ZvgHR8UxlIkaaLn9S8P
         q4yaOkNcyFoLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B97CAF03929;
        Tue, 10 May 2022 08:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6] net: atlantic: always deep reset on pm op, fixing up my
 null deref regression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165217201275.28090.9247936511102323749.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 08:40:12 +0000
References: <87bkw8dfmp.fsf@posteo.de>
In-Reply-To: <87bkw8dfmp.fsf@posteo.de>
To:     Manuel Ullmann <labre@posteo.de>
Cc:     irusskikh@marvell.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, ndanilov@marvell.com, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        jordanleppert@protonmail.com, holger@applied-asynchrony.com,
        kolman.jindrich@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 08 May 2022 00:36:46 +0000 you wrote:
> >From 18dc080d8d4a30d0fcb45f24fd15279cc87c47d5 Mon Sep 17 00:00:00 2001
> Date: Wed, 4 May 2022 21:30:44 +0200
> 
> The impact of this regression is the same for resume that I saw on
> thaw: the kernel hangs and nothing except SysRq rebooting can be done.
> 
> Fixes regression in commit cbe6c3a8f8f4 ("net: atlantic: invert deep
> par in pm functions, preventing null derefs"), where I disabled deep
> pm resets in suspend and resume, trying to make sense of the
> atl_resume_common() deep parameter in the first place.
> 
> [...]

Here is the summary with links:
  - [v6] net: atlantic: always deep reset on pm op, fixing up my null deref regression
    https://git.kernel.org/netdev/net/c/1809c30b6e5a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


