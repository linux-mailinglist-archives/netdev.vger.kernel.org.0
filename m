Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982B27266D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfGXE1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfGXE1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 00:27:05 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 083C920644;
        Wed, 24 Jul 2019 04:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563942424;
        bh=cx652LSvTliC/5t7gKp5hLCCQ8toJpWgNevgIKbWw6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YA4MAgRz4+lTtUcRp0h3rOJaR2hFephJVSoDDssaOTILoaBnPoQ9s2knYGP6HG1BO
         iFuwjK7V9t8x6CHSgauY5gSAd2IF6r9BSEGqTGWa3dxNtA/ffsThRWrygcxPEyZue5
         nSPn+7WR0j9CQMIVORaopPoYjWK72Yt55iX59Vb0=
Date:   Wed, 24 Jul 2019 07:26:46 +0300
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
Message-ID: <20190724042646.GV5125@mtr-leonro.mtl.com>
References: <20190723071255.6588-1-leon@kernel.org>
 <20190723.112850.610952032088764951.davem@davemloft.net>
 <20190723190414.GU5125@mtr-leonro.mtl.com>
 <20190723.130211.1967999203654051483.davem@davemloft.net>
 <702add119e2059101ce67b7e153b5ad0ef0df288.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <702add119e2059101ce67b7e153b5ad0ef0df288.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 08:34:07PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-07-23 at 13:02 -0700, David Miller wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Date: Tue, 23 Jul 2019 22:04:14 +0300
> >
> > > The intention was to have this patch in shared mlx5 branch, which
> > > is
> > > picked by RDMA too. This "Cc: stable@..." together with merge
> > > through
> > > RDMA will ensure that such patch will be part of stable
> > > automatically.
> >
> > Why wouldn't it come via Saeed's usual mlx5 bug fix pull requests to
> > me?
>
> That should have been the plan in first place, i will handle this,
> thanks Dave and sorry for any inconvenience.
>
> I will apply this patch to my (mlx5) net queue, will submit to net
> shortly.

OK, whatever works for you best.

Thanks
