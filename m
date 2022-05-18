Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76E352BABD
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbiERMfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiERMeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:34:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27CA11E497
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 715DAB81F40
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 12:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E651C34118;
        Wed, 18 May 2022 12:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652877013;
        bh=CoCtdZx3eYUWU8ZMEOtZeYRBTW0Y/OdXAeKPD1RVItU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KGABcTQb26ALPP0NP8A68CwdL4dSTnCsn7i9APC/g2sagVmQjkw0lrBrh8xGYu2oW
         hn4vdtojQn7grFChf7J5jGToEOs8/9FlycgqEHlo3SqwHxynJVBznryNSX3u5jQtLq
         GlfOiu/4KjtEGGDZDEjfjmMHS0ue0vVdBGPCLUPSWS4gYikFrcvyR5qP6UdIfJcF3C
         sU4o9bs70c4z0A3Ge5djk7+VhRBNRrXMCKOq+8cymEC+NkEDBprPvtVuiBhJ9ceqXq
         xFrcLZCSTCETvy4WNy0NvU7ehbY6Ws965bsHV+Sh4et/5j1pytclDU5x8hzXCJz5AR
         0NZHT46yxBKfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02BFBF0383D;
        Wed, 18 May 2022 12:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: Fix checksum byte order on little-endian
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287701300.2655.7984916105463190195.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 12:30:13 +0000
References: <20220517180212.92597-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220517180212.92597-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 17 May 2022 11:02:10 -0700 you wrote:
> These patches address a bug in the byte ordering of MPTCP checksums on
> little-endian architectures. The __sum16 type is always big endian, but
> was being cast to u16 and then byte-swapped (on little-endian archs)
> when reading/writing the checksum field in MPTCP option headers.
> 
> MPTCP checksums are off by default, but are enabled if one or both peers
> request it in the SYN/SYNACK handshake.
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: fix checksum byte order
    https://git.kernel.org/netdev/net/c/ba2c89e0ea74
  - [net,2/2] mptcp: Do TCP fallback on early DSS checksum failure
    https://git.kernel.org/netdev/net/c/ae66fb2ba6c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


