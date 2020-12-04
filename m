Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA71F2CF656
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbgLDVlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgLDVlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 16:41:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607118026;
        bh=uNPuqXFYIGKlg/LtzADylh84tk1uzZd6pTpoiZDvyQs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KrnmSrLQhTkLPrrujlbupXE3NOM41MDxSi+nmir8HC5NXpQFjUlY92rJFKNU/newy
         5k9q2/3SliGz7eqXA/H6JaTqVzpMTOxi9cel0T2tiOrFp0+0olgNVUDMOlOI6B+I/4
         T2Sj+BlCfWpacrd8xCf5wqqsYoXqVEkd/F/Bpio5FvElrkhjtivMBDurpwBxTYztsV
         YwqToYY/QyVsw24BxUD17U6D7xxB2Pzo0U1qhj5SKNSxLK81IAmHKJG7x5lFt4s2RE
         eHy05hh37IZvNBGsjdJ0D+VLMIMxn8LL6EKZVfTCKr9GXuqHSqNKQzAIKNHeFYAwGi
         JLC5fTCIdV24Q==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v4 0/8] seg6: add support for SRv6 End.DT4/DT6 behavior
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160711802655.19007.16256732742816656137.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Dec 2020 21:40:26 +0000
References: <20201202130517.4967-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20201202130517.4967-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, dsahern@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, shuah@kernel.org,
        shrijeet@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, natechancellor@gmail.com,
        stefano.salsano@uniroma2.it, paolo.lungaroni@cnit.it,
        ahabdels.dev@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Dec 2020 14:05:09 +0100 you wrote:
> This patchset provides support for the SRv6 End.DT4 and End.DT6 (VRF mode)
> behaviors.
> 
> The SRv6 End.DT4 behavior is used to implement multi-tenant IPv4 L3 VPNs. It
> decapsulates the received packets and performs IPv4 routing lookup in the
> routing table of the tenant. The SRv6 End.DT4 Linux implementation leverages a
> VRF device in order to force the routing lookup into the associated routing
> table.
> The SRv6 End.DT4 behavior is defined in the SRv6 Network Programming [1].
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/8] vrf: add mac header for tunneled packets when sniffer is attached
    https://git.kernel.org/netdev/net-next/c/048939088220
  - [net-next,v4,2/8] seg6: improve management of behavior attributes
    https://git.kernel.org/netdev/net-next/c/964adce526a4
  - [net-next,v4,3/8] seg6: add support for optional attributes in SRv6 behaviors
    https://git.kernel.org/netdev/net-next/c/0a3021f1d4e5
  - [net-next,v4,4/8] seg6: add callbacks for customizing the creation/destruction of a behavior
    https://git.kernel.org/netdev/net-next/c/cfdf64a03406
  - [net-next,v4,5/8] seg6: add support for the SRv6 End.DT4 behavior
    https://git.kernel.org/netdev/net-next/c/664d6f86868b
  - [net-next,v4,6/8] seg6: add VRF support for SRv6 End.DT6 behavior
    https://git.kernel.org/netdev/net-next/c/20a081b7984c
  - [net-next,v4,7/8] selftests: add selftest for the SRv6 End.DT4 behavior
    https://git.kernel.org/netdev/net-next/c/2195444e09b4
  - [net-next,v4,8/8] selftests: add selftest for the SRv6 End.DT6 (VRF) behavior
    https://git.kernel.org/netdev/net-next/c/2bc035538e16

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


