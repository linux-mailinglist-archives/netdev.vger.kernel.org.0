Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A026722A3C1
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733112AbgGWAhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:37:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:13247 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgGWAhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 20:37:36 -0400
IronPort-SDR: eypBeU/1swSvTgO5+IBoVHxg6gv4QbZOo6woSrUOTd01jyPbW0yjenUPAwyUhMBsLflQWHrwvS
 yqWVjgVKuYiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="148383622"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="148383622"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 17:37:35 -0700
IronPort-SDR: ynHEZWPf4C4K6NldbaVg87xRcuyuDKMxBTTk8fhpaC+6e7+kh5jT16pkUcsoykBNM0vvfSEY90
 Y4b/UV6DMLGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="310829658"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jul 2020 17:37:35 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 17:37:34 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Jul 2020 17:37:34 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 Jul 2020 17:37:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 22 Jul 2020 17:37:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQ1L1E1I6URWafduzHzMoslUsoFWf+OGf7+Dh4I6SdmkKMyWz06zIi0PeyE9iC7l6J0mKMvOnhhabeXzxeXpaQLu5S6X+rYa/a7ChCVWM8HC+lUwNg5zt9I0vVZqy9MSllYMcLqCAyBPL86OoHH68PUV9KvLAfr9LBL44k1OLpEQiF7cax7295Sw4CbpNM8Yq9+16q6uvDDAeVDfKFBO6Nh8CksztAAmNhMD3hRVRiKo+LeqpYqzMD8KMdE8sWh5WzRT7Zko9X4vvHsIW923hAWNHhIXDTmvqFRbXI6vrC3USLHw1uhdsGQYmtmt++NHBVFZP/Y/+zptE39A47w1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpjIpZgGBMHWb5gf70wQOaptwxD43VF8Z8WVImUh5lg=;
 b=APBSClepq3I8yqr7Va3FsuKH/yxZ+0Y6WjugL/0XwH50rY8SKBWW//4qrANZzB1gGKz6Gb2AEf85vdYcG+puqMF2QakfnOHgLZFbO3hyNx1w1AOlZtEnfvR4ZKYF1tx8gOMqAX8x/KfpVsK1dqhIKT0YP4oMDJxlvtkLXqf1xoiOkqk10iOfHLL5X+7KNwHbcJiyZxD0ODfOJqaTSbnUasHH4KxPRoXk499UkaY4+rNP0kY9mupyp9SzAKUVXPNnh1sQahCRgl3VRNJygugOhM2E/fXICKoi5pdKK7w3U78CjI4j4Ol87YU1puYQQ4ktO+3jl7UOM3/ryT7H70mesw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpjIpZgGBMHWb5gf70wQOaptwxD43VF8Z8WVImUh5lg=;
 b=IFoEsVIQlslajT6exX3N7lujv5EsNH1MAtpXBJvSO4Sx7gbpPsIIMkkzxAMQJqEDixXoeZTqOWECYQtsfrViOpARa7TDoB2WvnFYXmimu4BY61tX5Jv3LQqsvAARW9kpZiuBkktts3F38yIDpKuWfk78ZXIXHwivrOAMb/L7174=
Received: from MW3PR11MB4633.namprd11.prod.outlook.com (2603:10b6:303:5b::9)
 by MWHPR11MB0077.namprd11.prod.outlook.com (2603:10b6:301:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 23 Jul
 2020 00:37:30 +0000
Received: from MW3PR11MB4633.namprd11.prod.outlook.com
 ([fe80::6062:8436:de8e:3c2a]) by MW3PR11MB4633.namprd11.prod.outlook.com
 ([fe80::6062:8436:de8e:3c2a%2]) with mapi id 15.20.3216.020; Thu, 23 Jul 2020
 00:37:30 +0000
From:   "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Wang, Haiyue" <haiyue.wang@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>
Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Topic: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Index: AQHWWT0uo0DH8BlIxEiXYGLAByZC7KkGHQqAgAAs+ACAARuAgIAAc2oAgAEZGICAC2w6AA==
Date:   Thu, 23 Jul 2020 00:37:29 +0000
Message-ID: <8026dce002758d509b310afa330823be0c8191ec.camel@intel.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
         <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
         <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
         <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
         <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.55.39]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b3f2fc5-e453-4eb3-9a89-08d82ea094dc
x-ms-traffictypediagnostic: MWHPR11MB0077:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB007744E8ACC0D0F40F35B25B90760@MWHPR11MB0077.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GWswn4jp8t9S8oysY4bHjy3/rC06w5lFfcxLo/Fyzn/9qb3Virn/fg1lMC4KjaX7Fn2p+pvwTdNQfOPywYGLnI/YSfmQmYqbyssqU50V1RmFZaz1223dgkVZNhmhqXbNSJGATgYn2kFhKmBEswyI9y+dc1vB+7+Cz505SwIbE7tbPrudfswhJ7Js4QAl2ZgwW+2TvL2gMKaKV8hDqVIFZTsBAJTHNjW8grU+ns4Le6WDxObScj066Iv1Xi8HHKPepWykb0fkR9hVCjadx6BfuTNRsqfbmaVW0Zx6QIIsSPgn4OPzTN4WV/Ny/V3XGCup
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4633.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(316002)(4326008)(110136005)(8936002)(5660300002)(186003)(107886003)(6512007)(6636002)(64756008)(66446008)(6506007)(66476007)(86362001)(2616005)(6486002)(2906002)(76116006)(71200400001)(54906003)(8676002)(66556008)(26005)(91956017)(66946007)(478600001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1kge7KT70R6hdy3AxDZvUMA7EwQvEre2vjqxIjbwtpYMllkMb4LQpQF2F0SXVWD+i6TmERkH50EddbNceIOn1yTkkQMkTh8qx0H8+Oqm+kSB12O5hCgF8gx1ugwO/PKyah4Iqr8RxdLkeWbQZ+STtOo/w3yoa3qfMqvPKCBVcsjJtZKW3x+7cnlPWsomgGWTCeRw54U4GbPhf6Lyv1BjJpk9zESVQn688raYACKBGiNUgggF2xrj/ZJ94M8i5iGzleV6wUPXNOjDnE2+iuk3fKF3C9JfZbVQvq8gNkRzJ9dUtsmjPYFqmlD/4j8rZxdS+rnD9MY9s9k3g5IwG7i27g+hfMH7gouk8gT9xnrURxMwmEGp08I5l7tI1MzsNaRuArYEPm6Bvg1pTRGj89XQKObJAT+D/rc3lFXPQ8aAaG3Erp6tyc4GI7d5kcPBX58MaVCAnU0G91uQJLh1VMOHPB93tqLC3kAkq8VTaIlI+AM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A327B3858AABC74D85EC14805D4226C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4633.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b3f2fc5-e453-4eb3-9a89-08d82ea094dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 00:37:29.8547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AC7kHkF+WXaKHnhpku7A3S+QqJ6NFEOsCCSFOOmxDjqc1O4LA5JFnoGF9BwsfMnRrTCOphZqNZvQIfhoqFWoxy/rDXCa92aVV+Ev38jAV9iuqdfCs04ZWKcEMeFoXxAg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0077
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA3LTE1IGF0IDExOjAzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxNSBKdWwgMjAyMCAwMToxNzoyNiArMDAwMCBXYW5nLCBIYWl5dWUgd3JvdGU6
DQo+ID4gPiBDb3VsZCB5b3Ugc2F5IGEgbGl0dGxlIG1vcmUgYWJvdXQgdGhlIGFwcGxpY2F0aW9u
IGFuZCBtb3RpdmF0aW9uDQo+ID4gPiBmb3INCj4gPiA+IHRoaXM/DQo+ID4gDQo+ID4gU3VyZSwg
SSB3aWxsIHRyeSB0byBkZXNjcmliZSB0aGUgd2hvbGUgc3RvcnkuDQo+ID4gDQo+ID4gPiBXZSBh
cmUgdGFsa2luZyBhYm91dCBhIHNpbmdsZSBjb250cm9sIGRvbWFpbiBoZXJlLCBjb3JyZWN0PyAg
DQo+ID4gDQo+ID4gQ29ycmVjdC4NCj4gDQo+IFdlIGhhdmUgYSBsb25nIHN0YW5kaW5nIHBvbGlj
eSBvZiBub3Qgc3VwcG9ydGluZyBvciBoZWxwaW5nDQo+IGJpZnVyY2F0ZWQNCj4gZHJpdmVycy4N
Cg0KSmFrdWIsDQogDQpGcm9tIHdoYXQgSSB1bmRlcnN0YW5kLCBhIGJpZnVyY2F0ZWQgZHJpdmVy
IGNhcnZlcyBvdXQgdGhlIGhvc3QNCmludGVyZmFjZSBuZXRkZXYncyBxdWV1ZXMgKHJlc291cmNl
cyBpZiB5b3Ugd2FudCB0byBmdXJ0aGVyIGdlbmVyYWxpemUNCnRoaXMpIGFuZCBhbGxvd3MgYW5v
dGhlciBlbnRpdHkgdG8gY29udHJvbC91c2UgdGhlbS4gSWYgdGhpcyBpcyB0aGUNCmRlZmluaXRp
b24sIHRoZW4gRENGIGlzIG5vdCBiaWZ1cmNhdGluZyB0aGUgZHJpdmVyLg0KIA0KRENGIGlzIG9u
IHRvcCBvZiBTUi1JT1YgVkZzIGFuZCB0aGUgZGV2aWNlIHJlc291cmNlcyByZXF1aXJlZCBmb3Ig
dGhlDQpEQ0YgVkYgYXJlIG1hZGUgYXZhaWxhYmxlIGJ5IHRoZSBkZXZpY2UgdGhyb3VnaCB0aGUg
UENJIGNvbmZpZ3VyYXRpb24NCnNwYWNlIGR1cmluZyBTUi1JT1YgaW5pdC4gVGhpcyBwYXJ0IGlz
bid0IGFueXRoaW5nIGRpZmZlcmVudCBmcm9tIHRoZQ0KdXN1YWwgU1ItSU9WIFZGIGluc3RhbnRp
YXRpb24uIFRoZSBEQ0YgZmVhdHVyZSBhZGRzIHRoZSBhYmlsaXR5IGZvciBhDQp0cnVzdGVkIFZG
IHRvIGFkZCBmbG93IHJ1bGVzLiBTbyB0aGlzIGlzIHJlYWxseSBqdXN0IGFuIGV4dGVuc2lvbiBv
Zg0KdGhlIFZGLVBGIGludGVyZmFjZSB0aGF0IGFsbG93cyBhZHZhbmNlZCBmbG93L3N3aXRjaCBy
dWxlcyBwcm9ncmFtbWluZy4NCkFkZGl0aW9uYWxseSwgdGhlIGRyaXZlciBhbHNvIGhhcyBhIGxp
c3Qgb2Ygb3BlcmF0aW9ucyB0aGF0IHRoZSBEQ0YgVkYNCmlzIGFsbG93ZWQgdG8gZXhlY3V0ZS4N
Cg0KQ2FuIHlvdSBwbGVhc2UgY2xhcmlmeSBob3cgeW91IChhbmQgdGhlIGNvbW11bml0eSkgZGVm
aW5lIGJpZnVyY2F0ZWQNCmRyaXZlcj8NCg0KVGhhbmtzLA0KQW5pDQo=
