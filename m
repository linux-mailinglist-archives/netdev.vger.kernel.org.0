Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F90235202
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 14:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgHAMV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 08:21:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:54230 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbgHAMV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 08:21:56 -0400
IronPort-SDR: ZPZH3po8kX4vPtstcafHFaBHIFGM6uhz2Co8L7t+VsobM0y+oL/pu7QOgPqsyiUoB/hI5niPmi
 A+NPE3HRgN8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="213463749"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="213463749"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 05:21:56 -0700
IronPort-SDR: Hr8Kx0HQXfVtdnK5LlSLagfWsEYrQp8QcLTCgEZsTQdBOUl8V3ugF3f2tcxGE8mAoJQrq/nEYB
 SuRqNEdXANXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="323542918"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga002.fm.intel.com with ESMTP; 01 Aug 2020 05:21:54 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1k1qWP-005Vvn-UJ; Sat, 01 Aug 2020 15:21:53 +0300
Date:   Sat, 1 Aug 2020 15:21:53 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] qed: Use %pM format specifier for MAC addresses
Message-ID: <20200801122153.GQ3703480@smile.fi.intel.com>
References: <SKiAD0R1iJX4FHbr-_GUICKdDvuTvqrJjcR2CQEpE_-GCYtJq-lLbDeec-WmOCZ6NIxW6rca1CRm-d1tSRUu2zFyAapHAjvmgvI5iN6Zvp8=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SKiAD0R1iJX4FHbr-_GUICKdDvuTvqrJjcR2CQEpE_-GCYtJq-lLbDeec-WmOCZ6NIxW6rca1CRm-d1tSRUu2zFyAapHAjvmgvI5iN6Zvp8=@pm.me>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 04:26:17PM +0000, Alexander Lobakin wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date: Thu, 30 Jul 2020 18:59:20 +0300
> 
> > Convert to %pM instead of using custom code.

> Thanks!
> 
> Acked-by: Alexander Lobakin <alobakin@pm.me>

Thanks, but no-one sees this properly (seems broken message-id -> in-reply-to
chain). You have to fix your email.

-- 
With Best Regards,
Andy Shevchenko


