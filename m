Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858A32FC892
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbhATDOY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Jan 2021 22:14:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:41730 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389369AbhATC50 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:57:26 -0500
IronPort-SDR: +tqYSUAvJq2j8vQm2vJgum2crtz0M/pklOwucfGKg7ih7nrOs9QRC9/7D7j5h94/cUacFnrgrn
 hT7FDvFvbzXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="243105324"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="243105324"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 18:56:44 -0800
IronPort-SDR: 054cMV2fPfs4AHEfqJpd/TJx0x16OrndzTfihhHekhg2rmlre7gU7G+iSitMyDSqR97RmMfkVl
 S2Tu2yhsswNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="402589859"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2021 18:56:44 -0800
Received: from shsmsx602.ccr.corp.intel.com (10.109.6.142) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Jan 2021 18:56:43 -0800
Received: from shsmsx603.ccr.corp.intel.com (10.109.6.143) by
 SHSMSX602.ccr.corp.intel.com (10.109.6.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 Jan 2021 10:56:41 +0800
Received: from shsmsx603.ccr.corp.intel.com ([10.109.6.143]) by
 SHSMSX603.ccr.corp.intel.com ([10.109.6.143]) with mapi id 15.01.1713.004;
 Wed, 20 Jan 2021 10:56:41 +0800
From:   "Zhang, Rui" <rui.zhang@intel.com>
To:     Thara Gopinath <thara.gopinath@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "amitk@kernel.org" <amitk@kernel.org>,
        "Errera, Nathan" <nathan.errera@intel.com>
Subject: RE: [PATCH 0/2] thermal: Replace thermal_notify_framework with
 thermal_zone_device_update
Thread-Topic: [PATCH 0/2] thermal: Replace thermal_notify_framework with
 thermal_zone_device_update
Thread-Index: AQHW7myNyN+HFidWAkieGDM5y8leBqov0QOw
Date:   Wed, 20 Jan 2021 02:56:41 +0000
Message-ID: <fb5571b452f7495eb76396795eeec096@intel.com>
References: <20210119140541.2453490-1-thara.gopinath@linaro.org>
In-Reply-To: <20210119140541.2453490-1-thara.gopinath@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Thara,

Thanks for the cleanup. I've proposed similar patches previously.
https://patchwork.kernel.org/project/linux-pm/patch/20200430063229.6182-2-rui.zhang@intel.com/
https://patchwork.kernel.org/project/linux-pm/patch/20200430063229.6182-3-rui.zhang@intel.com/
can you please also address the comments in the previous discussion, like doc cleanup?

Thanks,
rui

> -----Original Message-----
> From: Thara Gopinath <thara.gopinath@linaro.org>
> Sent: Tuesday, January 19, 2021 10:06 PM
> To: Zhang, Rui <rui.zhang@intel.com>; daniel.lezcano@linaro.org;
> kvalo@codeaurora.org; davem@davemloft.net; kuba@kernel.org; Coelho,
> Luciano <luciano.coelho@intel.com>
> Cc: linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; linux-pm@vger.kernel.org; amitk@kernel.org;
> Errera, Nathan <nathan.errera@intel.com>
> Subject: [PATCH 0/2] thermal: Replace thermal_notify_framework with
> thermal_zone_device_update
> Importance: High
> 
> thermal_notify_framework just updates for a single trip point where as
> thermal_zone_device_update does other bookkeeping like updating the
> temperature of the thermal zone, running through the list of trip points and
> setting the next trip point etc. Since  the later is a more thorough version of
> former, replace thermal_notify_framework with
> thermal_zone_device_update.
> 
> Thara Gopinath (2):
>   net: wireless: intel: iwlwifi: mvm: tt: Replace
>     thermal_notify_framework
>   drivers: thermal: Remove thermal_notify_framework
> 
>  drivers/net/wireless/intel/iwlwifi/mvm/tt.c |  4 ++--
>  drivers/thermal/thermal_core.c              | 18 ------------------
>  include/linux/thermal.h                     |  4 ----
>  3 files changed, 2 insertions(+), 24 deletions(-)
> 
> --
> 2.25.1

