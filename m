Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7DF610CCB
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiJ1JLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ1JLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:11:08 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDA2664EB;
        Fri, 28 Oct 2022 02:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666948265; x=1698484265;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ly7+HAQfpn4/xVSZsitzehQ1kryk3ZFPDVcAIydFii4=;
  b=XvtEBYmYzytwtC61ooiRceBwBgXspOD9IUeU3iqOSSEZvh5Nis6skHHe
   ZWFK9etgIejgT7176esS8Lvp5LxHr4S11NImbniH+pPsutBoI5TOhQuve
   gz7mLExQ6Wy6OTTx48bjJwHjmUEwc5+s7O9Ff/6VSSHSFWzZvRXMNKu7A
   ZBoF/ZraopfxrbJqYRYby2/vvDOIAhG74qPMOL3OK0iB9SBwIAWwG++QK
   AYvlaixQtZZhIR2IoG7W11g+jSgi+xZuy8EZMJPdvAqzCRIr0a8hEkJFT
   5E6T8ZaDFnV0db9rqm6gxdKc2aVn83kcl99cQXac2gxBM1qlXEPcjqxt1
   g==;
X-IronPort-AV: E=Sophos;i="5.95,220,1661810400"; 
   d="scan'208";a="27033332"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 28 Oct 2022 11:11:00 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 28 Oct 2022 11:11:00 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 28 Oct 2022 11:11:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666948260; x=1698484260;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ly7+HAQfpn4/xVSZsitzehQ1kryk3ZFPDVcAIydFii4=;
  b=BzL7Du+GrJ33ddRfb0rEy9z4szhrHdpVMmnz3ZKoB8xwMJkMlUWlUe0e
   pJh5eWuwverB3RwMxjhWFeC5Bdu9bc64jqD3KVrBrDPjEbpIPm6hp8sTA
   EwIqXigmkicKLfoBdqPxNijxW0QlT7bOO3f5t7YI1JVLip7VLX6/qg43a
   a/Z2Ual/Tdfa4hBw42Z0tIaJHrJLdqO9BmHcmXqEoihicM3YYINdt2N5b
   dlnUa02B9w993RoJPhKhLtk0LfLot1jO3MkAvd2UaC6NUyHWuVvdsH4rL
   wucLRkhoVuMHNJBX3cv0hPjTyc6P5/XE2qwyub9ufBKlKUHR5uU2VIEGA
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,220,1661810400"; 
   d="scan'208";a="27033330"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 28 Oct 2022 11:11:00 +0200
Received: from schifferm-ubuntu (SCHIFFERM-M2.tq-net.de [10.121.49.14])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 36CBF280056;
        Fri, 28 Oct 2022 11:11:00 +0200 (CEST)
Message-ID: <2983d3fc9516695da57d389b0d90cb2a748c3bee.camel@ew.tq-group.com>
Subject: Re: [RFC 1/5] misc: introduce notify-device driver
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@ew.tq-group.com
Date:   Fri, 28 Oct 2022 11:10:58 +0200
In-Reply-To: <Y1q2RKTaw69C7vZT@kroah.com>
References: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
         <db30127ab4741d4e71b768881197f4791174f545.1666786471.git.matthias.schiffer@ew.tq-group.com>
         <Y1lGPRvKMbNDs1iK@kroah.com>
         <ed580c15fbf690acde24679956a9439c1c0a1137.camel@ew.tq-group.com>
         <Y1q2RKTaw69C7vZT@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-10-27 at 18:48 +0200, Greg Kroah-Hartman wrote:
> On Thu, Oct 27, 2022 at 06:33:33PM +0200, Matthias Schiffer wrote:
> > On Wed, 2022-10-26 at 16:37 +0200, Greg Kroah-Hartman wrote:
> > > On Wed, Oct 26, 2022 at 03:15:30PM +0200, Matthias Schiffer wrote:
> > > > A notify-device is a synchronization facility that allows to query
> > > > "readiness" across drivers, without creating a direct dependency between
> > > > the driver modules. The notify-device can also be used to trigger deferred
> > > > probes.
> > > > 
> > > > Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> > > > ---
> > > >  drivers/misc/Kconfig          |   4 ++
> > > >  drivers/misc/Makefile         |   1 +
> > > >  drivers/misc/notify-device.c  | 109 ++++++++++++++++++++++++++++++++++
> > > >  include/linux/notify-device.h |  33 ++++++++++
> > > >  4 files changed, 147 insertions(+)
> > > >  create mode 100644 drivers/misc/notify-device.c
> > > >  create mode 100644 include/linux/notify-device.h
> > > > 
> > > > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > > > index 358ad56f6524..63559e9f854c 100644
> > > > --- a/drivers/misc/Kconfig
> > > > +++ b/drivers/misc/Kconfig
> > > > @@ -496,6 +496,10 @@ config VCPU_STALL_DETECTOR
> > > >  
> > > >  	  If you do not intend to run this kernel as a guest, say N.
> > > >  
> > > > +config NOTIFY_DEVICE
> > > > +	tristate "Notify device"
> > > > +	depends on OF
> > > > +
> > > >  source "drivers/misc/c2port/Kconfig"
> > > >  source "drivers/misc/eeprom/Kconfig"
> > > >  source "drivers/misc/cb710/Kconfig"
> > > > diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> > > > index ac9b3e757ba1..1e8012112b43 100644
> > > > --- a/drivers/misc/Makefile
> > > > +++ b/drivers/misc/Makefile
> > > > @@ -62,3 +62,4 @@ obj-$(CONFIG_HI6421V600_IRQ)	+= hi6421v600-irq.o
> > > >  obj-$(CONFIG_OPEN_DICE)		+= open-dice.o
> > > >  obj-$(CONFIG_GP_PCI1XXXX)	+= mchp_pci1xxxx/
> > > >  obj-$(CONFIG_VCPU_STALL_DETECTOR)	+= vcpu_stall_detector.o
> > > > +obj-$(CONFIG_NOTIFY_DEVICE)	+= notify-device.o
> > > > diff --git a/drivers/misc/notify-device.c b/drivers/misc/notify-device.c
> > > > new file mode 100644
> > > > index 000000000000..42e0980394ea
> > > > --- /dev/null
> > > > +++ b/drivers/misc/notify-device.c
> > > > @@ -0,0 +1,109 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > > +
> > > > +#include <linux/device/class.h>
> > > > +#include <linux/kernel.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/notify-device.h>
> > > > +#include <linux/platform_device.h>
> > > > +#include <linux/slab.h>
> > > > +
> > > > +static void notify_device_release(struct device *dev)
> > > > +{
> > > > +	of_node_put(dev->of_node);
> > > > +	kfree(dev);
> > > > +}
> > > > +
> > > > +static struct class notify_device_class = {
> > > > +	.name = "notify-device",
> > > > +	.owner = THIS_MODULE,
> > > > +	.dev_release = notify_device_release,
> > > > +};
> > > > +
> +static struct platform_driver notify_device_driver = {
> > 
> > [Pruning the CC list a bit, to avoid clogging people's inboxes]
> > 
> > > Ick, wait, this is NOT a platform device, nor driver, so it shouldn't be
> > > either here.  Worst case, it's a virtual device on the virtual bus.
> > 
> > This part of the code is inspired by mac80211_hwsim, which uses a
> > platform driver in a similar way, for a plain struct device. Should
> > this rather use a plain struct device_driver?
> 
> It should NOT be using a platform device.
> 
> Again, a platform device should NEVER be used as a child of a device in
> the tree that is on a discoverable bus.
> 
> Use the aux bus code if you don't want to create virtual devices with no
> real bus, that is what it is there for.

Thanks, the auxiliary bus seems to be what I'm looking for.

> 
> > Also, what's the virtual bus? Grepping the Linux code and documentation
> > didn't turn up anything.
> 
> Look at the stuff that ends up in /sys/devices/virtual/  Lots of users
> there.
> 
> > > But why is this a class at all?  Classes are a representation of a type
> > > of device that userspace can see, how is this anything that userspace
> > > cares about?
> > 
> > Makes sense, I will remove the class.
> > 
> > > Doesn't the device link stuff handle all of this type of "when this
> > > device is done being probed, now I can" problems?  Why is a whole new
> > > thing needed?
> > 
> > The issue here is that (as I understand it) the device link and
> > deferred probing infrastructore only cares about whether the supplier
> > device has been probed successfully.
> > 
> > This is insuffient in the case of the dependency between mwifiex and
> > hci_uart/hci_mrvl that I want to express: mwifiex loads its firmware
> > asynchronously, so finishing the mwifiex probe is too early to retry
> > probing the Bluetooth driver.
> 
> Welcome to deferred probing hell :)
> 
> > While mwifiex does create a few devices (ieee80211, netdevice) when the
> > firmware has loaded, none of these bind to a driver, so they don't
> > trigger the deferred probes. Using their existence as a condition for
> > allowing the Bluetooth driver to probe also seems ugly too me
> > (ieee80211 currently can't be looked up by OF node, and netdevices can
> > be created and deleted dynamically).
> > 
> > Because of this, I came to the conclusion that creating and binding a
> > device specifically for this purpose is a good solution, as it solves
> > two problems at once:
> > - The driver bind triggers deferred probes
> > - The driver allows to look up the device by OF node
> > 
> > Integrating this with device links might make sense as well, but I
> > haven't looked much into that yet.
> 
> Try looking at device links, I think this fits exactly what that solves.
> If not, please figure out why.

According to [1], what triggers device link state changes is the
binding of drivers. As mentioned, this doesn't help in the mwifiex
case: The mwifiex probe does not wait for the firmware to load, as the
probe would otherwise take too long (see [2]).

So unless we want to extend the device link facility with a manual mode
where the supplier explicitly sets the link to a "ready" state, we
still need to extend mwifiex with a child device to attach the link to,
triggering the state change by binding it to a driver at the right
moment. Which is what this patch implements in a generic way (just
without device links so far).

Thanks,
Matthias


[1] https://www.kernel.org/doc/html/latest/driver-api/device_link.html#state-machine
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=59a4cc2539076f868f2a3fcd7a3385a26928a27a


