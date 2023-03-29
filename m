Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860776CD416
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjC2IKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjC2IKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967524228
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 01:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9C7E61B5C
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 294E8C433EF;
        Wed, 29 Mar 2023 08:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680077423;
        bh=AJtPjGo71juJ6N7XgOAELRM51Qfnug1wOEHnPHFEqjM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JNEit4YO19vnVVITsdl8SGnGbWu1zZ8+5TH6WCHec9KpSLXHVLBeA4kypUkdDMP8e
         pQmz/tnw1N5UbakQg5Z9q1d3AzKImlZ5L5XBC8qe1wn48w2g+mJAaqSQG0k19Rk8aD
         86shZpd/Ey6M6fUI6LigCaf/p5Gf7c1I70DS90oQx39Zh7qJC3x+YbAgyu89WXMNwo
         Kq9cNg5FiRY+6CI+nu22+PIBt8JCKVMswVX8F+XCtKCi8VsR6YkEhG8a1+an9QJzoC
         4jPHnwGu8ldhS4gZI/f1ihnSTKZ4YFMU1Nro+4oA6Wr+CPqwHcEhFz83NvbUDDpsx0
         we/gtmQNv9SSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07C87E4F0DB;
        Wed, 29 Mar 2023 08:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: wwan: iosm: fixes 7560 modem crash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007742301.16006.16789663362058964487.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 08:10:23 +0000
References: <b5b3b67ed4dcbc508961dfd3e196857d6ae1385c.1679983314.git.m.chetan.kumar@intel.com>
In-Reply-To: <b5b3b67ed4dcbc508961dfd3e196857d6ae1385c.1679983314.git.m.chetan.kumar@intel.com>
To:     Kumar@ci.codeaurora.org, M Chetan <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, shaneparslow808@gmail.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com, mwolf@adiumentum.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Mar 2023 11:58:44 +0530 you wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> ModemManger/Apps probing the wwan0xmmrpc0 port for 7560 Modem results in
> modem crash.
> 
> 7560 Modem FW uses the MBIM interface for control command communication
> whereas 7360 uses Intel RPC interface so disable wwan0xmmrpc0 port for
> 7560.
> 
> [...]

Here is the summary with links:
  - [net] net: wwan: iosm: fixes 7560 modem crash
    https://git.kernel.org/netdev/net/c/5f70bcbca469

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


