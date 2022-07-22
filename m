Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EABD57E0FE
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiGVLuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiGVLuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BDF10CD
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E1E9B8282D
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A718C341CA;
        Fri, 22 Jul 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658490614;
        bh=EusVjW1jdK5hU9lxIiyZjcWbtJKnL9bv9PfOmH6gP8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D+wsZcO498FhZJoG2CJ7S6+9exrpbowEMTjK8J7c0n2slS17M5dZxIOman3a4CmSz
         ij7erwXiozhDhTaZ3Wo/StpYxQIU0jB5qq7ql9ZydMKJeC5xgKyiwucTtGzRt9+0G+
         /o+hjmp9rvFTQQpxU3/hBRGPoHkSq5uhvA8WrI/6clhgf5BNn3GJxbMEe07ECTVUz0
         pk3Ni+/csi9hqQq0YhsupKN+NP+n02pTRxfrrPPW4duPAPeR/og9qaQ3zaC2LXCKr4
         25FszGdpDB3gIn+vg/PDKy7MPLGAgAHxRTctzAKsf8yGryoeZikiFnhe4krpvLV77v
         JBSifuVjZJO3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1FA27D9DDDD;
        Fri, 22 Jul 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] ping: support ipv6 ping socket flow labels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165849061412.6358.11471823288314773131.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 11:50:14 +0000
References: <20220720181310.1719994-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220720181310.1719994-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, alan.brady@intel.com, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Jul 2022 11:13:10 -0700 you wrote:
> From: Alan Brady <alan.brady@intel.com>
> 
> Ping sockets don't appear to make any attempt to preserve flow labels
> created and set by userspace using IPV6_FLOWINFO_SEND. Instead they are
> clobbered by autolabels (if enabled) or zero.
> 
> Grab the flowlabel out of the msghdr similar to how rawv6_sendmsg does
> it and move the memset up so it doesn't get zeroed after.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] ping: support ipv6 ping socket flow labels
    https://git.kernel.org/netdev/net-next/c/16576a034c4b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


