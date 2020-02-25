Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D9F16EED7
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731357AbgBYTQj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Feb 2020 14:16:39 -0500
Received: from mga18.intel.com ([134.134.136.126]:36580 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgBYTQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 14:16:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 11:16:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,485,1574150400"; 
   d="scan'208";a="260805520"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga004.fm.intel.com with ESMTP; 25 Feb 2020 11:16:37 -0800
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 25 Feb 2020 11:16:37 -0800
Received: from orsmsx113.amr.corp.intel.com ([169.254.9.183]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.208]) with mapi id 14.03.0439.000;
 Tue, 25 Feb 2020 11:16:37 -0800
From:   "Allan, Bruce W" <bruce.w.allan@intel.com>
To:     Colin King <colin.king@canonical.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH][next] ice: remove redundant
 assignment to pointer vsi
Thread-Topic: [Intel-wired-lan] [PATCH][next] ice: remove redundant
 assignment to pointer vsi
Thread-Index: AQHV6aMWiEGBawp1sE64DZXz6vfzxKgsR9Og
Date:   Tue, 25 Feb 2020 19:16:36 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A184010B0500CE@ORSMSX113.amr.corp.intel.com>
References: <20200222171054.171505-1-colin.king@canonical.com>
In-Reply-To: <20200222171054.171505-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYmZhOTY1YmUtOWQ5ZC00MDcyLTg5ZTMtYzQ2YzJhNDQwNDJmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNENUaUxac2FRUkYyVTBoNytRMFlaRmM0NjAweDUwb1RQc2sySGNLQzBrM1VlVjUxU1Z3QW94bk12VFRWcFN1MyJ9
x-ctpclassification: CTP_NT
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
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Colin King
> Sent: Saturday, February 22, 2020 9:11 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S . Miller
> <davem@davemloft.net>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH][next] ice: remove redundant assignment to
> pointer vsi
> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer vsi is being re-assigned a value that is never read,
> the assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")

What version of coverity and what options were used?

> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> index 169b72a94b9d..2c8e334c47a0 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> @@ -2191,7 +2191,6 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8
> *msg)
>  		set_bit(vf_q_id, vf->rxq_ena);
>  	}
> 
> -	vsi = pf->vsi[vf->lan_vsi_idx];
>  	q_map = vqs->tx_queues;
>  	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
>  		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
> --
> 2.25.0
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
