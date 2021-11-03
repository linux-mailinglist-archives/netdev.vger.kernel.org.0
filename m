Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03E8444761
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhKCRmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:42:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:37473 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230156AbhKCRmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 13:42:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="255188797"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="255188797"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 10:39:55 -0700
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="585274566"
Received: from smile.fi.intel.com ([10.237.72.184])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 10:39:50 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1miKEZ-003KOE-4t;
        Wed, 03 Nov 2021 19:39:35 +0200
Date:   Wed, 3 Nov 2021 19:39:34 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v3 0/2] mwifiex: Add quirk to disable deep sleep with
 certain hardware revision
Message-ID: <YYLJVoR9egoPpmLv@smile.fi.intel.com>
References: <20211103171055.16911-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211103171055.16911-1-verdre@v0yd.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 06:10:53PM +0100, Jonas Dreßler wrote:
> Third revision of this patch.
> v1: https://lore.kernel.org/linux-wireless/20211028073729.24408-1-verdre@v0yd.nl/T/
> v2: https://lore.kernel.org/linux-wireless/20211103135529.8537-1-verdre@v0yd.nl/T/

With one comment addressed
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks for continuing fixing this crappy SW+FW.

> Changes between v2 and v3:
>  - Remove redundant sizeof(char) in the second patch
> 
> Jonas Dreßler (2):
>   mwifiex: Use a define for firmware version string length
>   mwifiex: Add quirk to disable deep sleep with certain hardware
>     revision
> 
>  drivers/net/wireless/marvell/mwifiex/fw.h     |  4 ++-
>  drivers/net/wireless/marvell/mwifiex/main.c   | 18 +++++++++++++
>  drivers/net/wireless/marvell/mwifiex/main.h   |  3 ++-
>  .../wireless/marvell/mwifiex/sta_cmdresp.c    | 25 +++++++++++++++++--
>  4 files changed, 46 insertions(+), 4 deletions(-)
> 
> -- 
> 2.33.1
> 

-- 
With Best Regards,
Andy Shevchenko


