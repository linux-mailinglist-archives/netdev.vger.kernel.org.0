Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D713584B28
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbiG2Fah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiG2Fa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:30:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349371A3A6;
        Thu, 28 Jul 2022 22:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC10AB826F7;
        Fri, 29 Jul 2022 05:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0891CC43144;
        Fri, 29 Jul 2022 05:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072620;
        bh=fquHH0Brp5sK5TXFacCxIR2XEa8azd6MKqqJmtPAvhI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iBv81L8McUP9YKjyl2YM0sAS4kAelPNi5O/S1OsWbvJsx0RdUeqgpeZY+Typs0I0A
         VYAQ8QZFRkuZQt+uKNjbS52ltvUtog1eUakeTFiDJb9skY5zXDFcN+rVMylUcgXfb2
         sXIbUq5iKAhGtsocl74iOTv9UNyaKjxKYM1vaJuLpEq+EEYu5jEoPEwt8PIt6nRAE+
         GOzWlEP1hWvfvLYLrZ7kEHoO3Artm5K2qdwhkoeoigHE49RFCErivw7VkkSPsQYD0n
         q/l8AlVpN+gC2btK6zw3BKgONSK290CQ43yNJSR12gdSYe0/AOevezEpjrSOv9vinj
         d2bxIx4yUpBRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8F3DC43148;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v9 0/2] add framework for selftests in devlink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907261994.17632.8400006268893599861.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:30:19 +0000
References: <20220727165721.37959-1-vikas.gupta@broadcom.com>
In-Reply-To: <20220727165721.37959-1-vikas.gupta@broadcom.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Jul 2022 22:27:19 +0530 you wrote:
> Hi,
>   This patchset adds support for selftests in the devlink framework.
>   It adds a callback .selftests_check and .selftests_run in devlink_ops.
>   User can add test(s) suite which is subsequently passed to the driver
>   and driver can opt for running particular tests based on its capabilities.
> 
>   Patchset adds a flash based test for the bnxt_en driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v9,1/2] devlink: introduce framework for selftests
    https://git.kernel.org/netdev/net-next/c/08f588fa301b
  - [net-next,v9,2/2] bnxt_en: implement callbacks for devlink selftests
    https://git.kernel.org/netdev/net-next/c/5b6ff128fdf6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


