Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD5C4AA99F
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358655AbiBEPUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiBEPUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8E1C061353
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 07:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 362FF60F6D
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 15:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AA3EC340F0;
        Sat,  5 Feb 2022 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644074409;
        bh=gVeoFGmObb+wsFxpEBLUv8BPxJZTC/P8Y8ULC9yjAgo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=frcEKYDpEJ0Y4UB8uA8htoq1YQIfBeByfrWuAGv/oneQY0w+TOiXoHh/1QzfoxMxw
         6dhRhOsiEt/XFCHRwyXqUKh5VYztIl9V7GpzCEt1tiFNFU5FUMk7pBjFsHOMgjB1Tn
         tg/+DKA5cJgCka0oqS/py/yTKXF1llF/Kc3fEyBObNFwXIiJAkBOi14LEBIhCN0Bb0
         CsY4QBTY76dZjws0R+g4J5fya7AJkwA9toqN867tN5fzTGpcSHR0V76eHoIHwCHyyc
         Mz+RHXrSyU0vew8g4A/CivflhKXh2rpv86IIZrvkK1Y2QurHZGc4npU4iP2P6GhKTz
         eUhsr+uwfkzsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84386E6D3DE;
        Sat,  5 Feb 2022 15:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] gro: a couple of minor optimization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407440953.21243.5195486084792064856.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:20:09 +0000
References: <cover.1643972527.git.pabeni@redhat.com>
In-Reply-To: <cover.1643972527.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        alexandr.lobakin@intel.com, edumazet@google.com,
        alexander.duyck@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Feb 2022 12:28:35 +0100 you wrote:
> This series collects a couple of small optimizations for the GRO engine,
> reducing slightly the number of cycles for dev_gro_receive().
> The delta is within noise range in tput tests, but with big TCP coming
> every cycle saved from the GRO engine will count - I hope ;)
> 
> v1 -> v2:
>  - a few cleanup suggested from Alexander(s)
>  - moved away the more controversial 3rd patch
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: gro: avoid re-computing truesize twice on recycle
    https://git.kernel.org/netdev/net-next/c/7881453e4adf
  - [net-next,2/2] net: gro: minor optimization for dev_gro_receive()
    https://git.kernel.org/netdev/net-next/c/de5a1f3ce4c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


