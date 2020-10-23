Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3062969FB
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 08:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375480AbgJWGzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 02:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373446AbgJWGzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 02:55:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EC6821527;
        Fri, 23 Oct 2020 06:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603436134;
        bh=NIK8YqU0UAeUuqB3Fw2hEF+C+03sZYkTOCGN29s/iPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kLQR+Fz4Le3idbzalFRg3vSNKw7jp+rA/02vOGU1QGfml4CveJJOyv1+6syy3XiQW
         eVyK94i+lrirVfZ6rpSWdKaSyckd69KC8p+rykMpU3l/NSoY6xcJ9FiibG5akGPnbO
         T+HOT5jh5ezHT3DcsdPYvhDHcfB8Ad2QMMdT1w78=
Date:   Fri, 23 Oct 2020 08:56:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Auxiliary bus implementation and SOF
 multi-client support
Message-ID: <20201023065610.GA2162757@kroah.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023064946.GP2611066@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023064946.GP2611066@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 09:49:46AM +0300, Leon Romanovsky wrote:
> On Thu, Oct 22, 2020 at 05:33:28PM -0700, Dave Ertman wrote:
> 
> <...>
> 
> > Dave Ertman (1):
> >   Add auxiliary bus support
> 
> We are in merge window now and both netdev and RDMA are closed for
> submissions. So I'll send my mlx5 conversion patches once -rc1 will
> be tagged.
> 
> However, It is important that this "auxiliary bus" patch will be applied
> to some topic branch based on Linus's -rcX. It will give us an ability
> to pull this patch to RDMA, VDPA and netdev subsystems at the same time.

I will do that, but as you said, it's the middle of the merge window and
I can't do anything until after -rc1 is out.  Give us some time to catch
up after that...

greg k-h
