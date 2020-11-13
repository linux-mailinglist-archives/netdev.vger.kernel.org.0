Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8772B132B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgKMAUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 19:20:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605226805;
        bh=A9GlXH6q7yVPHhOJVS5gYEM8NSVeP9Ck6OHbqQFe0Ag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NYCix47SlDtDv9N0EetkhDLXrL9jn2Npsaz/W0Vv/WWad5PLNQ2NmChPm38J665bR
         YE42oJKytJ1HazRcWiXu/QYl22/ttsaTRDnuc4/aJavoatK4yYGT8ji4cFu5F1CjE9
         f7MhhG/qwzHmfLT5KbIUdVA3t4Vr12i69p6dT3kE=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: set conf.all.rp_filter=0 in bareudp.sh
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160522680539.1261.2025528347077942558.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 00:20:05 +0000
References: <f2d459346471f163b239aa9d63ce3e2ba9c62895.1605107012.git.gnault@redhat.com>
In-Reply-To: <f2d459346471f163b239aa9d63ce3e2ba9c62895.1605107012.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Nov 2020 16:05:35 +0100 you wrote:
> When working on the rp_filter problem, I didn't realise that disabling
> it on the network devices didn't cover all cases: rp_filter could also
> be enabled globally in the namespace, in which case it would drop
> packets, even if the net device has rp_filter=0.
> 
> Fixes: 1ccd58331f6f ("selftests: disable rp_filter when testing bareudp")
> Fixes: bbbc7aa45eef ("selftests: add test script for bareudp tunnels")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: set conf.all.rp_filter=0 in bareudp.sh
    https://git.kernel.org/netdev/net-next/c/e86580235708

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


