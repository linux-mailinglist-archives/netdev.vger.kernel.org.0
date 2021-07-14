Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CF23C929A
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 22:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhGNU5u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Jul 2021 16:57:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:43572 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhGNU5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 16:57:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10045"; a="271537028"
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="271537028"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 13:54:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="562561073"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga004.jf.intel.com with ESMTP; 14 Jul 2021 13:54:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 13:54:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 13:54:57 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.010;
 Wed, 14 Jul 2021 13:54:57 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>
Subject: RE: [PATCH net-next RFC] devlink: add commands to query flash and
 reload support
Thread-Topic: [PATCH net-next RFC] devlink: add commands to query flash and
 reload support
Thread-Index: AQHXeOf8manj9a07IkKwIDHDT9TX46tDYGaA//+SLpA=
Date:   Wed, 14 Jul 2021 20:54:56 +0000
Message-ID: <51a6e7a33c7d40889c80bf37159f210e@intel.com>
References: <20210714193918.1151083-1-jacob.e.keller@intel.com>
 <YO9ITZknrXte6jpB@lunn.ch>
In-Reply-To: <YO9ITZknrXte6jpB@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, July 14, 2021 1:26 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kubakici@wp.pl>; Jiri Pirko
> <jiri@resnulli.us>
> Subject: Re: [PATCH net-next RFC] devlink: add commands to query flash and
> reload support
> 
> > I'm not sure if this is the best direction to go for implementing this.
> 
> Hi Jacob
> 
> Maybe add a --dry-run option? That would allow the driver to also read
> the firmware file, make sure it can parse it, it fits the actual
> hardware, and the CRC is O.K, etc.
> 
> We just need to make sure that if it fails with -EOPNOTSUPP, is it
> clear if --dry-run itself is not supported, or the operation is not
> supported. extack should help with that.
> 
> 	   Andrew

That approach could be useful. It doesn't give an easy way to dump all of the supported flags, but that's not super critical. I think a dry-run makes a lot of sense for flash update.

I can go that approach for these two and see how it turns out.

Thanks,
Jake
