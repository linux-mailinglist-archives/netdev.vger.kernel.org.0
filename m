Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C911D8D2A
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgESBfd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 May 2020 21:35:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:33822 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgESBfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 21:35:32 -0400
IronPort-SDR: wAN7bg7CsKKUDBQU/KIJOV4Lt1Bhbh90tk+0GwajNSsM97wOYRVodSfUJV70/Obmh32z4F9pAk
 JHrKVGdDEDZw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 18:35:31 -0700
IronPort-SDR: XB5AUh7t1yAl41T0Cw5Y8bPSB0v2j/nHSJ2XDma5Z4aG7+4zPUtKwMbulMMQduemHIVLVqiIhk
 n/x9myo9+JHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,408,1583222400"; 
   d="scan'208";a="253087909"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga007.jf.intel.com with ESMTP; 18 May 2020 18:35:31 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 18 May 2020 18:35:30 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.140]) with mapi id 14.03.0439.000;
 Mon, 18 May 2020 18:35:30 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Joe Perches <joe@perches.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Guedes, Andre" <andre.guedes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
Subject: RE: [net-next v5 4/9] igc: Use netdev log helpers in igc_ethtool.c
Thread-Topic: [net-next v5 4/9] igc: Use netdev log helpers in igc_ethtool.c
Thread-Index: AQHWLXlc/UAqfAsIWUWhfNcOY8SyaKivEkoA//+NGqA=
Date:   Tue, 19 May 2020 01:35:30 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986A0C1E@ORSMSX112.amr.corp.intel.com>
References: <20200519010343.2386401-1-jeffrey.t.kirsher@intel.com>
         <20200519010343.2386401-5-jeffrey.t.kirsher@intel.com>
 <697e1cc89bec1cbe18d6e1c155a5ca1c9ac05e4a.camel@perches.com>
In-Reply-To: <697e1cc89bec1cbe18d6e1c155a5ca1c9ac05e4a.camel@perches.com>
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
> From: Joe Perches <joe@perches.com>
> Sent: Monday, May 18, 2020 18:22
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: Guedes, Andre <andre.guedes@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Brown, Aaron F
> <aaron.f.brown@intel.com>
> Subject: Re: [net-next v5 4/9] igc: Use netdev log helpers in igc_ethtool.c
> 
> On Mon, 2020-05-18 at 18:03 -0700, Jeff Kirsher wrote:
> > This patch converts all dev_* calls to netdev_*.
> []
> > diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c
> > b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> []
> > @@ -1904,7 +1905,7 @@ static void igc_diag_test(struct net_device
> *netdev,
> >  	bool if_running = netif_running(netdev);
> >
> >  	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
> > -		netdev_info(adapter->netdev, "offline testing starting");
> > +		netdev_info(adapter->netdev, "Offline testing starting");
> 
> several missing '\n' format terminations
[Kirsher, Jeffrey T] 

Your right, these never had them, which is why it was not caught.  I am fine with adding the terminating \n, if that is what is requested.  Andre was just trying to fix the message to properly capitalize the first letter of the message.

> 
> 		netdev_info(adapter->netdev, "Offline testing starting\n");
> 
> >  		set_bit(__IGC_TESTING, &adapter->state);
> >
> >  		/* Link test performed before hardware reset so autoneg doesn't
> @@
> > -1918,13 +1919,13 @@ static void igc_diag_test(struct net_device *netdev,
> >  		else
> >  			igc_reset(adapter);
> >
> > -		netdev_info(adapter->netdev, "register testing starting");
> > +		netdev_info(adapter->netdev, "Register testing starting");
> 
> etc...
[Kirsher, Jeffrey T] 

Yep here too

