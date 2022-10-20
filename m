Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4924260547D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiJTAaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiJTAaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1166911F4BF;
        Wed, 19 Oct 2022 17:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E0DB82658;
        Thu, 20 Oct 2022 00:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB1C6C43140;
        Thu, 20 Oct 2022 00:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666225817;
        bh=pRl0+DSMGYOIeWm9GcncNAKVky0quhgm8G6SzQfP0Mk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZayUWyeTSlOkjkrPzy9UB7svdP3YBmeiepR4q32erEtjgyM5SkOoNSJHNt+lOpGDd
         TUiPlceeNbw/lKSkfDJk+HRRCy4kSDnluEg2sC1t3/C8rnIuXBkJB7GXCn2iJaR4Jp
         PU/Pq2iGZWX3t2i6cf/lSFDH81iCOb/+woPT225zivHqhmd6otnAXA8ASLcsyKxtKI
         +PBzJvo3QfSd35tjRMSVA7BaFDyud+e5Teawh7aqohqeT8l/w/cGPLKHO6yH3P/m0y
         idog2+jKv6TO7sVvPtEV9PfyDlDbhcqbgjCR8quNibwbYJQpFu8fzDVVjO6SMTnoAI
         oR7TCs5jHMD2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94A57E270EA;
        Thu, 20 Oct 2022 00:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] openvswitch: Use kmalloc_size_roundup() to match ksize()
 usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166622581760.22962.5530740992080732843.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Oct 2022 00:30:17 +0000
References: <20221018090628.never.537-kees@kernel.org>
In-Reply-To: <20221018090628.never.537-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Oct 2022 02:06:33 -0700 you wrote:
> Round up allocations with kmalloc_size_roundup() so that openvswitch's
> use of ksize() is always accurate and no special handling of the memory
> is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.
> 
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: dev@openvswitch.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> [...]

Here is the summary with links:
  - openvswitch: Use kmalloc_size_roundup() to match ksize() usage
    https://git.kernel.org/netdev/net-next/c/ab3f7828c979

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


