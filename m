Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F4760F9EA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbiJ0OAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbiJ0OAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:00:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287B83B9AB;
        Thu, 27 Oct 2022 07:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2F5DCE26DD;
        Thu, 27 Oct 2022 14:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 021CBC43142;
        Thu, 27 Oct 2022 14:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666879216;
        bh=AJwhwpeBI7cTTGtqpA1nFwS/kJCC94Aeq1zbEHzb75U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nPC1x+DtmBSo/48xAUA1kv4fDjCkxRhkr4xjvTF8XAvdLt5ViqrGizL51wjaoTOKB
         cIZBO5gS91BKdZ9gdeYd2yXp09tT8PMlWRf5MN8BZo28XY2P/T0c/jCBlDwhpIQUqD
         zeEDbczTZQ7YErjzRPb9aQM8RFWJHZaqksddK7MiRI+IenIZq8Nucbfdu9p9lGSRJ4
         djpjkWHmz6x2n0PAM022BU+tsjsEt1UvGB+mhArNzfhb8fCru4s9yU83Pb6+dUy6Ga
         EDEfqX3t1tjZFFnvnHcCSYG3YsMNMmJU/X0ZIPHPF4dAYdT4fPKp/GDt/0Gv6zviF/
         +vXmiEv2vb4yA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E175DE270D8;
        Thu, 27 Oct 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] skbuff: Proactively round up to kmalloc bucket
 size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166687921591.3700.16973059849541139256.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 14:00:15 +0000
References: <20221025223811.up.360-kees@kernel.org>
In-Reply-To: <20221025223811.up.360-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, ndesaulniers@google.com,
        rientjes@google.com, vbabka@suse.cz, asml.silence@gmail.com,
        imagedong@tencent.com, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 15:39:35 -0700 you wrote:
> Instead of discovering the kmalloc bucket size _after_ allocation, round
> up proactively so the allocation is explicitly made for the full size,
> allowing the compiler to correctly reason about the resulting size of
> the buffer through the existing __alloc_size() hint.
> 
> This will allow for kernels built with CONFIG_UBSAN_BOUNDS or the
> coming dynamic bounds checking under CONFIG_FORTIFY_SOURCE to gain
> back the __alloc_size() hints that were temporarily reverted in commit
> 93dd04ab0b2b ("slab: remove __alloc_size attribute from __kmalloc_track_caller")
> 
> [...]

Here is the summary with links:
  - [net-next,v5] skbuff: Proactively round up to kmalloc bucket size
    https://git.kernel.org/netdev/net-next/c/12d6c1d3a2ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


