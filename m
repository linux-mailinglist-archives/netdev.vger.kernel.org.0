Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BCF1DABDF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgETHWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgETHWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:22:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AEEB205CB;
        Wed, 20 May 2020 07:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589959352;
        bh=+6xSQMgqCUxeZ2jLH2vNB6ZQG3m2a3a+LadAkCUif8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GeVYZCyGuR03+m/F5V/LwpQ9sYQ6bsFMM1oY/bT4xOYK9iYMe+G4VaqoPD9PwBddO
         yVfoSaNLKc6FGWewGskh1dzzIinfg1I+x36JlnHvWxOqkQQ6OajB/8PVxIFqarKtWz
         ZumsYuRN4xriQri4OXltBWFHwkcr6NMd8KLXVaVE=
Date:   Wed, 20 May 2020 09:22:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 11/12] ASoC: SOF: Create client driver for IPC test
Message-ID: <20200520072229.GC2365898@kroah.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-12-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520070227.3392100-12-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:02:26AM -0700, Jeff Kirsher wrote:
> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> 
> Create an SOF client driver for IPC flood test. This
> driver is used to set up the debugfs entries and the
> read/write ops for initiating the IPC flood test that
> would be used to measure the min/max/avg response times
> for sending IPCs to the DSP.

No form of documentation for what these debugfs files are for?  I know
you don't normally have to do this, but all you are doing here is
creating a "test" driver, with testing interfaces from userspace to the
kernel.  So how is anyone supposed to know how to use them?

These are complex debugfs files you are writing to, so a bit of a hint
as to what they are going to be doing would be nice, don't you think?

thanks,

greg k-h
