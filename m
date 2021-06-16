Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACD33A9472
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhFPHxi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Jun 2021 03:53:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:10615 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231345AbhFPHxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 03:53:37 -0400
IronPort-SDR: +i8LJ4yxk6YSr9DzVEPbtftXdeQr+fyOsoWIZi0yW+iU67OPiAbSm+Twh9tlpdJPx1lje3WpVS
 0SXTZO5dLOKg==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="269982912"
X-IronPort-AV: E=Sophos;i="5.83,277,1616482800"; 
   d="scan'208";a="269982912"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 00:51:27 -0700
IronPort-SDR: uer3ogkESCcjboK7tiGLYgPxiNTLS6jHn+0HE74cNSKSLO34RccsJLGV/niup/Y1c8TdnLSkRo
 vUB6c6pz3Dfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,277,1616482800"; 
   d="scan'208";a="450547047"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 16 Jun 2021 00:51:27 -0700
Received: from bgsmsx604.gar.corp.intel.com (10.67.234.6) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 16 Jun 2021 00:51:26 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 BGSMSX604.gar.corp.intel.com (10.67.234.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 16 Jun 2021 13:21:23 +0530
Received: from bgsmsx606.gar.corp.intel.com ([10.67.234.8]) by
 BGSMSX606.gar.corp.intel.com ([10.67.234.8]) with mapi id 15.01.2242.008;
 Wed, 16 Jun 2021 13:21:23 +0530
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     linuxwwan <linuxwwan@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH] net: iosm: remove the repeated declaration and comment
Thread-Topic: [PATCH] net: iosm: remove the repeated declaration and comment
Thread-Index: AQHXYoDmPLcwpusAXUKXi9SOvT1Ku6sWQsUw
Date:   Wed, 16 Jun 2021 07:51:23 +0000
Message-ID: <2735788e3a224cb0b50fc015a76f4f82@intel.com>
References: <1623828340-2019-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1623828340-2019-1-git-send-email-zhangshaokun@hisilicon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.223.10.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Function 'ipc_mmio_get_cp_version' is declared twice, so remove the
> repeated declaration and wrong comments.
> 
> Cc: M Chetan Kumar <m.chetan.kumar@intel.com>
> Cc: Intel Corporation <linuxwwan@intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_mmio.h | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_mmio.h
> b/drivers/net/wwan/iosm/iosm_ipc_mmio.h
> index bcf77aea06e7..45e6923da78f 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_mmio.h
> +++ b/drivers/net/wwan/iosm/iosm_ipc_mmio.h
> @@ -121,16 +121,6 @@ void ipc_mmio_set_contex_info_addr(struct
> iosm_mmio *ipc_mmio,
>  				   phys_addr_t addr);
> 
>  /**
> - * ipc_mmio_get_cp_version - Write context info and AP memory range
> addresses.
> - *			     This needs to be called when CP is in
> - *			     IPC_MEM_DEVICE_IPC_INIT state
> - * @ipc_mmio:	Pointer to mmio instance
> - *
> - * Returns: cp version else failure value on error
> - */
> -int ipc_mmio_get_cp_version(struct iosm_mmio *ipc_mmio);
> -
> -/**
>   * ipc_mmio_get_cp_version - Get the CP IPC version
>   * @ipc_mmio:	Pointer to mmio instance
>   *
> --
> 2.7.4

Thanks,
Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
