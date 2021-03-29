Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6466B34D378
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhC2PNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:13:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:39095 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhC2PNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 11:13:14 -0400
IronPort-SDR: I/FmzDCJFuG3Gsd+Yvd9pqHiuQPNVPojfKEk17z/089KM1qKH97UVBFdfJVmFCFoM/Eqp8sMhI
 WNQk6A2+/3fA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="191665753"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="191665753"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 08:13:13 -0700
IronPort-SDR: fkCByWOrxFy1drNkS52eqVwT6GY1eGLLcjvnnMvIL1Asm6oPYX8g2AQ866oiXirJmtIa1GkirZ
 Avi0CQ4bTH7A==
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="516057076"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 08:13:12 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lQtZl-00H3LS-8N; Mon, 29 Mar 2021 18:13:09 +0300
Date:   Mon, 29 Mar 2021 18:13:09 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Flavio Suligoi <f.suligoi@asem.it>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 0/5] net: pch: fix and a few cleanups
Message-ID: <YGHuhbe/+9cjPdFH@smile.fi.intel.com>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 07:34:07PM +0200, Andy Shevchenko wrote:
> The series provides one fix (patch 1) for GPIO to be able to wait for
> the GPIO driver to appear. This is separated from the conversion to
> the GPIO descriptors (patch 2) in order to have a possibility for
> backporting. Patches 3 and 4 fix a minor warnings from Sparse while
> moving to a new APIs. Patch 5 is MODULE_VERSION() clean up.
> 
> Tested on Intel Minnowboard (v1).

Anything should I do here?

-- 
With Best Regards,
Andy Shevchenko


