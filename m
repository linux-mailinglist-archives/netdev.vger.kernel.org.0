Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5A63F86B6
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242331AbhHZLvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:51:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:45624 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242100AbhHZLvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 07:51:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="281443945"
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="281443945"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 04:50:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="465099620"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 26 Aug 2021 04:50:21 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 719855805A3;
        Thu, 26 Aug 2021 04:50:17 -0700 (PDT)
Date:   Thu, 26 Aug 2021 19:50:14 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: pcs: xpcs: enable skip xPCS soft reset
Message-ID: <20210826115014.GA5112@linux.intel.com>
References: <20210809102229.933748-1-vee.khee.wong@linux.intel.com>
 <20210809102229.933748-2-vee.khee.wong@linux.intel.com>
 <YREvDRkiuScyN8Ws@lunn.ch>
 <20210810235529.GB30818@linux.intel.com>
 <f2a1f135-b77a-403d-5d2e-c497efc99df7@gmail.com>
 <YRPcyHTc2FJeEoqk@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRPcyHTc2FJeEoqk@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 04:20:56PM +0200, Andrew Lunn wrote:
> > > BIOS does configured the SerDes. The problem here is that all the
> > > configurations done by BIOS are being reset at xpcs_create().
> > > 
> > > We would want user of the pcs-xpcs module (stmmac, sja1105) to have
> > > control whether or not we need to perform to the soft reset in the
> > > xpcs_create() call.
> > 
> > I understood Andrew's response as suggesting to introduce the ability for
> > xpcs_create() to make a BIOS call which would configure the SerDes after
> > xpcs_soft_reset().
> 
> Yes. Exactly. That is what ACPI is for, so we should use it for this.
> 
>      Andrew

Thanks Florian for the explaination.

I have checked with the BIOS developers and they did not implmenet a
method to this at the kernel level.

Also, Intel AlderLake has both UEFI BIOS and Slim Bootloader which
make it least feasible to go for the ACPI method as per suggested.


Regards,
  VK
