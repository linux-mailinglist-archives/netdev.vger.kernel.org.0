Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2253396B3
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 19:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhCLSfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 13:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233756AbhCLSei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 13:34:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76CF364F5B;
        Fri, 12 Mar 2021 18:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615574078;
        bh=eBRGUpzOaiG5s/KUQiDidE3SFCB985o0uUgGmkVc+7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jUXTQMMT4xJUisClB8arBD8gM7tXact5Bf9ae/m0vxPmf25EdtjZc/lchUomrMr4L
         /48tlBwvJ76SwgO5bNIWJxvvTrcoCjBVwWnPqIU0xMmvPuixxy6oDWVKY69c6fzeyW
         8sYRPwS1GxbSJH6A+huhqLafajZtRNA4QcGjtsJHeSIcOGmMW8ozZRx4u2Ecxr0AYj
         Y8hLJmGUYwXz4NI1aKezPsd+rvIQ4XAr5NhaBooytorb/exulIyrlQYwgEA6RpawNj
         SF90jzZhNBz8183tpzY905dSdLOkNxL/r42lYlCTNLazc2fkBIMmEn4bktu/+AQJvC
         11sHQomgrHM0A==
Date:   Fri, 12 Mar 2021 20:34:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YEu0OZTjizqooG89@unreal>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <20210311201929.GN2356281@nvidia.com>
 <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
 <20210311232059.GR2356281@nvidia.com>
 <CAKgT0Ud+gnw=W-2U22_iQ671himz8uWkr-DaBnVT9xfAsx6pUg@mail.gmail.com>
 <YEsK6zoNY+BXfbQ7@unreal>
 <CAKgT0UfsoXayB72KD+H_h14eN7wiYtWCUjxKJxwiNKr44XUPfA@mail.gmail.com>
 <20210312170319.GG2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312170319.GG2356281@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 01:03:19PM -0400, Jason Gunthorpe wrote:
> On Fri, Mar 12, 2021 at 08:59:38AM -0800, Alexander Duyck wrote:
>
> > Lastly by splitting out the onlining step you can avoid potentially
> > releasing a broken VF to be reserved if there is some sort of
> > unrecoverable error between steps 2 and 3.
>
> If the PF FW gets in a state that it can't respond to a trivial
> command like this then *every* VF is broken. It not a useful scenario
> to focus on.

Right, many VF initial configurations are done through PF. It MUST work.

Thanks

>
> Jason
