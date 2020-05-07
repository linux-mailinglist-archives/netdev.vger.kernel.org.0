Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83ABA1C7F6B
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgEGAvT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 20:51:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:46852 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgEGAvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 20:51:18 -0400
IronPort-SDR: 5tgD+6MoHKz5UehpIvmV+3Ev0QTlvZfNsy4UI10TDX/eBtar1oPWVfWsmKrX/fBa1oO/tE35zY
 HRC7HTXG0KEA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 17:51:18 -0700
IronPort-SDR: I4Z52cp2qylLuLNRjjCP9KqTe9cmDW2wjSh0woPGMMkBMBMg8MOb3u7JmqdCi8Pkz5g3weg85B
 nnJJTVolaEVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,361,1583222400"; 
   d="scan'208";a="260362665"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 17:51:18 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.150]) with mapi id 14.03.0439.000;
 Wed, 6 May 2020 17:51:18 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     David Miller <davem@davemloft.net>,
        "yanaijie@huawei.com" <yanaijie@huawei.com>
CC:     "Azarewicz, Piotr" <piotr.azarewicz@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] i40e: Make i40e_shutdown_adminq() return void
Thread-Topic: [PATCH net-next] i40e: Make i40e_shutdown_adminq() return void
Thread-Index: AQHWI25tmvA42/9KCUuzJLtjmKxV26icAdWA///KUoA=
Date:   Thu, 7 May 2020 00:51:16 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449868CF1C@ORSMSX112.amr.corp.intel.com>
References: <20200506061835.19662-1-yanaijie@huawei.com>
 <20200506.140239.2129195871879981516.davem@davemloft.net>
In-Reply-To: <20200506.140239.2129195871879981516.davem@davemloft.net>
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
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, May 6, 2020 14:03
> To: yanaijie@huawei.com
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Azarewicz, Piotr
> <piotr.azarewicz@intel.com>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] i40e: Make i40e_shutdown_adminq() return void
> 
> From: Jason Yan <yanaijie@huawei.com>
> Date: Wed, 6 May 2020 14:18:35 +0800
> 
> > Fix the following coccicheck warning:
> >
> > drivers/net/ethernet/intel/i40e/i40e_adminq.c:699:13-21: Unneeded
> > variable: "ret_code". Return "0" on line 710
> >
> > Signed-off-by: Jason Yan <yanaijie@huawei.com>
> 
> Jeff, please pick this up.
> 
> Thank you.
[Kirsher, Jeffrey T] 

Yep already added it to my queue, thanks.
