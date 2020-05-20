Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE841DABFB
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgETH0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETH0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:26:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 109D3205CB;
        Wed, 20 May 2020 07:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589959572;
        bh=B86idNzIV0l9bu1aY1PWCbWcFKAqcMb/btcsv2mDs9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cBCZdyzFoyBVepyB8sB+0fZFIU7ikawW2CaGbOsoCN3MUsdauLsbYR9knO6svrdqH
         fET40rPm0Z4eDqTnmH+qbEsL/CpXElLe7ykQruCyw5HLXSsXlZYpN6ACutw9D7KSn7
         527Ex255JtA3bD6LvK0cYUEQoMz8+nFyK1ZkkIw4=
Date:   Wed, 20 May 2020 09:26:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     dledford@redhat.com, jgg@mellanox.com, davem@davemloft.net,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, poswald@suse.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RDMA RFC v6 01/16] RDMA/irdma: Add driver framework definitions
Message-ID: <20200520072609.GE2365898@kroah.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200520070415.3392210-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520070415.3392210-2-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:04:00AM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
> 
> Register irdma as a platform driver capable of supporting platform
> devices from multi-generation RDMA capable Intel HW. Establish the
> interface with all supported netdev peer devices and initialize HW.

Um, this changelog text does not match up with the actual patch at all
:(

{sigh}

And Intel developers wonder why I'm grumpy these days...

greg k-h
