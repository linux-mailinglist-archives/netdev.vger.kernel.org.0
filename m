Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEABA338251
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhCLAab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:30:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231229AbhCLAaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 19:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 03B2E64F9E;
        Fri, 12 Mar 2021 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615509015;
        bh=fedZKBWgWYZ4OKzbgZ6Jc/BULfL1QDJDBsYffPMT3f8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k164T9gpadQ7nwgRvsLScF12pwsgWqxYOBb1kyTsjY4bgusATCOPGQmf1F6HE4aQk
         o4pmIa+loxsDXRtOWrEi+/AdHAHsWBLIaj061HNcu86X9yEkkl9Yh8JCuSCee9RS+d
         53uWUl48URVH4QEjaNx31s3mbOZSFrOLgyT+Li3ApKirzv1A30AzYAwbLylerDcuUV
         t+21pgdFPehlypL5F8sCF3wL4dReQMPCbzJ9/V3z8o9ImF6GHil/e6o48AFjXDRdzn
         QhoUg/gOS04JBH5THM4p72ppSHqkrKhmwSJrFbzTYIz4sEFV1yw0c9f6M2kRLoZpUg
         HWVZyaTRmbitQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E99B8609E7;
        Fri, 12 Mar 2021 00:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] SRv6: SRH processing improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161550901495.18262.17354824917685725766.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 00:30:14 +0000
References: <20210311155319.2280-1-julien.massonneau@6wind.com>
In-Reply-To: <20210311155319.2280-1-julien.massonneau@6wind.com>
To:     Julien Massonneau <julien.massonneau@6wind.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, dlebrun@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 16:53:17 +0100 you wrote:
> Add support for IPv4 decapsulation in ipv6_srh_rcv() and
> ignore routing header with segments left equal to 0 for
> seg6local actions that doesn't perfom decapsulation.
> 
> Julien Massonneau (2):
>   seg6: add support for IPv4 decapsulation in ipv6_srh_rcv()
>   seg6: ignore routing header with segments left equal to 0
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] seg6: add support for IPv4 decapsulation in ipv6_srh_rcv()
    https://git.kernel.org/netdev/net-next/c/ee90c6ba341f
  - [net-next,2/2] seg6: ignore routing header with segments left equal to 0
    https://git.kernel.org/netdev/net-next/c/fbbc5bc2ab8c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


