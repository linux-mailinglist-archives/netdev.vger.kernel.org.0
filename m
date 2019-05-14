Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC90F1C68C
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 12:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfENKCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 06:02:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:40377 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfENKCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 06:02:13 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 03:02:12 -0700
X-ExtLoop1: 1
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.86])
  by fmsmga006.fm.intel.com with ESMTP; 14 May 2019 03:02:10 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1hQUGA-0006BG-MG; Tue, 14 May 2019 13:02:10 +0300
Date:   Tue, 14 May 2019 13:02:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] NFC: Orphan the subsystem
Message-ID: <20190514100210.GA9224@smile.fi.intel.com>
References: <20190514090231.32414-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514090231.32414-1-johannes@sipsolutions.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 11:02:31AM +0200, Johannes Berg wrote:
> Samuel clearly hasn't been working on this in many years and
> patches getting to the wireless list are just being ignored
> entirely now. Mark the subsystem as orphan to reflect the
> current state and revert back to the netdev list so at least
> some fixes can be picked up by Dave.

Good to know.

But Samuel was active like year ago and he is still at Intel, right?
Perhaps he can appear last time here to Ack this?

> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  MAINTAINERS | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fb9f9d71f7a2..b2659312e9ed 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11028,10 +11028,8 @@ S:	Supported
>  F:	drivers/net/ethernet/qlogic/netxen/
>  
>  NFC SUBSYSTEM
> -M:	Samuel Ortiz <sameo@linux.intel.com>
> -L:	linux-wireless@vger.kernel.org
> -L:	linux-nfc@lists.01.org (subscribers-only)
> -S:	Supported
> +L:	netdev@vger.kernel.org
> +S:	Orphan
>  F:	net/nfc/
>  F:	include/net/nfc/
>  F:	include/uapi/linux/nfc.h
> -- 
> 2.17.2
> 

-- 
With Best Regards,
Andy Shevchenko


