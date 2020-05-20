Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BE61DABDC
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgETHUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETHUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:20:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92D11207D3;
        Wed, 20 May 2020 07:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589959234;
        bh=35iXB/au3tBZIql3xx3Q4NWV5Vl+PG6r3+MDwXmNFUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YiD7pyHhe5Xn5Jj2hrR/JWfZENU9AHUdXV5c7+mkrUlb6mfh1HxvMdhEXLjmXdBpq
         4jglOHQbIJIE6JChRFLcOKVhSVRPmBBU4HPF9aVZJyiKDu+4kWY+OjguJhsvebbKPf
         mTWdS3XoqZMkONyUQ/AUdoC6E5+L5qI/hkhIYEmc=
Date:   Wed, 20 May 2020 09:20:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200520072031.GB2365898@kroah.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:02:25AM -0700, Jeff Kirsher wrote:
> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> 
> A client in the SOF (Sound Open Firmware) context is a
> device that needs to communicate with the DSP via IPC
> messages. The SOF core is responsible for serializing the
> IPC messages to the DSP from the different clients. One
> example of an SOF client would be an IPC test client that
> floods the DSP with test IPC messages to validate if the
> serialization works as expected. Multi-client support will
> also add the ability to split the existing audio cards
> into multiple ones, so as to e.g. to deal with HDMI with a
> dedicated client instead of adding HDMI to all cards.
> 
> This patch introduces descriptors for SOF client driver
> and SOF client device along with APIs for registering
> and unregistering a SOF client driver, sending IPCs from
> a client device and accessing the SOF core debugfs root entry.
> 
> Along with this, add a couple of new members to struct
> snd_sof_dev that will be used for maintaining the list of
> clients.

Here is where you are first using a virtual bus driver, and yet, no
mention of that at all in the changelog.  Why?

Why are virtual devices/busses even needed here?

greg k-h
