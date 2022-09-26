Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB7E5EB21E
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiIZUae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiIZUaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB77025E5;
        Mon, 26 Sep 2022 13:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D2161349;
        Mon, 26 Sep 2022 20:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA4F4C433D7;
        Mon, 26 Sep 2022 20:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664224217;
        bh=PHeuVR4oq6lCJKevMwcZfXT8Ff7EsKqy2MQBwwFcYMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b6ro6RevwMFVYAQRNC57wlL5Wc0QpNYK9sS8P3/NMpdpm28Ycwpc9pPBOTLNJcV1O
         c1Q+KuOPoY3YNz//mRoO1pG2bTlM+DnOfK9kcvLKEbEgBFJqsOeKhVeKuMECWn2ryz
         ioGCulMEk6UX5y53AeYQCZwQNkru/habkr00eVRur3jho9vftZL3TbB4qZf6I0XbX4
         fUTV1gZ3J/MKhm29olmVZanK/AhUG+NiN2DExNUwKAdzwvum9Dc7dw6Qpv6gq6/Ki0
         MIA/ucBFFmTQTFExU+CqqHBzrlNGwATaPyUuSveuVXhB2WwHXOe3ppZypbICgh10lU
         yNcBVMJAZdj2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2FC9C04E59;
        Mon, 26 Sep 2022 20:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Improve tsn_lib selftests for future distributed
 tasks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422421686.13925.11977641432026324347.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 20:30:16 +0000
References: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, vinicius.gomes@intel.com,
        kurt@linutronix.de, alexandre.belloni@bootlin.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 24 Sep 2022 00:00:11 +0300 you wrote:
> Some of the boards I am working with are limited in the number of ports
> that they offer, and as more TSN related selftests are added, it is
> important to be able to distribute the work among multiple boards.
> A large part of implementing that is ensuring network-wide
> synchronization, but also permitting more streams of data to flow
> through the network. There is the more important aspect of also
> coordinating the timing characteristics of those streams, and that is
> also something that is tackled, although not in this modest patch set.
> The goal here is not to introduce new selftests yet, but just to lay a
> better foundation for them. These patches are a part of the cleanup work
> I've done while working on selftests for frame preemption. They are
> regression-tested with psfp.sh.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] selftests: net: tsn_lib: don't overwrite isochron receiver extra args with UDS
    https://git.kernel.org/netdev/net-next/c/7d45b5fd27b4
  - [net-next,2/4] selftests: net: tsn_lib: allow running ptp4l on multiple interfaces
    https://git.kernel.org/netdev/net-next/c/7ff9396ee82c
  - [net-next,3/4] selftests: net: tsn_lib: allow multiple isochron receivers
    https://git.kernel.org/netdev/net-next/c/a7ce95ac837d
  - [net-next,4/4] selftests: net: tsn_lib: run phc2sys in automatic mode
    https://git.kernel.org/netdev/net-next/c/162d52dfee44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


