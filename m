Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D4E2DB5DB
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 22:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgLOV3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:29:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729933AbgLOV27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 16:28:59 -0500
Date:   Tue, 15 Dec 2020 13:28:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608067687;
        bh=fU7bWhe7CB3Ejuj1/qA6X+k8w8TbAvt70UEwgVPc0s0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=lqfaW/w9OMdKGAbbYfkNu7pZ1MzBjnXlMbcV7xIjxhfX5HFiM+Ogkfh8yNRAEmq7x
         HJeiu804npSL2gP+lIjXANU73fHbJ3yPdbq2kJRZ2wr2YKE/JJ6QeXGCgIyl1BMZRL
         yUCli/q8b8HdfnqYFkKUF/7hXZ3jfWQpQQotLq/szZce3MHsynIj39CIkBIm7BBFWz
         Ca9u4Euv3eSl9jaHH7B6UO6lIS1hE6Rpbk3AcAN0N832TsMVjcxJhaKHQ5ZgFx1MM9
         XUWyzHosIA3DySnpFIflfDe2p35fWSk2lL8Jh3RgmwXcjv4PlGZMHNbiBwyJknFaxv
         1CuKLDeG2KQZQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
Message-ID: <20201215132805.22ddcd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
References: <20201214214352.198172-1-saeed@kernel.org>
        <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
        <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
        <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
        <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 12:35:20 -0800 Saeed Mahameed wrote:
> > I think the big thing we really should do if we are going to go this
> > route is to look at standardizing what the flavours are that get
> > created by the parent netdevice. Otherwise we are just creating the
> > same mess we had with SRIOV all over again and muddying the waters of
> > mediated devices.
> 
> yes in the near future we will be working on auxbus interfaces for
> auto-probing and user flavor selection, this is a must have feature for
> us.

Can you elaborate? I thought config would be via devlink.
