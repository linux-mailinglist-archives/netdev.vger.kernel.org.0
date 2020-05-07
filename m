Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068F01C849C
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgEGIRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgEGIRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 04:17:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A476620753;
        Thu,  7 May 2020 08:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588839459;
        bh=ABrJ2MjXyJJzImWtfy4NrU81CbImTys40NxcYWZ+pEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d24cc5QyojfMERgZm2wYcaSmrFVZyeNjPhilmPD9EYosADJKbkumwC8UNHWAtx+2u
         t/aZLUJM5a0nvzSKHlR2NiHuTm4tOveyV2f7B/OMZObpdPNzewekDOUw6c47A5/S31
         QdSAqVnVpW4rguVLrrIe75Yd5Utrt3QHZBuEyYt0=
Date:   Thu, 7 May 2020 10:17:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v3 2/9] ice: Create and register virtual bus for RDMA
Message-ID: <20200507081737.GC1024567@kroah.com>
References: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
 <20200506210505.507254-3-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506210505.507254-3-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 02:04:58PM -0700, Jeff Kirsher wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> The RDMA block does not have its own PCI function, instead it must utilize
> the ice driver to gain access to the PCI device. Create a virtual bus
> device so the irdma driver can register a virtual bus driver to bind to it
> and receive device data. The device data contains all of the relevant
> information that the irdma peer will need to access this PF's IIDC API
> callbacks.

But there is no virtual bus driver in this patch!

What am I missing?  This patch is really really hard to follow, you seem
to be adding new functionality at the same time you are adding virtual
devices, is there some way to split it up into reviewable pieces?  This
feels like a big mix of things all lumped together.

In other words, I can't review this at all to try to see if you are
using the virtual devices properly at all, which is not a good thing...

greg k-h
