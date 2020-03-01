Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489CD174D8C
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 14:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCANuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 08:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgCANuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 08:50:11 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3601F214DB;
        Sun,  1 Mar 2020 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583070610;
        bh=A317jEfQ1Poqsq6S20l+J3zea46T9KCGh/Tsx/hXmn4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mTNwvociFMx0PIhwXEz35NGE7J/SLtx9nzG7D3UecOHhvHuBuQBTc1fQ6sscNmXaJ
         pgcElSBpn4y4RDopmdHZTi7xdm8DkS7RINgAFruqTw3BIo4vDesr5tPqvOyP8cz3lD
         SHaoPXdEmXX0cQlGZNCQK7ldqUSaDTyZ9zqTSdt4=
Date:   Sun, 1 Mar 2020 15:50:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     akiyano@amazon.com, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, ndagan@amazon.com, shayagr@amazon.com,
        sameehj@amazon.com
Subject: Re: [RESEND PATCH V1 net-next] net: ena: fix broken interface
 between ENA driver and FW
Message-ID: <20200301135007.GS12414@unreal>
References: <1582711415-4442-1-git-send-email-akiyano@amazon.com>
 <20200226.204809.102099518712120120.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226.204809.102099518712120120.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 08:48:09PM -0800, David Miller wrote:
> From: <akiyano@amazon.com>
> Date: Wed, 26 Feb 2020 12:03:35 +0200
>
> > From: Arthur Kiyanovski <akiyano@amazon.com>
> >
> > In this commit we revert the part of
> > commit 1a63443afd70 ("net/amazon: Ensure that driver version is aligned to the linux kernel"),
> > which breaks the interface between the ENA driver and FW.
> >
> > We also replace the use of DRIVER_VERSION with DRIVER_GENERATION
> > when we bring back the deleted constants that are used in interface with
> > ENA device FW.
> >
> > This commit does not change the driver version reported to the user via
> > ethtool, which remains the kernel version.
> >
> > Fixes: 1a63443afd70 ("net/amazon: Ensure that driver version is aligned to the linux kernel")
> > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>
> Applied.

Dave,

I see that I'm late here and my email sounds like old man grumbling,
but I asked from those guys to update their commit with request
to put the following line:
"/* DO NOT CHANGE DRV_MODULE_GEN_* values in in-tree code */"
https://lore.kernel.org/netdev/20200224162649.GA4526@unreal/

I also asked how those versions are transferred to FW and used there,
but was ignored.
https://lore.kernel.org/netdev/20200224094116.GD422704@unreal/

BTW, It is also unclear why I wasn't CCed in this patch.

Thanks
