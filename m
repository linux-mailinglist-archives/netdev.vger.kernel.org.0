Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139686258B3
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 11:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiKKKug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 05:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbiKKKuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 05:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B762363CD1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 02:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 729FAB82590
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21988C433D7;
        Fri, 11 Nov 2022 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668163817;
        bh=4CRswwPtbHMpfVG8/NDBOlXssseOr8yUMDe9rvaj7y8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aY8yF8d9En536OT+HA7+IJLm2VdKaiJlfEmbW8CHE6o559j2/1mUSQ8Ib27dapVVw
         TZsi7pm01rzzjHTTqEbb4gptDufsSjT6g2+pe2pmkdUdyUaJf5kdQq8EIVn6B5nZww
         VQZGWr11aV+TIoem3PP3AmDH/8XVXUicD+YDXAhh7JBEYpI8Y56jcgBmac37QcboOo
         RT7nNtp6uYcLsIw+9b4Bho5S0iAy+Eho2I1uhr4Qw4Gp68LKufs0na60JAZo7FbJkm
         W7U0g4N2ZubiHr1NRib7kgA5zbHaat32Wa5auQLE+qAItNogeIBXRFWOD5LQTA1rzc
         xbayzkKF77CjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0683DE4D022;
        Fri, 11 Nov 2022 10:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: take numa node into account when setting irq
 affinity
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166816381702.5678.69189249878962539.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 10:50:17 +0000
References: <20221109200442.143589-1-simon.horman@corigine.com>
In-Reply-To: <20221109200442.143589-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yinjun.zhang@corigine.com, louis.peens@corigine.com,
        niklas.soderlund@corigine.com
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
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Nov 2022 15:04:42 -0500 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Set irq affinity to cpus that belong to the same numa node with
> NIC device first.
> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: take numa node into account when setting irq affinity
    https://git.kernel.org/netdev/net-next/c/42ba9654acad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


