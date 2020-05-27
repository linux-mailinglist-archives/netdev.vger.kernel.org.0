Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9086A1E3600
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 04:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgE0C7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 22:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgE0C7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 22:59:24 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 732482075F;
        Wed, 27 May 2020 02:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590548364;
        bh=rMWn6rFED+GvNFSmCgXYT9PgKv+jdKNEWyDrFTEFKNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kViElYTKepjN30GgkUJ8tLTsCb4OVC5wzZ/0jXBeu5NtgKBcInzoEG47K6fta+YP0
         TyuQHdjwKpvBILPSRWmyIBg38O1Oq4i4EmO4zGiw+VE+KvaSFIvLSO9/kfHV/1k57s
         JpU9QtjEkGqckR9kKDbJg7eTFo0nqE83R0uRI5Sc=
Date:   Wed, 27 May 2020 05:59:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next 0/4] RAW format dumps through RDMAtool
Message-ID: <20200527025921.GH100179@unreal>
References: <20200520102539.458983-1-leon@kernel.org>
 <acfe3236-0ab9-53ae-eb3b-7ff8a510e599@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acfe3236-0ab9-53ae-eb3b-7ff8a510e599@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 06:00:17PM -0600, David Ahern wrote:
> On 5/20/20 4:25 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > The following series adds support to get the RDMA resource data in RAW
> > format. The main motivation for doing this is to enable vendors to
> > return the entire QP/CQ/MR data without a need from the vendor to set
> > each field separately.
> >
> > User-space part of the kernel series [1].
> >
> > Thanks
> >
> > [1] https://lore.kernel.org/linux-rdma/20200513095034.208385-1-leon@kernel.org
> >
> > Maor Gottlieb (4):
> >   rdma: Refactor res_qp_line
> >   rdma: Add support to get QP in raw format
> >   rdma: Add support to get CQ in raw format
> >   rdma: Add support to get MR in raw format
> >
>
> The set depends on UAPI files not visible in either Dave or Linus' tree
> yet. We moved rdma uapi files under rdma/include/uapi/ and as I recall
> the expectation is that you submit updates with your patches once they
> are accepted and that the headers are in sync with Linus' tree once the
> code arrives there.

Yes, you remember correctly.

What should I write in the series to make it clear that the patches
need to be reviewed but not merged yet due to on-going kernel
submission?

We are not merging any code in RDMA that doesn't have corresponding
parts in iproute2 or rdma-core.

Thanks
