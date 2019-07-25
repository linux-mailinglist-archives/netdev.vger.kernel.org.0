Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19E874393
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 05:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389550AbfGYDDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 23:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388759AbfGYDDA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 23:03:00 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5FF0229F4;
        Thu, 25 Jul 2019 03:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564023779;
        bh=1I5HVAZ8LrjB3eONoPwZXmFtQ2dW/++0B32YjLyLcmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AO6/vJ7TAigTHx6Ix6BjNmTXxqZBXwzlHDn7MlYPHIBZMf9NJBkiX8RckNSlzv0K1
         1aspZo0FjhBCAZSVM3v4xubru7ujQ+mfigJV+DG9XV1tM15bqip+wdYMXpTfqago47
         MrWzsjI1lQ4+b/fCSJ0Bao0VACHz2z1xoBxms3MM=
Date:   Thu, 25 Jul 2019 06:02:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Edward Srouji <edwards@mellanox.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix modify_cq_in alignment
Message-ID: <20190725030246.GE4674@mtr-leonro.mtl.com>
References: <20190723071255.6588-1-leon@kernel.org>
 <20190723.112850.610952032088764951.davem@davemloft.net>
 <20190723190414.GU5125@mtr-leonro.mtl.com>
 <5447fded90dfd133ef002177b77bfd3685bf8b42.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5447fded90dfd133ef002177b77bfd3685bf8b42.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 08:56:08PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-07-23 at 22:04 +0300, Leon Romanovsky wrote:
> > On Tue, Jul 23, 2019 at 11:28:50AM -0700, David Miller wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Date: Tue, 23 Jul 2019 10:12:55 +0300
> > >
> > > > From: Edward Srouji <edwards@mellanox.com>
> > > >
> > > > Fix modify_cq_in alignment to match the device specification.
> > > > After this fix the 'cq_umem_valid' field will be in the right
> > > > offset.
> > > >
> > > > Cc: <stable@vger.kernel.org> # 4.19
> > > > Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID
> > > > bits")
>
> Leon, I applied this patch to my tree, it got marked for -stable 4.20
> and not 4.19, i checked manually and indeed the offending patch came to
> light only on 4.20

Thanks

>
