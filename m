Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565AC57E0A9
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiGVLKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiGVLKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E6E12ADE
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E233761779
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F848C341C7;
        Fri, 22 Jul 2022 11:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658488216;
        bh=NNRspKDDJYD8F9MozAlCZYEyemWNg5LF4njNt3KF3dw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uq6bLJrMaf7MOJE0aLBm42PQkwO/Bhh0tR4gaQ7Kc5UnCoab+Wv+Yw+MLWXog2/Y2
         /gZYIcaxpgrhgvadTRrYhXbi9gTv9Ir0TiJ9cP3HPI+wlr/Fn/xl/314KuiBo260yJ
         zV7+OHjtr6utK2K+wRhqVOFlNlYdT27l7JU4H0Pt953BDioZyf+nNuQJin9CV3vgbr
         QQiI+GPdUQE88IxgLGwMtfdbB2dNCWQbuR1oy6+EqWRF5HAU/g98SWO6P6lu0uTuiF
         RBhgMvSbwzPSHFpKScd33bqmIVFsHjQqvlw4Hikou9O6SA9D3ma9e4ytSqrp5mkk7L
         Sp4vGR1/i56zw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25C94E451BB;
        Fri, 22 Jul 2022 11:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table
 (Round 5).
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165848821615.18977.1186112541963178512.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 11:10:16 +0000
References: <20220720165026.59712-1-kuniyu@amazon.com>
In-Reply-To: <20220720165026.59712-1-kuniyu@amazon.com>
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

On Wed, 20 Jul 2022 09:50:11 -0700 you wrote:
> This series fixes data-races around 15 knobs after tcp_dsack in
> ipv4_net_table.
> 
> tcp_tso_win_divisor was skipped because it already uses READ_ONCE().
> 
> So, the final round for ipv4_net_table will start with tcp_pacing_ss_ratio.
> 
> [...]

Here is the summary with links:
  - [v1,net,01/15] tcp: Fix data-races around sysctl_tcp_dsack.
    https://git.kernel.org/netdev/net/c/58ebb1c8b35a
  - [v1,net,02/15] tcp: Fix a data-race around sysctl_tcp_app_win.
    https://git.kernel.org/netdev/net/c/02ca527ac558
  - [v1,net,03/15] tcp: Fix a data-race around sysctl_tcp_adv_win_scale.
    https://git.kernel.org/netdev/net/c/36eeee75ef01
  - [v1,net,04/15] tcp: Fix a data-race around sysctl_tcp_frto.
    https://git.kernel.org/netdev/net/c/706c6202a358
  - [v1,net,05/15] tcp: Fix a data-race around sysctl_tcp_nometrics_save.
    https://git.kernel.org/netdev/net/c/8499a2454d9e
  - [v1,net,06/15] tcp: Fix data-races around sysctl_tcp_no_ssthresh_metrics_save.
    https://git.kernel.org/netdev/net/c/ab1ba21b523a
  - [v1,net,07/15] tcp: Fix data-races around sysctl_tcp_moderate_rcvbuf.
    https://git.kernel.org/netdev/net/c/780476488844
  - [v1,net,08/15] tcp: Fix data-races around sysctl_tcp_workaround_signed_windows.
    https://git.kernel.org/netdev/net/c/0f1e4d06591d
  - [v1,net,09/15] tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.
    https://git.kernel.org/netdev/net/c/9fb90193fbd6
  - [v1,net,10/15] tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.
    https://git.kernel.org/netdev/net/c/db3815a2fa69
  - [v1,net,11/15] tcp: Fix a data-race around sysctl_tcp_min_tso_segs.
    https://git.kernel.org/netdev/net/c/e0bb4ab9dfdd
  - [v1,net,12/15] tcp: Fix a data-race around sysctl_tcp_tso_rtt_log.
    https://git.kernel.org/netdev/net/c/2455e61b85e9
  - [v1,net,13/15] tcp: Fix a data-race around sysctl_tcp_min_rtt_wlen.
    https://git.kernel.org/netdev/net/c/1330ffacd05f
  - [v1,net,14/15] tcp: Fix a data-race around sysctl_tcp_autocorking.
    https://git.kernel.org/netdev/net/c/85225e6f0a76
  - [v1,net,15/15] tcp: Fix a data-race around sysctl_tcp_invalid_ratelimit.
    https://git.kernel.org/netdev/net/c/2afdbe7b8de8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


