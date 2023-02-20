Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165CF69CA05
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjBTLk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbjBTLkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:40:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513E31816B
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 03:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FA5CB80CA0
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 11:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C25D1C433EF;
        Mon, 20 Feb 2023 11:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676893217;
        bh=Ak8Gv6VX5ozIP2GJCQz2RlFo7YQXD4ucwLE5lndsXi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TJ5spbbrWiDbKhHBudkMSR30W9PYafnxHqLnukuUmWq+uKo+LzzizCOP7V6PP2Fbh
         KOV+KX82twAb2H+60v1daBzTwi+Hbm+pSBzNmVcPyXTYU94G8NN+Q5QegSVdM9Rc0Z
         JjG1Li0oD9kBfuY4iDo78nuRMiFenBOZ6kkl/BIb4D43MSKH/SuPW37Glh70auGpEh
         qYDFSapQdKH7fbovG6fIBE/yohvkB8OgP4uBitWcW7WDSvDf7VB6NodUa0LKCZhKIo
         r0Db/V4AxYPeyhsHgDUfwXTa29pmGHumYi1hbYUFmIVkaNJq1hC6WGbgwpz3bTl69K
         z6XW7MhvGs59A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACE0FE68D20;
        Mon, 20 Feb 2023 11:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: drop leftover duplicate/unused code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689321769.10349.7150877347305355182.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 11:40:17 +0000
References: <8ad783f77a577505653d90fb47075ea4c9ca5d97.1676657010.git.pabeni@redhat.com>
In-Reply-To: <8ad783f77a577505653d90fb47075ea4c9ca5d97.1676657010.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, jiri@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 19:09:20 +0100 you wrote:
> The recent merge from net left-over some unused code in
> leftover.c - nomen omen.
> 
> Just drop the unused bits.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: drop leftover duplicate/unused code
    https://git.kernel.org/netdev/net-next/c/fce10282a03d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


