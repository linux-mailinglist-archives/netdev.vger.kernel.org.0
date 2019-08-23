Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF9D9B55A
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 19:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388934AbfHWRUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 13:20:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:58706 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732886AbfHWRUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 13:20:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 10:20:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="379820434"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by fmsmga006.fm.intel.com with ESMTP; 23 Aug 2019 10:20:09 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i1DEN-0007xv-Fm; Fri, 23 Aug 2019 20:20:07 +0300
Date:   Fri, 23 Aug 2019 20:20:07 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sedat Dilek <sedat.dilek@credativ.de>
Cc:     =?iso-8859-1?Q?Cl=E9ment?= Perrochaud 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH v4 00/14] NFC: nxp-nci: clean up and new device support
Message-ID: <20190823172007.GW30120@smile.fi.intel.com>
References: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
 <892584913.468.1566336479573@ox.credativ.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <892584913.468.1566336479573@ox.credativ.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 11:27:59PM +0200, Sedat Dilek wrote:
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> hat am 29. Juli 2019 15:35 geschrieben:

> I gave that patchset v4 a try against Linux v5.3-rc5.
> 
> And played with neard and neard-tools v0.16-0.1 from Debian/buster AMD64.
> 
> # nfctool --list
> 
> # nfctool --enable --device=nfc0
> 
> # nfctool --list --device=nfc0
> nfc0:
>           Tags: [ tag11 ]
>           Devices: [ ]
>           Protocols: [ Felica MIFARE Jewel ISO-DEP NFC-DEP ]
>           Powered: Yes
>           RF Mode: Initiator
>           lto: 0
>           rw: 0
>           miux: 0
> 
> # nfctool --device=nfc0 --poll=Both --sniff --dump-symm
> Start sniffer on nfc0
> 
> Start polling on nfc0 as both initiator and target
> 
> Targets found for nfc0
>   Tags: [ tag11 ]
>   Devices: [ ]
> 
> But I see in the logs:
> 
> # journalctl -u neard.service -f
> Aug 20 23:01:15 iniza neard[6158]: Error while reading NFC bytes
> 
> What does this error mean?
> How can I get more informations?
> Can you aid with debugging help?

Unfortunately I have no idea about user space tools.
But I think neard has to be updated to match kernel somehow.

-- 
With Best Regards,
Andy Shevchenko


