Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D0952F6F4
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiEUAkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiEUAkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:40:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FC01ACF8A
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54D4E61E93
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAED0C34113;
        Sat, 21 May 2022 00:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653093611;
        bh=R/nn6Mx9F5EBXJsi3g3kdwFnyJ8TqYyrGvVJKlCE7hA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mlQLkngm9wNBHOy+BE11AOPWXZTLRjJAxAukLe3eHPeb7X8fP78pb72CtOSTc4hae
         B2GaFPNS8V7WL82bPERNMzDA3S23imf78OemEhwjv3opmN+F2/CrlzREeuGJCz9oxO
         VcrUSzrSjzHHfbO0+MmkH6Jew7US80JZMQD4t7Sj8CP/93XzBepEjVDBNrSjAsh3gx
         jf0PeJfQ4mV3xpWXiIlXRkfEMuZzzeJBhwr4kz/uMvunjx52oKubRAHHl8ygjiFDLD
         DHyZ2YaZl2q26A2Kih4uaDgSwpL9FqifMscbj54txapPFG6krnza7cdnh7h9GDC4Zu
         UbnlZ3CDFfJbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91A1CF0389D;
        Sat, 21 May 2022 00:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: bnxt: make ulp_id unsigned to make GCC 12 happy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309361159.27605.17333088037543148709.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 00:40:11 +0000
References: <20220520061955.2312968-1-kuba@kernel.org>
In-Reply-To: <20220520061955.2312968-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, michael.chan@broadcom.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 May 2022 23:19:55 -0700 you wrote:
> GCC array bounds checking complains that ulp_id is validated
> only against upper bound. Make it unsigned.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: michael.chan@broadcom.com
> 
> [...]

Here is the summary with links:
  - [net-next] eth: bnxt: make ulp_id unsigned to make GCC 12 happy
    https://git.kernel.org/netdev/net-next/c/dbb2f362c783

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


