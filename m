Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7890C0FE2
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 07:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfI1FzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 01:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfI1FzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Sep 2019 01:55:15 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC1392081B;
        Sat, 28 Sep 2019 05:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569650114;
        bh=zeKjhwCf7GhFCQgmig2FZlvYJ1HcAhDSb8kElWZk5Dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dcKEwv8PkXVI9zPT2rZUhxr6ReouabFfsAzpj3BmQM2sPMLDooIg7m4oTG9Tia4L8
         huM4AVHClVJK2wbD2uJXOnS5xlBL4oEypi6AB1nvOLshOJkSp5tkNK6bQuAtNAx1mL
         V8Kfc8cGv7g/B/r7/aVyE6e+/Q1+4gfNJp52LacA=
Date:   Sat, 28 Sep 2019 08:55:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
Message-ID: <20190928055511.GI14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
 <20190926174009.GD14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BDA@fmsmsx123.amr.corp.intel.com>
 <20190926195517.GA1743170@kroah.com>
 <bc18503dcace47150d5f45e8669d7978e18a38f9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc18503dcace47150d5f45e8669d7978e18a38f9.camel@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 04:17:15PM -0400, Doug Ledford wrote:
> On Thu, 2019-09-26 at 21:55 +0200, gregkh@linuxfoundation.org wrote:
> > On Thu, Sep 26, 2019 at 07:49:44PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
> > > >
> > > > On Thu, Sep 26, 2019 at 09:45:19AM -0700, Jeff Kirsher wrote:
> > > > > From: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > >
> > > > > Mark i40iw as deprecated/obsolete.
> > > > >
> > > > > irdma is the replacement driver that supports X722.
> > > >
> > > > Can you simply delete old one and add MODULE_ALIAS() in new
> > > > driver?
> > > >
> > >
> > > Yes, but we thought typically driver has to be deprecated for a few
> > > cycles before removing it.
> >
> > If you completely replace it with something that works the same, why
> > keep the old one around at all?
> >
> > Unless you don't trust your new code?  :)
>
> I have yet to see, in over 20 years of kernel experience, a new driver
> replace an old driver and not initially be more buggy and troublesome
> than the old driver.  It takes time and real world usage for the final
> issues to get sorted out.  During that time, the fallback is often
> necessary for those real world users.

How many real users exist in RDMA world who run pure upstream kernel?

Thanks

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD


