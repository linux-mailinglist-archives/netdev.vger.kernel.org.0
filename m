Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7F86E7968
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjDSMKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjDSMKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:10:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C490D1BD4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F9463E5F
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 12:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA6F6C433EF;
        Wed, 19 Apr 2023 12:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681906221;
        bh=YWKBo441e6ea72gmMFsEHC6f0DQwlnOsM/OEBhp1up8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mn/qpLz4M5PwTmRETi3mQ5W7+D329SJrSh6rgw/j/ueW9moTW4w6FNumlH/GJB5Ex
         hCaSMSKb5aRm/VFWZwNujJFRXWmv/pFMB4+6p9+GrsnIyYhSyuAz659Q4O8F1L2Ihf
         6+99DgNolymUiEByNbgdrlOA+yTwNEQMpbCO4isA9SB5xGxNB+5yxRTH01Mvi0TqG5
         1a7uv33qX+bSOE2+2aqq1Q9dueFQsxre1wHB1M+3vPJqCPqCiI75+thxcWL3bDHdL5
         YE1MnCnCPb0qKathAntHNAD0yxVpusAtptstT0WmMKtlqmXS5pGjkfQ65aNfFkEH+k
         ZiEuSxxd7D4+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4875E270E5;
        Wed, 19 Apr 2023 12:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] net: skbuff: hide some bitfield members
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168190622173.8890.3731322595799456667.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 12:10:21 +0000
References: <20230417155350.337873-1-kuba@kernel.org>
In-Reply-To: <20230417155350.337873-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
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

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Apr 2023 08:53:45 -0700 you wrote:
> There is a number of protocol or subsystem specific fields
> in struct sk_buff which are only accessed by one subsystem.
> We can wrap them in ifdefs with minimal code impact.
> 
> This gives us a better chance to save a 2B and a 4B holes
> resulting with the following savings (assuming a lucky
> kernel config):
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net: skbuff: hide wifi_acked when CONFIG_WIRELESS not set
    https://git.kernel.org/netdev/net-next/c/eb6fba7555a8
  - [net-next,v2,2/5] net: skbuff: hide csum_not_inet when CONFIG_IP_SCTP not set
    https://git.kernel.org/netdev/net-next/c/c24831a13ba2
  - [net-next,v2,3/5] net: skbuff: move alloc_cpu into a potential hole
    https://git.kernel.org/netdev/net-next/c/4398f3f6d138
  - [net-next,v2,4/5] net: skbuff: push nf_trace down the bitfield
    https://git.kernel.org/netdev/net-next/c/4c60d04c2888
  - [net-next,v2,5/5] net: skbuff: hide nf_trace and ipvs_property
    https://git.kernel.org/netdev/net-next/c/48d80c394d3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


