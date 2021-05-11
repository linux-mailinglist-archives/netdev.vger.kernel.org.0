Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F5D379F1E
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 07:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhEKF0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 01:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229885AbhEKF0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 01:26:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E55361430;
        Tue, 11 May 2021 05:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620710696;
        bh=tedzO4j79RgpF1qfY72+/eO1XDi74WvdZPvTm4kNDQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDrmsS5/rmR5vCk/Qjzgg3k9U+YCcpOBVpqIvNQGXbQt1VWH1oJKE3vVBc3kQtI5l
         aZHoC5kQ3+5XagAzDXCWfq6XxCWjeYxi1sBJYCmgnD4U9oNkHnkd7awlrlgFZ5jWbE
         ARsWnkLnuplPfb/el9RZ8iQTH6athgg36H28ohn/Fhj1R6UQPuLXzpuoKYAo8tAIMn
         CGzu2rpkyq5pl5MB13p/TMox/eSBPkofxurtNElbGSghQkXva8gUmmuXcX4FXl/Tf0
         wMAVnqcwTL714YBLrxhFXkBkwFM978DSjdM2ODpxoo+5wXnH6XgOYvJKOGGDeoxVOm
         P/PgelLHx9Uuw==
Date:   Tue, 11 May 2021 08:24:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Zhu Yanjun <zyjzyj2000@gmail.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] forcedeth: Delete a redundant condition branch
Message-ID: <YJoVJFPVrTlvyPAF@unreal>
References: <20210510135656.3960-1-thunder.leizhen@huawei.com>
 <CAD=hENe9A-dbq8FGoCS=0_RV6qMmE8irb4crKjnLrSyc1orFCA@mail.gmail.com>
 <20210510113124.414f3924@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YJmPBjsKK2MTxlyA@lunn.ch>
 <20210510163147.7925d569@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510163147.7925d569@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 04:31:47PM -0700, Jakub Kicinski wrote:
> On Mon, 10 May 2021 21:52:38 +0200 Andrew Lunn wrote:
> > > This patch (and the stmmac one) removes a branch based on the fact that
> > > it's the same as the default / catch all case. It's has a net negative
> > > effect on the reability of the code since now not all cases are
> > > explicitly enumerated. But it's at least the 3rd time we got that
> > > stmmac patch so perhaps not worth fighting the bots...  
> > 
> > Hi Jakub
> > 
> > Is it the same bot every time? Or are the masters of the bots learning
> > what good code actually looks like and fixing their bots? Unless we
> > push back, the bot masters are not going to get any better at managing
> > their bots.
> 
> I think 2 may have been the same bot (Hulk), I found 4 previous
> attempts:
> 
> https://lore.kernel.org/netdev/1616039414-13288-1-git-send-email-f.fangjian@huawei.com/
> https://lore.kernel.org/netdev/1603938832-53705-1-git-send-email-zou_wei@huawei.com/
> https://lore.kernel.org/netdev/1576060284-12371-1-git-send-email-vulab@iscas.ac.cn/
> https://lore.kernel.org/netdev/20200602104405.28851-1-aishwaryarj100@gmail.com/

We (RDMA) got them too and decided that it is not worth to fight against them.
https://lore.kernel.org/linux-rdma/YJkByCnQGcLOIlCz@unreal/T/#m66ec31acf5e0fea5233a4b7265a3a49232492a4a

Thanks
