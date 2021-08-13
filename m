Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E37F3EBBAD
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhHMRts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:49:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:31878 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhHMRtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 13:49:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="215594812"
X-IronPort-AV: E=Sophos;i="5.84,319,1620716400"; 
   d="scan'208";a="215594812"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 10:48:51 -0700
X-IronPort-AV: E=Sophos;i="5.84,319,1620716400"; 
   d="scan'208";a="470149063"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 10:48:50 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mEbIR-009M9C-Mw; Fri, 13 Aug 2021 20:48:43 +0300
Date:   Fri, 13 Aug 2021 20:48:43 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kbuild-all@lists.01.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net-next 3/3] ptp_ocp: use bits.h macros for all masks
Message-ID: <YRaweyNQDoaMY2bk@smile.fi.intel.com>
References: <20210813122737.45860-3-andriy.shevchenko@linux.intel.com>
 <202108140106.K9cVluxn-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202108140106.K9cVluxn-lkp@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 01:35:13AM +0800, kernel test robot wrote:
> Hi Andy,
> 
> I love your patch! Perhaps something to improve:

Not in my patches.

-- 
With Best Regards,
Andy Shevchenko


