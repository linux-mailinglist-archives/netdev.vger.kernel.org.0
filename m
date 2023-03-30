Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3D36CFAAE
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjC3FUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC3FUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9BB4C3D
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 22:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1A9661EEA
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F3E8C4339B;
        Thu, 30 Mar 2023 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680153620;
        bh=7G+7afgPShYuPkr8yEhZQGawKG8+CoNmGNVOzzPG794=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EEA5+R7OFno4hJLOOW/wa/gD3TrWVEtoUUbl7/TknWKfQ0u7/Nd2e1pgNQrude4Bi
         zLT57YibCvqV01mJ/UEgaPGonwvkYbRrJO8ID7nsvLV0id/DhyQWsbd3XUbjjlW0C5
         USo9YpuWe3YdP0+emwRXiqaIXA1aB1l0aE+i33t34eKVcodvZRjDI0j/fiAR0Svqju
         KmWR3LAVhkb+BrjjGuvebo3plHNGDcpoTfdkTPqZJZew6gSitTuxJ25hYUtf273RX3
         IqWRVGOXnTzwpUItT1FuAjsGh+LQmtVfl99nJiedAYtcbR65iE/tcW15VVz1Ep7jBG
         n6oU3mr3wg98g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 119C9E21EDD;
        Thu, 30 Mar 2023 05:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ena: removed unused tx_bytes variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015362006.23884.10215773403903401350.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 05:20:20 +0000
References: <20230328151958.410687-1-horms@kernel.org>
In-Reply-To: <20230328151958.410687-1-horms@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, ndagan@amazon.com, saeedb@amazon.com,
        trix@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Mar 2023 17:19:58 +0200 you wrote:
> clang 16.0.0 with W=1 reports:
> 
> drivers/net/ethernet/amazon/ena/ena_netdev.c:1901:6: error: variable 'tx_bytes' set but not used [-Werror,-Wunused-but-set-variable]
>         u32 tx_bytes = 0;
> 
> The variable is not used so remove it.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ena: removed unused tx_bytes variable
    https://git.kernel.org/netdev/net-next/c/c5370374bb1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


