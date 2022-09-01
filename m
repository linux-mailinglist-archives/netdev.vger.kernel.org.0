Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BC95A8BB7
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiIADAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiIADAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E6A77EA1;
        Wed, 31 Aug 2022 20:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3178DB8241B;
        Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC6A2C433B5;
        Thu,  1 Sep 2022 03:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662001215;
        bh=06ZGis4JESxq4BUNVE9UyWDbzEk3v3Be/wRmkvWLcac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FfFcZCzVMc/X3DrzKJNDQwKgEgnuLSOpatBS0saQQHIljJjVPJjZiHKurWy0ap4I9
         +lY8dp1qKuu27IToacHPUNz76Fihjoyp7JmkVMv5ube57Oeehng/IvA8C/oRDRWN9Z
         LDhcsJd/MhH9+xn1Dl1KNE3HkR5mklwapTDzlRnwMB+/AgjQScDGl1OCWi48NNa7CI
         8qfzmWRCu8//GwWcWGpMBjniBskKSPHW+faWP+t13J9zfryCHV8uz8M3a4DSCsJ+F5
         MV4CMJQytgntm3Yfg1Lyjz8ApJPEHyQwHo8d4LVJe1XUM6WaMVP78tKBti23fHbR1B
         8gE8+ho7dOeZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B218DC4166F;
        Thu,  1 Sep 2022 03:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ip: fix triggering of 'icmp redirect'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166200121572.29714.8922887683350296133.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 03:00:15 +0000
References: <20220829100121.3821-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20220829100121.3821-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@kernel.org, netdev@vger.kernel.org,
        hengqi@linux.alibaba.com, edwin.brossette@6wind.com, lkp@intel.com,
        lkp@lists.01.org, stable@vger.kernel.org, yujie.liu@intel.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 Aug 2022 12:01:21 +0200 you wrote:
> __mkroute_input() uses fib_validate_source() to trigger an icmp redirect.
> My understanding is that fib_validate_source() is used to know if the src
> address and the gateway address are on the same link. For that,
> fib_validate_source() returns 1 (same link) or 0 (not the same network).
> __mkroute_input() is the only user of these positive values, all other
> callers only look if the returned value is negative.
> 
> [...]

Here is the summary with links:
  - [net] ip: fix triggering of 'icmp redirect'
    https://git.kernel.org/netdev/net/c/eb55dc09b5dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


