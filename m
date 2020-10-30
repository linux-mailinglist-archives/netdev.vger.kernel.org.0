Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9317D2A0391
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgJ3LBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:01:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:34435 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3LBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:01:48 -0400
IronPort-SDR: /61smBNGFYchOgLduukY55Po0IeEdJ9Np1z31MSQkVgCu478k5fXXu533O2cKxmJuPqpS1iBU7
 10PNOgjcL3XA==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="168720443"
X-IronPort-AV: E=Sophos;i="5.77,433,1596524400"; 
   d="scan'208";a="168720443"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 04:01:47 -0700
IronPort-SDR: xD7lJ1F3cGaAArwBy4nhHOhgWd1SNAn6GSQHuPUMRWYdqpgq4GUVPBUv3iovq8+aSsGXmkwlhm
 aOT9/2Pb3n1g==
X-IronPort-AV: E=Sophos;i="5.77,433,1596524400"; 
   d="scan'208";a="525853665"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 04:01:44 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1kYSBC-001xuI-S7; Fri, 30 Oct 2020 13:02:46 +0200
Date:   Fri, 30 Oct 2020 13:02:46 +0200
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     Tsuchiya Yuto <kitakar@gmail.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>, verdre@v0yd.nl
Subject: Re: [PATCH 2/3] mwifiex: add allow_ps_mode module parameter
Message-ID: <20201030110246.GM4077@smile.fi.intel.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
 <20201028142433.18501-3-kitakar@gmail.com>
 <CA+ASDXMXoyOr9oHBjtXZ1w9XxDggv+=XS4nwn0qKWCHQ3kybdw@mail.gmail.com>
 <837d7ecd6f8a810153d219ec0b4995856abbe458.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <837d7ecd6f8a810153d219ec0b4995856abbe458.camel@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 04:58:33PM +0900, Tsuchiya Yuto wrote:
> On Wed, 2020-10-28 at 15:04 -0700, Brian Norris wrote:

...

> On the other hand, I agree that I don't want to break the existing users.
> As you mentioned in the reply to the first patch, I can set the default
> value of this parameter depending on the chip id (88W8897) or DMI matching.

Since it's a PCIe device you already have ID table where you may add a
driver_data with what ever quirks are needed.

-- 
With Best Regards,
Andy Shevchenko


