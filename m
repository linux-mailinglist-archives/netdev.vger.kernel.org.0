Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B0F2850C7
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 19:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgJFR0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 13:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFR0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 13:26:55 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30CFD20674;
        Tue,  6 Oct 2020 17:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602005214;
        bh=F0HQbTaTERZyH2PFQJHENFBsyRZFyRlCovByBrhvGhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1tgYY+e97jByt5c9GwVMffHxWfneSxaysC3hOM/TsjT7KlfG00ssd6BFZUDSSEGZw
         r5Z5SW6jnduPzBDwAuoPRLRqlLCmEGWPJ9gQkJXWbR2ZhITmpCN6e5D2llB1CVllRN
         q46uU5CoZBAy1NVHUT7r3KSmiz2LO+uCHBVzLuWw=
Date:   Tue, 6 Oct 2020 20:26:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201006172650.GO1874917@unreal>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 05:09:09PM +0000, Parav Pandit wrote:
>
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, October 6, 2020 10:33 PM
> >
> > On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > > Thanks for the review Leon.
> > >
> > > > > Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> > > > > It enables drivers to create an ancillary_device and bind an
> > > > > ancillary_driver to it.
> > > >
> > > > I was under impression that this name is going to be changed.
> > >
> > > It's part of the opens stated in the cover letter.
> >
> > ok, so what are the variants?
> > system bus (sysbus), sbsystem bus (subbus), crossbus ?
> Since the intended use of this bus is to
> (a) create sub devices that represent 'functional separation' and
> (b) second use case for subfunctions from a pci device,
>
> I proposed below names in v1 of this patchset.
>
> (a) subdev_bus

It sounds good, just can we avoid "_" in the name and call it subdev?

> (b) subfunction_bus
