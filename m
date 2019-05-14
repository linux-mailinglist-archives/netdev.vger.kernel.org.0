Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B380A1CB94
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfENPPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:15:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:1983 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfENPPm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 11:15:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 08:15:41 -0700
X-ExtLoop1: 1
Received: from amitc-mobl.amr.corp.intel.com (HELO caravaggio) ([10.254.27.243])
  by fmsmga004.fm.intel.com with ESMTP; 14 May 2019 08:15:41 -0700
Date:   Tue, 14 May 2019 17:15:14 +0200
From:   Samuel Ortiz <sameo@linux.intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] NFC: Orphan the subsystem
Message-ID: <20190514151514.GA4346@caravaggio>
References: <20190514090231.32414-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514090231.32414-1-johannes@sipsolutions.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On Tue, May 14, 2019 at 11:02:31AM +0200, Johannes Berg wrote:
> Samuel clearly hasn't been working on this in many years and
> patches getting to the wireless list are just being ignored
> entirely now. Mark the subsystem as orphan to reflect the
> current state and revert back to the netdev list so at least
> some fixes can be picked up by Dave.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I meant to do that for many months now but did not find time to push it
to the top of my TODO. Thanks.

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

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
