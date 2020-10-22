Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7229619F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 17:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901422AbgJVPZY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 11:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2901409AbgJVPZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 11:25:23 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0B85C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 08:25:21 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 09MFOI5F081938;
        Thu, 22 Oct 2020 17:24:18 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 09MFOIP2032233;
        Thu, 22 Oct 2020 17:24:18 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 09MFOHmV032232;
        Thu, 22 Oct 2020 17:24:17 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v6 6/6] docs: ctucanfd: CTU CAN FD open-source IP core documentation.
Date:   Thu, 22 Oct 2020 17:24:16 +0200
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz> <213155c64da5a97c574cd15de1cb06f8d0acef6a.1603354744.git.pisa@cmp.felk.cvut.cz> <20201022112540.GB30566@duo.ucw.cz>
In-Reply-To: <20201022112540.GB30566@duo.ucw.cz>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <202010221724.17063.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 09MFOI5F081938
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.099, required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.40,
        NICE_REPLY_A -0.00, SPF_HELO_NONE 0.00, SPF_NONE 0.00,
        URIBL_BLOCKED 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1603985061.91739@0qJRKdcuMkLIiFhIWHpJqw
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pavel,

thanks for review.

As for the documentation, my current intention is to keep/maintain
the common driver documentation for CTU CAN FD site
and kernel source. The standalone driver documentation

  http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/driver_doc/ctucanfd-driver.html

when the driver documentation moves to

  https://www.kernel.org/doc/html/latest/

we may consider to drop standalone. But resource are limited
and keeping and maintaining sync between slightly different
files is error prone. I run manual kdiff3 updates
of both RST files because references to sources are different.

On Thursday 22 of October 2020 13:25:40 Pavel Machek wrote:
> On Thu 2020-10-22 10:36:21, Pavel Pisa wrote:
> > CTU CAN FD IP core documentation based on Martin Jeřábek's diploma theses
> > Open-source and Open-hardware CAN FD Protocol Support
> > https://dspace.cvut.cz/handle/10467/80366
> > .
> >
> > ---
> >  .../ctu/FSM_TXT_Buffer_user.png               | Bin 0 -> 174807 bytes
>
> Maybe picture should stay on website, somewhere. It is rather big for
> kernel sources.

My sense is that it is proffered that documentation is self-contained
without embedded references to "untrusted" third party sites.
But we try to do something with it. I try reduce size or switch
to SVG, our actual source is PDF prepared by Ondrej Ille
as part of CTU CAN FD IP core architecture. I probably redraw
image in inscape with little worse graphics style, fonts,
smoothness etc. but in smaller and simpler SVG file size format.
I expect that use of original PDF in vector form would not help much.

> > +About SocketCAN
> > +---------------
> > +
> > +SocketCAN is a standard common interface for CAN devices in the Linux
> > +kernel. As the name suggests, the bus is accessed via sockets, similarly
> > +to common network devices. The reasoning behind this is in depth
> > +described in `Linux SocketCAN
> > <https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Doc
> >umentation/networking/can.rst>`_. +In short, it offers a
> > +natural way to implement and work with higher layer protocols over CAN,
> > +in the same way as, e.g., UDP/IP over Ethernet.
>
> Drop? Or at least link directly to the file in kernel tree?

Yes, this is another place where we need other diversion
between standalone and kernel. I try to learn what is the right
way to cross-reference Linux kernel manuals writtent n RST? 
If you can speedup it by hint/right done example I would be happy.

> > +Device probe
> > +~~~~~~~~~~~~
> > +
> > +Before going into detail about the structure of a CAN bus device driver,
> > +let's reiterate how the kernel gets to know about the device at all.
> > +Some buses, like PCI or PCIe, support device enumeration. That is, when
> > +the system boots, it discovers all the devices on the bus and reads
> > +their configuration. The kernel identifies the device via its vendor ID
> > +and device ID, and if there is a driver registered for this identifier
> > +combination, its probe method is invoked to populate the driver's
> > +instance for the given hardware. A similar situation goes with USB, only
> > +it allows for device hot-plug.
> > +
> > +The situation is different for peripherals which are directly embedded
> > +in the SoC and connected to an internal system bus (AXI, APB, Avalon,
> > +and others). These buses do not support enumeration, and thus the kernel
> > +has to learn about the devices from elsewhere. This is exactly what the
> > +Device Tree was made for.
>
> Dunno. Is it suitable? This is supposed to be ctu-can documentation,
> not "how hardware works" docs.

I think that this text is fully valid for standalone driver documentation,
I understand that in the kernel tree this can be replaced by references
to right places if we locate them.

> > +Platform device driver
> > +^^^^^^^^^^^^^^^^^^^^^^
> > +
> > +In the case of Zynq, the core is connected via the AXI system bus, which
> > +does not have enumeration support, and the device must be specified in
> > +Device Tree. This kind of devices is called *platform device* in the
> > +kernel and is handled by a *platform device driver*\  [1]_.
> > +
> > +A platform device driver provides the following things:
> > +
> > +-  A *probe* function
> > +
> > +-  A *remove* function
> > +
> > +-  A table of *compatible* devices that the driver can handle
> > +
> > +The *probe* function is called exactly once when the device appears (or
> > +the driver is loaded, whichever happens later). If there are more
> > +devices handled by the same driver, the *probe* function is called for
> > +each one of them. Its role is to allocate and initialize resources
> > +required for handling the device, as well as set up low-level functions
> > +for the platform-independent layer, e.g., *read_reg* and *write_reg*.
> > +After that, the driver registers the device to a higher layer, in our
> > +case as a *network device*.
> > +
> > +The *remove* function is called when the device disappears, or the
> > +driver is about to be unloaded. It serves to free the resources
> > +allocated in *probe* and to unregister the device from higher layers.
> > +
> > +Finally, the table of *compatible* devices states which devices the
> > +driver can handle. The Device Tree entry ``compatible`` is matched
> > +against the tables of all *platform drivers*.
>
> And this is "how to write a kernel driver" documentation. Like, why
> not, but maybe it does not need to be in kernel tree, and certainly
> should be separate from real "what is ctucan and how to use it" docs.

I agree, we try to find way how to separate the things and reference
pieces already found in the kernel. But it probably means massive
diversion of documentation sources which is yet another additional
load during preparation for mainlining. So I probably drop updates
of standalone documentation. Which can be problem for another university
group which builds applications based on the core and needs
to maintain and patch kernels now.

Best wishes,

                Pavel
--
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://dce.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
