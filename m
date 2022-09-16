Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28B05BABE5
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 13:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiIPLA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 07:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiIPK7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 06:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2113C156;
        Fri, 16 Sep 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52B27624B3;
        Fri, 16 Sep 2022 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7B53C433C1;
        Fri, 16 Sep 2022 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663325414;
        bh=kNaWbCbYimO1IGqs2085hHU/G9a8yX91dtEHKbN0/CQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fqd4riV99bPv85jPwYXgCvtufoPQkEaMkzr/oSxZkw5+AAXyDMSylC5ldGOBC7yoZ
         O11tkSq7EbBr3UQd42kDix5YrjoBZJ1Mw9TBDnEIZGGY7r6uQVDV+f/nE/daz9V0+N
         +d/iFkZ3oERAbkV+pofZYDF1jqemEIRv/z9Ro5vldVnUL4zcKvHMIYyWi4X27Wdnku
         TzT1PH22Ybzlshk9/0AXZZ3l1eKcpq+EjmbUnaggK3nNvgKCcWG2lNZG6Hzz4W8nKC
         KkgunfiY6LJ1A+sY2HSCWYjQDvRoZhu3C/4ESUKEU/gsqLSXbOA7iYmMs9d1owZu55
         rzcaqs+ssNEdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8032EC59A58;
        Fri, 16 Sep 2022 10:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] iov_iter: use "maxpages" parameter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166332541451.30138.16398671339875317736.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 10:50:14 +0000
References: <YxneB8I8gydE+8MF@kili>
In-Reply-To: <YxneB8I8gydE+8MF@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     viro@zeniv.linux.org.uk, kuba@kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 8 Sep 2022 15:20:23 +0300 you wrote:
> This was intended to be "maxpages" instead of INT_MAX.  There is only
> one caller and it passes INT_MAX so this does not affect runtime.
> 
> Fixes: b93235e68921 ("tls: cap the output scatter list to something reasonable")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I'm not sure which tree this should go through.  It's a cleanup and the
> only caller is in networking so probably net-next is easiest.
> 
> [...]

Here is the summary with links:
  - [net-next] iov_iter: use "maxpages" parameter
    https://git.kernel.org/netdev/net-next/c/7187440dd7c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


