Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AD3302D05
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732447AbhAYUxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732427AbhAYUxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 15:53:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BCB52251D;
        Mon, 25 Jan 2021 20:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611607963;
        bh=jKa1NaFdRA7s2N74JjyXd7xJi2aGjpOTnv1ljZflI1g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pja8o96UTo95+PIxYC7eUqyEYKzkD0G8H/Yc2OpXQkoSdMBWAWDzpQIFZzGYx7Gq6
         JKrqVtOvCXtoIwxXVdOFIGsTuLozSn7fk+F/G3yJ9SGStXWSDTc/r9FjOdbxH34jfb
         agV/cFKqcp4Y4eWRiSNni6hwP0VJ8t33/SBV2X8dav/3Q+IHc2K2JxhHjlek2y9jQy
         GXu2EaYL7hQ59NbfrAzVXgfPPxQDLdDQI+6hvofu02aBA2k7iX7Mfxw616ZoIrD/9n
         y9R0iwooH1h1PMI+pWdPEJ9Lm6CSR94h9lJqYz4BSvIy38OnrAHw1t9ptoFf5CGKzS
         TQR4C8vBSS26g==
Date:   Mon, 25 Jan 2021 12:52:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>, <dledford@redhat.com>,
        <davem@davemloft.net>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        <david.m.ertman@intel.com>, <anthony.l.nguyen@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210125125241.495d8d82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125132834.GK4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
        <20210122234827.1353-8-shiraz.saleem@intel.com>
        <20210124134551.GB5038@unreal>
        <20210125132834.GK4147@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 09:28:34 -0400 Jason Gunthorpe wrote:
> On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
> > On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:  
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Register irdma as an auxiliary driver which can attach to auxiliary RDMA
> > > devices from Intel PCI netdev drivers i40e and ice. Implement the private
> > > channel ops, add basic devlink support in the driver and register net
> > > notifiers.  
> > 
> > Devlink part in "the RDMA client" is interesting thing.
> > 
> > The idea behind auxiliary bus was that PCI logic will stay at one place
> > and devlink considered as the tool to manage that.  
> 
> Yes, this doesn't seem right, I don't think these auxiliary bus
> objects should have devlink instances

+1
