Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672C36790AB
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbjAXGKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbjAXGKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:10:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250D42BF3C
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2D2EB81081
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85AD4C4339B;
        Tue, 24 Jan 2023 06:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674540617;
        bh=eh7EW6ts5bwIvsWSk4osU0M5hikP4K7U9wazAAPcJDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LQzGm8ZqBLacbg21/+LOc9u3Np3ZnUOfsQ1i5ZOO1CKnVsrxEbjmxTvMi5qEduMcm
         QJO4n8Q83G4mhwapTt+aXasbf6oI+RO1oaTUZ8YUpifHnTyBnmGZutxelzgd61hD/y
         B2HRQ+KjDKU/+bl1FgmyUnYV3VOB3Lqvrpdf6jyPgwMO6+4x6rEZbXsRB3eNLCyBzE
         w5Y10nuRdCk1w9T/woKu57jY5xQl+QNJhA1J3xf7R5XRtupqcHXdvPUR/LMjVkELdN
         TOW5lZuOHw2KhOzAECbhrX/R0ukDu1aV57BKYfLXcxTTWNyQb6tejhkkxj5thGYMPx
         Mwil073M4yo9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63F16E21EE1;
        Tue, 24 Jan 2023 06:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2] net: avoid irqsave in skb_defer_free_flush
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167454061739.14000.11446503028686934516.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 06:10:17 +0000
References: <167421646327.1321776.7390743166998776914.stgit@firesoul>
In-Reply-To: <167421646327.1321776.7390743166998776914.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, jacob.e.keller@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 20 Jan 2023 13:07:43 +0100 you wrote:
> The spin_lock irqsave/restore API variant in skb_defer_free_flush can
> be replaced with the faster spin_lock irq variant, which doesn't need
> to read and restore the CPU flags.
> 
> Using the unconditional irq "disable/enable" API variant is safe,
> because the skb_defer_free_flush() function is only called during
> NAPI-RX processing in net_rx_action(), where it is known the IRQs
> are enabled.
> 
> [...]

Here is the summary with links:
  - [net-next,V2] net: avoid irqsave in skb_defer_free_flush
    https://git.kernel.org/netdev/net-next/c/3176eb82681e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


