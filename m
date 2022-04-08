Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D074F93A7
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiDHLWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiDHLWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:22:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8565F2968A4
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 04:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A683B82A58
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A82CC385B4;
        Fri,  8 Apr 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649416813;
        bh=oLKWTOP16IV1OvGdFSAdjnMLOu/cYjZGYIBuReUQKUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bR2+n4Ck1sGoONDMjYGULDORQbXnczJFsF7VCdjKbF+PVfzvgmCapCFauwRx3Q7xB
         GN/w4lxOeY/8M8oFkxsIYxuCYuFcEWnCUdoMyLpxRXV2bOHYZxOzQmvPn7GsLhLGlG
         svkFkIMjX7aGDWhetdF7WLAGLrQWzGvmzA1HE7T0BqcUEb5VZRPaRJwjPvgkuukqH+
         XkVkPWJ4D3O8+UKU4iKjbBZto/K0gIgj0DhMkZV2p1e1MQV+nSFEFDnMijr6Ri2inc
         BQ3OyEm2tc7C86bwH5cGsJTjf3ohnJShKj/4Pn0j4qbJp/wZqLYssYtCPVl+7uO+Qi
         JkLbGGr3x+61g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4958CE8DBDA;
        Fri,  8 Apr 2022 11:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] flow_dissector: fix false-positive
 __read_overflow2_field() warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164941681329.25766.14882349158625098737.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 11:20:13 +0000
References: <20220406211521.723357-1-kuba@kernel.org>
In-Reply-To: <20220406211521.723357-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        gustavoars@kernel.org, kurt@linutronix.de, keescook@chromium.org
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
by David S. Miller <davem@davemloft.net>:

On Wed,  6 Apr 2022 14:15:21 -0700 you wrote:
> Bounds checking is unhappy that we try to copy both Ethernet
> addresses but pass pointer to the first one. Luckily destination
> address is the first field so pass the pointer to the entire header,
> whatever.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] flow_dissector: fix false-positive __read_overflow2_field() warning
    https://git.kernel.org/netdev/net/c/1b808993e194

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


