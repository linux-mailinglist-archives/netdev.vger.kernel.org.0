Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AA95114DB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 12:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiD0K3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 06:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiD0K27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 06:28:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D05308538
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 03:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4A707CE2369
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A374C385AA;
        Wed, 27 Apr 2022 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651053012;
        bh=COwgWPaaoHdfJl+YwIcM2rJ7zTyu4uqOdzRJSXAiqFo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a4/gn3vYzjVQ9vwEdrQQWPAbzxh+B1Hcfz0MsQkeIIoUuxb8Ovdg0akNA49TwDoim
         +SKfjnu2bBoOshmNHnmtPacMv89yTz23kd8Fn4FpgFFCuLFtzjZJjSs8iehbpPL+5T
         lRB1Bjr5jjI+CtU99GcOFr/AR3Niwqb6QICt5auo190vJwEH6RfdbaQqU+ik/6N4pD
         A07RepdDCGkoAuAJE44SHJZaVPjGheXNr0PSySLvN+Bs17yrTy5cxlghkyvSQ2u5zl
         q2UnVRxbNHx8cLRsptbVqmb0Rg/iD9cxI+RldMfcB6Nk+KpPs00AsMvflrHzsd6hFc
         Qp2eKW0bs5EZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DA3BF0383D;
        Wed, 27 Apr 2022 09:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] mptcp: Timeout for MP_FAIL response
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165105301244.17866.15528494250616223898.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 09:50:12 +0000
References: <20220426215717.129506-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220426215717.129506-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Apr 2022 14:57:10 -0700 you wrote:
> When one peer sends an infinite mapping to coordinate fallback from
> MPTCP to regular TCP, the other peer is expected to send a packet with
> the MPTCP MP_FAIL option to acknowledge the infinite mapping. Rather
> than leave the connection in some half-fallback state, this series adds
> a timeout after which the infinite mapping sender will reset the
> connection.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] selftests: mptcp: add infinite map testcase
    https://git.kernel.org/netdev/net-next/c/b6e074e171bc
  - [net-next,2/7] mptcp: use mptcp_stop_timer
    https://git.kernel.org/netdev/net-next/c/bcf3cf93f645
  - [net-next,3/7] mptcp: add data lock for sk timers
    https://git.kernel.org/netdev/net-next/c/4293248c6704
  - [net-next,4/7] mptcp: add MP_FAIL response support
    https://git.kernel.org/netdev/net-next/c/9c81be0dbc89
  - [net-next,5/7] mptcp: reset subflow when MP_FAIL doesn't respond
    https://git.kernel.org/netdev/net-next/c/49fa1919d6bc
  - [net-next,6/7] selftests: mptcp: check MP_FAIL response mibs
    https://git.kernel.org/netdev/net-next/c/1f7d325f7d49
  - [net-next,7/7] selftests: mptcp: print extra msg in chk_csum_nr
    https://git.kernel.org/netdev/net-next/c/53f368bfff31

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


