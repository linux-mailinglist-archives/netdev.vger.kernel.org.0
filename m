Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA0635849A
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhDHN0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:26:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:11780 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhDHN0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:26:06 -0400
IronPort-SDR: ww4h/U7+irKCc3YOeupPiEaYX5YFCSIOFv5volLojDWSU+0/9jHr99kM3FgkNulCx6BNb1Ntg7
 mvTYu8fantHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="191383381"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="191383381"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 06:25:54 -0700
IronPort-SDR: b0+IQfi0CGz4Mc2d3UYFsFyAOo1A4WX7GCnqr3djVRrpOc3V97HI8WU+iA47imuouNjaIOytmM
 4c24H3IwfhbA==
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="519851439"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 06:25:53 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lUUfO-002ISp-Ar; Thu, 08 Apr 2021 16:25:50 +0300
Date:   Thu, 8 Apr 2021 16:25:50 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Flavio Suligoi <f.suligoi@asem.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/5] net: pch: fix and a few cleanups
Message-ID: <YG8EXgciWnoG6E1a@smile.fi.intel.com>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
 <YGHuhbe/+9cjPdFH@smile.fi.intel.com>
 <92353220370542c7acdabbd269269d80@asem.it>
 <YGw5xFdczcKGqW1v@smile.fi.intel.com>
 <fe865a23dfd04b7daab5d8325f5eaba2@asem.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe865a23dfd04b7daab5d8325f5eaba2@asem.it>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 09:57:12AM +0000, Flavio Suligoi wrote:
> > > > On Thu, Mar 25, 2021 at 07:34:07PM +0200, Andy Shevchenko wrote:
> > > > > The series provides one fix (patch 1) for GPIO to be able to wait for
> > > > > the GPIO driver to appear. This is separated from the conversion to
> > > > > the GPIO descriptors (patch 2) in order to have a possibility for
> > > > > backporting. Patches 3 and 4 fix a minor warnings from Sparse while
> > > > > moving to a new APIs. Patch 5 is MODULE_VERSION() clean up.
> > > > >
> > > > > Tested on Intel Minnowboard (v1).
> > > >
> > > > Anything should I do here?
> > >
> > > it's ok for me
> > 
> > Thanks!
> > Who may apply them?
> 
> I used your patches on kernel net-next 5.12.0-rc2, on a board with an
> Intel(R) Atom(TM) CPU E640   @ 1.00GHz and an EG20T PCH.
> I used the built-in OKI gigabit ethernet controller:
> 
> 02:00.1 Ethernet controller: Intel Corporation Platform Controller Hub EG20T Gigabit Ethernet Controller (rev 02)
> 	Kernel driver in use: pch_gbe
> 
> with a simple iperf test and all works fine:

> I hope this can help you.

> Tested-by: Flavio Suligoi <f.suligoi@asem.it>

Thank you, Flavio, very much!

Jesse, Jakub, David. can this be applied, please?

-- 
With Best Regards,
Andy Shevchenko


