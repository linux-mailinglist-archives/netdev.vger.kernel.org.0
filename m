Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFC31DDA6D
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgEUWqX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 May 2020 18:46:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:36682 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730371AbgEUWqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 18:46:23 -0400
IronPort-SDR: E+DLNaujHMbB2glVcrP+il1LBTLwByF0Wr9OqE8TBoMpaVzZpvkYZZwPWWMypenW3q1RGVSRZP
 3JWwh1NVcUXQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 15:46:22 -0700
IronPort-SDR: DI0EcICjVwKpoK5MkqDRIEfHw6cm/NqwXzr+tY6xSDKEEldYpc/LhJDF2Be5r5mR6rQRvCzj7S
 4Bwt3ibh37nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="283216488"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga002.jf.intel.com with ESMTP; 21 May 2020 15:46:22 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX107.amr.corp.intel.com ([169.254.1.106]) with mapi id 14.03.0439.000;
 Thu, 21 May 2020 15:46:22 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Guedes, Andre" <andre.guedes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
Subject: RE: [net-next 03/15] igc: Add support for source address filters in
 core
Thread-Topic: [net-next 03/15] igc: Add support for source address filters
 in core
Thread-Index: AQHWL0FlgPpZUMqG1E6bKdsihznH3aizLyGA///1LsA=
Date:   Thu, 21 May 2020 22:46:21 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986CC07C@ORSMSX112.amr.corp.intel.com>
References: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
        <20200521072758.440264-4-jeffrey.t.kirsher@intel.com>
 <20200521092323.70b8c9b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200521092323.70b8c9b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, May 21, 2020 09:23
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Guedes, Andre <andre.guedes@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Brown, Aaron F <aaron.f.brown@intel.com>
> Subject: Re: [net-next 03/15] igc: Add support for source address filters in core
> 
> On Thu, 21 May 2020 00:27:46 -0700 Jeff Kirsher wrote:
> >  /**
> >   * igc_del_mac_filter() - Delete MAC address filter
> >   * @adapter: Pointer to adapter where the filter should be deleted from
> > + * #type: MAC address filter type (source or destination)
> 
> @ here^ otherwise:
> 
> drivers/net/ethernet/intel/igc/igc_main.c:2282: warning: Function parameter or
> member 'type' not described in 'igc_del_mac_filter'
> 
[Kirsher, Jeffrey T] 

I will get that cleaned up.  

> >   * @addr: MAC address
> >   *
> >   * Return: 0 in case of success, negative errno code otherwise.
> >   */
> > -int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr)
> > +int igc_del_mac_filter(struct igc_adapter *adapter,
> > +		       enum igc_mac_filter_type type, const u8 *addr)
