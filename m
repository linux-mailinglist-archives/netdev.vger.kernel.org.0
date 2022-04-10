Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF2C4FAF04
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 18:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243662AbiDJQm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 12:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238030AbiDJQm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 12:42:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4894B846
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2F25B80E19
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 16:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E0B8C385A6;
        Sun, 10 Apr 2022 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649608814;
        bh=nn7b++CxWYzCDC77zfHNfRnWLsx3xloG8Y6rTQIqerU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yy6tbpFSFeITBaftVW3G4psYGdlNcdKscSGN+oKEinDuH0Yk8m63LVS7KTpk+Vwh3
         2/0T1y7dG9QbzgJrfEAodoxxMB78diaa3ivtN0lot4Myh5RMj2LXpg5jPQWsjH5hcW
         3LDfSQv7Q2PG31VZUjbjMSJptFs2esN0KiQJajhi3FoL3pKMWAaccOdyVSbENr/vod
         62ajy7jpOvag7nDfQHrE1X7bcRLzZqREGfKAoAQWOsq9O2V/R0Pb2LDAOYqt8PcNRy
         f/4e7WVNEz5XAGuJ+7hLEOe+GsbL1KOCK7bOXkr6nQ0hq5sJK4Z8x+75Af/bCizGTU
         FiPcDUzhlHCfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3EFECE8DBD1;
        Sun, 10 Apr 2022 16:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] tls: rx: random refactoring part 2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164960881425.10567.4095642970036190437.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Apr 2022 16:40:14 +0000
References: <20220408183134.1054551-1-kuba@kernel.org>
In-Reply-To: <20220408183134.1054551-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Apr 2022 11:31:23 -0700 you wrote:
> TLS Rx refactoring. Part 2 of 3. This one focusing on the main loop.
> A couple of features to follow.
> 
> Jakub Kicinski (11):
>   tls: rx: drop unnecessary arguments from tls_setup_from_iter()
>   tls: rx: don't report text length from the bowels of decrypt
>   tls: rx: wrap decryption arguments in a structure
>   tls: rx: simplify async wait
>   tls: rx: factor out writing ContentType to cmsg
>   tls: rx: don't handle async in tls_sw_advance_skb()
>   tls: rx: don't track the async count
>   tls: rx: pull most of zc check out of the loop
>   tls: rx: inline consuming the skb at the end of the loop
>   tls: rx: clear ctx->recv_pkt earlier
>   tls: rx: jump out for cases which need to leave skb on list
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] tls: rx: drop unnecessary arguments from tls_setup_from_iter()
    https://git.kernel.org/netdev/net-next/c/d4bd88e67666
  - [net-next,02/11] tls: rx: don't report text length from the bowels of decrypt
    https://git.kernel.org/netdev/net-next/c/9bdf75ccffa6
  - [net-next,03/11] tls: rx: wrap decryption arguments in a structure
    https://git.kernel.org/netdev/net-next/c/4175eac37123
  - [net-next,04/11] tls: rx: simplify async wait
    https://git.kernel.org/netdev/net-next/c/37943f047bfb
  - [net-next,05/11] tls: rx: factor out writing ContentType to cmsg
    https://git.kernel.org/netdev/net-next/c/06554f4ffc25
  - [net-next,06/11] tls: rx: don't handle async in tls_sw_advance_skb()
    https://git.kernel.org/netdev/net-next/c/fc8da80f9906
  - [net-next,07/11] tls: rx: don't track the async count
    https://git.kernel.org/netdev/net-next/c/7da18bcc5e4c
  - [net-next,08/11] tls: rx: pull most of zc check out of the loop
    https://git.kernel.org/netdev/net-next/c/ba13609df18d
  - [net-next,09/11] tls: rx: inline consuming the skb at the end of the loop
    https://git.kernel.org/netdev/net-next/c/465ea7353567
  - [net-next,10/11] tls: rx: clear ctx->recv_pkt earlier
    https://git.kernel.org/netdev/net-next/c/b1a2c1786330
  - [net-next,11/11] tls: rx: jump out for cases which need to leave skb on list
    https://git.kernel.org/netdev/net-next/c/f940b6efb172

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


