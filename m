Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C8E6ED9A5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbjDYBKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjDYBKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5823D3C0D;
        Mon, 24 Apr 2023 18:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD04A62AAC;
        Tue, 25 Apr 2023 01:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3506DC4339E;
        Tue, 25 Apr 2023 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682385020;
        bh=e9aBgEbjRyxsLbexVjWZJWbxZ+OxkG7/jN+cF6riUFo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d15PA143KHrMMxnrBUvjeBpfSf8U3UYCADLW2gYhU5kR91zx0ZuCrxHgzjSizqvqt
         IEwlycNqIbmrXsCt183nUfOmAkBa4bngudQRqD1CliLliUwHHRn8e+sWAeCED26hmd
         dY7HXjzFf3AJJnPSOagS8qzU72YgN+YB3Hropy7y0bsS6mJhENTgOjyzb26k8Lx8uv
         enX/9VJgSScDmQx+MO3BYd0wvhdXHTowMTJvTIJ9hptd8grdoh65oOrPTXgIJphhjm
         tuRt5bCb5SxTmwsl2rpJpTeB2V+DvVxHfm+k0eZF0hbZGP+Qm+okGs+ruAxsd0T9WY
         e/zNyBdaTzc4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 132C9C395D8;
        Tue, 25 Apr 2023 01:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next, 0/2] Update coding style and check alloc_frag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238502007.6495.17788733347454101690.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 01:10:20 +0000
References: <1682096818-30056-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1682096818-30056-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, leon@kernel.org, longli@microsoft.com,
        ssengar@linux.microsoft.com, linux-rdma@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        bpf@vger.kernel.org, ast@kernel.org, sharmaajay@microsoft.com,
        hawk@kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Apr 2023 10:06:56 -0700 you wrote:
> Follow up patches for the jumbo frame support.
> 
> As suggested by Jakub Kicinski, update coding style, and check napi_alloc_frag
> for possible fallback to single pages.
> 
> Haiyang Zhang (2):
>   net: mana: Rename mana_refill_rxoob and remove some empty lines
>   net: mana: Check if netdev/napi_alloc_frag returns single page
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: mana: Rename mana_refill_rxoob and remove some empty lines
    https://git.kernel.org/netdev/net-next/c/5c74064f43c2
  - [net-next,2/2] net: mana: Check if netdev/napi_alloc_frag returns single page
    https://git.kernel.org/netdev/net-next/c/df18f2da302f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


