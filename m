Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF305AF84
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 10:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfF3Ixj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 04:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfF3Ixj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 04:53:39 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF51C20449;
        Sun, 30 Jun 2019 08:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561884818;
        bh=yMg2MekXRUw/XD9/h6dc2/qckNEFchtjI/TJ9i3JMbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bTRSK+Yetsr5m5r8oFZYE7qrmx434T1p8jQE38LvJ4fr0tmI9M/PafoKutHOP510L
         P+S4c3AizQy/kE6e244+P5Ixv/FozuYOA3+1tYBVTVSwTez6jtikh9xtDKhc1aI35x
         NBNncYcJvanGWil7GyKdcfbB3DKxab4QA+CEZkOg=
Date:   Sun, 30 Jun 2019 11:53:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [PATCH rdma-next v1 00/12] DEVX asynchronous events
Message-ID: <20190630085335.GD4727@mtr-leonro.mtl.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <19107c92279cf4ad4d870fa54514423c5e46b748.camel@mellanox.com>
 <20190619044557.GA11611@mtr-leonro.mtl.com>
 <a8de53f1acb069057dedc94fb8bd29ea3e658716.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8de53f1acb069057dedc94fb8bd29ea3e658716.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 09:57:05PM +0000, Saeed Mahameed wrote:
> On Wed, 2019-06-19 at 07:45 +0300, Leon Romanovsky wrote:
> > On Tue, Jun 18, 2019 at 06:51:45PM +0000, Saeed Mahameed wrote:
> > > On Tue, 2019-06-18 at 20:15 +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > >
> > > > Changelog:
> > > >  v0 -> v1:
> > >
> > > Normally 1st submission is V1 and 2nd is V2.
> > > so this should have been v1->v2.
> >
> > "Normally" depends on the language you are using. In C, everything
> > starts from 0, including version of patches :).
> >
>
> You are wrong:
> quoting: https://kernelnewbies.org/PatchTipsAndTricks
>
> "For example, if you're sending the second revision of a patch, you
> should use [PATCH v2]."
>
> now don't tell me that second revision is actually 3rd revision or 1st
> is 2nd :)..

:)

If you don't mind, I will stick to common sense (v0, v1, v2 ...)
and official kernel documentation, which mentions existence of v1.

https://elixir.bootlin.com/linux/latest/source/Documentation/process/submitting-patches.rst#L682

>
> > > For mlx5-next patches:
> > >
> > > Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> >
> > Thanks
