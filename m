Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E2C29B38A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 15:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775768AbgJ0OxM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Oct 2020 10:53:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:26400 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773160AbgJ0Ovk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 10:51:40 -0400
IronPort-SDR: 8ygIKS9jiWCfU+dllPCfxa+qXGMDkl0nBUZ8RNm6/IjDAbYPbUHuWD3CANk41cBq5HwUWA19QZ
 Q3ByahE6XbMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="232278238"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="232278238"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 07:51:39 -0700
IronPort-SDR: QsN1CmXeuCWCB83XI37JPoftKcFSesGTOGfClnAFj9tL3jY3rHZErjuxhjhP26FmlSh1ZMJegN
 QJSCZXQiY/vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="468337811"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga004.jf.intel.com with ESMTP; 27 Oct 2020 07:51:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Oct 2020 07:51:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Oct 2020 07:51:37 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Tue, 27 Oct 2020 07:51:37 -0700
From:   "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     linux-wimax <linux-wimax@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 04/11] wimax: fix duplicate initializer warning
Thread-Topic: [PATCH net-next 04/11] wimax: fix duplicate initializer warning
Thread-Index: AQHWq9+IizPtCG0Uk0iW2uocMKyLWamrgVyAgABLJQD//7tyFw==
Date:   Tue, 27 Oct 2020 14:51:37 +0000
Message-ID: <b102ea5e9e2e4365a1c05a1c24e66cc4@intel.com>
References: <20201026213040.3889546-1-arnd@kernel.org>
 <20201026213040.3889546-4-arnd@kernel.org>
 <03c5bc171594c884c903994ef82d703776bfcbc0.camel@sipsolutions.net>,<CAK8P3a30T5o=EEnp3sdNM5iqsSaL6DKZONGBs+3S6g+36uHVzQ@mail.gmail.com>
In-Reply-To: <CAK8P3a30T5o=EEnp3sdNM5iqsSaL6DKZONGBs+3S6g+36uHVzQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Arnd Bergmann <arnd@kernel.org>
> 
> Makes sense. I checked
> https://en.wikipedia.org/wiki/List_of_WiMAX_networks, and it appears
> that these entries are all stale, after everyone has migrated to LTE
> or discontinued their service altogether.
> 
> NetworkManager appears to have dropped userspace support in 2015
> https://bugzilla.gnome.org/show_bug.cgi?id=747846, the
> www.linuxwimax.org site had already shut down earlier.
> 
> WiMax is apparently still being deployed on airport campus
> networks ("AeroMACS"), but in a frequency band that was not
> supported by the old Intel 2400m (used in Sandy Bridge laptops
> and earlier), which is the only driver using the kernel's wimax
> stack.
> 
> Inaky, do you have any additional information about possible
> users? If we are sure there are none, then I'd suggest removing
> all the wimax code directly, otherwise it could go through
> drivers/staging/ for a release or two (and move it back in case
> there are users after all). I can send a patch if you like.

I have not

Every now and then I get the occasional message from a student or
researcher asking for support about a production network, but they
have dwindled in the last years.

My vote would be to scrap the whole thing; if there are die hard
users, they can always rise up and move it back from staging.
