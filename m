Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933DD6ED2AF
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjDXQkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjDXQkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7407D8C
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52EDA6150B
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 16:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B615EC433EF;
        Mon, 24 Apr 2023 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682354419;
        bh=i4saptdzGOFgVWtI4CnliBXIY4yWQf2yu6P9NJwwn94=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WZfUcKnQrwMM6Cjgj94X7hemE6+HX/gYGOX6KefeoC7hyqetghAUQOZcYkla6ixQ6
         rGYWPadVy887hxu+xRxBq4miWbr42f4PGHy0+XDxHqGMyhYqydns5TWB4tHO3bZqnE
         B4T9rdNUo7n9H1MzVvKFWjnS0o1jfJFuIiiYDHnyJMrR8PmjrrDiGiSpmRS4elAOBO
         vn1hMD+QuIwMGNMVVP+oZGoqqm1uTpB9yj36IafejT/Axz6avq/MJH0pjyMSGeAWbt
         UrbW6dOsQfaD8bG/A/2DPee5EP/Pm1SLytIUOxofBfVXSItHUmmxxKJhIsKrIGyEba
         /IW776zqkBpgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87C42E4D030;
        Mon, 24 Apr 2023 16:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 iproute2-next 00/10] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168235441955.3182.11739919832221309922.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Apr 2023 16:40:19 +0000
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

On Tue, 18 Apr 2023 14:39:43 +0300 you wrote:
> This is the iproute2 support for the tc program to make use of the
> kernel features added in commit f7d29571ab0a ("Merge branch
> 'add-kernel-tc-mqprio-and-tc-taprio-support-for-preemptible-traffic-classes'").
> 
> The state of the man pages prior to this work was a bit unsatisfactory,
> so patches 03-07 contain some man page cleanup in tc-taprio(8) and
> tc-mqprio(8).
> 
> [...]

Here is the summary with links:
  - [v2,iproute2-next,01/10] tc/taprio: add max-sdu to the man page SYNOPSIS section
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=bad08997cfec
  - [v2,iproute2-next,02/10] tc/taprio: add a size table to the examples from the man page
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=201e2f968bd2
  - [v2,iproute2-next,03/10] tc/mqprio: fix stray ] in man page synopsis
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=4f4e2481e3a5
  - [v2,iproute2-next,04/10] tc/mqprio: use words in man page to express min_rate/max_rate dependency on bw_rlimit
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=82289b7addab
  - [v2,iproute2-next,05/10] tc/mqprio: break up synopsis into multiple lines
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=8c028693cd5f
  - [v2,iproute2-next,06/10] tc/taprio: break up help text into multiple lines
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=b54a4c9fc0cb
  - [v2,iproute2-next,07/10] Update kernel headers
    (no matching commit)
  - [v2,iproute2-next,08/10] utils: add max() definition
    (no matching commit)
  - [v2,iproute2-next,09/10] tc/mqprio: add support for preemptible traffic classes
    (no matching commit)
  - [v2,iproute2-next,10/10] tc/taprio: add support for preemptible traffic classes
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


