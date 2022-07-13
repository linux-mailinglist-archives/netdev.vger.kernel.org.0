Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1097572AFC
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiGMBk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiGMBku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:40:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A0A32ECA
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 18:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 655F3B81CAE
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D88FAC341C0;
        Wed, 13 Jul 2022 01:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657676446;
        bh=Y6Mox/jY5SgiNr0pzQPL8k+nYL9XeITke+iPiXH2neo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NJWKJSS226nIvpfUraq3K+zSoxLDQ4zLJ6K2VILH0VrlBog+M1KYcor2yilpIGihV
         CRsQIwsVKYzron5hbMblNRB3SNCx+k/OYTcnW8LfXwUat9Jahn42TuTUpF72QDzSBE
         Wu0lMBcEFPlFve9BTepEOsUTguyxeefU727X+q+VfxlWV9dPew1yJ8PWpE5Xpc/mK5
         VOWQHW7lLzJ/q/wzdIGndhZqAi25Y5WZAfWpjoORcqR1QcxZPHtil5I3aJEuszgHyZ
         2fB7cyVC7IjNjmYlSOMNUppHTWhI+xTKkDFq3QCBh6oFcbNNpxp73UnEX34I7WDwN8
         i/j3dOsVjqi5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4423E45224;
        Wed, 13 Jul 2022 01:40:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] tcp: make retransmitted SKB fit into the send window
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165767644680.18634.9382117929489634256.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 01:40:46 +0000
References: <1657532838-20200-1-git-send-email-liyonglong@chinatelecom.cn>
In-Reply-To: <1657532838-20200-1-git-send-email-liyonglong@chinatelecom.cn>
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 Jul 2022 17:47:18 +0800 you wrote:
> current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
> in send window, and TCP_SKB_CB(skb)->seq_end maybe out of send window.
> If receiver has shrunk his window, and skb is out of new window,  it
> should retransmit a smaller portion of the payload.
> 
> test packetdrill script:
>     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 fcntl(3, F_GETFL) = 0x2 (flags O_RDWR)
>    +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
> 
> [...]

Here is the summary with links:
  - [v4] tcp: make retransmitted SKB fit into the send window
    https://git.kernel.org/netdev/net-next/c/536a6c8e05f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


