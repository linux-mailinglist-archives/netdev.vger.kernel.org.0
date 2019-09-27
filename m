Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F272EBFE78
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 07:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfI0FNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 01:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbfI0FNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 01:13:31 -0400
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1524621783;
        Fri, 27 Sep 2019 05:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569561209;
        bh=AftiEiLWyKEj9+4fCQzCQskHt9HJiWKV//AZDTI6ZHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bj38Ej61OzeAqlcz7xjR0Bet3kaASNF4zHAMMsax8CiLBTTPGmSHR85idFgMOyztn
         qdFWAbRRAUm3+mqK78d7AD/ZPbbc/MBcNlngvz6PeyNgSJCkH4VsDNqxQj9G9MRcZk
         F4vRnA0d6eaic/8IOHQ2Wdo+IV6gM0IBUjyYcspk=
Date:   Fri, 27 Sep 2019 07:13:20 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ertman, David M" <david.m.ertman@intel.com>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Message-ID: <20190927051320.GA1767635@kroah.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
 <20190926180556.GB1733924@kroah.com>
 <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 11:39:22PM +0000, Nguyen, Anthony L wrote:
> On Thu, 2019-09-26 at 20:05 +0200, Greg KH wrote:
> > On Thu, Sep 26, 2019 at 09:45:00AM -0700, Jeff Kirsher wrote:
> > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > 
> > > The RDMA block does not advertise on the PCI bus or any other bus.
> > 
> > Huh?  How do you "know" where it is then?  Isn't is usually assigned
> > to
> > a PCI device?
> 
> The RDMA block does not have its own PCI function so it must register
> and interact with the ice driver.  

So the "ice driver" is the real thing controlling the pci device?  How
does it "know" about the RDMA block?

thanks,

greg k-h
