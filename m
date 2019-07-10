Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2166C64086
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfGJFUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfGJFUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 01:20:19 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80CAE20838;
        Wed, 10 Jul 2019 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562736018;
        bh=4yM1npzftBpxuVgRC3mLUgT1oBnr8PRgpCmOAd29ZGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AyfxZBd3hPL236CCsdQX4V3ldQ43ZRvUj3Mbu4KFGsJPrbpYfzPIAkpYG5VtQQU0y
         9Y8wGhJAvHxDpquoLDYwzFaF6vtJateswyLzvp8yoWIZKgTjFNeEBixcuQeAzacD/K
         qcGhvjyQoDSOswK8uGJqtK/VCdTCUydCnqA3A5A8=
Date:   Wed, 10 Jul 2019 08:20:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190710052005.GB7034@mtr-leonro.mtl.com>
References: <20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
 <20190710143158.6e4bf706@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710143158.6e4bf706@canb.auug.org.au>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 02:31:58PM +1000, Stephen Rothwell wrote:
> Hi Leon,
>
> On Tue, 9 Jul 2019 09:43:46 +0300 Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From 56c9e15ec670af580daa8c3ffde9503af3042d67 Mon Sep 17 00:00:00 2001
> > From: Leon Romanovsky <leonro@mellanox.com>
> > Date: Sun, 7 Jul 2019 10:43:42 +0300
> > Subject: [PATCH] Fixup to build SIW issue
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>
> I applied this to linux-next today and it fixes my build problems.

Thanks

>
> --
> Cheers,
> Stephen Rothwell


