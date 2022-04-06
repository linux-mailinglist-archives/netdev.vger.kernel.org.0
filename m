Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD824F66D6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238505AbiDFRKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbiDFRKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:10:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93CB4EA1FB;
        Wed,  6 Apr 2022 07:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36771B82437;
        Wed,  6 Apr 2022 14:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C35CFC385A6;
        Wed,  6 Apr 2022 14:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649256012;
        bh=oz5cPgr9O/p4lJnagOaSV/gcGjBKVsh699eZaPO5P0M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=erze3bsZ0c1NWoWjuk8llr8OvP/FHm6YANAxv+/S69AT0skiLJtUG08eQYR9w8ZtC
         GKqjrhRwOceQf+GjdBiY44pzcFPrPwcfw/h0vNsSbnXwtT3T+iPLQnrMt4snoPBRfp
         vcjATdsR3zrtWDsrA+lpam6DzNBs6bs3BXaM86sYEvEE/6+CS/y5xc8QwfuRNMuYqk
         BsWYNJTHI+4t8Y8/2F+TxQYKJ+/tAocbMEja9mcydGH4s0hkTkcfCrhBQV7V5fKQHd
         9cdCK4JWaGf7wO0QZ2MCMh4s4YOUheOfwMtwanhxDIjc6F2GFZytrBHbVHb1d4JOqd
         0RTz+4og0cbCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9AB0CE4A6CB;
        Wed,  6 Apr 2022 14:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ip6_tunnel: Remove duplicate assignments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925601261.27163.16276780123417931525.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 14:40:12 +0000
References: <20220406020634.72995-1-wh_bin@126.com>
In-Reply-To: <20220406020634.72995-1-wh_bin@126.com>
To:     Hongbin Wang <wh_bin@126.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, sahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  5 Apr 2022 22:06:34 -0400 you wrote:
> There is a same action when the variable is initialized
> 
> Signed-off-by: Hongbin Wang <wh_bin@126.com>
> ---
>  net/ipv6/ip6_tunnel.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - ip6_tunnel: Remove duplicate assignments
    https://git.kernel.org/netdev/net-next/c/487dc3ca60e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


