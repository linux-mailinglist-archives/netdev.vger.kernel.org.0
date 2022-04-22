Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C91950B43F
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 11:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446133AbiDVJnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 05:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353303AbiDVJnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 05:43:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DAA2AC63;
        Fri, 22 Apr 2022 02:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA993B82B76;
        Fri, 22 Apr 2022 09:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48C4FC385AB;
        Fri, 22 Apr 2022 09:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650620411;
        bh=5AVuItH7Id/wbofPyzjVLqjCGopQpNfSRp0+TDzMaXE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uWrElIVD9tJeDm3hI1LSuM8sOmMJDilW+di1z9909DMD3AVcYSvpOCVRFmkTEtssh
         n1JRdc5182qwQqRR11KrWeDdSnj8Ucu8vXWSZeBPjt7HdarVbGoKtK5bogJVnmmbnd
         OaaR9fIg3aDD8HrkP50dm11x2VYRwbwZnw/qZ7qeSHT8bgG45GdVNCmdsr5WNRRimu
         Ozju6RR4FZCjKfqeWVNRgXMwBrMWF9lnSbxuJe9A2rD19ScSX9ehoFrDb73ddNpmTC
         yYqoIMBCHpnD1JsfXr8fm4WNejXmbkRlGAtGQwHXuNPZ7qkqfsZu1SOOy9ah5O9NEO
         FQak6aOivZicQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A8B6E85D90;
        Fri, 22 Apr 2022 09:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/ipv6: Enforce limits for accept_unsolicited_na
 sysctl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165062041116.29063.4593608402439834170.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 09:40:11 +0000
References: <20220419105910.686-1-aajith@arista.com>
In-Reply-To: <20220419105910.686-1-aajith@arista.com>
To:     Arun Ajith S <aajith@arista.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Apr 2022 10:59:10 +0000 you wrote:
> Fix mistake in the original patch where limits were specified but the
> handler didn't take care of the limits.
> 
> Signed-off-by: Arun Ajith S <aajith@arista.com>
> ---
>  net/ipv6/addrconf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net/ipv6: Enforce limits for accept_unsolicited_na sysctl
    https://git.kernel.org/netdev/net-next/c/d09d3ec03f02

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


