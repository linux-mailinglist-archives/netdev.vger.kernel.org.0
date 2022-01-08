Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67D64885A0
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 20:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiAHTkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 14:40:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37380 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiAHTkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 14:40:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD68B80B4E
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 19:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5608CC36AED;
        Sat,  8 Jan 2022 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641670808;
        bh=+JQHaNOrFsNhTWv4WkxEQmcC53EmjeQca0Qr3i2EFE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ioEFT5nDtFZP06g0njUMY+wm7Tw7sPKN6C3+8+4LGVm2/4iQewBDcUUPO9i/+ttyg
         fXlS9WOCRvGauN5ThpLQExCB9gy3hD0VlDo7HsNT50keHTi19IN6Oai2GJxmSAB6Q4
         4I5g+bb1JrMnP1t8AwvNtRpQ+5dx5CRd2Bpung6IM5C5NaG0JQ6YE8orOXwuME60F2
         aOGK1GwdovIzX72aLavcUXVLbHyfYuQFr8gaWeP7YbZjm92RXYvOyLHyC/8b4axwUV
         UzlspNYjsWzOt49Fw5yAaCwxAv4XPigCGJZqdGgJ3RTT431piY+xVvnHl1EzUL1udm
         AytyREkwNnY9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F367F7940C;
        Sat,  8 Jan 2022 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] testsuite: Fix tc/vlan.t test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164167080825.29977.16727169874548402154.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Jan 2022 19:40:08 +0000
References: <31ec3c6473b76d320301767cc3920ce6dac33e4c.1641232756.git.aclaudi@redhat.com>
In-Reply-To: <31ec3c6473b76d320301767cc3920ce6dac33e4c.1641232756.git.aclaudi@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon,  3 Jan 2022 19:00:22 +0100 you wrote:
> Following commit 8323b20f1d76 ("net/sched: act_vlan: No dump for unset
> priority"), the kernel no longer dump vlan priority if not explicitly
> set before.
> 
> When modifying a vlan, tc/vlan.t test expects to find priority set to 0
> without setting it explicitly. Thus, after 8323b20f1d76 this test fails.
> 
> [...]

Here is the summary with links:
  - [iproute2] testsuite: Fix tc/vlan.t test
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=1225e3071020

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


