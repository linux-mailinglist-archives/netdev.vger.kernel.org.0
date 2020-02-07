Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CD9155EED
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 20:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgBGTw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 14:52:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:38250 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgBGTw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 14:52:57 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 11:52:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="255512161"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004.fm.intel.com with ESMTP; 07 Feb 2020 11:52:53 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1j09gM-0003xV-DU; Fri, 07 Feb 2020 21:52:54 +0200
Date:   Fri, 7 Feb 2020 21:52:54 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        christopher.s.hall@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        jacob.e.keller@intel.com,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 5/5] drivers/ptp: Add PMC Time-Aware
 GPIO Driver
Message-ID: <20200207195254.GN10400@smile.fi.intel.com>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-6-christopher.s.hall@intel.com>
 <CACRpkdbi7q5Vr2Lt12eirs3Z8GLL2AuLLrAARCHkYEYgKbYkHg@mail.gmail.com>
 <20200207172844.GC19213@lunn.ch>
 <20200207194951.GM10400@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207194951.GM10400@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 07, 2020 at 09:49:51PM +0200, Andy Shevchenko wrote:
> On Fri, Feb 07, 2020 at 06:28:44PM +0100, Andrew Lunn wrote:
> > On Fri, Feb 07, 2020 at 06:10:46PM +0100, Linus Walleij wrote:
> > > OK this looks like some GPIO registers...
> > > 
> > > Then there is a bunch of PTP stuff I don't understand I suppose
> > > related to the precision time protocol.
> > 
> > Hi Linus
> > 
> > I understand your confusion. The first time this was posted to netdev,
> > i asked it to be renamed because it has very little to do with GPIO
> > 
> > https://lore.kernel.org/netdev/20190719132021.GC24930@lunn.ch/
> 
> And besides that I didn't see it in internal review list, so, it needs to be
> very carefully reviewed. I already saw some not good formatted and questionable
> code.

Just to have some evidences.

The entire function
  static const plat_acpi_resource *find_plat_acpi_resource (struct platform_device *pdev, int *n_pins)
brings a lot of questions.

  MODULE_ALIAS("acpi*:INTC1021:*");
What is this?!

And so on...

-- 
With Best Regards,
Andy Shevchenko


