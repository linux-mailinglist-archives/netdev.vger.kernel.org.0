Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720F958F754
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 07:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiHKFkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 01:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbiHKFkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 01:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846FEE20
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 22:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37C5EB81F31
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC4F2C433D7;
        Thu, 11 Aug 2022 05:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660196413;
        bh=Jh7pLrddM9PTiTGILwC33kkyZq/nIiD5WjiGygaHrX4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jPp0ojDb1ikEdCTutSjfX/Pmwd2yVL4j3fR5NvlluiHm7qZT/m9q/GUonXHdbXsKZ
         /bt2+JRRqpTCI/UvTjHpDPbqmy1LM6rtPBBBuLRAVocW5ohfvhAjLxAQMeUazBrl0e
         XQ61iFaHIaHtkvMGt9753/Du323Rt9R1YMmF0L4b9UceDhnsk3c4qfVpTVntBc7Fio
         fvdHIkQaHk8DQguBUn7i95LXPZHLSp9AGQvIfr4Sc3p+7k+P/2jBzYeOBBbaCuo7J4
         t3hPx16ozRykosvHSRtJXKcPlIeRxIpLlwEeJZYqVmpIHz3Jl3WAizjQzO5HcFR3Ad
         OA0c9EDbxpxuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B04D2C43143;
        Thu, 11 Aug 2022 05:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: forwarding: Fix failing tests with old libnet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166019641371.21224.16931279962426380285.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 05:40:13 +0000
References: <20220809113320.751413-1-idosch@nvidia.com>
In-Reply-To: <20220809113320.751413-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, amcohen@nvidia.com,
        dsahern@gmail.com, ivecera@redhat.com, mlxsw@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 Aug 2022 14:33:20 +0300 you wrote:
> The custom multipath hash tests use mausezahn in order to test how
> changes in various packet fields affect the packet distribution across
> the available nexthops.
> 
> The tool uses the libnet library for various low-level packet
> construction and injection. The library started using the
> "SO_BINDTODEVICE" socket option for IPv6 sockets in version 1.1.6 and
> for IPv4 sockets in version 1.2.
> 
> [...]

Here is the summary with links:
  - [net] selftests: forwarding: Fix failing tests with old libnet
    https://git.kernel.org/netdev/net/c/8bcfb4ae4d97

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


