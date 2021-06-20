Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3403ADF40
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 17:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhFTPwn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 20 Jun 2021 11:52:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:6923 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229658AbhFTPwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Jun 2021 11:52:42 -0400
IronPort-SDR: tffdjx2aE7xFXM2GrxVoMFLP5MCPInwz2aMu6htk5obtJlfXpDLwttrLqeCqOegpGZO3YULJd2
 HGtY/0jwuFzQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10021"; a="206679084"
X-IronPort-AV: E=Sophos;i="5.83,287,1616482800"; 
   d="scan'208";a="206679084"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2021 08:50:29 -0700
IronPort-SDR: Hi7UQq4myHc8fBrrS89Qmi2EkDTi+zkEZq7MSE0DM6shP2m45nenXziPxDLFwStRcCGNxaOj0M
 7GYYLZsWKVVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,287,1616482800"; 
   d="scan'208";a="451933471"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 20 Jun 2021 08:50:29 -0700
Received: from bgsmsx605.gar.corp.intel.com (10.67.234.7) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 20 Jun 2021 08:50:28 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 BGSMSX605.gar.corp.intel.com (10.67.234.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 20 Jun 2021 21:20:26 +0530
Received: from bgsmsx606.gar.corp.intel.com ([10.67.234.8]) by
 BGSMSX606.gar.corp.intel.com ([10.67.234.8]) with mapi id 15.01.2242.008;
 Sun, 20 Jun 2021 21:20:26 +0530
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     linuxwwan <linuxwwan@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH net-next] net: iosm: remove an unnecessary NULL check
Thread-Topic: [PATCH net-next] net: iosm: remove an unnecessary NULL check
Thread-Index: AQHXZRI798ezFD6cdU64vYoI1XicEasdDYyQ
Date:   Sun, 20 Jun 2021 15:50:25 +0000
Message-ID: <c3c02130b88d43f4bbd3d69bc277b596@intel.com>
References: <YM32XksFPUbN2Oyi@mwanda>
In-Reply-To: <YM32XksFPUbN2Oyi@mwanda>
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

> The address of &ipc_mux->ul_adb can't be NULL because it points to the
> middle of a non-NULL struct.
> 
> Fixes: 9413491e20e1 ("net: iosm: encode or decode datagram")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
