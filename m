Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740C14AF217
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiBIMuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiBIMuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:50:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955B1C05CB97;
        Wed,  9 Feb 2022 04:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 466E2B820CB;
        Wed,  9 Feb 2022 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10B24C340EE;
        Wed,  9 Feb 2022 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644411010;
        bh=xWHN9CIsMOkHElKuRiLQjIOW5O8pYSdRfpxje3zeYbI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gndt95hOjSs49VZNjWxwyIynDE3V7pTUDoAjTYNh8HlTc1/Y0YkEgGndwSRQTQIyU
         n6m2fJrBBN0goP9ok06y7PuJ/NbNYzWiMLn1Lki3ZLu3EmeV3pA1RSutOqHidSrcjt
         +4EHh7nt1/VD7EjcnUM43tIcVMFFOyu6MyLC2eD7L2Pk9z7kM2eqoBlM/m8tAu5zw9
         aYtphW768nx5rqAN1rboOtgIi0NxYpbAI5RWzmMGgEkjp2+5kyOHjYzlTvDvHuRnBE
         Au/zVDEbArrtwHGKCJrBudDKjumKg4KYzd/uVg+qn92dmgexyu2G0gRFSyIK99Y8kO
         2jnpCNn+feVDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0003DE5D07D;
        Wed,  9 Feb 2022 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] MCTP tag control interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441100999.3630.17468274065248587297.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:50:09 +0000
References: <20220209040557.391197-1-jk@codeconstruct.com.au>
In-Reply-To: <20220209040557.391197-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        rostedt@goodmis.org, mingo@redhat.com, linux-doc@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 12:05:52 +0800 you wrote:
> This series implements a small interface for userspace-controlled
> message tag allocation for the MCTP protocol. Rather than leaving the
> kernel to allocate per-message tag values, userspace can explicitly
> allocate (and release) message tags through two new ioctls:
> SIOCMCTPALLOCTAG and SIOCMCTPDROPTAG.
> 
> In order to do this, we first introduce some minor changes to the tag
> handling, including a couple of new tests for the route input paths.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] mctp: tests: Rename FL_T macro to FL_TO
    https://git.kernel.org/netdev/net-next/c/62a2b005c6d6
  - [net-next,v2,2/5] mctp: tests: Add key state tests
    https://git.kernel.org/netdev/net-next/c/c5755214623d
  - [net-next,v2,3/5] mctp: Add helper for address match checking
    https://git.kernel.org/netdev/net-next/c/8069b22d656f
  - [net-next,v2,4/5] mctp: Allow keys matching any local address
    https://git.kernel.org/netdev/net-next/c/0de55a7d1133
  - [net-next,v2,5/5] mctp: Add SIOCMCTP{ALLOC,DROP}TAG ioctls for tag control
    https://git.kernel.org/netdev/net-next/c/63ed1aab3d40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


