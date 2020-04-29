Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2A81BE9AC
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgD2VNK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Apr 2020 17:13:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:41185 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgD2VNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 17:13:09 -0400
IronPort-SDR: c6m4nEd5P+fRFUXSihOjaGKNo1vOOE07jnqPJgoj2OOQzmXH+Vuc/qc9b2RVS24i5fgT+x0Br8
 yWCBRsIiB6Sw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 14:13:08 -0700
IronPort-SDR: 7o/t/NEOoozVcg0E6oYqZbWVW0oqWN+lhjnjJRQJxNI79CxeVCiIBytonRGsLsXA6MPVL4RF0b
 MQhV+nXv4l4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="246970025"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga007.jf.intel.com with ESMTP; 29 Apr 2020 14:13:08 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Apr 2020 14:13:08 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.195]) with mapi id 14.03.0439.000;
 Wed, 29 Apr 2020 14:13:08 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kubakici@wp.pl>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fisher, Benjamin L" <benjamin.l.fisher@intel.com>
Subject: RE: [net] ice: cleanup language in ice.rst for fw.app
Thread-Topic: [net] ice: cleanup language in ice.rst for fw.app
Thread-Index: AQHWHmkgPs6D7cUA5U+yDZiDgr7QvKiRDVkA//+LhaA=
Date:   Wed, 29 Apr 2020 21:13:08 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449867D1BD@ORSMSX112.amr.corp.intel.com>
References: <20200429205950.1906223-1-jacob.e.keller@intel.com>
 <20200429140904.68123cef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200429140904.68123cef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> From: Jakub Kicinski <kubakici@wp.pl>
> Sent: Wednesday, April 29, 2020 14:09
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>;
> Fisher, Benjamin L <benjamin.l.fisher@intel.com>
> Subject: Re: [net] ice: cleanup language in ice.rst for fw.app
> 
> On Wed, 29 Apr 2020 13:59:50 -0700 Jacob Keller wrote:
> > The documentation for the ice driver around "fw.app" has a spelling
> > mistake in variation. Additionally, the language of "shall have a
> > unique name" sounds like a requirement. Reword this to read more like
> > a description or property.
> >
> > Reported-by: Benjamin Fisher <benjamin.l.fisher@intel.com>
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
