Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216A8270B2C
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 08:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgISGkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 02:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgISGkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 02:40:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4722100A;
        Sat, 19 Sep 2020 06:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600497624;
        bh=Rw1fKQZnuVnuseWjXKTsz/1trckMMO2cNujeP3URrLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VVVYL5XMH9mdHhzC6N+k3lubdk8Lr0JiELYE53i5NwwXJxm5dc85/YjiqcnK94ZvC
         HhssywKVeigYUCghDyS3aBmasn3SqClEldJAHtI4yj1KkxPTLG4eqV+v4j/SemQdQg
         2wtGAOVCWJ6r1FfM8pbYW2vonBkqZiozHU/TxlVw=
Date:   Sat, 19 Sep 2020 08:40:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200919064020.GC439518@kroah.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca>
 <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal>
 <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal>
 <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918121905.GU869610@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 03:19:05PM +0300, Leon Romanovsky wrote:
> > So we do have an open-source library called hl-thunk, which uses our
> > driver and indeed that was part of the requirement.
> > It is similar to libdrm.
> > Here is the link:
> > https://github.com/HabanaAI/hl-thunk
> 
> Are you kidding?
> 
> This is mirror of some internal repository that looks like dumpster
> with ChangeId, internal bug tracker numbers, not part of major OS
> distributions.
> 
> It is not open-source library and shows very clear why you chose
> to upstream your driver through driver/misc/ tree.

It is an open source library, as per the license and the code
availability.  What more is expected here?

No distro has to pick it up, that's not a requirement for kernel code,
we have many kernel helper programs that are not in distros.  Heck, udev
took a long time to get into distros, does that mean the kernel side of
that interface should never have been merged?

I don't understand your complaint here, it's not our place to judge the
code quality of userspace libraries, otherwise we would never get any
real-work done :)

thanks,

greg k-h
