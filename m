Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654C6248E66
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgHRTDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:03:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:3692 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHRTDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 15:03:22 -0400
IronPort-SDR: yAgxTOfvUCxp7LBcaogGbdzH3qtz9o+v11mGfyj2ytio6TYSYmHKMwxdmALssbKYJ1s4f04Yrc
 PLfaPL45QaWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="134508440"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="134508440"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 12:03:21 -0700
IronPort-SDR: oY7DktAw2xmecMxxy3jIOaMbaMOWnvdOmp4uMBMi+kTKL+1/8/TZYZqymWSFnyF1ppESvT4dhO
 cd1kRd4JUvyQ==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="279479355"
Received: from ammccann-mobl.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 12:03:21 -0700
Date:   Tue, 18 Aug 2020 12:03:19 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net 4/4] sfc: don't free_irq()s if they were never
 requested
Message-ID: <20200818120319.00001d7b@intel.com>
In-Reply-To: <94cf6748-2adb-a85b-9d95-c2dc02fe586e@solarflare.com>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
        <94cf6748-2adb-a85b-9d95-c2dc02fe586e@solarflare.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote:

> If efx_nic_init_interrupt fails, or was never run (e.g. due to an earlier
>  failure in ef100_net_open), freeing irqs in efx_nic_fini_interrupt is not
>  needed and will cause error messages and stack traces.
> So instead, only do this if efx_nic_init_interrupt successfully completed,
>  as indicated by the new efx->irqs_hooked flag.
> 
> Fixes: 965b549f3c20 ("sfc_ef100: implement ndo_open/close and EVQ probing")
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Makes sense.
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
