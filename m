Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B818DB91
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 07:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfD2Fh4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Apr 2019 01:37:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:11169 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfD2Fh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 01:37:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Apr 2019 22:37:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,408,1549958400"; 
   d="scan'208";a="341656340"
Received: from pgsmsx108.gar.corp.intel.com ([10.221.44.103])
  by fmsmga005.fm.intel.com with ESMTP; 28 Apr 2019 22:37:53 -0700
Received: from pgsmsx114.gar.corp.intel.com ([169.254.4.194]) by
 PGSMSX108.gar.corp.intel.com ([169.254.8.246]) with mapi id 14.03.0415.000;
 Mon, 29 Apr 2019 13:37:52 +0800
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Subject: RE: [PATCH 0/7] net: stmmac: enable EHL SGMII
Thread-Topic: [PATCH 0/7] net: stmmac: enable EHL SGMII
Thread-Index: AQHU+n5wKUIUU2n+WEWdYYhqXR355qZKzdAAgAEn3oCAAFapgIAApFcw//+J5wCABircQA==
Date:   Mon, 29 Apr 2019 05:37:52 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B75C0B8B35@pgsmsx114.gar.corp.intel.com>
References: <1556126241-2774-1-git-send-email-weifeng.voon@intel.com>
 <20190424134854.GP28405@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8146EF128@PGSMSX103.gar.corp.intel.com>
 <20190425123801.GD8117@lunn.ch>
 <AF233D1473C1364ABD51D28909A1B1B75C0B205D@pgsmsx114.gar.corp.intel.com>
 <20190425152332.GD23779@lunn.ch>
In-Reply-To: <20190425152332.GD23779@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWQ3N2Q5ODAtZDRhNC00ZjhjLWJjMjAtMDRhMjI2YzQ4MzgxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibE0xM0dxWjhrd04ya3JiUmZFOGJ4YVk2bkVmTll2QmpCOFBycWlXdEZrYVpVWGs3VmJZUXFPZmJtaDdvVnpEOSJ9
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn [mailto:andrew@lunn.ch]
>Sent: Thursday, April 25, 2019 11:24 PM
>To: Ong, Boon Leong <boon.leong.ong@intel.com>
>Cc: Voon, Weifeng <weifeng.voon@intel.com>; David S. Miller
><davem@davemloft.net>; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org; Kweh, Hock Leong <hock.leong.kweh@intel.com>;
>Florian Fainelli <f.fainelli@gmail.com>; Maxime Coquelin
><mcoquelin.stm32@gmail.com>; Giuseppe Cavallaro
><peppe.cavallaro@st.com>; Jose Abreu <joabreu@synopsys.com>
>Subject: Re: [PATCH 0/7] net: stmmac: enable EHL SGMII
>
>> >> > > This patch-set is to enable Ethernet controller (DW Ethernet QoS and
>> >> > > DW Ethernet PCS) with SGMII interface in Elkhart Lake.
>> >> >
>> >> > Can the hardware also do 1000BaseX?
>> >>
>> >> Yes, it is able to do 1000BaseX.
>> >
>> >I Voon
>> >
>> >That means you should not really hard code it to SGMII. Somebody is
>> >going to connect an SFP or an Ethernet switch and want to use
>> >1000BaseX.
>>
>> Hi Andrew,
>>
>> The Ethernet controller consists of two ways to connect to external PHY,
>> RGMII and SGMII. The selection is done through soft strap.
>> The patch-series is to enable SGMII interface. The DW xPCS IP is
>> configured to operate in 1000BASE-X mode. The xPCS IP is external
>> connected through internal PHY interface which presents externally
>> as SGMII interface. To help illustrate the connection:-
>>
>>       <-----------------GBE Controller----------------->|<--External PHY chip-->
>>
>>       +----------+                    +----+          +---+                          +-----------------+
>>       |   EQoS   | <-GMII->|xPCS|<--> | L1 | <-- SGMII --> | External GbE |
>>       |   MAC    |                 |         |       |PHY|                         | PHY Chip        |
>>       +----------+                    +----+          +---+                          +-----------------+
>>
>> In future, we will submit the changes for the RGMII connection that
>> bypasses DW xPCS.
>
>The ASCII art get messed up somewhere.
Sorry for that. 

>
>What you are implementing looks like:
>
>
>       <-----------------GBE Controller------------>|<--External PHY chip-->
>
>       +----------+                    +----+                 +---+
>       |   EQoS   | <-GMII->|xPCS|<--> | L1 | <-- SGMII -->   |PHY|
>       |   MAC    |                    |    |                 +---+
>       +----------+                    +----+
>
>With the Ethernet controller, the MAC connects to the xPCS. Out of the
>xPCS you have a SERDES connection, running the SGMII protocol. That
>connects to external pins of the SoC. These are then connected to a
>copper PHY which also supports SGMII.
>
>What i'm trying to understand is if the following is possible:
>
>       <-----------------GBE Controller------------->|<--External SFP cage/module-->
>
>       +----------+                    +----+                   +---+
>       |   EQoS   | <-GMII->|xPCS|<--> | L1 | <-- 1000BaseX --> |SPF|
>       |   MAC    |                    |    |                   +---+
>       +----------+                    +----+
>
>Rather than use a Copper PHY, an SFP cage+module is used. The same
>SERDES interface is used, but 1000BaseX runs over it.
>
>Generally, an xPCS which can run SGMII can also do 1000BaseX, because
>SGMII is just some Cisco Proprietary extensions to 1000BaseX.
>
>If the xPCS can do 1000BaseX over the SERDES, you should not hard code
>it to SGMII, but allow it to be configured.

Thanks for the review and checking above.

Sorry for the delay, we have checked with hardware/SoC HW architect
and gotten confirmation that the controller can only support SGMII inter-chip
connection. It does not support 1000Base-X. 

In this case, we believe that the current implementation of the DW xPCS
are sufficient. Ok?
