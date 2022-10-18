Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4F8602919
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiJRKK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiJRKKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA05B2D92;
        Tue, 18 Oct 2022 03:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB85BB81E46;
        Tue, 18 Oct 2022 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94418C433C1;
        Tue, 18 Oct 2022 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666087816;
        bh=+FAZdVtzBqp5dKUEoJozHGOrDCeAhDa+0yX0QiejY7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eqmTGm3BSUU1Vyt9a3tF2nwRkh5zq3EijPsqhNUTb1U49Epmtn7nAzHt9rRRhLP+/
         RHTkS9cDmzkXqlD8zuEZl53eePdQjkhiDVsysHMdoFDrS9UDzEiyIoWfxVXq0hxi5i
         WHEL8hUb+guArE//BtDP6hAcYdMfZeeZhFkPYskQvuOla7s4j99FB3AQAwk9UiNTW+
         lV2f3gX4ClwnMuvKbqGf3IeqPoyWOjI4rv7wDmw1ntSjHiwKm9rtAbCEL/lA3EJjag
         5HMUdJeeTcWBDEhx2XdAolxMY2NC1NWEQwssi3Pj2K6wMLwkWS060zi7XzRbtfWUSn
         /kLvXGsHBX69A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72EDBE270EF;
        Tue, 18 Oct 2022 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ip6_gre: Remove the unused function
 ip6gre_tnl_addr_conflict()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166608781646.29872.16437645266477707037.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Oct 2022 10:10:16 +0000
References: <20221017093540.26806-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20221017093540.26806-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 17 Oct 2022 17:35:40 +0800 you wrote:
> The function ip6gre_tnl_addr_conflict() is defined in the ip6_gre.c file,
> but not called elsewhere, so delete this unused function.
> 
> net/ipv6/ip6_gre.c:887:20: warning: unused function 'ip6gre_tnl_addr_conflict'.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2419
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net: ip6_gre: Remove the unused function ip6gre_tnl_addr_conflict()
    https://git.kernel.org/netdev/net-next/c/f00909e2e6fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


