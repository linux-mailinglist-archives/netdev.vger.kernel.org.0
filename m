Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D438A3550FF
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242680AbhDFKhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:37:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:8776 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232103AbhDFKhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 06:37:04 -0400
IronPort-SDR: TbL10UJoimYRoRxUNvSyO5EuevaE2tt6Jbij7Nt5vkkItjOQfJ8mfPDK3iqNJtgZb5Ttmty0SB
 h3eOdO3pREVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="193149882"
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="193149882"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 03:36:56 -0700
IronPort-SDR: 3RoG2ebtD2ltte2/CydB+4lqyZ9diFIYqjECb/MlJp9N0Tz2r53RvpBYBwGE0LXTFnWQ7J97OS
 pVhkY/NXV6aA==
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="529762936"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 03:36:55 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lTj4m-001h5V-Eo; Tue, 06 Apr 2021 13:36:52 +0300
Date:   Tue, 6 Apr 2021 13:36:52 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Flavio Suligoi <f.suligoi@asem.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/5] net: pch: fix and a few cleanups
Message-ID: <YGw5xFdczcKGqW1v@smile.fi.intel.com>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
 <YGHuhbe/+9cjPdFH@smile.fi.intel.com>
 <92353220370542c7acdabbd269269d80@asem.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92353220370542c7acdabbd269269d80@asem.it>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 07:46:58AM +0000, Flavio Suligoi wrote:
> Hi Andy,
> ...
> > On Thu, Mar 25, 2021 at 07:34:07PM +0200, Andy Shevchenko wrote:
> > > The series provides one fix (patch 1) for GPIO to be able to wait for
> > > the GPIO driver to appear. This is separated from the conversion to
> > > the GPIO descriptors (patch 2) in order to have a possibility for
> > > backporting. Patches 3 and 4 fix a minor warnings from Sparse while
> > > moving to a new APIs. Patch 5 is MODULE_VERSION() clean up.
> > >
> > > Tested on Intel Minnowboard (v1).
> > 
> > Anything should I do here?
> 
> it's ok for me

Thanks!
Who may apply them?

-- 
With Best Regards,
Andy Shevchenko


