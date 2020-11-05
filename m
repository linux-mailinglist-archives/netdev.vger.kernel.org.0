Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8A62A8419
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbgKEQ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgKEQ4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 11:56:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A773C2073A;
        Thu,  5 Nov 2020 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604595375;
        bh=rveaLrZ2VekMaBIfhcAvnGUg2fcFO3veOvwCKc6KlV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p0zlCIJSZLU+hIGO/1OT9CsKyGQRT9xRqtuEOEJYahXBjO2R63qCOEBzaoC2jvC/W
         b3CyZRYfIxq8nHLYW+R8WfeBMZfDYBVEuMJK7rNNLj7g5UvHMQPmTC8sRuIQAKq6bJ
         KIIuiYd6H/ssEmRFS4YipJuNXx5/cC0UxgvuXAYQ=
Date:   Thu, 5 Nov 2020 17:57:01 +0100
From:   gregkh <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Netdev <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David M Ertman <david.m.ertman@intel.com>
Subject: Re: [PATCH mlx5-next v1 06/11] vdpa/mlx5: Connect mlx5_vdpa to
 auxiliary bus
Message-ID: <20201105165701.GA1243785@kroah.com>
References: <20201101201542.2027568-1-leon@kernel.org>
 <20201101201542.2027568-7-leon@kernel.org>
 <20201103154525.GO36674@ziepe.ca>
 <CAPcyv4jP9nFAGdvB7agg3x7Y7moHGcxLd5=f5=5CXnJRUf3n9w@mail.gmail.com>
 <20201105073302.GA3415673@kroah.com>
 <20201105164738.GD36674@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105164738.GD36674@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 12:47:38PM -0400, Jason Gunthorpe wrote:
> On Thu, Nov 05, 2020 at 08:33:02AM +0100, gregkh wrote:
> > > Were there any additional changes you wanted to see happen? I'll go
> > > give the final set another once over, but David has been diligently
> > > fixing up all the declared major issues so I expect to find at most
> > > minor incremental fixups.
> > 
> > This is in my to-review pile, along with a load of other stuff at the
> > moment:
> > 	$ ~/bin/mdfrm -c ~/mail/todo/
> > 	1709 messages in /home/gregkh/mail/todo/
> > 
> > So give me a chance.  There is no rush on my side for this given the
> > huge delays that have happened here on the authorship side many times in
> > the past :)
> 
> On the other hand Leon and his team did invest alot of time and
> effort, very quickly, to build and QA this large mlx5 series here to
> give a better/second example as you requested only a few weeks ago.

Leon and his team have done a great job, and I never said otherwise.

greg k-h
