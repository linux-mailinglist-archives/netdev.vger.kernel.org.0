Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E2F3E3114
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 23:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhHFVZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 17:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240338AbhHFVZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 17:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4064360EE8;
        Fri,  6 Aug 2021 21:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628285093;
        bh=OJXVvQV1lg0BTpnm4/Nv7ym7sLl0HIhqKTRdfOznYwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=goH/1yJM9CgOOo+OcwLI85KOcKMTJKy8qsbi9kmA/eUKLp96x9J8M/JAw+C0HoXtl
         LLP9C54GqLgkjnKpGR9kkrYUXUKz/g5bCUA/CpaOzR6XQzlUTgr5y3Dk7zGrmBxX8N
         en5fOF69mFY7iz78CR1nGEcyNekjfw/CZ0EQbDXeU3Hh82nmIhL0nXS2kQ3mhduoVP
         XswzHNEybaPpFHtw5KHBi3RP5f5dPsW9v9eFEsYvxzj76KiOdi8Bw4rMEV5B6PvQ1z
         CLKL2wH1wGanKV5ZinDF8ZSKormkVT85L0UCSY8TizkDvEv+r8Jkclod/etLJWRRFl
         2rifLx8uQfKtA==
Date:   Fri, 6 Aug 2021 16:24:52 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Russell Currey <ruscur@russell.cc>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        oss-drivers@corigine.com, Paul Mackerras <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-perf-users@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Ido Schimmel <idosch@nvidia.com>, x86@kernel.org,
        qat-linux@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        xen-devel@lists.xenproject.org, Vadym Kochan <vkochan@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 0/6] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
Message-ID: <20210806212452.GA1867870@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210806064623.3lxl4clzbjpmchef@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 08:46:23AM +0200, Uwe Kleine-König wrote:
> On Thu, Aug 05, 2021 at 06:42:34PM -0500, Bjorn Helgaas wrote:

> > I looked at all the bus_type.probe() methods, it looks like pci_dev is
> > not the only offender here.  At least the following also have a driver
> > pointer in the device struct:
> > 
> >   parisc_device.driver
> >   acpi_device.driver
> >   dio_dev.driver
> >   hid_device.driver
> >   pci_dev.driver
> >   pnp_dev.driver
> >   rio_dev.driver
> >   zorro_dev.driver
> 
> Right, when I converted zorro_dev it was pointed out that the code was
> copied from pci and the latter has the same construct. :-)
> See
> https://lore.kernel.org/r/20210730191035.1455248-5-u.kleine-koenig@pengutronix.de
> for the patch, I don't find where pci was pointed out, maybe it was on
> irc only.

Oh, thanks!  I looked to see if you'd done something similar
elsewhere, but I missed this one.

> > Looking through the places that care about pci_dev.driver (the ones
> > updated by patch 5/6), many of them are ... a little dubious to begin
> > with.  A few need the "struct pci_error_handlers *err_handler"
> > pointer, so that's probably legitimate.  But many just need a name,
> > and should probably be using dev_driver_string() instead.
> 
> Yeah, I considered adding a function to get the driver name from a
> pci_dev and a function to get the error handlers. Maybe it's an idea to
> introduce these two and then use to_pci_driver(pdev->dev.driver) for the
> few remaining users? Maybe doing that on top of my current series makes
> sense to have a clean switch from pdev->driver to pdev->dev.driver?!

I'd propose using dev_driver_string() for these places:

  eeh_driver_name() (could change callers to use dev_driver_string())
  bcma_host_pci_probe()
  qm_alloc_uacce()
  hns3_get_drvinfo()
  prestera_pci_probe()
  mlxsw_pci_probe()
  nfp_get_drvinfo()
  ssb_pcihost_probe()

The use in mpt_device_driver_register() looks unnecessary: it's only
to get a struct pci_device_id *, which is passed to ->probe()
functions that don't need it.

The use in adf_enable_aer() looks wrong: it sets the err_handler
pointer in one of the adf_driver structs.  I think those structs
should be basically immutable, and the drivers that call
adf_enable_aer() from their .probe() methods should set
".err_handler = &adf_err_handler" in their static adf_driver
definitions instead.

I think that basically leaves these:

  uncore_pci_probe()     # .id_table, custom driver "registration"
  match_id()             # .id_table, arch/x86/kernel/probe_roms.c
  xhci_pci_quirks()      # .id_table
  pci_error_handlers()   # roll-your-own AER handling, drivers/misc/cxl/guest.c

I think it would be fine to use to_pci_driver(pdev->dev.driver) for
these few.

Bjorn
