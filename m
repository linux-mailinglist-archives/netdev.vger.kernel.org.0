Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43589254BE1
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgH0RQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:16:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:25426 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbgH0RQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 13:16:56 -0400
IronPort-SDR: hVli3htuyzA4RZ8pTkcSktt+JWaOpgWHg1SjSBLmAlO3Qx2RJR21pET3msaGdmotS/LGKpztyn
 GJuLxSXz5Mxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156534760"
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="156534760"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 10:16:55 -0700
IronPort-SDR: WkUyG76TUYj1mTtqlgXxD60ynPArhxH5hie0KCPZlbVAviLmO0cIOqfCpNRiSRVCq94FQhqiPY
 8lNDgGlMu3sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="339590441"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2020 10:16:55 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Aug 2020 10:16:34 -0700
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Aug 2020 10:16:34 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX157.amr.corp.intel.com (10.18.116.73) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Aug 2020 10:16:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 27 Aug 2020 10:16:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDkRDip9sEQBEll5SHgzThovGKRRmJ3tpcwF39IQ9oy3dlenAEQJCdGuR73eCQSCvJjoEUAXWx1nDBFbyyOkQRjf74qUeBG/O9uaHv+V4sJKH393CJhG7bbmuO47QEsGh34T2Swr2nr564/1Ao68ekepDR/tr6aLG9wiDWUCzo99B/W3KVbnpKmWmasGll8dc9jvD+MaVW/h2r/GNnw8EMZfxW9ciR7PvieeKitoO9ECm4dIQuGEztG6mAZN7oTommSlwuqQuRAQgyHAyNVCIaLNmtBZ55tqsmmEPqjH5iLn7j3kAZqmxaVL162NtIWKNKLGBLOrRqclGA0M2ukgDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSB8fZvFPkh3TCUwZ+VM/11U4Lyru8vwUuk8EbI4ZjE=;
 b=lPlvLMsAd5FRpt/tSBtffnnCjWr3w2gEhOH5k8OHWC/mS2jFXjSgqvgk00n1sdlHuAE/LIaovF05JY0LEXaFUD8VsnUbmXWlr1Y8j//bRFUYIQ+xAZudVbwjIcQyChibHZzrH7Z4qIVPVswgFpwkKGi+qenKX0Pvg/NGNlW12SnNrY613DZZT7+/TxH0sedY49kV/RppKeVm+XgkdHTMLsMMzCPGexN3shkcU1SYK+EUHo1UpL5B1QCiYa7uwukQ1CQxNoS+igbEEaAiDWcuK7q/tZAd1C2PMkYM1P6pqCCBENYbAMzkNuS1iJQKjF78jXHpg7kIn47mJ32Ks7HhxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSB8fZvFPkh3TCUwZ+VM/11U4Lyru8vwUuk8EbI4ZjE=;
 b=ZHfmjHEwVVWoq6OIpUZorR6Ig2QIPM2gE2wt6V3EehQye6mOpCRhUDKlqh0qdZmmqK96tvXjZK5FuYL+ZTcN3FfveXCnOsWBngFdAjz5aGjgXrdxkRVtsGF4qK0OMJ08M7/Ex6fGOHQ4bq3V8paei/q0RUAi0ACC6WGZ2QEpbLY=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1728.namprd11.prod.outlook.com (2603:10b6:300:2b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Thu, 27 Aug
 2020 17:16:26 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 17:16:26 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v5 01/15] virtchnl: Extend AVF ops
Thread-Topic: [net-next v5 01/15] virtchnl: Extend AVF ops
Thread-Index: AQHWejy3Eg1ZclplnkqJSXD3Pmlr5KlHqO+AgASNt7A=
Date:   Thu, 27 Aug 2020 17:16:26 +0000
Message-ID: <MW3PR11MB4522EDF96406226D06C05CFF8F550@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-2-anthony.l.nguyen@intel.com>
 <20200824124231.61c1a04f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200824124231.61c1a04f@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f876a100-123e-4068-0018-08d84aacee5a
x-ms-traffictypediagnostic: MWHPR11MB1728:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB17282CD19060E3C5A5FF47198F550@MWHPR11MB1728.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yP40JaDo0W7+9futOWd4UGw4CMZefDQKLsPfbf5UCTR50IiDZv/SuoHRDwo2EOY+RnVsm+XLfoT7/wjRm40Wwi8JwWklIrZ6Xhv2Xu3/EId22ZNk0OTrgCqnDZxmXd/BmTZuWTfCCvjJBb5QO7lsbrRkaliiK9Foir54S+JujMCQtAhjSs6KsDJAXSlB5T8SVmSf7wHYn8KHwqa4BwYs8Ng10sgBc+tzXbZAWZtpsisjho9Jky6BIrqsmvHsPdPc3N1D/kLxANTPnXmqpHp4FuNp/lCFNjEuAff4BW2lO14B0JmQQJR6JP4tCfkxOPd94TAiEtu0MKHaJF/q2XbFow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(55016002)(6636002)(26005)(8936002)(9686003)(186003)(66476007)(66556008)(5660300002)(76116006)(316002)(33656002)(478600001)(64756008)(66446008)(66946007)(52536014)(53546011)(54906003)(7696005)(2906002)(71200400001)(110136005)(6506007)(86362001)(107886003)(8676002)(4326008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: h1MK+L18yIX3j3RjUmvoVMFEaxefwMJtVs24NLWet2NL4KlPzWYdnx4abDYuS6Qy8Kdvh7uwetELSl5wslWPyROo2J0IbZhCFoZi9pkx4+3t6g3sKgWfyOJ6mBnBNesxSoIHPeGz5DgEqim85yxDHeImvq24FixyqVxOMXAirVHQHLhl/xCqD0u7F7yK3Jqh+uLicAGAFBO1myBxpiGrcxZ0PztnQyVFrluZQCV1Z/oq2o3ETl8ql6wgYEAZhrB28IC3DK7VmnZ5N74GiiLLQOw2lrZtkTkcvuiIZJqLBdD8tEpp+fTWPWRU1wHmw4ztcmWm1+1UOElWSufDs694/NpHCN9H5E2UX3TcUcM5sxzcua9P995c+LkbbQBRA7VFOqnjcxPrurls3IKCClkdA8vwc96Wl+zFb9Fyl/w1Y5B3c8zvKjxe99F+eqr1h/UitKGhKRS5YNCYLNsD6XchS2wQaOfuUpyw1BYPN2TYt0zi6U47NkIgLmZh8nJvEO9IHhQdVYqtdE7XSVz0z2BcQtK6/G6wu7zhJePn4DIdFHZlkdopr1Gg38dBIBBiqUJpf1Q+JJ81Dy45gFZtTHVglkxsMWvhZcrc8FR5CEwVuk12UWn600fRt92PwbT0wYYl9e3yUq3FeTn8tx0m4mzU6Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f876a100-123e-4068-0018-08d84aacee5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 17:16:26.3335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H/qq0ADXNJyaQWM/gkxiP4DgMj10xQ4aTcj6b1DiJhBzXjavXEL16DJ3mwh1V7BywlWuoxgUevCZ+9oP6gsHeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1728
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIEF1Z3VzdCAyNCwgMjAyMCAxMjo0MyBQTQ0K
PiBUbzogTmd1eWVuLCBBbnRob255IEwgPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0KPiBD
YzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgTWljaGFlbCwgQWxpY2UgPGFsaWNlLm1pY2hhZWxAaW50
ZWwuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbmhvcm1hbkByZWRoYXQuY29tOyBz
YXNzbWFubkByZWRoYXQuY29tOw0KPiBLaXJzaGVyLCBKZWZmcmV5IFQgPGplZmZyZXkudC5raXJz
aGVyQGludGVsLmNvbT47IEJyYWR5LCBBbGFuDQo+IDxhbGFuLmJyYWR5QGludGVsLmNvbT47IEJ1
cnJhLCBQaGFuaSBSIDxwaGFuaS5yLmJ1cnJhQGludGVsLmNvbT47IEhheSwNCj4gSm9zaHVhIEEg
PGpvc2h1YS5hLmhheUBpbnRlbC5jb20+OyBDaGl0dGltLCBNYWRodQ0KPiA8bWFkaHUuY2hpdHRp
bUBpbnRlbC5jb20+OyBMaW5nYSwgUGF2YW4gS3VtYXINCj4gPHBhdmFuLmt1bWFyLmxpbmdhQGlu
dGVsLmNvbT47IFNraWRtb3JlLCBEb25hbGQgQw0KPiA8ZG9uYWxkLmMuc2tpZG1vcmVAaW50ZWwu
Y29tPjsgQnJhbmRlYnVyZywgSmVzc2UNCj4gPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsg
U2FtdWRyYWxhLCBTcmlkaGFyDQo+IDxzcmlkaGFyLnNhbXVkcmFsYUBpbnRlbC5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbbmV0LW5leHQgdjUgMDEvMTVdIHZpcnRjaG5sOiBFeHRlbmQgQVZGIG9wcw0K
PiANCj4gT24gTW9uLCAyNCBBdWcgMjAyMCAxMDozMjo1MiAtMDcwMCBUb255IE5ndXllbiB3cm90
ZToNCj4gPiArc3RydWN0IHZpcnRjaG5sX3Jzc19oYXNoIHsNCj4gPiArCXU2NCBoYXNoOw0KPiA+
ICsJdTE2IHZwb3J0X2lkOw0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArVklSVENITkxfQ0hFQ0tfU1RS
VUNUX0xFTigxNiwgdmlydGNobmxfcnNzX2hhc2gpOw0KPiANCj4gSSd2ZSBhZGRlZCAzMmJpdCBi
dWlsZHMgdG8gbXkgbG9jYWwgc2V0dXAgc2luY2UgdjQgd2FzIHBvc3RlZCAtIGxvb2tzIGxpa2Ug
dGhlcmUncw0KPiBhIG51bWJlciBvZiBlcnJvcnMgaGVyZS4gWW91IGNhbid0IGFzc3VtZSB1NjQg
Zm9yY2VzIGEgNjRiaXQgYWxpZ25tZW50LiBCZXN0IHRvDQo+IHNwZWNpZnkgdGhlIHBhZGRpbmcg
ZXhwbGljaXRseS4NCj4gDQo+IEZXSVcgdGhlc2UgYXJlIHRoZSBlcnJvcnMgSSBnb3QgYnV0IHRo
ZXJlIG1heSBiZSBtb3JlOg0KPiANCg0KSXQgc2VlbXMgbGlrZSB0aGVzZSBhcmUgdHJpZ2dlcmlu
ZyBvbiBvbGQgbWVzc2FnZXMgdG9vLCBjdXJpb3VzIHdoeSB0aGlzIHdhc24ndCBjYXVnaHQgc29v
bmVyLiAgV2lsbCBmaXgsIHRoYW5rcy4NCg0KLUFsYW4NCg==
