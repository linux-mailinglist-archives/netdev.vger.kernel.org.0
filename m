Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9837FFFFC4
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKRHtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfKRHtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 02:49:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6779920679;
        Mon, 18 Nov 2019 07:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574063378;
        bh=AV6l9cxsDAG2ISoLdHp8DlACnAVdJD/5/GbndswB/1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n41iPHjumO1lzpsuR34iOWDok/tp4N4kDm1lRL4KphTv9fMt3VIz89RiJEPT3LvqE
         ai0wa5gKmqvZugyc47frMUZ7TbQ7ZRwvxj0hCcyu3z1rLce6nSD6n0hSyoxxe7rPNG
         q8L7HYdgZ+mZh4Fcy3ZJNWGndumCWmI2gLIRrIFg=
Date:   Mon, 18 Nov 2019 08:49:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        parav@mellanox.com, Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191118074934.GB130507@kroah.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 02:33:55PM -0800, Jeff Kirsher wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> This is the initial implementation of the Virtual Bus,
> virtbus_device and virtbus_driver.  The virtual bus is
> a software based bus intended to support lightweight
> devices and drivers and provide matching between them
> and probing of the registered drivers.
> 
> The primary purpose of the virual bus is to provide
> matching services and to pass the data pointer
> contained in the virtbus_device to the virtbus_driver
> during its probe call.  This will allow two separate
> kernel objects to match up and start communication.
> 
> The bus will support probe/remove shutdown and
> suspend/resume callbacks.
> 
> Kconfig and Makefile alterations are included
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> v2: Cleaned up the virtual bus interface based on feedback from Greg KH
>     and provided a test driver and test virtual bus device as an example
>     of how to implement the virtual bus.

There is not a real user of this here, many of your exported functions
are not used at all, right?  I want to see this in "real use" to
actually determine how it works, and that's the only way you will know
if it solves your problem or not.

thanks,

greg k-h
