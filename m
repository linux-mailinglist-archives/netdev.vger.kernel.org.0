Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97590394784
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 21:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhE1TbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 15:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhE1TbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 15:31:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D58896128B;
        Fri, 28 May 2021 19:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622230180;
        bh=10u9nzWanGyRLEwuw7BKiOltYPxvIjrFa73KcH8u8d8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AqwvJ799zWCtmATKDgaod+LJAKAEp1RBrDElyoRGSYoWIDQrsiQ7ytZZRRl4CrqAD
         7PsgCQKf5EQse6Y08dlI+MUTdgO7odMk7Gejnext85/l71yTABWbCPItbZaCmpxggY
         92yoRxjwq1IoFILqaTUWiVtOvbPfJ882Fw7V7V+mie7ySMS1o4UwWps0NmNX9T1UBI
         8QYMlNw8oL2oEQxTO4BA/qt7m52/4xEa3OzbJOkoY4y0zcIBSVLG6SnAdkJsuNFcdA
         VZ2065GiEtE7NSYt8YNwTVkvjPqkVd49jj9fADf0h6Z6mdSOEmWoyeLkkIQGbkMHWQ
         7disToui3RQgw==
Date:   Fri, 28 May 2021 12:29:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/7] ice: Implement iidc operations
Message-ID: <20210528122939.3598f809@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <3cc44e5cde9894f0b4d1c6351d40f289d5938005.camel@intel.com>
References: <20210527173014.362216-1-anthony.l.nguyen@intel.com>
        <20210527173014.362216-5-anthony.l.nguyen@intel.com>
        <20210527171241.3b886692@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20210528130212.GL1002214@nvidia.com>
        <3cc44e5cde9894f0b4d1c6351d40f289d5938005.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 16:48:17 +0000 Nguyen, Anthony L wrote:
> On Fri, 2021-05-28 at 10:02 -0300, Jason Gunthorpe wrote:
> > > 
> > > defensive programming  
> 
> Will remove this.
>
> > > RDMA folks, are you okay with drivers inventing their own error
> > > codes?  
> > 
> > Not really, I was ignoring it because it looks like big part of their
> > netdev driver layer.  
> 
> We have looked into how we can eliminate/minimize the use of ice_status
> and our assessment is that this will take a decent amount of work. We
> are trying to get this done.

Sorry I don't speak managerese.

I asked you to stop using your own error codes multiple times, and 
now you're about to pollute another subsystem with the same problem.

Please fix.
