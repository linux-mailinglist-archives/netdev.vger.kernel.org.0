Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909C811C8E8
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 10:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfLLJMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 04:12:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbfLLJMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 04:12:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53567214D8;
        Thu, 12 Dec 2019 09:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576141960;
        bh=650VajuygiE4/MpnVz9+nPFd2DW177e2B2RedNSMY/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tNJFc9zceE29r2/eostnzq6iUM1pIn8kZzobjTY0U/nGUH3ETpVwEfU3Iz3u7RGfr
         wDZUobF/sla9m9iHYO5SZdisGMtUQnoP2r3mcWSKcNy2Ls4A7RSA3J4fvfGM+UBA9D
         OLpQn62cNFE9hkEJkl0CfWtAXmZ5pgfkkhjH9C8Q=
Date:   Thu, 12 Dec 2019 10:12:38 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: Re: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
Message-ID: <20191212091238.GA1373130@kroah.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-6-jeffrey.t.kirsher@intel.com>
 <20191210190438.GF46@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7B6B8FBCA@fmsmsx124.amr.corp.intel.com>
 <20191212083904.GT67461@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212083904.GT67461@unreal>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 10:39:04AM +0200, Leon Romanovsky wrote:
> On Thu, Dec 12, 2019 at 01:40:27AM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
> 
> <...>
> 
> > >
> > > > +		ldev->ops->reg_for_notification(ldev, &events);
> > > > +	dev_info(rfdev_to_dev(dev), "IRDMA VSI Open Successful");
> > >
> > > Lets not do this kind of logging..
> > >
> >
> > There is some dev_info which should be cleaned up to dev_dbg.
> > But logging this info is useful to know that this functions VSI (and associated ibdev)
> > is up and reading for RDMA traffic.
> > Is info logging to be avoided altogether?
> 
> Will function tracer (ftrace) output be sufficient here?
> https://www.kernel.org/doc/html/latest/trace/ftrace.html

Yes it should.
