Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD101E5132
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgE0Wcl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 May 2020 18:32:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:50051 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgE0Wcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 18:32:41 -0400
IronPort-SDR: u4FzEBCI5bMo07PcWRmU7eVVjT1IDNCAmpWfOwY+9LjchBma1QHtTJrE/1o4VpE530LiHF6jZO
 G3g4YWNeADjw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 15:32:41 -0700
IronPort-SDR: fpBj0o/fB4SSLMtM+Fjosio9kbsvNmixmkc3G+EStU5cqsbPuqTEbffjSGl6qFmqXCMD4IJUZF
 7Y/kCYOOJ5iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="291766281"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga004.fm.intel.com with ESMTP; 27 May 2020 15:32:38 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 27 May 2020 15:32:34 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.154]) with mapi id 14.03.0439.000;
 Wed, 27 May 2020 15:32:34 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Brady, Alan" <alan.brady@intel.com>,
        "Michael, Alice" <alice.michael@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [net-next RFC 00/15] Intel Ethernet Common Module and Data
Thread-Topic: [net-next RFC 00/15] Intel Ethernet Common Module and Data
Thread-Index: AQHWM99qPqE7VmXdPkmQAFF1oTkHpai88tEA//+SXgA=
Date:   Wed, 27 May 2020 22:32:33 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986DBDEF@ORSMSX112.amr.corp.intel.com>
References: <20200527042921.3951830-1-jeffrey.t.kirsher@intel.com>
 <20200527150310.362b99e4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527150310.362b99e4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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
> Sent: Wednesday, May 27, 2020 15:03
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; nhorman@redhat.com;
> sassmann@redhat.com
> Subject: Re: [net-next RFC 00/15] Intel Ethernet Common Module and Data
> 
> On Tue, 26 May 2020 21:29:06 -0700 Jeff Kirsher wrote:
> > This series introduces both the Intel Ethernet Common Module and the
> > Intel Data Plane Function.  The patches also incorporate extended
> > features and functionality added in the virtchnl.h file.
> 
> Is this a driver for your SmartNIC? Or a common layer for ice, iavf, or whatnot
> to use? Could you clarify the relationship with existing drivers?
[Kirsher, Jeffrey T] 

Adding the developers to this thread to help explain.
