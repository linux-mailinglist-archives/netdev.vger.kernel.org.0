Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3824349E1E
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCZAkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229761AbhCZAkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C89F61A14;
        Fri, 26 Mar 2021 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616719208;
        bh=mjtT4N2sFHKpG7j+Wq6ho1U6yp6pijrAOTZ33HCYo6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qeq9k3YU76iSz9fRMvHJhnsX8O3HV02wOfJN3nS2Pm3FJ7FnzStIz5tG3dA0ztew9
         BbB4C3pwxYW//cyt08srO/8SSCg4jct4wkWEnO4OIWfLIax55Sud3khYSJ+efyDLTO
         YQWo0qoAyqnrdong4otPDkI+p7FY60tsPBkAN9pP+qq5jZvY7artGBLF5X02uGuQ1s
         e9SA6098eSNno9X5vxSr00ucqYfhq5TmPy1mTkVeMsmeDKL6/RwlguZoPwRN22YvGB
         b2gxoU/a3qBiS7rl9dVvFuBnNEq1drRxRGvSiYjv0ioo4mY+OQECyMCLEJvIi/0ayY
         VydmyZ4ElzezA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 76D346096E;
        Fri, 26 Mar 2021 00:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: do not modify the shared tunnel info when PMTU
 triggers an ICMP reply
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671920848.5630.16086417270160819787.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:40:08 +0000
References: <20210325153533.770125-1-atenart@kernel.org>
In-Reply-To: <20210325153533.770125-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, echaudro@redhat.com,
        sbrivio@redhat.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Mar 2021 16:35:31 +0100 you wrote:
> Hi,
> 
> The series fixes an issue were a shared ip_tunnel_info is modified when
> PMTU triggers an ICMP reply in vxlan and geneve, making following
> packets in that flow to have a wrong destination address if the flow
> isn't updated. A detailled information is given in each of the two
> commits.
> 
> [...]

Here is the summary with links:
  - [net,1/2] vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
    https://git.kernel.org/netdev/net/c/30a93d2b7d5a
  - [net,2/2] geneve: do not modify the shared tunnel info when PMTU triggers an ICMP reply
    https://git.kernel.org/netdev/net/c/68c1a943ef37

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


