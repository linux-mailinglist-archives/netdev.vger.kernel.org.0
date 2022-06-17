Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C7754F6B6
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 13:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381587AbiFQLaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 07:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241130AbiFQLaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 07:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CA66CA81;
        Fri, 17 Jun 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4AB661F17;
        Fri, 17 Jun 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49E54C3411F;
        Fri, 17 Jun 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655465413;
        bh=2M0HTrznAjQEDWtLp13f/RhMvG9v+OTUVJ9tisRTfzM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D+j8FLh1E1mrbFNkaDsFrKEbgMhyGBcyKLwhN32UbRhOuhWeOJwbjjg9G4+Qwdpnu
         ldtNh2r1OijeFKo/4T5vwyS5J5/AETrPqUUXj1KvKTNBaPA4BCdSIl/IAtCH+PaK8r
         ThoAnDicQaShWxBS3PYiPLeQs2nFVDFv8A7MhWXrtRKKpge/1GZQMYL61q1lu1+3dA
         x3Ch2DHSCPdVr3LQerwRcI5tkfvN68pxzjH5TpLoTSR5FU8FVvACWa9vXW4Yd/NVR0
         3g3/OGZVhzOpbbifco8+vLX9MKsXFgip0SDCR/+lvhzhqzrEhhZBfSuyPYT8QEpd2i
         w6hbNo7rzXQJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2759DE6D466;
        Fri, 17 Jun 2022 11:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ipv4: ping: fix bind address validity check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 11:30:13 +0000
References: <20220617085435.193319-1-pbl@bestov.io>
In-Reply-To: <20220617085435.193319-1-pbl@bestov.io>
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     cmllamas@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linmiaohe@huawei.com, maze@google.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Jun 2022 10:54:35 +0200 you wrote:
> Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> introduced a helper function to fold duplicated validity checks of bind
> addresses into inet_addr_valid_or_nonlocal(). However, this caused an
> unintended regression in ping_check_bind_addr(), which previously would
> reject binding to multicast and broadcast addresses, but now these are
> both incorrectly allowed as reported in [1].
> 
> [...]

Here is the summary with links:
  - [v2] ipv4: ping: fix bind address validity check
    https://git.kernel.org/netdev/net/c/b4a028c4d031

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


