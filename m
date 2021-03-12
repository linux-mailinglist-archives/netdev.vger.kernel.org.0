Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F213397D3
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhCLT4q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 12 Mar 2021 14:56:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:45564 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232445AbhCLT4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 14:56:36 -0500
IronPort-SDR: MEs5AAPzGTwJNpCo94qBpWt183Me6GWVNDJSx7juvJkSxPDGgNOhtj39ZdhEEGxf2o6RQ1gQkn
 Ajqn7V396/3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168798196"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="168798196"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 11:56:35 -0800
IronPort-SDR: lo0eVtuq9niIqctdLC7zcWbI+l4+49Xv8/Ye4bIXxiKocV4QcftDJYP+HXUJA4WVf3vLB+MSzu
 Rm70hW6ItMlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="589647738"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2021 11:56:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 11:56:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 11:56:34 -0800
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2106.013;
 Fri, 12 Mar 2021 11:56:34 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     "f242ed68-d31b-527d-562f-c5a35123861a@intel.com" 
        <f242ed68-d31b-527d-562f-c5a35123861a@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "guglielmo.morandin@broadcom.com" <guglielmo.morandin@broadcom.com>,
        "eugenem@fb.com" <eugenem@fb.com>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>
Subject: RE: [RFC net-next v2 1/3] devlink: move health state to uAPI
Thread-Topic: [RFC net-next v2 1/3] devlink: move health state to uAPI
Thread-Index: AQHXFiZNx+FhzhRDYEGXkuwGACHYP6p+72gAgACWsACAAUDRAA==
Date:   Fri, 12 Mar 2021 19:56:34 +0000
Message-ID: <209931b3a2504a328db3b91802dc618e@intel.com>
References: <20210311032613.1533100-1-kuba@kernel.org>
        <20210311074734.GN4652@nanopsycho.orion>
 <20210311084654.4dcfdb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210311084654.4dcfdb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, March 11, 2021 8:47 AM
> To: Jiri Pirko <jiri@resnulli.us>
> Cc: f242ed68-d31b-527d-562f-c5a35123861a@intel.com;
> netdev@vger.kernel.org; saeedm@nvidia.com;
> andrew.gospodarek@broadcom.com; Keller, Jacob E <jacob.e.keller@intel.com>;
> guglielmo.morandin@broadcom.com; eugenem@fb.com;
> eranbe@mellanox.com
> Subject: Re: [RFC net-next v2 1/3] devlink: move health state to uAPI
> 
> On Thu, 11 Mar 2021 08:47:34 +0100 Jiri Pirko wrote:
> > Thu, Mar 11, 2021 at 04:26:11AM CET, kuba@kernel.org wrote:
> > >Move the health states into uAPI, so applications can use them.
> > >
> > >Note that we need to change the name of the enum because
> > >user space is likely already defining the same values.
> > >E.g. iproute2 does.
> > >
> > >Use this opportunity to shorten the names.
> > >
> > >Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > >---
> > > .../net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  4 ++--
> > > .../ethernet/mellanox/mlx5/core/en/health.c    |  4 ++--
> > > include/net/devlink.h                          |  7 +------
> > > include/uapi/linux/devlink.h                   | 12 ++++++++++++
> > > net/core/devlink.c                             | 18 +++++++++---------
> > > 5 files changed, 26 insertions(+), 19 deletions(-)
> > >
> > >diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> > >index 64381be935a8..cafc98ab4b5e 100644
> > >--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> > >+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> > >@@ -252,9 +252,9 @@ void bnxt_dl_health_status_update(struct bnxt *bp,
> bool healthy)
> > > 	u8 state;
> > >
> > > 	if (healthy)
> > >-		state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
> > >+		state = DL_HEALTH_STATE_HEALTHY;
> > > 	else
> > >-		state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
> > >+		state = DL_HEALTH_STATE_ERROR;
> >
> > I don't like the inconsistencies in the uapi (DL/DEVLINK). Can't we
> > stick with "DEVLINK" prefix for all, which is what we got so far?
> 
> Sure, but you have seen the previous discussion about the length of
> devlink names, right? I'm not the only one who thinks this is a counter
> productive rule.

I'd like  to see us shorten the names where possible. I do think we should be consistent in how we do it. I like DL_, but it would be nice if we could get "DL_HEATH_" for all health related ones, and so on, working towards shortening across the board over time?

I also didn't mind the "DLH_" that you used in another spot, though that could get us into trouble eventually once two features start with the same letter...

Thanks,
Jake
