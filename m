Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ECE665BBB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjAKMuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjAKMuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC74C4D
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CF9061D04
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A64B1C433F0;
        Wed, 11 Jan 2023 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673441416;
        bh=U+ft5MH8k98PHxxxlbA1DYv+z5FMFTaHmS4T7bnc1T4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=otXHmNuIROLW+jyW1xntK991eS+RavaQZFBXz4Bk7MBxtY6NyOwk+rbufVd521yIh
         vTNvQHHD2FATzByfG7Iy/V5zp6e72t3zXGlgknKgFoLiO53Vyz+au0XTvtTlHP7sXQ
         /rdNd4jpn+j/sVh/RyGq4dZQlY/61HQ+/cTWAuzRo3ov+Lum3ZSIoOVU1F70+U1/Ic
         qOW84QCoKLgrSLDM7ro39YCD0ppOSBBLPtmQhfSfVkd6dZusO4rKzOUeYUx5Kowub+
         bCfnx0rF95Z6AxF+P6SDngv5y3Rtw9RKSj7ZR6So3psNDHt3u6wHlmPIbC3IXgIhsq
         rvzh/ONAhwM8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F787E270F6;
        Wed, 11 Jan 2023 12:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: raw: Deduct extension header length in
 rawv6_push_pending_frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167344141651.6006.12590764301038912748.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 12:50:16 +0000
References: <Y7y4Wsfjm0G7kUBm@gondor.apana.org.au>
In-Reply-To: <Y7y4Wsfjm0G7kUBm@gondor.apana.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     edumazet@google.com, zengyhkyle@gmail.com, kuba@kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 10 Jan 2023 08:59:06 +0800 you wrote:
> On Mon, Jan 09, 2023 at 11:08:08AM +0100, Eric Dumazet wrote:
> >
> > Kyle posted one in https://lore.kernel.org/netdev/Y7s%2FFofVXLwoVgWt@westworld/
> 
> Thanks for the link!
> 
> It looks like I didn't think about extension headers in the original
> patch.
> 
> [...]

Here is the summary with links:
  - ipv6: raw: Deduct extension header length in rawv6_push_pending_frames
    https://git.kernel.org/netdev/net/c/cb3e9864cdbe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


