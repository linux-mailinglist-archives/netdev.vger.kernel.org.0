Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5547DF20
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfHAPaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbfHAPaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 11:30:18 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307B120665;
        Thu,  1 Aug 2019 15:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564673418;
        bh=Ky3VGBDmQvh/Gq3M6ZMHmZjJL6JY47WEplSqNyX+qhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=scDPz7zngkwyOlZO5dPVfT7fVpyrFeFYFf8zwx6sh3afAmKgZwIyov1t/TwETd4Hm
         ERFnQTo9IuaG5MKN9zSdlsMzU50xag3NvvQYczR4+n9pSmfQUxe55UZRrx5VPBTcFe
         ogUvoRWExJEC4TSCiiHnvk11TRB9rzlDHxWa90Oo=
Date:   Thu, 1 Aug 2019 17:55:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/3] ODP support for mlx5 DC QPs
Message-ID: <20190801145512.GP4832@mtr-leonro.mtl.com>
References: <20190801122139.25224-1-leon@kernel.org>
 <20190801142432.GD23885@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801142432.GD23885@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 02:24:37PM +0000, Jason Gunthorpe wrote:
> On Thu, Aug 01, 2019 at 03:21:36PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > From Michael,
> >
> > The series adds support for on-demand paging for DC transport.
> > Adding handling of DC WQE parsing upon page faults and exposing
> > capabilities.
> >
> > As DC is mlx-only transport, the capabilities are exposed to the user
> > using the direct-verbs mechanism. Namely through the mlx5dv_query_device.
>
> The cover letter should like to the RDMA core PR that uses the new
> API...

PR will be send in near future by Yishai. I don't have PR links at the
submission stage yet.

Thanks

>
> Jason
