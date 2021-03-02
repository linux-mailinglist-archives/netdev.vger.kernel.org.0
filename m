Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188B132A36C
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444788AbhCBI47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:56:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:13300 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376807AbhCBH5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 02:57:32 -0500
IronPort-SDR: klZKHoWBAVRyCZga7trrLlOav0JWpRjV/PW1oVxfRroRx2fQWvNyF8Gt1JKKUFRZ07JLoBYwUW
 QBrM5WF5kiqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="183326528"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="183326528"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 23:55:30 -0800
IronPort-SDR: u1riAQjEWpeiMCENb62vSylPeEXER4CnjOv3IZUf4AfrVnxuoICCkuyyNe+axElIwj9ASC2fxU
 19GdDSE9oTqg==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="444641353"
Received: from dfuxbrux-desk.ger.corp.intel.com (HELO [10.12.48.255]) ([10.12.48.255])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 23:55:27 -0800
Subject: Re: [Intel-wired-lan] [PATCH net 1/2] e1000e: Fix duplicate include
 guard
To:     Tom Seewald <tseewald@gmail.com>, netdev@vger.kernel.org
Cc:     Auke Kok <auke-jan.h.kok@intel.com>, Jeff Garzik <jeff@garzik.org>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>
References: <20210222040005.20126-1-tseewald@gmail.com>
From:   Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Message-ID: <fedcd02f-d3d3-763f-0032-dc68ca166a3c@linux.intel.com>
Date:   Tue, 2 Mar 2021 09:55:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222040005.20126-1-tseewald@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/02/2021 06:00, Tom Seewald wrote:
> The include guard "_E1000_HW_H_" is used by header files in three
> different drivers (e1000/e1000_hw.h, e1000e/hw.h, and igb/e1000_hw.h).
> Using the same include guard macro in more than one header file may
> cause unexpected behavior from the compiler. Fix the duplicate include
> guard in the e1000e driver by renaming it.
> 
> Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> ---
>   drivers/net/ethernet/intel/e1000e/hw.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
> index 69a2329ea463..db79c4e6413e 100644
> --- a/drivers/net/ethernet/intel/e1000e/hw.h
> +++ b/drivers/net/ethernet/intel/e1000e/hw.h
> @@ -1,8 +1,8 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   /* Copyright(c) 1999 - 2018 Intel Corporation. */
>   
> -#ifndef _E1000_HW_H_
> -#define _E1000_HW_H_
> +#ifndef _E1000E_HW_H_
> +#define _E1000E_HW_H_
>   
>   #include "regs.h"
>   #include "defines.h"
> @@ -714,4 +714,4 @@ struct e1000_hw {
>   #include "80003es2lan.h"
>   #include "ich8lan.h"
>   
> -#endif
> +#endif /* _E1000E_HW_H_ */
> 
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
