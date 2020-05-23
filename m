Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56831DF56D
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 09:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387671AbgEWHNY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 23 May 2020 03:13:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:65370 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387629AbgEWHNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 03:13:24 -0400
IronPort-SDR: ZS6BuM18XPgi2YKt8tfMOZJWg88shlZdckae1uKs1dFbRnGLmekHa22cmupQbD3pGS4PwqWX+n
 YrJTREUxJgJA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2020 00:13:23 -0700
IronPort-SDR: kW7MfcJBvs7Q20BttedynMMJZnzALUVX2POm3hsF8R8elQH2oIauFXX5Ca6JXjTbmNQe7mxgNx
 FD4dQl7f9aGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="441120808"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga005.jf.intel.com with ESMTP; 23 May 2020 00:13:22 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 23 May 2020 00:13:22 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.32]) with mapi id 14.03.0439.000;
 Sat, 23 May 2020 00:13:22 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Hari <harichandrakanthan@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] Fix typo in the comment
Thread-Topic: [Intel-wired-lan] [PATCH] Fix typo in the comment
Thread-Index: AQHWMIAROEHnu2n/tUy7sUnJiKhNsai1Qc8w
Date:   Sat, 23 May 2020 07:13:21 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986D1159@ORSMSX112.amr.corp.intel.com>
References: <20200522103024.9697-1-harichandrakanthan@gmail.com>
In-Reply-To: <20200522103024.9697-1-harichandrakanthan@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Hari
> Sent: Friday, May 22, 2020 03:30
> To: davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; linux-
> kernel@vger.kernel.org; Hari <harichandrakanthan@gmail.com>
> Subject: [Intel-wired-lan] [PATCH] Fix typo in the comment
[Kirsher, Jeffrey T] 

Please fix the title to "e1000: Fix typo in the comment", other than that your patch looks fine and I will add it to my queue after the title of your patch is fixed.

> 
> Continuous Double "the" in a comment. Changed it to single "the"
> 
> Signed-off-by: Hari <harichandrakanthan@gmail.com>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c
> b/drivers/net/ethernet/intel/e1000/e1000_hw.c
> index 48428d6a00be..623e516a9630 100644
> --- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
> +++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
> @@ -3960,7 +3960,7 @@ static s32 e1000_do_read_eeprom(struct e1000_hw
> *hw, u16 offset, u16 words,
>   * @hw: Struct containing variables accessed by shared code
>   *
>   * Reads the first 64 16 bit words of the EEPROM and sums the values read.
> - * If the the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
> + * If the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
>   * valid.
>   */
>  s32 e1000_validate_eeprom_checksum(struct e1000_hw *hw)
> --
> 2.17.1
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
