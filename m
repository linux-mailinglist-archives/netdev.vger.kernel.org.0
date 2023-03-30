Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8B46CFA49
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjC3Ek0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjC3EkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2916735A2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EE1AB825BC
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE8D1C433D2;
        Thu, 30 Mar 2023 04:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680151218;
        bh=awW+tfLm4wRbrze8tYMu6CbIHgyvdeKvS50U6vvpA6Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s72Rn9zjC1TgCR4L0/RPl6Ye9fF+U1ecc/+9n9HhIm3KmzcQ+9hubcNkH+bWR+VZK
         PfMuuaSGob0EFjUAB1CE2lS76tjx9E3R8r8veMOMM8vde/9aFzbhgfzqTOM7UcKt1b
         EkFal6rNVow47u+Kw51sM+Wu8Eq6v9LcARAUq6co/lt30yxxT/HjQv7p0DkPAeWe1o
         M/SFGtTDUSyjBDVsyxBt/YtB2pr/kEcjnTh1U7ELGfDlRfpEUK3GEO9UIzJnJNhjCA
         J8r4TBrmeeROk1ugSjOuCZQy1ikQdOh6dYwSvdxlEdjKU5UhoOlJsx5faMAKwAJKgY
         u+hghhoOtsWGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E58AE21EDD;
        Thu, 30 Mar 2023 04:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnx2x: use the right build_skb() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015121857.8019.7852378765910709111.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 04:40:18 +0000
References: <20230329000013.2734957-1-kuba@kernel.org>
In-Reply-To: <20230329000013.2734957-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, tv@lio96.de, aelior@marvell.com,
        skalluru@marvell.com, manishc@marvell.com, keescook@chromium.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Mar 2023 17:00:13 -0700 you wrote:
> build_skb() no longer accepts slab buffers. Since slab use is fairly
> uncommon we prefer the drivers to call a separate slab_build_skb()
> function appropriately.
> 
> bnx2x uses the old semantics where size of 0 meant buffer from slab.
> It sets the fp->rx_frag_size to 0 for MTUs which don't fit in a page.
> It needs to call slab_build_skb().
> 
> [...]

Here is the summary with links:
  - [net] bnx2x: use the right build_skb() helper
    https://git.kernel.org/netdev/net/c/8c495270845d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


