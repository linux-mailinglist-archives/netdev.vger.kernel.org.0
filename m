Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE847A597D
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 16:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbfIBOhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 10:37:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727393AbfIBOhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 10:37:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9BC4F2A09B3;
        Mon,  2 Sep 2019 14:37:05 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEB77608C1;
        Mon,  2 Sep 2019 14:37:00 +0000 (UTC)
Date:   Mon, 2 Sep 2019 16:36:58 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] mdev: Update sysfs documentation
Message-ID: <20190902163658.51fc48d2.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB4866372C521F59491838C8E4D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-6-parav@mellanox.com>
        <20190830144927.7961193e.cohuck@redhat.com>
        <AM0PR05MB4866372C521F59491838C8E4D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 02 Sep 2019 14:37:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 13:10:17 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Friday, August 30, 2019 6:19 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: Re: [PATCH v2 5/6] mdev: Update sysfs documentation
> > 
> > On Thu, 29 Aug 2019 06:19:03 -0500
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > Updated documentation for optional read only sysfs attribute.  
> > 
> > I'd probably merge this into the patch introducing the attribute.
> >   
> Ok. I will spin v3.
> 
> > >
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > ---
> > >  Documentation/driver-api/vfio-mediated-device.rst | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> > > b/Documentation/driver-api/vfio-mediated-device.rst
> > > index 25eb7d5b834b..0ab03d3f5629 100644
> > > --- a/Documentation/driver-api/vfio-mediated-device.rst
> > > +++ b/Documentation/driver-api/vfio-mediated-device.rst
> > > @@ -270,6 +270,7 @@ Directories and Files Under the sysfs for Each mdev  
> > Device  
> > >           |--- remove
> > >           |--- mdev_type {link to its type}
> > >           |--- vendor-specific-attributes [optional]
> > > +         |--- alias [optional]  
> > 
> > "optional" implies "not always present" to me, not "might return a read error if
> > not available". Don't know if there's a better way to tag this? Or make it really
> > optional? :)  
> 
> May be write it as,
> 
> alias [ optional when requested by parent ]

I'm not sure what 'optional when requested' is supposed to mean...
maybe something like 'content optional' or so?

> 
> >   
> > >
> > >  * remove (write only)
> > >
> > > @@ -281,6 +282,10 @@ Example::
> > >
> > >  	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
> > >
> > > +* alias (read only)
> > > +Whenever a parent requested to generate an alias, each mdev is
> > > +assigned a unique alias by the mdev core. This file shows the alias of the  
> > mdev device.
> > 
> > It's not really the parent, but the vendor driver requesting this, right? Also,  
> At mdev level, it only knows parent->ops structure, whether parent is registered by vendor driver or something else.

Who else is supposed to create the mdev device?

> 
> > "each mdev" is a bit ambiguous,   
> It is in context of the parent. Sentence is not starting with "each mdev".
> But may be more verbosely written as,
> 
> Whenever a parent requested to generate an alias, Each mdev device of such parent is assigned 
> unique alias by the mdev core. This file shows the alias of the mdev device.

I'd really leave the parent out of this: this seems more like an
implementation detail. It's more that alias may either contain an
alias, or return a read error if no alias has been generated. Who
requested the alias to be generated is probably not really of interest
to the userspace reader.

> 
> > created via that driver. Lastly, if we stick with the "returns an error if not
> > implemented" approach, that should also be mentioned here.  
> Ok. Will spin v3 to describe it.
> 
> >   
> > > +
> > >  Mediated device Hot plug
> > >  ------------------------
> > >  
> 

