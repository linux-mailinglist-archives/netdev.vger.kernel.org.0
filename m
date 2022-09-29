Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133325EEB9E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiI2CU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbiI2CUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A650E83BF6
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A8BDB8232C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A201DC43142;
        Thu, 29 Sep 2022 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664418017;
        bh=HqHC1Lw2ikAePwJrjBNkUpMLl/aWPqgbaZ+qf/Qti2g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DMSBlF+t5HFBvK5aJ08LtfuwV1mistOf+XD1ppPt5FjlgeQy6cuu4Pc35epnMTVec
         KoMkBb/3oWPPODcZhEyj+8pxEwtWxcyi0dkOIFpdw8gvCb0ZjGo88y4rXBGJIuKWlY
         v+dhyXMQeIi8ez1eF07ru8grt1jJp28ikQkU3N7g0iWRUQoAOOCW4GsirWJwV1OkhQ
         8nkk7+Nz+l3hB6SpfNuzvwgAkr12Q3T1H5qPmW/u47g351ImJ1FUhwzNmvz0WgHNWA
         K3NPQgvdo5wAZ5VdZAiHnjvnYYHfP8I7LWPjCDcPRoB35fXdGOriFp8rhcXAy52re/
         n7JxmUjqFu0Xg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81336E4D023;
        Thu, 29 Sep 2022 02:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: Properly clean up unaccepted subflows
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441801752.18961.14079404286061785586.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:20:17 +0000
References: <20220927193158.195729-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220927193158.195729-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 27 Sep 2022 12:31:56 -0700 you wrote:
> Patch 1 factors out part of the mptcp_close() function for use by a caller
> that already owns the socket lock. This is a prerequisite for patch 2.
> 
> Patch 2 is the fix that fully cleans up the unaccepted subflow sockets.
> 
> Menglong Dong (2):
>   mptcp: factor out __mptcp_close() without socket lock
>   mptcp: fix unreleased socket in accept queue
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: factor out __mptcp_close() without socket lock
    https://git.kernel.org/netdev/net/c/26d3e21ce1aa
  - [net,2/2] mptcp: fix unreleased socket in accept queue
    https://git.kernel.org/netdev/net/c/30e51b923e43

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


