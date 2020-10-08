Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E66F286FD0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgJHHuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727694AbgJHHuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 03:50:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C90F42184D;
        Thu,  8 Oct 2020 07:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602143404;
        bh=YBS+MwCavDsFdeUTd1WYUDdA6c+iqbiDUCr/7HtOI4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2Btk65BK/h0mFgXMRPEafb0pVYKBHvPk0aNd4i1Q2KDDX3kSYtxbJz9OgCU88iJjA
         cfmxKkC+pMryZkFLP6N68WfcvKvmhuLOFZqqJwOqgLHi5w2WvVN1q/X8jxPY8tS30W
         qnizCjT79GKXMA4zdH9kXuSDoaiTAU874K25I26o=
Date:   Thu, 8 Oct 2020 09:50:48 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201008075048.GA254837@kroah.com>
References: <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201008052137.GA13580@unreal>
 <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
 <20201008070032.GG13580@unreal>
 <CAPcyv4jUbNaR6zoHdSNf1Rsq7MUp2RvdUtDGrmi5Be6hK_oybg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jUbNaR6zoHdSNf1Rsq7MUp2RvdUtDGrmi5Be6hK_oybg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 12:38:00AM -0700, Dan Williams wrote:
> On Thu, Oct 8, 2020 at 12:01 AM Leon Romanovsky <leon@kernel.org> wrote:
> [..]
> > All stated above is my opinion, it can be different from yours.
> 
> Yes, but we need to converge to move this forward. Jason was involved
> in the current organization for registration, Greg was angling for
> this to be core functionality. I have use cases outside of RDMA and
> netdev. Parav was ok with the current organization. The SOF folks
> already have a proposed incorporation of it. The argument I am hearing
> is that "this registration api seems hard for driver writers" when we
> have several driver writers who have already taken a look and can make
> it work. If you want to follow on with a simpler wrappers for your use
> case, great, but I do not yet see anyone concurring with your opinion
> that the current organization is irretrievably broken or too obscure
> to use.

That's kind of because I tuned out of this thread a long time ago :)

I do agree with Leon that I think the current patch is not the correct
way to do this the easiest, but don't have a competing proposal to show
what I mean.

Yet.

Let's see what happens after 5.10-rc1 is out, it's too late now for any
of this for this next merge window so we can not worry about it for a
few weeks.

thanks,

greg k-h
