Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6C05305E2
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 22:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350690AbiEVUkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 16:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbiEVUkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 16:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4187F39160;
        Sun, 22 May 2022 13:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF6F960BB1;
        Sun, 22 May 2022 20:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38920C34119;
        Sun, 22 May 2022 20:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653252014;
        bh=pD6xEom4/FmHU0/kdHLrVWPmnU98ehKtE17Xkq11YpI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jO4RZYLECFCUBVxxVEbkhfdIzuT9AoK/9M7BtdqV1eDta5jfRhE934TT841RBuQn1
         l0Y601BmvRncOtS+Y0kPNZBuiOrnwgZtAaiMdOZO+k+PO6cBNCmT5jbzMqGJChFwEk
         DoRFGMO+WMT3/0cZHgy8X3dK9oj9c2tIouRr6kb57OBHPf78Gwuya3raN4OW7JWJBQ
         5YHKzRme615sH80QmR3N6DPJUp9J8rrgG0+7t+kJEKFOQyKf0x3b4xK/yOan2TwP6i
         GVLk/oOgW6LJA60+O+8yCbZ+hIvebQjJqGjZ61kBBQ4ciX/dSGDgqN3Tl3mON9Wtku
         KCGe5HMexoboQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2563AF03943;
        Sun, 22 May 2022 20:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] rxrpc: Miscellaneous changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325201415.15566.283158235872361657.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 20:40:14 +0000
References: <165311910893.245906.4115532916417333325.stgit@warthog.procyon.org.uk>
In-Reply-To: <165311910893.245906.4115532916417333325.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 08:45:08 +0100 you wrote:
> Here are some miscellaneous changes for AF_RXRPC:
> 
>  (1) Allow the list of local endpoints to be viewed through /proc.
> 
>  (2) Switch to using refcount_t for refcounting.
> 
>  (3) Fix a locking issue found by lockdep.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] rxrpc: Allow list of in-use local UDP endpoints to be viewed in /proc
    https://git.kernel.org/netdev/net-next/c/33912c2639ad
  - [net-next,2/7] rxrpc: Use refcount_t rather than atomic_t
    https://git.kernel.org/netdev/net-next/c/a05754295e01
  - [net-next,3/7] rxrpc: Fix locking issue
    https://git.kernel.org/netdev/net-next/c/ad25f5cb3987
  - [net-next,4/7] rxrpc: Automatically generate trace tag enums
    https://git.kernel.org/netdev/net-next/c/dc9fd093b2eb
  - [net-next,5/7] rxrpc: Return an error to sendmsg if call failed
    https://git.kernel.org/netdev/net-next/c/4ba68c519255
  - [net-next,6/7] rxrpc, afs: Fix selection of abort codes
    https://git.kernel.org/netdev/net-next/c/de696c4784f0
  - [net-next,7/7] afs: Adjust ACK interpretation to try and cope with NAT
    https://git.kernel.org/netdev/net-next/c/adc9613ff66c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


