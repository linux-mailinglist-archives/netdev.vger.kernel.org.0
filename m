Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F35DC99BB
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 10:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfJCIXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 04:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfJCIXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 04:23:37 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25BD2070B;
        Thu,  3 Oct 2019 08:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570091016;
        bh=kMVLItmWOvHbHYHw3FLdwWFyBWipkFaY3U7hgdBVMcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KvKn/xFquMuOqyoKN59d0YD7/x9dYeLd+2q9Et965cYgH/p8V29tfYJA02mQZ03e/
         n7prZWHJayKdRN3LyvdNZp6zBe4AA34NyhLK1HiXme+hwZ6ICbzrXxDKcjH/PfKy8x
         WbH6YpDia5kymRRDFW+poUNYpdhCoE/8qXm/SYTU=
Date:   Thu, 3 Oct 2019 11:23:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
Message-ID: <20191003082333.GL5855@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
 <20190926174009.GD14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BDA@fmsmsx123.amr.corp.intel.com>
 <20190926195517.GA1743170@kroah.com>
 <bc18503dcace47150d5f45e8669d7978e18a38f9.camel@redhat.com>
 <20190928055511.GI14368@unreal>
 <64752160-e8cc-5dcd-d0f9-f26f81057324@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64752160-e8cc-5dcd-d0f9-f26f81057324@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 05:15:45PM -0400, Dennis Dalessandro wrote:
> On 9/28/2019 1:55 AM, Leon Romanovsky wrote:
> > On Fri, Sep 27, 2019 at 04:17:15PM -0400, Doug Ledford wrote:
> > > On Thu, 2019-09-26 at 21:55 +0200, gregkh@linuxfoundation.org wrote:
> > > > On Thu, Sep 26, 2019 at 07:49:44PM +0000, Saleem, Shiraz wrote:
> > > > > > Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
> > > > > >
> > > > > > On Thu, Sep 26, 2019 at 09:45:19AM -0700, Jeff Kirsher wrote:
> > > > > > > From: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > > >
> > > > > > > Mark i40iw as deprecated/obsolete.
> > > > > > >
> > > > > > > irdma is the replacement driver that supports X722.
> > > > > >
> > > > > > Can you simply delete old one and add MODULE_ALIAS() in new
> > > > > > driver?
> > > > > >
> > > > >
> > > > > Yes, but we thought typically driver has to be deprecated for a few
> > > > > cycles before removing it.
> > > >
> > > > If you completely replace it with something that works the same, why
> > > > keep the old one around at all?
> > > >
> > > > Unless you don't trust your new code?  :)
> > >
> > > I have yet to see, in over 20 years of kernel experience, a new driver
> > > replace an old driver and not initially be more buggy and troublesome
> > > than the old driver.  It takes time and real world usage for the final
> > > issues to get sorted out.  During that time, the fallback is often
> > > necessary for those real world users.
> >
> > How many real users exist in RDMA world who run pure upstream kernel?
>
> I doubt too many especially the latest bleeding edge upstream kernel. That
> could be interesting, but I don't think it's the reality.
>
> Distro kernels could certainly still keep the old driver, and that makes a
> lot of sense.

Also, they are invited to run their regression suite to verify
stability and report any arising problems to upstream/vendor.

Thanks

>
> -Denny
>
