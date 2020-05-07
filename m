Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09FC1C82F5
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 09:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgEGHAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 03:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEGHAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 03:00:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D41ED207DD;
        Thu,  7 May 2020 07:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588834811;
        bh=jEttYpxCR1pQOCpq/7bhNKiXaeKh7rbfeTCzjCdEEMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qcCX8/Pw+g4KEBJQzFzGBJz978QrAPH1SX+qhXTKNGlSNz1fkXtp3kY2wrhMaMicf
         KYNFGHRRx+AV+DmtMShaBbx+bDHwvmCxsHkbVvmww6FZY/7TB1ypYPcf75ofW7iE1D
         CR2NNyzqpAzdaY+eGgksLAZgBGlK9QQwfYemyvL8=
Date:   Thu, 7 May 2020 09:00:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        leonro@mellanox.com, mkalderon@marvell.com, aditr@vmware.com,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com
Subject: Re: [net-next v3 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-05-05
Message-ID: <20200507070008.GA841650@kroah.com>
References: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 02:04:56PM -0700, Jeff Kirsher wrote:
> This series contains the initial implementation of the Virtual Bus,
> virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the new
> Virtual Bus.
> 
> The primary purpose of the Virtual bus is to put devices on it and hook the
> devices up to drivers.  This will allow drivers, like the RDMA drivers, to
> hook up to devices via this Virtual bus.
> 
> The associated irdma driver designed to use this new interface, is still
> in RFC currently and was sent in a separate series.  A new RFC version
> is expected later this week.
> 
> This series currently builds against net-next tree.
> 
> Revision history:
> v2: Made changes based on community feedback, like Pierre-Louis's and
>     Jason's comments to update virtual bus interface.
> v3: Updated the virtual bus interface based on feedback from Jason and
>     Greg KH.  Also updated the initial ice driver patch to handle the
>     virtual bus changes and changes requested by Jason and Greg KH.
> 
> The following are changes since commit f989d546a2d5a9f001f6f8be49d98c10ab9b1897:
>   erspan: Add type I version 0 support.
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

pull request?

Come on, give us a chance to review this mess please, give me a week or
so.

greg k-h
