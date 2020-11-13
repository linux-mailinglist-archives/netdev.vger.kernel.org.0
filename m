Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEBB2B1F28
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgKMPtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:49:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgKMPtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 10:49:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67DBE208D5;
        Fri, 13 Nov 2020 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605282554;
        bh=OUwhf42qpFcM/lBJ/hTBqW+PXMEvyYGYP0TAhunP7Ko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xcj3LLMlUrmTP+AsKN9QMNiDNCE3tAf9Y8iiu3mBwCgfEHnofYnEr90y3p9cvHAhT
         owXylYxt6Ka1m5upfse3XgyZwCwf0EtG9O3GCPtz6uuS6bN3qrHWJA3gO52tZkjxBW
         IEn3JWdHmzZykXDA9yN5nfz5dIMMDKBhgShB9EgU=
Date:   Fri, 13 Nov 2020 16:50:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Ertman <david.m.ertman@intel.com>
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org, leonro@nvidia.com
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
Message-ID: <X66rMg1lNJq+W/cp@kroah.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023003338.1285642-2-david.m.ertman@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 05:33:29PM -0700, Dave Ertman wrote:
> Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> It enables drivers to create an auxiliary_device and bind an
> auxiliary_driver to it.
> 
> The bus supports probe/remove shutdown and suspend/resume callbacks.
> Each auxiliary_device has a unique string based id; driver binds to
> an auxiliary_device based on this id through the bus.
> 
> Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> ---

Is this really the "latest" version of this patch submission?

I see a number of comments on it already, have you sent out a newer one,
or is this the same one that the mlx5 driver conversion was done on top
of?

thanks,

greg k-h
