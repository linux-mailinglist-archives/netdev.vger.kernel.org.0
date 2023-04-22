Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EBA6EB70B
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjDVDUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjDVDUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413CF1BD2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 20:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C23F6640B1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 03:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31C98C433EF;
        Sat, 22 Apr 2023 03:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682133619;
        bh=flrBuYoQnqV7q8mFlz6Gmq3LmOBxigQAGd4sjJbrFF0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fk9Dl1sBthIspRIgXsE6KyG6eUewtIadOnM44S8XLc2B6wWEIGVSvPFxdAFYnPfQz
         PRFCIE8l9gvgk/uYil/HBdx8keWJCXtwggrfhyZgy2j6oHblSA7ZEY1GOwEKo2lhZr
         bp7lfEjUTaRKEtdQpmEtPjGtvAEY4W6Ttu1tiZUq/b+atGjGhC1uTJJWMmheBuVJL+
         oB57sk5jTdGXAcy7yKrF6yjfGZnxE92lO85iZwr7y5dEcpMRkVQHqRhfaBXAvsddLM
         ISR/iXa0QN+ANpClQ1rfRgfjuy8ArW+egF5zKKIhzcpYVR3/EBK8ypgE9RGb+M1AZp
         OITG6CSr3lDMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1DBBBE270E0;
        Sat, 22 Apr 2023 03:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 v3 0/2] iplink: update doc related to the 'netns' arg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213361911.18367.12559054475550059262.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:20:19 +0000
References: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com, simon.horman@corigine.com
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

This series was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 21 Apr 2023 09:47:18 +0200 you wrote:
> v2 -> v3:
>  - make doc about netns arg consistent between 'add' and 'set'
> 
> v1 -> v2:
>  - add patch 1/2
>  - s/NETNS_FILE/NETNSFILE
>  - describe NETNSNAME in the DESCRIPTION section of man pages
> 
> [...]

Here is the summary with links:
  - [iproute2,v3,1/2] iplink: use the same token NETNSNAME everywhere
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=3921f56ec3be
  - [iproute2,v3,2/2] iplink: fix help of 'netns' arg
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=1371d7deaa20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


