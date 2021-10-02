Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D65F41F994
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 06:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhJBEKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 00:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229560AbhJBEKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 00:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A82A61262;
        Sat,  2 Oct 2021 04:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633147713;
        bh=B2+VAr2tvRTd14eBrSAL0dHTayhHy8nTlD595mDOWCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SMuZusYFm2Y9Lnza3YJE78P1tYKoQ7irZfQQGBWKm6dSdduqaHcqU927DyRUF8T7V
         HOCs9d+OfNtgKJ/xOyAwhWYndl6BmiGM74SD3+uIdsd0U470dq43DBbExKZLs/3ZKy
         OZr0AoStfdwRJenkZhHcPTVW26sKLQTm8rj3JdwTTminCKHCmXY3KrT4a6kyOPtwc1
         LJKOxbu8getHHxbbfX7GXN+85GfFv9zUJr2YPvV1CxJ5Oyz893algEu6kgzfbGUtBA
         Zw6iQD8t/6o3dK48tN0vVJm/8CoE28DNwRnT0FRzTOfJUyRCyQbGXWcSkKKJhSBdPF
         a8dlXquN4bYoA==
Date:   Fri, 1 Oct 2021 21:08:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth 2021-10-01
Message-ID: <20211001210832.5902ea53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CABBYNZLE-iVAT0Tt1aJK9VqYhWPYJeSTiWh6s2HTeqyQczMbVQ@mail.gmail.com>
References: <20211001230850.3635543-1-luiz.dentz@gmail.com>
        <20211001201128.7737a4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CABBYNZLE-iVAT0Tt1aJK9VqYhWPYJeSTiWh6s2HTeqyQczMbVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Oct 2021 20:29:54 -0700 Luiz Augusto von Dentz wrote:
> On Fri, Oct 1, 2021 at 8:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri,  1 Oct 2021 16:08:50 -0700 Luiz Augusto von Dentz wrote:  
> > > bluetooth-next pull request for net-next:
> > >
> > >  - Add support for MediaTek MT7922 and MT7921
> > >  - Enable support for AOSP extention in Qualcomm WCN399x and Realtek
> > >    8822C/8852A.
> > >  - Add initial support for link quality and audio/codec offload.
> > >  - Rework of sockets sendmsg to avoid locking issues.
> > >  - Add vhci suspend/resume emulation.  

> > Commit 0b59e272f932 ("Bluetooth: reorganize functions from hci_sock_sendmsg()")
> >         committer Signed-off-by missing
> >         author email:    penguin-kernel@I-love.SAKURA.ne.jp
> >         committer email: marcel@holtmann.org
> >         Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> >         Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>  
> 
> I suspect those fixed and force pushed since I originally applied them
> given them all have my sign-offs, is this a blocker though?

I'm not an expert on SoB semantics so not sure if it's a deal breaker.
Stephen's checker will definitely notice and send us warnings.
I think it's worth the hassle to rebase and resubmit for 7 bad commits.
