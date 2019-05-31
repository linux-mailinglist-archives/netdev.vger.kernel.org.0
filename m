Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD67A3087E
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 08:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfEaG1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 02:27:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:5659 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfEaG1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 02:27:46 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 23:27:45 -0700
X-ExtLoop1: 1
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.157])
  by fmsmga001.fm.intel.com with SMTP; 30 May 2019 23:27:41 -0700
Received: by lahna (sSMTP sendmail emulation); Fri, 31 May 2019 09:27:40 +0300
Date:   Fri, 31 May 2019 09:27:40 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ruslan Babayev <ruslan@babayev.com>, wsa@the-dreams.de,
        linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next,v4 0/2] Enable SFP on ACPI based systems
Message-ID: <20190531062740.GQ2781@lahna.fi.intel.com>
References: <20190528230233.26772-1-ruslan@babayev.com>
 <20190529094818.GF2781@lahna.fi.intel.com>
 <20190529155132.GZ18059@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529155132.GZ18059@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 05:51:32PM +0200, Andrew Lunn wrote:
> On Wed, May 29, 2019 at 12:48:18PM +0300, Mika Westerberg wrote:
> > On Tue, May 28, 2019 at 04:02:31PM -0700, Ruslan Babayev wrote:
> > > Changes:
> > > v2:
> > > 	- more descriptive commit body
> > > v3:
> > > 	- made 'i2c_acpi_find_adapter_by_handle' static inline
> > > v4:
> > > 	- don't initialize i2c_adapter to NULL. Instead see below...
> > > 	- handle the case of neither DT nor ACPI present as invalid.
> > > 	- alphabetical includes.
> > > 	- use has_acpi_companion().
> > > 	- use the same argument name in i2c_acpi_find_adapter_by_handle()
> > > 	  in both stubbed and non-stubbed cases.
> > > 
> > > Ruslan Babayev (2):
> > >   i2c: acpi: export i2c_acpi_find_adapter_by_handle
> > >   net: phy: sfp: enable i2c-bus detection on ACPI based systems
> > 
> > For the series,
> > 
> > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Hi Mika
> 
> Are you happy for the i2c patch to be merged via net-next?

Yes, that's fine my me.

Wolfram do you have any objections?
