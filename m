Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98932583CE0
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbiG1LKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236474AbiG1LKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06EB14014
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D2CE61A2F
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C29E5C433D7;
        Thu, 28 Jul 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659006612;
        bh=SXDe/Oy5ipQvreLzdvz+OGlGXqgfN/9mWekb+4tuCik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LIA8l7z50Nad65ilPH4+h+1m03lqJikfyMF04Hgiu7B+pUr7feBwJ3xKl1UCZEYk8
         OIUarllsTm43fEn/rpAha2SACHmK2q4wDJsPFKxcmsWHMsSgBf52acCI1CygG0MEWY
         pWdth1mhH+z1gYLSWR/YHcoFu+NUjfMvHie4KJmeLtUGLkkPY27lQc33aFKtIzpJ4F
         zkFgPbzTjR7LK0vdrvprB1QHXn1PuxL2BDGto6isJHEOLqvxIT4G+QWT+/dp07z1VP
         tpBZl2FRDEkALxepr+b+pXRqy8d1nf0BPy3uRlpN+4vKK2XRliPRTz+9whqukPb7r4
         2c4UhchhfU4Wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9A8BC43143;
        Thu, 28 Jul 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/funeth: Fix fun_xdp_tx() and XDP packet reclaim
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165900661269.21458.8046586286921169324.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 11:10:12 +0000
References: <20220726215923.7887-1-dmichail@fungible.com>
In-Reply-To: <20220726215923.7887-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 26 Jul 2022 14:59:23 -0700 you wrote:
> The current implementation of fun_xdp_tx(), used for XPD_TX, is
> incorrect in that it takes an address/length pair and later releases it
> with page_frag_free(). It is OK for XDP_TX but the same code is used by
> ndo_xdp_xmit. In that case it loses the XDP memory type and releases the
> packet incorrectly for some of the types. Assorted breakage follows.
> 
> Change fun_xdp_tx() to take xdp_frame and rely on xdp_return_frame() in
> reclaim.
> 
> [...]

Here is the summary with links:
  - [net] net/funeth: Fix fun_xdp_tx() and XDP packet reclaim
    https://git.kernel.org/netdev/net/c/51a83391d77b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


