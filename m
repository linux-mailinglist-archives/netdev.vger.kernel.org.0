Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0384118163
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfLJHdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:33:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfLJHdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 02:33:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56308206D5;
        Tue, 10 Dec 2019 07:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575963210;
        bh=JPqMrsYFGc0/85JOVZhoNHjbP97FSnCpRd17R/WrPzU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1UwTEDsR+4Fc3q31V3+3yVI/WwROe8vR+e0jXcZam40sdwqFCzYqvuy3uFElovoPi
         IaxV5PvYi5VUQgksQt4ZCf9eQWYbGMH+K5JTo8g8Gbtw7+T7Qg6G5rUiwZibcrt1Fy
         lK3Aqyg/Qqzu3HInmOcp+A60teQWglSPyGvjX3w0=
Date:   Tue, 10 Dec 2019 08:33:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com
Subject: Re: [net-next v3 00/20][pull request] Intel Wired LAN Driver Updates
 2019-12-09
Message-ID: <20191210073326.GA3077639@kroah.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:49:15PM -0800, Jeff Kirsher wrote:
> This series contains the initial implementation of the Virtual Bus,
> virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the new
> Virtual Bus and the new RDMA driver 'irdma' for use with 'ice' and 'i40e'.
> 
> The primary purpose of the Virtual bus is to provide a matching service
> and to pass the data pointer contained in the virtbus_device to the
> virtbus_driver during its probe call.  This will allow two separate
> kernel objects to match up and start communication.
> 
> The last 16 patches of the series adds a unified Intel Ethernet Protocol
> driver for RDMA that supports a new network device E810 (iWARP and
> RoCEv2 capable) and the existing X722 iWARP device.  The driver
> architecture provides the extensibility for future generations of Intel
> hardware supporting RDMA.
> 
> The 'irdma' driver replaces the legacy X722 driver i40iw and extends the
> ABI already defined for i40iw.  It is backward compatible with legacy
> X722 rdma-core provider (libi40iw).
> 
> This series currently builds against net-next tree AND the rdma "for-next"
> branch.
> 
> v1: Initial virtual bus submission
> v2: Added example virtbus_dev and virtbus_drv in
>     tools/testing/sefltests/ to test the virtual bus and provide an
>     example on how to implement
> v3: Added ice and i40e driver changes to implement the virtual bus, also
>     added the new irdma driver which is the RDMA driver which
>     communicates with the ice and i40e drivers

Seems pretty premature to ask for a pull request after I rejected your
first 2 submissions and have not seen a valid implementation yet.

Please give me a few days to review this...

greg k-h
