Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4694221F698
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgGNP64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:58:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:53204 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgGNP6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 11:58:55 -0400
IronPort-SDR: mwbo8BbXzNkUhboRXRzMvyJuqYfCmP7s0D9GPRQgGQr5Prr1q033DsMxjrff38CeUxa3fUS/nA
 O5BUWVCbExeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="233807723"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="233807723"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 08:58:55 -0700
IronPort-SDR: QKWYwV7G0OGMKoR2zfM+AL0IbLcHgFsPK+dO5sZ1hRpkB5xujimNxEojjMvfjHofvwe/kdJtey
 IZMBv9qdfxRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="360428112"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga001.jf.intel.com with ESMTP; 14 Jul 2020 08:58:54 -0700
Received: from fmsmsx121.amr.corp.intel.com ([169.254.6.72]) by
 FMSMSX105.amr.corp.intel.com ([169.254.4.212]) with mapi id 14.03.0439.000;
 Tue, 14 Jul 2020 08:58:54 -0700
From:   "Westergreen, Dalon" <dalon.westergreen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Ooi, Joyce" <joyce.ooi@intel.com>
CC:     "See, Chin Liang" <chin.liang.see@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thor.thayer@linux.intel.com" <thor.thayer@linux.intel.com>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Topic: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Index: AQHWWfesVOnA2ZULWEys5PcG6yGprA==
Date:   Tue, 14 Jul 2020 15:58:53 +0000
Message-ID: <3bcb9020f0a3836f41036ddc3c8034b96e183197.camel@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
         <20200708072401.169150-10-joyce.ooi@intel.com>
         <20200708144900.058a8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CY4PR11MB12537DA07C73574B82A239BDF2610@CY4PR11MB1253.namprd11.prod.outlook.com>
         <20200714085526.2bb89dc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200714085526.2bb89dc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
x-originating-ip: [10.212.241.105]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD230C14DD51844EA6E370AB08633EDF@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIFR1ZSwgMjAyMC0wNy0xNCBhdCAwODo1NSAtMDcwMCwgSmFrdWIgS2ljaW5za2kgd3Jv
dGU6DQo+IE9uIFR1ZSwgMTQgSnVsIDIwMjAgMTQ6MzU6MTYgKzAwMDAgT29pLCBKb3ljZSB3cm90
ZToNCj4gPiA+IEknbSBubyBkZXZpY2UgdHJlZSBleHBlcnQgYnV0IHRoZXNlIGxvb2sgbGlrZSBj
b25maWcgb3B0aW9ucyByYXRoZXIgdGhhbg0KPiA+ID4gSFcNCj4gPiA+IGRlc2NyaXB0aW9uLiBU
aGV5IGFsc28gZG9uJ3QgYXBwZWFyIHRvIGJlIGRvY3VtZW50ZWQgaW4gdGhlIG5leHQgcGF0Y2gu
ICANCj4gPiANCj4gPiBUaGUgcG9sbF9mcmVxIGFyZSBwYXJ0IG9mIHRoZSBtc2dkbWEgcHJlZmV0
Y2hlciBJUCwgd2hlcmVieSBpdA0KPiA+IHNwZWNpZmllcyB0aGUgZnJlcXVlbmN5IG9mIGRlc2Ny
aXB0b3IgcG9sbGluZyBvcGVyYXRpb24uIEkgY2FuIGFkZA0KPiA+IHRoZSBwb2xsX2ZyZXEgZGVz
Y3JpcHRpb24gaW4gdGhlIG5leHQgcGF0Y2guDQo+IA0KPiBJcyB0aGUgdmFsdWUgZGVjaWRlZCBh
dCB0aGUgdGltZSBvZiBzeW50aGVzaXMgb3IgY2FuIHRoZSBkcml2ZXIgY2hvb3NlIA0KPiB0aGUg
dmFsdWUgaXQgd2FudHM/DQoNCkl0IGlzIG5vdCBjb250cm9sbGVkIGF0IHN5bnRoZXNpcywgdGhp
cyBwYXJhbWV0ZXIgc2hvdWxkIGxpa2VseSBub3QgYmUgYQ0KZGV2aWNldHJlZSBwYXJhbWV0ZXIs
IHBlcmhhcHMganVzdCBtYWtlIGl0IGEgbW9kdWxlIHBhcmFtZXRlciB3aXRoIGEgZGVmYXVsdA0K
dmFsdWUuDQoNCi0tZGFsb24NCg==
