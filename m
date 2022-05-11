Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7CA522913
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 03:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240622AbiEKBkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 21:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239953AbiEKBkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 21:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29731260865;
        Tue, 10 May 2022 18:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3C6EB81F93;
        Wed, 11 May 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43C23C385DA;
        Wed, 11 May 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652233213;
        bh=zAeVVFCOfVIH3U08m9Kbv4tv2FZ5L25f2zgKxCiG3eo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jvdMbskyp5mM+g+dt2rUKWQRc/QpEp8XMjkV9fQuy9lBR/0prEvTtFJTY5F7reJ9F
         4Mwy6OFTinHLYBDjTtmIrRHtaEISNZ0PNVN+uqEsvU9wAToxlRfzSKm4Ay7yRQuprH
         2jK5c/J/PTWkUUh1YJB/Crm4FcmuijghDiYVUyAKt2DOga363G/chPrvvPyuXbNyOF
         y1T/N07cHOgN1md7ARz1eSI8k1wS4M6QCVXZvzJJGF9Vzle4QCLE48nUXWRTDHxb0e
         i/FJw37VbEfiPmm382ii2PgUzqiJhNUscqlNtUJHnjpNsttfXdIKGKxs2v6R+qIIRd
         nGRy7JfBMbS6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 217A0F0392B;
        Wed, 11 May 2022 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] docs: document some aspects of struct sk_buff
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165223321313.1620.2112906960535144895.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 01:40:13 +0000
References: <20220509160456.1058940-1-kuba@kernel.org>
In-Reply-To: <20220509160456.1058940-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        imagedong@tencent.com, dsahern@gmail.com, talalahmad@google.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  9 May 2022 09:04:53 -0700 you wrote:
> This small set creates a place to render sk_buff documentation,
> documents one random thing (data-only skbs) and converts the big
> checksum comment to kdoc.
> 
> RFC v2 (no changes since then):
>  - fix type reference in patch 1
>  - use "payload" and "data" more consistently
>  - add snippet with calls
> https://lore.kernel.org/r/20220324231312.2241166-1-kuba@kernel.org/
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] skbuff: add a basic intro doc
    https://git.kernel.org/netdev/net-next/c/ddccc9ef5599
  - [net-next,2/3] skbuff: rewrite the doc for data-only skbs
    https://git.kernel.org/netdev/net-next/c/9ec7ea146208
  - [net-next,3/3] skbuff: render the checksum comment to documentation
    https://git.kernel.org/netdev/net-next/c/9facd94114b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


