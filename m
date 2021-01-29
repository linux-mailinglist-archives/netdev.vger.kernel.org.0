Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31C308A72
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhA2Qi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:38:59 -0500
Received: from mail-ot1-f54.google.com ([209.85.210.54]:33549 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhA2Qij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:38:39 -0500
Received: by mail-ot1-f54.google.com with SMTP id 63so9183006oty.0;
        Fri, 29 Jan 2021 08:38:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yo+UnI3asEDx3wQagFoNSo48d6iNCcAeofFLaX+Rbpg=;
        b=TxzIMabWlaXrADQOsnsptQ56TEse+jdaQyExn2LfuHtxGrwYBdVFG0vFSX7NbmR6qo
         eLAFrQnV+soNt2EV9vI7CrdcVFr3AwglMWkU6QdImG2WN78eaFMgIJaK5SpLWEgja8O3
         ppMtZTRj+PGZvJG8LAUv2MeufQZfsz+UJSt1+f7yh/uXM7G7OeClKzWL0DOyCbKXlZZc
         zE+BIK4W5u+dKVnpOv9YnEsq+rnRvqKCHprOAxQnOT6bfZYov6P2lSVCR84ebwtf2gyY
         9JPw3IFYUnfF6CbFvEv20fn9r2PE8cpvtR6J8qfNCO0f07p89wkwLzSmad82mqFXTMLQ
         tmow==
X-Gm-Message-State: AOAM5307MNYRayJ2MSbpjLacWLmRzA+pPtltSudW4Yt/MA2CNrjcf29s
        Kn+LDKmhuq3WTwO5ZOIjA6NUGBOalk2l+fD1RkM=
X-Google-Smtp-Source: ABdhPJxgf0sJ5HPAtEF+5FN4u/sSQlAPYoCyji0nqaaynjhRbquiHqVZK39cTpiMdklkj0gEm+MYVNNbWLn6eXY/Tpw=
X-Received: by 2002:a05:6830:2313:: with SMTP id u19mr3479681ote.321.1611938276935;
 Fri, 29 Jan 2021 08:37:56 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-2-calvin.johnson@oss.nxp.com> <CAJZ5v0iX3uU36448ALA20hiVk968VKTsvgwLrp8ur96MQo3Acw@mail.gmail.com>
 <20210128112729.GA28413@lsv03152.swis.in-blr01.nxp.com> <CAJZ5v0id1i57K_=7eiK0cpOE6UtsKNfR7L7UEBcN1=G+WS+1TA@mail.gmail.com>
 <20210128131205.GA7882@lsv03152.swis.in-blr01.nxp.com> <CAJZ5v0j1XVSyFa1q4RZ=FnSmfR5VOyX+u1uWBWdvTOVBJJ-JXw@mail.gmail.com>
 <20210129064739.GA24267@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20210129064739.GA24267@lsv03152.swis.in-blr01.nxp.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 29 Jan 2021 17:37:45 +0100
Message-ID: <CAJZ5v0hrG_-_3LLb956TdFO830DaPv6NdobKetXrc9H+u9bdgw@mail.gmail.com>
Subject: Re: [net-next PATCH v4 01/15] Documentation: ACPI: DSD: Document MDIO PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 7:48 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> On Thu, Jan 28, 2021 at 02:27:00PM +0100, Rafael J. Wysocki wrote:
> > On Thu, Jan 28, 2021 at 2:12 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:
> > >
> > > On Thu, Jan 28, 2021 at 01:00:40PM +0100, Rafael J. Wysocki wrote:
> > > > On Thu, Jan 28, 2021 at 12:27 PM Calvin Johnson
> > > > <calvin.johnson@oss.nxp.com> wrote:
> > > > >
> > > > > Hi Rafael,
> > > > >
> > > > > Thanks for the review. I'll work on all the comments.
> > > > >
> > > > > On Fri, Jan 22, 2021 at 08:22:21PM +0100, Rafael J. Wysocki wrote:
> > > > > > On Fri, Jan 22, 2021 at 4:43 PM Calvin Johnson
> > > > > > <calvin.johnson@oss.nxp.com> wrote:
> > > > > > >
> > > > > > > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > > > > > > provide them to be connected to MAC.
> > > > > > >
> > > > > > > Describe properties "phy-handle" and "phy-mode".
> > > > > > >
> > > > > > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > > > > > ---
> > > > > > >
> > > > > > > Changes in v4:
> > > > > > > - More cleanup
> > > > > >
> > > > > > This looks much better that the previous versions IMV, some nits below.
> > > > > >
> > > > > > > Changes in v3: None
> > > > > > > Changes in v2:
> > > > > > > - Updated with more description in document
> > > > > > >
> > > > > > >  Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
> > > > > > >  1 file changed, 129 insertions(+)
> > > > > > >  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > > > >
> > > > > > > diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..76fca994bc99
> > > > > > > --- /dev/null
> > > > > > > +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > > > > @@ -0,0 +1,129 @@
> > > > > > > +.. SPDX-License-Identifier: GPL-2.0
> > > > > > > +
> > > > > > > +=========================
> > > > > > > +MDIO bus and PHYs in ACPI
> > > > > > > +=========================
> > > > > > > +
> > > > > > > +The PHYs on an MDIO bus [1] are probed and registered using
> > > > > > > +fwnode_mdiobus_register_phy().
> > > > > >
> > > > > > Empty line here, please.
> > > > > >
> > > > > > > +Later, for connecting these PHYs to MAC, the PHYs registered on the
> > > > > > > +MDIO bus have to be referenced.
> > > > > > > +
> > > > > > > +The UUID given below should be used as mentioned in the "Device Properties
> > > > > > > +UUID For _DSD" [2] document.
> > > > > > > +   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> > > > > >
> > > > > > I would drop the above paragraph.
> > > > > >
> > > > > > > +
> > > > > > > +This document introduces two _DSD properties that are to be used
> > > > > > > +for PHYs on the MDIO bus.[3]
> > > > > >
> > > > > > I'd say "for connecting PHYs on the MDIO bus [3] to the MAC layer."
> > > > > > above and add the following here:
> > > > > >
> > > > > > "These properties are defined in accordance with the "Device
> > > > > > Properties UUID For _DSD" [2] document and the
> > > > > > daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> > > > > > Data Descriptors containing them."
> > > > > >
> > > > > > > +
> > > > > > > +phy-handle
> > > > > > > +----------
> > > > > > > +For each MAC node, a device property "phy-handle" is used to reference
> > > > > > > +the PHY that is registered on an MDIO bus. This is mandatory for
> > > > > > > +network interfaces that have PHYs connected to MAC via MDIO bus.
> > > > > > > +
> > > > > > > +During the MDIO bus driver initialization, PHYs on this bus are probed
> > > > > > > +using the _ADR object as shown below and are registered on the MDIO bus.
> > > > > >
> > > > > > Do you want to mention the "reg" property here?  I think it would be
> > > > > > useful to do that.
> > > > >
> > > > > No. I think we should adhere to _ADR in MDIO case. The "reg" property for ACPI
> > > > > may be useful for other use cases that Andy is aware of.
> > > >
> > > > The code should reflect this, then.  I mean it sounds like you want to
> > > > check the "reg" property only if this is a non-ACPI node.
> > >
> > > Right. For MDIO case, that is what is required.
> > > "reg" for DT and "_ADR" for ACPI.
> > >
> > > However, Andy pointed out [1] that ACPI nodes can also hold reg property and
> > > therefore, fwnode_get_id() need to be capable to handling that situation as
> > > well.
> >
> > No, please don't confuse those two things.
> >
> > Yes, ACPI nodes can also hold a "reg" property, but the meaning of it
> > depends on the binding which is exactly my point: _ADR is not a
> > fallback replacement for "reg" in general and it is not so for MDIO
> > too.  The new function as proposed doesn't match the MDIO requirements
> > and so it should not be used for MDIO.
> >
> > For MDIO, the exact flow mentioned above needs to be implemented (and
> > if someone wants to use it for their use case too, fine).
> >
> > Otherwise the code wouldn't match the documentation.
>
> In that case, is this good?

It would work, but I would introduce a wrapper around the _ADR
evaluation, something like:

int acpi_get_local_address(acpi_handle handle, u32 *addr)
{
      unsigned long long adr;
      acpi_status status;

      status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &adr);
      if (ACPI_FAILURE(status))
                return -ENODATA;

      *addr = (u32)adr;
      return 0;
}

in drivers/acpi/utils.c and add a static inline stub always returning
-ENODEV for it for !CONFIG_ACPI.

> /**
>  * fwnode_get_local_addr - Get the local address of fwnode.
>  * @fwnode: firmware node
>  * @addr: addr value contained in the fwnode
>  *
>  * For DT, retrieve the value of the "reg" property for @fwnode.
>  *
>  * In the ACPI case, evaluate the _ADR object located under the
>  * given node, if present, and provide its return value to the
>  * caller.
>  *
>  * Return 0 on success or a negative error code.
>  */
> int fwnode_get_local_addr(struct fwnode_handle *fwnode, u32 *addr)
> {
>         int ret;
>
>         if (is_of_node(fwnode))
>                 return of_property_read_u32(to_of_node(fwnode), "reg", addr);

So you can write the below as

if (is_acpi_device_node(fwnode))
    return acpi_get_local_address(ACPI_HANDLE_FWNODE(fwnode), addr);

return -EINVAL;

and this should compile just fine if CONFIG_ACPI is unset, so you can
avoid the whole #ifdeffery in this function.

>
> #ifdef CONFIG_ACPI
>         if (is_acpi_node(fwnode)) {
>                 unsigned long long adr;
>                 acpi_status status;
>
>                 status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
>                                                METHOD_NAME__ADR, NULL, &adr);
>                 if (ACPI_FAILURE(status))
>                         return -ENODATA;
>                 *addr = (u32)adr;
>                 return 0;
>         }
> #endif
>         return -EINVAL;
> }
