Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4501BE0BF
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgD2OWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:22:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:2447 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgD2OWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:22:52 -0400
IronPort-SDR: ddIyjzvcB8w0uI64c2EH6wT5U6HAzdX8pFnDzATEN9YpqFwMK06TJMDvyQ99K4hpNFf6XvRbZn
 6Ox1T/fxpvxQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 07:22:51 -0700
IronPort-SDR: LewOahKZhx0sn+cAkxy5DPIPD5ioJPKN91mYfHiyAhJgNQqzdLT3xtPMdU0LITnlc0fXmK3I9L
 Ll8ufsaZ0K/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="293215157"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2020 07:22:49 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jTnbw-003jji-Bu; Wed, 29 Apr 2020 17:22:52 +0300
Date:   Wed, 29 Apr 2020 17:22:52 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 1/5] stmmac: intel: Check return value of
 clk_prepare_enable()
Message-ID: <20200429142252.GK185537@smile.fi.intel.com>
References: <20200429140449.9484-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429140449.9484-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 05:04:45PM +0300, Andy Shevchenko wrote:
> clk_prepare_enable() might fail, we have to check its returned value.
> 
> While at it, remove leftover in stmmac_pci, also remove unneeded condition
> for NULL-aware clk_unregister_fixed_rate() call and call it when
> stmmac_dvr_probe() fails.

Please, ignore this series. It appears that there is one more issue with proper
error handling. I'll send v2 soon after additional testing.

-- 
With Best Regards,
Andy Shevchenko


