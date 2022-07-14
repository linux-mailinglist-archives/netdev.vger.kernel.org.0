Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7A25756B8
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 23:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbiGNVKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 17:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiGNVKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 17:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6851052445;
        Thu, 14 Jul 2022 14:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15D04B82919;
        Thu, 14 Jul 2022 21:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84AC4C341C6;
        Thu, 14 Jul 2022 21:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657833012;
        bh=wDJFMCIldNg3buIOyrXwMRP04Ypy4APP2ckNEJBRdbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AgiORRcM4z00p08x5VMvwme/zC4aQfWi9AS7NZ58RECGV8RXFbb0hgOW7GoDHub9G
         E1Cuq3ocNBCfmS42Nf/kyBoun4T++zEG39L/bh5ZQZPjtDG2OZc/1q6HDwfL+NDIKD
         o3fmRCkc6OKcN7JDvPVB6ia80nnRkFe6jKA9+CqvnoRbZ7L9utVXZS4C+81QhmEPn2
         MY7IBt5R2AbJ73YvFCTA1CND9gOPBhJmUyYvRwKyaQuqKuxbOu1kgHb/1i5F+6TXTM
         c/JxA6tBRmhSMUQlPykn/DMK0MThhUyN+JwcSF3acNWWf7GBtMx0HFGzYju+ihzrnP
         FVBVoqnzlhVHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A7BDE45225;
        Thu, 14 Jul 2022 21:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: add endian modifiers to fix endian warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165783301243.27796.8416117339886942240.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 21:10:12 +0000
References: <20220714105101.297304-1-ben.dooks@sifive.com>
In-Reply-To: <20220714105101.297304-1-ben.dooks@sifive.com>
To:     Ben Dooks <ben.dooks@sifive.com>
Cc:     linux-kernel@vger.kernel.org, sudip.mukherjee@sifive.com,
        jude.onyenegecha@sifive.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 14 Jul 2022 11:51:01 +0100 you wrote:
> A couple of the syscalls which load values (bpf_skb_load_helper_16
> and bpf_skb_load_helper_32) are using u16/u32 types which are
> triggering warnings as they are then converted from big-endian
> to cpu-endian. Fix these by making the types __be instead.
> 
> Fixes the following sparse warnings:
> 
> [...]

Here is the summary with links:
  - bpf: add endian modifiers to fix endian warnings
    https://git.kernel.org/bpf/bpf-next/c/96a233e600df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


