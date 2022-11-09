Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1F262343B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiKIUKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiKIUKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD0ADEBB
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 929A5B8200A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 20:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 385A8C433D7;
        Wed,  9 Nov 2022 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668024615;
        bh=ujo+0BRfJsme1Rbyi64/NOhe1EYM+xjX9ffcDpn6WgI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L3FwOs7x1K9Q1QJBKY5LyEfPswIQgPOEM8XAX4w2eQ3Gv8jAwufOUHvvKgF5Kmb7R
         3oBCgxzstRRiQK7avJxzogw5I68k4Ay2S004gMMFUmC2Lkjk0gS4q2WaBrYo6N1Nsi
         BjdVS+HPTM/Px8gNzEV775RSB+4KWreY7+QehDCFNZxvsCVFGMBPyOyWsbdThzY+X0
         nXbOsM4QdenyLDRhAqOkw4IJ7zO3/j3iGLCNsFGYwQwKOenpaZ7uawzB9jGUCRm0mz
         GKhYzS7lNc+dwcS9f412Wmsa3NIOqJNuIs9SZaXkckHloORekoDnppQCByg0KDBOoH
         tMj655Z5XWriQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20672C395FD;
        Wed,  9 Nov 2022 20:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] genetlink: correctly begin the iteration over
 policies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166802461512.30373.18057693825103816017.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 20:10:15 +0000
References: <20221108204128.330287-1-kuba@kernel.org>
In-Reply-To: <20221108204128.330287-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
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

On Tue,  8 Nov 2022 12:41:28 -0800 you wrote:
> The return value from genl_op_iter_init() only tells us if
> there are any policies but to begin the iteration (and therefore
> load the first entry) we need to call genl_op_iter_next().
> Note that it's safe to call genl_op_iter_next() on a family
> with no ops, it will just return false.
> 
> This may lead to various crashes, a warning in
> netlink_policy_dump_get_policy_idx() when policy is not found
> or.. no problem at all if the kmalloc'ed memory happens to be
> zeroed.
> 
> [...]

Here is the summary with links:
  - [net-next] genetlink: correctly begin the iteration over policies
    https://git.kernel.org/netdev/net-next/c/154ba79c9f16

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


