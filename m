Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3093951296F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbiD1CXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbiD1CXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:23:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958077305C
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 19:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2F5FB82BA2
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6862AC385A7;
        Thu, 28 Apr 2022 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651112413;
        bh=QJJQQZvZRUirACSkMdaF18iwGwe+wDkamqZ33bT//w8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bbUlCu7sxED9k67YUD+vI1CeHVNDYyYfZs9COrHroVfHjjBwgUHqN/1RdiKt/QU62
         mFPesOrSb2169DPNelESPHKUgCwgh0sDF99Dn2Hx81msk3ZL9+yWHiciIUpRQpz46m
         X1+fVYKOMNIX0PmH7lMHtwmLwzKffgJhrtpXwfHHNIxTkA1yzdr1AlCMV+94RJM+TK
         HeAV1Aqb+1DTQ/KpOZRKFulKc0elcen6/z0M54KGyTw4GbF1agc3iRcEeZNzkNi3l4
         ehuLvI1sOxU0VYm7FB555/m6roywoKwwJ8bF5rvo0h3pFRVMXfQVRT7/FGZBTh93LN
         9OsCXqxctiTHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B37BF03840;
        Thu, 28 Apr 2022 02:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch iproute2-next v3] devlink: introduce -[he]x cmdline option to
 allow dumping numbers in hex format
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165111241330.28424.17590096957335466558.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 02:20:13 +0000
References: <20220425103627.1521070-1-jiri@resnulli.us>
In-Reply-To: <20220425103627.1521070-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        snelson@pensando.io
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Mon, 25 Apr 2022 12:36:27 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> For health reporter dumps it is quite convenient to have the numbers in
> hexadecimal format. Introduce a command line option to allow user to
> achieve that output.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v3] devlink: introduce -[he]x cmdline option to allow dumping numbers in hex format
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=38ae12d39632

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


