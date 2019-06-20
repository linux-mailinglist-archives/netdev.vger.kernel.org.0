Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACCE4C5B7
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 05:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfFTDOe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jun 2019 23:14:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:38947 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbfFTDOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 23:14:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 20:14:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,395,1557212400"; 
   d="scan'208";a="165197511"
Received: from pgsmsx106.gar.corp.intel.com ([10.221.44.98])
  by orsmga006.jf.intel.com with ESMTP; 19 Jun 2019 20:14:31 -0700
Received: from pgsmsx114.gar.corp.intel.com ([169.254.4.160]) by
 PGSMSX106.gar.corp.intel.com ([169.254.9.141]) with mapi id 14.03.0439.000;
 Thu, 20 Jun 2019 11:14:30 +0800
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Voon, Weifeng" <weifeng.voon@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: RE: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Thread-Topic: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Thread-Index: AQHVJdrXUsdOVQF/k0iKWNkitFHiIaahxnCAgABfNgCAAEIFgIABeMbQ
Date:   Thu, 20 Jun 2019 03:14:29 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B75C17F4D4@pgsmsx114.gar.corp.intel.com>
References: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
 <1560893778-6838-2-git-send-email-weifeng.voon@intel.com>
 <20190619030729.GA26784@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81472623A@PGSMSX103.gar.corp.intel.com>
 <20190619124433.GC26784@lunn.ch>
In-Reply-To: <20190619124433.GC26784@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzQ1NDcyOTYtNjI1MC00OWNkLTk5NjgtN2JhMGJhZWRlZjE1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRzEzckZXTVlOVEJ1OUE4b0Mzbk94NTcxTk9iQk1nTHUxNVVxQ29cLzZwWFpEWVNSa012UHZoRzdjNlNOczNVNm4ifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> > It looks like most o the TSN_WARN should actually be netdev_dbg().
>> >
>> >    Andrew
>>
>> Hi Andrew,
>> This file is targeted for dual licensing which is GPL-2.0 OR BSD-3-Clause.
>> This is the reason why we are using wrappers around the functions so that
>> all the function call is generic.
>
>I don't see why dual licenses should require wrappers. Please explain.
>
>  Thanks
>	Andrew
Agree with the Andrew. We can change those wrapper functions that have
serve the internal development needs for multiple OS scaling reason. 
We will update the kernel codes as suggsted.  


