Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B6517A523
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgCEMVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgCEMVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 07:21:11 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF3C208CD;
        Thu,  5 Mar 2020 12:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583410870;
        bh=bVD4g11Lxcku3ujT07RaRaqAWjWvVYJ87eNVktaYvn4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R7NcS6QSxx9wrl/bAbqs7wztGNcturzS81BHL6o6uUEQM/7NEeZoGfK5dgjjDVo7d
         jAaFd5DOYV5qUEs3ExBcmWr41bWi5s3RwQXlNLV32Xj+zYMwWPb8eDXjGJsYtc4q7N
         ZzIwcBOTFQk6RNUKg+4C6t039iXjk9RivbWCYttI=
Date:   Thu, 5 Mar 2020 14:21:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] Packet pacing DEVX API
Message-ID: <20200305122107.GE184088@unreal>
References: <20200219190518.200912-1-leon@kernel.org>
 <20200304003303.GA16047@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304003303.GA16047@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 08:33:03PM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 19, 2020 at 09:05:16PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > This series from Yishai extends packet pacing to work over DEVX
> > interface. In first patch, he refactors the mlx5_core internal
> > logic. In second patch, the RDMA APIs are added.
> >
> > Thanks
> >
> > Yishai Hadas (2):
> >   net/mlx5: Expose raw packet pacing APIs
> >   IB/mlx5: Introduce UAPIs to manage packet pacing
>
> It looks Ok, can you apply this to the shared branch?

Applied to mlx5-next
1326034b3ce7 net/mlx5: Expose raw packet pacing APIs

>
> Thanks,
> Jason
