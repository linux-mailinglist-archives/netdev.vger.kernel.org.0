Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7620584F5E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 13:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiG2LKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbiG2LKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 07:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452B3636D
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 04:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAF25B8267B
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C2CEC433D7;
        Fri, 29 Jul 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659093013;
        bh=dG/em1hJJQf2d66mPqAGdWM0BQ1bvsW8FOdnmPcukHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B7bNuMreZ+h/E26tjmb7Edxl6q/LvCXRhNuNm9yvn5o2wTQxf+yQxiXN9SaqrZ+Iu
         kddjqXv9utQA3CJOzfXZYFody5iWx9cBjrpqsd9HMaSJsVmHOh7hvmoJ/1ARPl1QSb
         X7wf2OgbD/ou+wphFzEBuRYjBtkk3GMUkQnEulCAW/8TQgp6jn/x7zuzaKHWt8VTDU
         4ta4yqGKpFeG28QMx9UcW3DgzfSY+CYSXUDPZfFne7StUlOYTYa3difMsqTYBNJvk4
         +RWfrDxZPTqIv7q+YNoP2h3SQfw/Pl6+R5RuKEBEbDFhs8lUchxHuzWA866tcp5F0x
         TIUH14JRM2+qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D059C43142;
        Fri, 29 Jul 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: allow unbound socket for packets in VRF when
 tcp_l3mdev_accept set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165909301337.17056.12183027187667104121.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 11:10:13 +0000
References: <20220725181442.18041-1-mvrmanning@gmail.com>
In-Reply-To: <20220725181442.18041-1-mvrmanning@gmail.com>
To:     Mike Manning <mvrmanning@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, jluebbe@lasnet.de
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Jul 2022 19:14:42 +0100 you wrote:
> The commit 3c82a21f4320 ("net: allow binding socket in a VRF when
> there's an unbound socket") changed the inet socket lookup to avoid
> packets in a VRF from matching an unbound socket. This is to ensure the
> necessary isolation between the default and other VRFs for routing and
> forwarding. VRF-unaware processes running in the default VRF cannot
> access another VRF and have to be run with 'ip vrf exec <vrf>'. This is
> to be expected with tcp_l3mdev_accept disabled, but could be reallowed
> when this sysctl option is enabled. So instead of directly checking dif
> and sdif in inet[6]_match, here call inet_sk_bound_dev_eq(). This
> allows a match on unbound socket for non-zero sdif i.e. for packets in
> a VRF, if tcp_l3mdev_accept is enabled.
> 
> [...]

Here is the summary with links:
  - net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set
    https://git.kernel.org/netdev/net/c/944fd1aeacb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


