Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21282DDABD
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 22:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgLQVUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 16:20:24 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58345 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbgLQVUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 16:20:23 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 21204E0006;
        Thu, 17 Dec 2020 21:19:37 +0000 (UTC)
Date:   Thu, 17 Dec 2020 22:19:37 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201217211937.GA3177478@piout.net>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8usiKhLCU3PGL9J@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 05/12/2020 16:51:36+0100, Greg KH wrote:
> > To me, the documentation was written, and reviewed, more from the
> > perspective of "why not open code a custom bus instead". So I can see
> > after the fact how that is a bit too much theory and justification and
> > not enough practical application. Before the fact though this was a
> > bold mechanism to propose and it was not clear that everyone was
> > grokking the "why" and the tradeoffs.
> 
> Understood, I guess I read this from the "of course you should do this,
> now how do I use it?" point of view.  Which still needs to be addressed
> I feel.
> 
> > I also think it was a bit early to identify consistent design patterns
> > across the implementations and codify those. I expect this to evolve
> > convenience macros just like other parts of the driver-core gained
> > over time. Now that it is in though, another pass through the
> > documentation to pull in more examples seems warranted.
> 
> A real, working, example would be great to have, so that people can know
> how to use this.  Trying to dig through the sound or IB patches to view
> how it is being used is not a trivial thing to do, which is why
> reviewing this took so much work.  Having a simple example test module,
> that creates a number of devices on a bus, ideally tied into the ktest
> framework, would be great.  I'll attach below a .c file that I used for
> some basic local testing to verify some of this working, but it does not
> implement a aux bus driver, which needs to be also tested.
> 

There is something I don't get from the documentation and it is what is
this introducing that couldn't already be done using platform drivers
and platform devices?

We already have a bunch of drivers in tree that have to share a state
and register other drivers from other subsystems for the same device.
How is the auxiliary bus different?

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
