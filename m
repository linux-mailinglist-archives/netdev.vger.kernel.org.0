Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAF955E4A4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbiF1Nbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346497AbiF1Nap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73FEA188
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 440EF61802
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 13:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5370C341CA;
        Tue, 28 Jun 2022 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656423015;
        bh=AjUTlRJGuvI6COmwF5bO0xh+XvcsiIKEafaPCvgbllc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=inrmSNtawFX+EdIW95DiudCWgXTjIbPTX1KQDcorUUXvAsc4DSq6MnaAFUyVsx0qK
         AghiDNy/H0Rl2K0Jv4z7/vYpKLDLZEWam9J1d8mHeCjTzZfsWCUwPT9rORb4lYeGB7
         /HAy0YBgsuG3jMk8xdPlWFm5DMuhL7GpEvL5fgHlPb3q9ByGxafN37j/S48SX7/xeC
         UpBHnIUAp2aQ85ahKQhTwmRP+DW0a/dR/QaDO+qJjWMXf+rNjSIF/0OCEzvOsVUF1b
         tKSOqF5pVJM6gRsxd2tnTiWOTAbaj/FOGPJZQKwEcZJfWkbN9Yy3te1wmHRA4ZSjyQ
         CqADnCodK49GQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86555E49F65;
        Tue, 28 Jun 2022 13:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bonding: fix possible NULL deref in rlb code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165642301554.12733.2537135863290099487.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 13:30:15 +0000
References: <20220627102813.126264-1-edumazet@google.com>
In-Reply-To: <20220627102813.126264-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 27 Jun 2022 10:28:13 +0000 you wrote:
> syzbot has two reports involving the same root cause.
> 
> bond_alb_initialize() must not set bond->alb_info.rlb_enabled
> if a memory allocation error is detected.
> 
> Report 1:
> 
> [...]

Here is the summary with links:
  - [net] net: bonding: fix possible NULL deref in rlb code
    https://git.kernel.org/netdev/net/c/ab84db251c04

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


