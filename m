Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F7E1DAE07
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgETIwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgETIwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:52:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B06C2075F;
        Wed, 20 May 2020 08:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589964750;
        bh=XLMVasPRMp/XY7j8mB0G8O5n6GWEn6WEmxfjRYS3eSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cg45fzsc9lb0qbz/IHTAlnYQJm5gzL/HTkOHYpAU9PRTzesGodrfzIdiedYBgHoDM
         5t4F4XED7m2pJ51kP+C4RkZYRvd1R1yqo6qDseLF0pEZNs9Z+ofvYX3AAQucByY7N7
         Z4sRcjnSU54bTQPtzTooa8AVtxfjP8EI1OyWUmVU=
Date:   Wed, 20 May 2020 10:52:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, dledford@redhat.com,
        jgg@mellanox.com, davem@davemloft.net,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, poswald@suse.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RDMA RFC v6 14/16] RDMA/irdma: Add ABI definitions
Message-ID: <20200520085228.GF2837844@kroah.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200520070415.3392210-15-jeffrey.t.kirsher@intel.com>
 <34ea2c1d-538c-bcb7-b312-62524f31a8dd@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34ea2c1d-538c-bcb7-b312-62524f31a8dd@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 10:54:25AM +0300, Gal Pressman wrote:
> On 20/05/2020 10:04, Jeff Kirsher wrote:
> > +struct i40iw_create_qp_resp {
> > +	__u32 qp_id;
> > +	__u32 actual_sq_size;
> > +	__u32 actual_rq_size;
> > +	__u32 i40iw_drv_opt;
> > +	__u16 push_idx;
> > +	__u8 lsmm;
> > +	__u8 rsvd;
> > +};
> 
> This struct size should be 8 bytes aligned.

Aligned in what way?  Seems sane to me, what would you want it to look
like instead?

thanks,

greg k-h
