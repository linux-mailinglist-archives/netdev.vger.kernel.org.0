Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297002A87E8
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732273AbgKEUVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732238AbgKEUV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 15:21:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45C11206A1;
        Thu,  5 Nov 2020 20:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604607687;
        bh=iisDYmnCqmymIp9jDmc3emaxJKy7G18dQ4jz7l5yNf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2P75OZLUStWL1aGyyd/Da81aZljbX9qzXGnTnNGkvCtGQl1yRW5hjpyqSk+W8F11h
         7WAiJuz8nKkh8LipvSMy6M7FDwqfwv86DDpoXmgzTxvOzFOnNCeR9UNmWl0Wx36Que
         DvkEz5vw/fpxwDyRRfIqH1A7uT2TvCyv1zB1yLOA=
Date:   Thu, 5 Nov 2020 21:22:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
Message-ID: <20201105202214.GA1339091@kroah.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <20201105094719.GQ5429@unreal>
 <CAPcyv4hmBhkFjSA2Q_p=Ss40CLFs86N7FugJOpq=sZ-NigoSRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hmBhkFjSA2Q_p=Ss40CLFs86N7FugJOpq=sZ-NigoSRw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 09:12:51AM -0800, Dan Williams wrote:
> > >
> > > Per above SPDX is v2 only, so...
> >
> > Isn't it default for the Linux kernel?
> 
> SPDX eliminated the need to guess a default, and MODULE_LICENSE("GPL")
> implies the "or later" language. The only default assumption is that
> the license is GPL v2 compatible, those possibilities are myriad, but
> v2-only is the first preference.

No, MODULE_LICENSE("GPL") does not imply "or later" at all.  Please see
include/linux/module.h, it means "GPL version 2".

thanks,

greg k-h
