Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A01379AC1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 01:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhEJXcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 19:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhEJXcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 19:32:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 860046147E;
        Mon, 10 May 2021 23:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620689508;
        bh=ga3dRvTM86gUohvIWp9wEqTR9W9e+526mCsSdUeb9mE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gdKwrIQiBpbqTECLL4aRuYwsXQpa/4h+iLf4ZzWQfE7iSYGAZlzgdK6qRpFAKMpJp
         lnEGjQdO2BPOvzAoHDtJbrV8o2/2TM5TLoGyrnjtO/btWlRScFrG6DC4NMjisG69j5
         mstKnGq0cvizQHUpsWaHx5ljAyCKWQ4rI/xV6BNHOTJ5KWrFHMSdQ0I0TdAV14uHdw
         KxhORuj+P52i/ZsE+TLS//QqLUGN9IiiEdJbyODXSNBF9S1BOIRk4GDTjApQkJS+cc
         QH08mJ1VduQHxMGlSiMtaVX5kFae3KCI3z8dUViqDgRz0PJEHi1y9cUhZzVITOq4RK
         VArr7uHg5eQng==
Date:   Mon, 10 May 2021 16:31:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Zhu Yanjun <zyjzyj2000@gmail.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] forcedeth: Delete a redundant condition branch
Message-ID: <20210510163147.7925d569@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YJmPBjsKK2MTxlyA@lunn.ch>
References: <20210510135656.3960-1-thunder.leizhen@huawei.com>
        <CAD=hENe9A-dbq8FGoCS=0_RV6qMmE8irb4crKjnLrSyc1orFCA@mail.gmail.com>
        <20210510113124.414f3924@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YJmPBjsKK2MTxlyA@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 May 2021 21:52:38 +0200 Andrew Lunn wrote:
> > This patch (and the stmmac one) removes a branch based on the fact that
> > it's the same as the default / catch all case. It's has a net negative
> > effect on the reability of the code since now not all cases are
> > explicitly enumerated. But it's at least the 3rd time we got that
> > stmmac patch so perhaps not worth fighting the bots...  
> 
> Hi Jakub
> 
> Is it the same bot every time? Or are the masters of the bots learning
> what good code actually looks like and fixing their bots? Unless we
> push back, the bot masters are not going to get any better at managing
> their bots.

I think 2 may have been the same bot (Hulk), I found 4 previous
attempts:

https://lore.kernel.org/netdev/1616039414-13288-1-git-send-email-f.fangjian@huawei.com/
https://lore.kernel.org/netdev/1603938832-53705-1-git-send-email-zou_wei@huawei.com/
https://lore.kernel.org/netdev/1576060284-12371-1-git-send-email-vulab@iscas.ac.cn/
https://lore.kernel.org/netdev/20200602104405.28851-1-aishwaryarj100@gmail.com/
