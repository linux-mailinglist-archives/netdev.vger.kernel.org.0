Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07243BDC11
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 19:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhGFRUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 13:20:39 -0400
Received: from relay.sw.ru ([185.231.240.75]:60982 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhGFRUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 13:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=MCHOi6ZEh59hnCa9zu4iiaV7gFv1WZns08qoIFW3r0o=; b=dXoV4CNfBGHNNNIoX8x
        yxPqT/PFSg5kjkdOspHIkBvebXBQW1ENcRjD6TXOQfVHiozOxX3I2wfWJ3iTkkX4ZrCAPqMzUEo2N
        5+129pcqzWy0kPDJOT9tfd+nmrMDSWuHyJZVCYxbRZ7zmq4azwbPoafDWfilC3RzJbGe7PEXfhY=;
Received: from [192.168.15.199] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1m0ohp-0036Rj-Kw; Tue, 06 Jul 2021 20:17:57 +0300
Date:   Tue, 6 Jul 2021 20:17:57 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv4 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-Id: <20210706201757.46678b763f35ae41a12f48c1@virtuozzo.com>
In-Reply-To: <20210706091821.7a5c2ce8@hermes.local>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210629155116.23464-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210706083407.76deb4c0@hermes.local>
        <20210706184415.baf59983a9cb5de56050389c@virtuozzo.com>
        <20210706091821.7a5c2ce8@hermes.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Jul 2021 09:18:21 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Tue, 6 Jul 2021 18:44:15 +0300
> Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> 
> > On Tue, 6 Jul 2021 08:34:07 -0700
> > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > 
> > > On Tue, 29 Jun 2021 18:51:15 +0300
> > > Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> > >   
> > > > +	const struct rtnl_dump_filter_arg a[2] = {
> > > > +		{ .filter = filter, .arg1 = arg1,
> > > > +		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
> > > > +		{ .filter = NULL,   .arg1 = NULL,
> > > > +		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = 0, },
> > > >  	};  
> > > 
> > > I am OK with this as is. But you don't need to add initializers for fields
> > > that are 0/NULL (at least in C).  
> > 
> > Sure, I've made such explicit initializations just because in original
> > rtnl_dump_filter_nc() we already have them.
> > 
> > Do I need to resend with fixed initializations? ;)
> 
> Not worth it

Ok, thanks!

