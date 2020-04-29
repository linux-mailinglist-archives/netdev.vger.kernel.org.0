Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5191BD97C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgD2KWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:22:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:51400 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgD2KWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 06:22:47 -0400
IronPort-SDR: A5n8sHPjzXSV90RQUd8OoPTBisaLaZ/Xn5bHSOwPiYU9gu7iTz/ksO9Ox9gcNbk/qSzPSkRWuh
 O4c0Ux8Z6Q/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 03:22:47 -0700
IronPort-SDR: H4zHciGZTwYi0gg8aA1WCO3C5ckFgJATsv5r/mqRZlt7JSKQc1dSJPRMfxa+/MPcZIYu+qdb96
 9gBzOwzMvdWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,331,1583222400"; 
   d="scan'208";a="282455691"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004.fm.intel.com with ESMTP; 29 Apr 2020 03:22:44 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jTjrb-003hww-3A; Wed, 29 Apr 2020 13:22:47 +0300
Date:   Wed, 29 Apr 2020 13:22:47 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shannon Nelson <snelson@pensando.io>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH 6/6] net: atm: Add annotation for lec_priv_walk()
Message-ID: <20200429102247.GG185537@smile.fi.intel.com>
References: <0/6>
 <20200429100529.19645-1-jbi.octave@gmail.com>
 <20200429100529.19645-7-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429100529.19645-7-jbi.octave@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 11:05:28AM +0100, Jules Irenge wrote:
> Sparse reports a warning at lec_priv_walk()
> warning: context imbalance in lec_priv_walk() - unexpected unlock
> 
> The root cause is the missing annotation at lec_priv_walk()
> To fix this, __acquire() and __release() annotations
> are added in case conditions are not met.
> This only instruct  Sparse to shutdown the warning
> 
> Add the  __acquire(&priv->lec_arp_lock)
> Add __release(&priv->lec_arp_lock) annotation

At least those two I got should be in one patch. Simple fix all same sparse
issues at once.

-- 
With Best Regards,
Andy Shevchenko


