Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2DD57B3D6
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbiGTJaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiGTJaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3418410FE9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 02:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFAC4B81EAE
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7643EC341C7;
        Wed, 20 Jul 2022 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658309415;
        bh=H7R94Ce3M4X0AKEib1vkgTIvsNynJkKdXWTxohyZST8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IJXTH/rY2OD9+o5K/5armMBwxNVmLVktl9smQAI3vOEmgb8/ONxK6cnJPKHYvG2MO
         zef19uAZL5Lms+GBtaOf0xwfTOEprjwsFB7B1Gp4G5wWk5klIGhIKTKvmklnDZT+Km
         tjG3hPVY3ObrddLtAYtwQc9clMf8CaxKfx1YLny0h8M030KEGShSNG/9sFtEeZ8Her
         sFW/sC1VFNm6DlyjdfrKNuXYUSgLZT2uptOWGdlq49//8akTVKObQiUgrTbtUD3rwX
         eCrqOZfApIkoeAskwxbnDRQoBfbzgqtSegTJ0lbQN0JU2h5zfEC2BsQS92pH9F3IZ/
         wkVJHlmA4Ja4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 577F4E451B3;
        Wed, 20 Jul 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table
 (Round 4).
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165830941535.20880.4278139156048226222.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 09:30:15 +0000
References: <20220718172653.22111-1-kuniyu@amazon.com>
In-Reply-To: <20220718172653.22111-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Jul 2022 10:26:38 -0700 you wrote:
> This series fixes data-races around 17 knobs after fib_multipath_use_neigh
> in ipv4_net_table.
> 
> tcp_fack was skipped because it's obsolete and there's no readers.
> 
> So, round 5 will start with tcp_dsack, 2 rounds left for 27 knobs.
> 
> [...]

Here is the summary with links:
  - [v1,net,01/15] ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.
    https://git.kernel.org/netdev/net/c/87507bcb4f5d
  - [v1,net,02/15] ipv4: Fix data-races around sysctl_fib_multipath_hash_policy.
    https://git.kernel.org/netdev/net/c/7998c12a08c9
  - [v1,net,03/15] ipv4: Fix data-races around sysctl_fib_multipath_hash_fields.
    https://git.kernel.org/netdev/net/c/8895a9c2ac76
  - [v1,net,04/15] ip: Fix data-races around sysctl_ip_prot_sock.
    https://git.kernel.org/netdev/net/c/9b55c20f8336
  - [v1,net,05/15] udp: Fix a data-race around sysctl_udp_l3mdev_accept.
    https://git.kernel.org/netdev/net/c/3d72bb4188c7
  - [v1,net,06/15] tcp: Fix data-races around sysctl knobs related to SYN option.
    https://git.kernel.org/netdev/net/c/3666f666e996
  - [v1,net,07/15] tcp: Fix a data-race around sysctl_tcp_early_retrans.
    https://git.kernel.org/netdev/net/c/52e65865deb6
  - [v1,net,08/15] tcp: Fix data-races around sysctl_tcp_recovery.
    https://git.kernel.org/netdev/net/c/e7d2ef837e14
  - [v1,net,09/15] tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.
    https://git.kernel.org/netdev/net/c/7c6f2a86ca59
  - [v1,net,10/15] tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.
    https://git.kernel.org/netdev/net/c/4845b5713ab1
  - [v1,net,11/15] tcp: Fix a data-race around sysctl_tcp_retrans_collapse.
    https://git.kernel.org/netdev/net/c/1a63cb91f0c2
  - [v1,net,12/15] tcp: Fix a data-race around sysctl_tcp_stdurg.
    https://git.kernel.org/netdev/net/c/4e08ed41cb11
  - [v1,net,13/15] tcp: Fix a data-race around sysctl_tcp_rfc1337.
    https://git.kernel.org/netdev/net/c/0b484c91911e
  - [v1,net,14/15] tcp: Fix a data-race around sysctl_tcp_abort_on_overflow.
    https://git.kernel.org/netdev/net/c/2d17d9c73823
  - [v1,net,15/15] tcp: Fix data-races around sysctl_tcp_max_reordering.
    https://git.kernel.org/netdev/net/c/a11e5b3e7a59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


