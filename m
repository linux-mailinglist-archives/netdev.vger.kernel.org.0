Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9988C68CF91
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBGGk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjBGGkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3384222DD8;
        Mon,  6 Feb 2023 22:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7ED5B81711;
        Tue,  7 Feb 2023 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69BE7C4339B;
        Tue,  7 Feb 2023 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675752019;
        bh=CVEC+G/Q16Ka05gCAS9aSdF4EfoxIBD+edro1nL3xtQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qUi60+lDKLVYQbYDH4/3NTFwRwjBj2mVLwpPmquF/ei37XgtTGY9I47aFOI4Z3Di0
         jBrtSmsWGJQFL+A3UNWlgMfY0uv1KuWYWuoIheAaSCxJzc7A7tYmC7AslruA7mh+BR
         wKoRXrmZ7bkufvRGe32V3Y+NgEKmwGuTvgkT5HE033hK/Jyj3xda4slPpQpfzKA6SU
         tonL5m6iy+kr4SBb9rZ9gK4ska8BKbrAAFJn5DzCI3nplKCw78RRImdxRy4eyAxVe6
         qWcw4wm0GEMfieqTbzQTfjPsvFXe24+z/a8eWjRfM9NjpWNKYpnPoICI54fepr0YZT
         uG5Wlak7N4OUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50B8EE21ECD;
        Tue,  7 Feb 2023 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 1/1] net: openvswitch: reduce cpu_used_mask memory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167575201932.385.5295768848668955221.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 06:40:19 +0000
References: <OS3P286MB229570CCED618B20355D227AF5D59@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
In-Reply-To: <OS3P286MB229570CCED618B20355D227AF5D59@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  5 Feb 2023 09:35:37 +0800 you wrote:
> Use actual CPU number instead of hardcoded value to decide the size
> of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.
> 
> 'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
> Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
> 8192 by default, it costs memory and slows down ovs_flow_alloc.
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/1] net: openvswitch: reduce cpu_used_mask memory
    https://git.kernel.org/netdev/net-next/c/15ea59a0e9bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


