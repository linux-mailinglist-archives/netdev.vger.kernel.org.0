Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D59D1285CC
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 01:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfLUAAP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Dec 2019 19:00:15 -0500
Received: from mga04.intel.com ([192.55.52.120]:36265 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfLUAAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 19:00:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 16:00:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="267652901"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2019 16:00:15 -0800
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 20 Dec 2019 16:00:14 -0800
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.124]) by
 FMSMSX155.amr.corp.intel.com ([169.254.5.244]) with mapi id 14.03.0439.000;
 Fri, 20 Dec 2019 16:00:14 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: RE: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
Thread-Topic: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
Thread-Index: AQHVruL9MH0IThHAC0+pMLCxvmnyHKfDxL7g
Date:   Sat, 21 Dec 2019 00:00:13 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B26E80B9@fmsmsx101.amr.corp.intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-6-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20191209224935.1780117-6-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jeff Kirsher
> Sent: Monday, December 09, 2019 2:49 PM
> To: davem@davemloft.net; gregkh@linuxfoundation.org
> Cc: Ismail, Mustafa <mustafa.ismail@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> jgg@ziepe.ca; parav@mellanox.com; Saleem, Shiraz <shiraz.saleem@intel.com>;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Subject: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
> 
> From: Mustafa Ismail <mustafa.ismail@intel.com>
> 
> Register irdma as a virtbus driver binding to
> 'i40e' and 'ice' virtbus devices added from their
> respective netdev drivers for each PF. During
> irdma probe(), the gen-specific netdev peer device
> is obtained from virtbus device to establish an
> interface and initialize the HW.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> +enum irdma_dl_param_id {
> +	IRDMA_DEVLINK_PARAM_ID_BASE =
> DEVLINK_PARAM_GENERIC_ID_MAX,
> +	IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
> +	IRDMA_DEVLINK_PARAM_ID_UPLOAD_CONTEXT,
> +	IRDMA_DEVLINK_PARAM_ID_ROCE_ENABLE,
> +};
> +
> +static const struct devlink_param irdma_devlink_params[] = {
> +	/* Common */
> +
> 	DEVLINK_PARAM_DRIVER(IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECT
> OR,
> +			     "resource_limits_selector",
> DEVLINK_PARAM_TYPE_U8,
> +			      BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
> +			      NULL, NULL, irdma_devlink_rsrc_limits_validate),
> +
> 	DEVLINK_PARAM_DRIVER(IRDMA_DEVLINK_PARAM_ID_UPLOAD_CON
> TEXT,
> +			     "upload_context", DEVLINK_PARAM_TYPE_BOOL,
> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			     irdma_devlink_upload_ctx_get,
> +			     irdma_devlink_upload_ctx_set, NULL),
> +#define IRDMA_DL_COMMON_PARAMS_ARRAY_SZ 2
> +	/* GEN_2 only */
> +	DEVLINK_PARAM_DRIVER(IRDMA_DEVLINK_PARAM_ID_ROCE_ENABLE,
> +			     "roce_enable", DEVLINK_PARAM_TYPE_BOOL,
> +			      BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
> +			      NULL, NULL, NULL),
> +};
> +

Instead of adding a driver specific "roce_enable", use the generic parameter "enable_roce".

Thanks,
Jake

