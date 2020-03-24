Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577D4191635
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgCXQYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbgCXQYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 12:24:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E8BC20774;
        Tue, 24 Mar 2020 16:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585067092;
        bh=CyeZI5q6pGu5wzW1/2PIpZcFnB5xOU9rhWTk0PMxim4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MwVZUl+R0IJDpX+M0chGF/CwJ5HBBSK8ZaUTiD3HiPbJiVh+sekft5+IYmZNq7NXu
         0+S9LfIaw4l4PLQAvegHFK8DklyBMB3+Gx6etfsGYp5PCL0YrWIJOkGzRiVMzf4AJb
         uvhlk+yADie0UKFMc1mf68tbs1BCnMZyQ1KBZw18=
Date:   Tue, 24 Mar 2020 09:24:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        eugenem@fb.com, jacob.e.keller@intel.com, jiri@resnulli.us,
        michael.chan@broadcom.com, snelson@pensando.io,
        jesse.brandeburg@intel.com, vasundhara-v.volam@broadcom.com
Subject: Re: [PATCH net-next v2] devlink: expand the devlink-info
 documentation
Message-ID: <20200324092450.33ec1d3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fa91cf18-8d2c-bc11-b3d3-bd8671318e7f@infradead.org>
References: <20200324041548.87488-1-kuba@kernel.org>
        <fa91cf18-8d2c-bc11-b3d3-bd8671318e7f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Mar 2020 22:33:26 -0700 Randy Dunlap wrote:
> On 3/23/20 9:15 PM, Jakub Kicinski wrote:
> > We are having multiple review cycles with all vendors trying
> > to implement devlink-info. Let's expand the documentation with
> > more information about what's implemented and motivation behind
> > this interface in an attempt to make the implementations easier.
> > 
> > Describe what each info section is supposed to contain, and make
> > some references to other HW interfaces (PCI caps).
> > 
> > Document how firmware management is expected to look, to make
> > it clear how devlink-info and devlink-flash work in concert.
> > 
> > Name some future work.
> > 
> > v2: - improve wording
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Hi Jakub,
> 
> One minor edit below, and
> 
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Will fix, thanks!

> >  Generic Versions
> >  ================
> >  
> >  It is expected that drivers use the following generic names for exporting
> > -version information. Other information may be exposed using driver-specific
> > -names, but these should be documented in the driver-specific file.
> > +version information. If a generic name for a given component doesn't exist, yet,  
> 
>                                                                         exist yet,
> 
> > +driver authors should consult existing driver-specific versions and attempt
> > +reuse. As last resort, if a component is truly unique, using driver-specific
> > +names is allowed, but these should be documented in the driver-specific file.
> > +
> > +All versions should try to use the following terminology:  


