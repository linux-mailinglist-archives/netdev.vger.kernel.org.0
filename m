Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8293526765E
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgIKXKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:10:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:58572 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbgIKXKN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:10:13 -0400
IronPort-SDR: 7LfUgO2DqF59kRoWndXZQvAmfJiA7O0kiiWT7k98YBdy3Jc3+2xXYX6iIHO7b11g+bvGSrhB38
 5TwPMT1/W5tA==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="146603974"
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="146603974"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:10:00 -0700
IronPort-SDR: 2D2AgbHz9Oim/R1z+oqP2mHsJRHMlEYQJp8FlDTM3zF7lBVuAFMHgmZcrW2mKYoKvVE+/lZpM7
 sN3A0ZvKmQWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="344776970"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 11 Sep 2020 16:10:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Sep 2020 16:10:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Sep 2020 16:09:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 11 Sep 2020 16:09:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bwd3P98BOyaE6xxNmTqxP4LO8o+WqpsCRlvdoNL52A/C28RfsURBjx9/Ydz7AFfQMAxZL/24KbIZOAcVWEgtS37IJQmtxqs9onjTPRz+ZF3Bzdy5ANB1Yxbhh6Xer4/3ZvmIXF60qfunWVKMrFtaOoKM5YaZk7RMU75j5MsuLXY4XOEBTwh+48kdvPXS1NsaQGvflUdc4miyN2y0ZfKgsp5EtTiZVPx+FNqMZqIefSbC2w/r+biAftNMwmKMH15aE63cS7a9d/BvYoJzjewZknhm/ivhEWdzic9lW83EsxMSqucS/I3nwlR87l4RUlfEKrEbwHlIDy3hlAeca5Mj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pbxs0iQCiQONXVy39vDFwNoo8PbKBFKreAVv/M6cJ4I=;
 b=XhJm4KhKSPTV07mygKRnru42+T5s8J5+tB2Ezd+KmFZ1LevpZRwJAWriVSwYqjxx060GgjwwxsNbhDEjY5dAjPqZqg+A/rmK1PK8w1i1jOXrKUYueuyTuiwJE+H7fkY6DgmyWK/a6SpAmkq6NKei9otdrOhpbkwHNVsuqTe6nFadoT0VRWAXUFvXiT2D1eZ6Smq+dFTlK3RGAkOBYUjwxMScrs4M+6pVcJsxAmPUk9u6DWR3yakZs65pRfFNHKr2jmOVz6Zqo7krJ0KxNBJDhYjRGQr7qWt48awV1k3TTk4uybodpKfd+LVh8nBYzR5YUg82DGcpAUFE7uACKhmSTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pbxs0iQCiQONXVy39vDFwNoo8PbKBFKreAVv/M6cJ4I=;
 b=aqQ2dofh0QgGXmYUs3f4KzsJWRDkSAgaaByovlEOI+PH1fvWbqlW/70/SzBhSzRVi/LkVyLDF+0Ejo6sCPdI5t2P247uRVpXnxxT+h6aeHwQEEbGBgTcOJrIlIeFeoTBJcP0xTm3hdaF5VXFBDb1vgnP1OJmUqofZ6KbGEImeGI=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2845.namprd11.prod.outlook.com (2603:10b6:805:5f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 23:09:57 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7147:6b91:afe3:1579]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7147:6b91:afe3:1579%3]) with mapi id 15.20.3370.016; Fri, 11 Sep 2020
 23:09:57 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates 2020-09-09
Thread-Topic: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-09-09
Thread-Index: AQHWhwX1/f6rgKMOfUKvGLdMghsVeqlh9OMAgAIeZAA=
Date:   Fri, 11 Sep 2020 23:09:57 +0000
Message-ID: <63501c55d7e60ef914dfd08defa36c0a4f1a1bb9.camel@intel.com>
References: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
         <20200910074838.72c842aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910074838.72c842aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf5cc77c-a9df-450f-d989-08d856a7cd33
x-ms-traffictypediagnostic: SN6PR11MB2845:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2845CEFE80BD6F173E5E42ADC6240@SN6PR11MB2845.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cS2lsjP9y9JIC9IeWo/9a+MjF/btErITB2FoKVxnJhBA/AYGfo2L+qNVa6orNTXnXDYNMLISdghJxnVvYERBUCJQP7y9XsuAdAyiygDwB2dUITY421uY9koLsRPrn90iAk2ai4LYUXsCuKpQWzXGlVlgrpl7Ca4shCuejkVCAqm91QXPnHP0VYc6BPn0ARvse70voiM/YMhTOONC3JPwYBn1ql7ZoiNvvzbAU1+B5WEfhjEVHAUcPvMocy3nMJDL8GugejAyTRS8kz0LMc7qawMBDkI2RFBhsCbodRoVo4vFpUmiZvXITZAzFiOUbf4SaFI5dD6EC32J2XewmRC1XQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(5660300002)(54906003)(316002)(6916009)(4744005)(26005)(186003)(6506007)(76116006)(8936002)(6512007)(478600001)(15650500001)(66476007)(91956017)(6486002)(66946007)(64756008)(66446008)(4326008)(86362001)(66556008)(71200400001)(2616005)(36756003)(2906002)(83380400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JdrqJhmbOTWcuTcXhcaYsKnmvhmvX98I+GohGx2LLoEZpw0A21mtwjUzqg0TEJCXYlOblrItH/n6tQfdbsHqwTo2VSXqEJ1DuyYh/YTbY3K699yH6OWH0HmoyBH+gBMahQtfke25ruoOlZFcBM7KSCezPcMkVWlxdhvsAgV8rX9dT5Gak/YNAAzDmkCufhbs2T+gsAX8RbeWen9AnmLWzLSepx/T7veU2JrvOA2OZn3OFjO6HLi+v++6iL50rJ7d6NB5dfTQ7i/s51nCGIaELraZaFcmQy/w/dOlbH3ntFwlsmGKrkDryFlg+1c/parz/aZ4+/Y1vVv7UWohcRagU2YR0ae5WRc10uk+Srh2JPfHowARE7RY/deUG0CPgRvy7+kDGI0QuybtpVBIpdDIoTxVoY6N9Z5GTp2BsXjaiHtZDWkkYXKX2GeYU4kLgk9uSkgYuTC+9H6N+VopPu4T+MAm51CZMHhuF+Qxn6ruN3mWWwubBhpuw1UTuUDjgXJJqLhUHhmYanHVNFgaYcH4mstD21YnDVtZabMRix05H7fD4XR++LNsOQ0JDDmkfjGOYgT9cdEGDT4cOVVNNj4oNMaM5eRaPQZwCSJl86/iTKGnY10hQtvqMpJl4fRFiUCp8yVMiIMi4xm7Qy4dYRJMxw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <38B5FD7D3BB6C34B992427C99CE0566C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5cc77c-a9df-450f-d989-08d856a7cd33
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2020 23:09:57.3780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dqgpZhGP8VwB8QTSMl9ZNPF4Wa8rt/YQRdqshANdfDHF0qsgP62FpKDK9It/O6BOlP8QpLJyabukhRFZbmzYLO3Dks9FjHuEt4zGkU3+XuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2845
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA5LTEwIGF0IDA3OjQ4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAgOSBTZXAgMjAyMCAxNzowNDowNyAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBUaGlzIHNlcmllcyBjb250YWlucyB1cGRhdGVzIHRvIGk0MGUgYW5kIGlnYyBkcml2ZXJz
Lg0KPiA+IA0KPiA+IFN0ZWZhbiBBc3NtYW5uIGNoYW5nZXMgbnVtX3ZsYW5zIHRvIHUxNiB0byBm
aXggbWF5IGJlIHVzZWQNCj4gPiB1bmluaXRpYWxpemVkDQo+ID4gZXJyb3IgYW5kIHByb3BhZ2F0
ZXMgZXJyb3IgaW4gaTQwX3NldF92c2lfcHJvbWlzYygpIGZvciBpNDBlLg0KPiA+IA0KPiA+IFZp
bmljaXVzIGNvcnJlY3RzIHRpbWVzdGFtcGluZyBsYXRlbmN5IHZhbHVlcyBmb3IgaTIyNSBkZXZp
Y2VzIGFuZA0KPiA+IGFjY291bnRzIGZvciBUWCB0aW1lc3RhbXBpbmcgZGVsYXkgZm9yIGlnYy4N
Cj4gDQo+IEhpIQ0KPiANCj4gRldJVyBwYXRjaCAzIGRpZCBub3QgbWFrZSBpdCB0byB0aGUgTUws
IHNvIHlvdSdsbCBuZWVkIHRvIHJlc2VuZC4NCg0KVGhhbmtzLCBJJ2xsIHJlc2VuZC4NCg0KPiBI
b3cgYXJlIG15IHBhdGNoZXM/DQoNClNvcnJ5IGZvciB0aGUgZGVsYXksIHdlJ3ZlIGhhZCBrZXkg
cGVvcGxlIG91dCBvbiBzdW1tZXINCnZhY2F0aW9ucy9zYWJiYXRpY2Fscy4gSSdtIHdvcmtpbmcg
b24gcHVsbGluZyBwZW9wbGUgYmFjayBhbmQgZW5nYWdpbmcNCm90aGVycyB0byBnZXQgdGhlbSB0
ZXN0ZWQvcmV2aWV3ZWQuIFBsZWFzZSBnaXZlIHVzIGEgY291cGxlIG9mIHdlZWtzLg0KDQpUaGFu
a3MsDQpUb255DQo=
