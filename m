Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD9734B498
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 07:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhC0GAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 02:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhC0GAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 02:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961666199F;
        Sat, 27 Mar 2021 06:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616824810;
        bh=ueAuv9utEoHBZmfdpiI4l2xOZCBEIMmjKCHXXCSu0gU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m4j62uGxZ1Wh5hN5Nk4oKhc4HnYyjlbPevowb2LqlNCZRLFFMNNVVo3QSrjE2wD/d
         2oekHNwt5JFzbYecZc/BT+I+Uq5WMyzWKZE1iT6F1VivmZuxOcaFUiSFbonGtsxIux
         RWGzJv2gZqQfmd2Hbp19QbmdhriHisQbFaHFRbVNjiteJWiLhEeRZ4U+YBQwbpGkNV
         2DmXWOiW/syLCSo8YRq0GcWuwr3stLG0rlYVnyKZqRCDCFnrQfTtuQDn9ZkopYdbXd
         K3hSEnO1roUCPxezZN/FaMnUj9MvenHVtMAy2iWKzsLDcxLAiSY43CuFbHYs5XW4pg
         WnXeRH2zWq7Hw==
Date:   Sat, 27 Mar 2021 09:00:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
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
Message-ID: <YF7J5spvQuW/GdIs@unreal>
References: <CAKgT0UfK3eTYH+hRRC0FcL0rdncKJi=6h5j6MN0uDA98cHCb9A@mail.gmail.com>
 <20210326170831.GA890834@bjorn-Precision-5520>
 <20210326171209.GP2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326171209.GP2356281@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 02:12:09PM -0300, Jason Gunthorpe wrote:
> On Fri, Mar 26, 2021 at 12:08:31PM -0500, Bjorn Helgaas wrote:
> 
> > Leon has implemented a ton of variations, but I don't think having all
> > the files in the PF directory was one of them.
> 
> If you promise this is the last of this bike painting adventure then
> let's do it.

So Bjorn, can you promise?

Thanks

> 
> Jason
