Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF3CC0DE9
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 00:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfI0WQn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Sep 2019 18:16:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:8275 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfI0WQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 18:16:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 15:16:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,557,1559545200"; 
   d="scan'208";a="202179390"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga002.jf.intel.com with ESMTP; 27 Sep 2019 15:16:42 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Sep 2019 15:16:42 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.190]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.216]) with mapi id 14.03.0439.000;
 Fri, 27 Sep 2019 15:16:42 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: RE: [net-next v3 0/7] new PTP ioctl fixes
Thread-Topic: [net-next v3 0/7] new PTP ioctl fixes
Thread-Index: AQHVdJXQZ4VVw33DpU6C3xL/BA8h0adAT0SA///JfrA=
Date:   Fri, 27 Sep 2019 22:16:41 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58968DBB73@ORSMSX121.amr.corp.intel.com>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190927.202949.1014916876082211694.davem@davemloft.net>
In-Reply-To: <20190927.202949.1014916876082211694.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzRhM2FkOWUtYzNhNy00YzlhLWFhYWQtZmYyYzcxZTI3MGYxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVnduODNLTmUxdVJKVkY1OWkrZEtyYlRjUjFpTVI1dElYZ3Fld3hIVUlqd0FubUxoMWlwSEc5Kzc5dzRQTnNyUCJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, September 27, 2019 11:30 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>
> Subject: Re: [net-next v3 0/7] new PTP ioctl fixes
> 
> 
> Bug fixes should target 'net' not 'net-next'

Right, that was my mistake. I think I saw the ioctl change only on the net-next tree so I built the whole series on net-next. Come to think of it, I didn't check the net tree at all. I'll aim to do that better going forward.

Thanks Dave.

Regards,
Jake
 
