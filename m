Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD94130AEB9
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBASGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:06:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:45642 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhBASGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:06:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612202774; x=1643738774;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uvNHKPIJ3Na8c4Fc6wY7Wp5XamzoM6zKqvChAqDaW5g=;
  b=C1Hvl2T2Z8ypen6xhZp9NbzabOb/V2Kjp9Uj+3xZpzftO/l5/lrvRhCQ
   QPUd09Dwx9DXLuFiekCYokCmPv8oQEkPdZge814zYbBxeROIrCiETVGUj
   cawJhkxMbpQJbd+XDKfkplOV/sWcxQEyFyxa7iKsBNpgZZYdJHs0UcHXx
   FJ8Oxym9d4uvFlbL4Xi5yHLr5WZe9tqyjmVJkN4gkqHtr3lf9kUqUunAZ
   x/7ZAiUOJevpUoMp/DsEF0UnGnlxsQ31wfA5gGQ+fh0PzCAUhXlLr4+SE
   33mOHwxVEMLEGiIrlaz2pRbHoQwix0OF9+Ay/VRF9xZeQF3ld6VYpeaCJ
   w==;
IronPort-SDR: B/0m5HyefR7ExEcTeDzRqAp4ObXpq4s/ri+8+sqE/ZjTWUhAXF2X+gyb5HyoBSvuO+/ZiOrgmd
 K9sqRX5sKEQ84Cdp1Lekcp9hnecuMq+eDp5YEe6wwIMvWP18G/4OO6Y+x9ixTc/32aGdvBS94x
 nGEUX4V3qIJyAMxERIGMIDOTRyXsbF5xlnPBetO8x8IORBMDufg4eySwTUczwbhxkwamdSNeaM
 xLX+fT+ZQK4+oGIkoRmtJN9gzFmmFD3nHkf000YelqJzwrYQbPS8vU34nvt/NYFKdHNlba+CwJ
 R0Q=
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="42508220"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2021 11:04:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Feb 2021 11:04:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 1 Feb 2021 11:04:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cj3Fxa6bze/rG6OTSOZfhQLbbXqQXpjN+OPVReoIhInC8Lqhm+METNe31Dl/46fcqy1UYJOgo4vDux1QoNrNW2JQ5Hz7R6Y6XKjLBgnQGAX24aaUcuYd3pDKq3/2oE/eIZkFTW674mgkv56FkJWTsGM0aerMz3wETcHjyHSsvT4GVuNYaP+S9gY9Jj3gvuxIgUVvTfa3w5A/EYfPATYTU7JrVO6WvUWGSajPbO5AZ8HAS1TEdF8Eh5nqe2i2qyVKyiT/Kz26Xabvh6TNGW6mLvfYRAguNwCO/uR7Az/cJWxJn8vG4XhCgKf+iFpOdouR+5ny0RRIdzEVJ5wj26zcPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvNHKPIJ3Na8c4Fc6wY7Wp5XamzoM6zKqvChAqDaW5g=;
 b=VMEe3Y+gxrCwrRjA57IVfHuPchsOUkFq4T7xF6oj68TBL65N+i5K9+dbahIcgDjRzMljDy8NI1ZDRnpu02nMfBkZuinLn7C4iczgDc4ud3IAgCeTAwba2sO9MuVVzEQdi4fGaUJmqKGnMKj0pTBUy+NVpkFHDGM0cB8lEL8Pt2ahjFga4euL6iBAc9ee3bl1WgMEuyLPFPa0irQqJIOdWp0Go5MnPmzzF9hrH+fJ5atKYBpl/y9Cinh9rfePyMLEzPmx7Pm9cRBwtgOOMLF20pLtHyNix96LMTyTQgbfnE+gKtR6je//P52ePbAqCEYDnAHEwo4c20ZcCryBIb83Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvNHKPIJ3Na8c4Fc6wY7Wp5XamzoM6zKqvChAqDaW5g=;
 b=eY70qIY3w/78LTPSVNit4JmFV9NOhcXmBV09YXyKQZloPwzbZBtTUYDXhUdt3WQMUWS+1tuiaRy823WioQCM+Veegc+OwFOMp9lpBYM9i/sk83bm7Melc6kVuoOjT0W/KZa2e56pA5pyS1TaVcKnpRyyhORxBCOV/wQjDhD9lBs=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3920.namprd11.prod.outlook.com (2603:10b6:208:153::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Mon, 1 Feb
 2021 18:04:44 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584%2]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 18:04:44 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <rtgbnm@gmail.com>,
        <sbauer@blackbox.su>, <tharvey@gateworks.com>,
        <anders@ronningen.priv.no>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
Thread-Topic: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
Thread-Index: AQHW9nhaCkvjLk51A0iB0GiaIb00V6pBUlxwgACLTYCAAbrREA==
Date:   Mon, 1 Feb 2021 18:04:44 +0000
Message-ID: <MN2PR11MB3662E5A8E190F8F43F348E72FAB69@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20210129195240.31871-1-TheSven73@gmail.com>
 <20210129195240.31871-3-TheSven73@gmail.com>
 <MN2PR11MB3662C081B6CDB8BC1143380FFAB79@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiVvuNYC4WPCRfPOfjr98S_BGBNGjPze11AiHY9Pq1eJsA@mail.gmail.com>
In-Reply-To: <CAGngYiVvuNYC4WPCRfPOfjr98S_BGBNGjPze11AiHY9Pq1eJsA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92f9ed88-b216-42f6-b662-08d8c6dbdae7
x-ms-traffictypediagnostic: MN2PR11MB3920:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3920B7B2ADFE58CB124C2403FAB69@MN2PR11MB3920.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qi+uSBJSO8jxEF0GxqQbl4nHIbPam29PQ9DjvLWJTLKTNZt5x8vNTafq+kIHykKXt8z90rMy4MtsniAK9r/rUbiwtbtPcMf86zR+A06FCzcP+Xz/exj8dZB5rJFbcTuwDBKKH9vQJCj49uKfogZJSO9VFBvhat5omvqDyJYtAvsRwUPxgHGQPWRsEuyZ8Aja1Hw0AgPUARq6m0gQi821dKVmbbzkZAEGJPYmDVmgoFsGEFE3TIJJSKbogK6rWX2Z2rNxeg39PpQxJ8fO+JW58mPFz6LaGP9YBp2RJGJ2NJ3jW0PTIXmdWrQ/ALY/NLCbsqjB730kzYFKrCa6ja2i1p9Qf/Tk5tB+22pAYEj73BEszJWnJv3updc1od9FhERASnE5dchy0c7qEqBOF0egVmYJC+aLg8N7M6s7b7vepX+4NH0jsr3Mc3nkuZm5Do4ZqRs42dfgBmWnDk+xcrSS7eshtXXLIQWRizbDZ9LlbXv8D+JJTku4RNQrXADQCK2RmFzyU1gKgX8MRZ01lp68oyvLiZrfJJdPNFQpj+YDDQe4xV291U3NmL5HJo9UNjNp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(39860400002)(376002)(396003)(66946007)(6916009)(9686003)(52536014)(478600001)(64756008)(55016002)(71200400001)(54906003)(66476007)(316002)(2906002)(7696005)(7416002)(66446008)(66556008)(6506007)(8936002)(4326008)(5660300002)(8676002)(86362001)(26005)(83380400001)(76116006)(33656002)(186003)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VkhtTnpncTBDcWxhdFBKRElvZzNDcndoMDMyZ0VMRGgzWUxKbGxsdVViWFB5?=
 =?utf-8?B?VDg4ZGs1YmovUW9UOTZSNFVHRldXeTdQNGV3YjJKd0JpTnY3T0RJYy9zYUxT?=
 =?utf-8?B?Z3ZYSmhBcVJGVE4ya083c2dMdnRsUDdNdjNJN3llUWU1eTFDaHhKczBzREVS?=
 =?utf-8?B?RVA5cFgwSzArUDVwbmtsWkc4NHRiTlhtMkl6c1pZeXR3RmN3YTlMeE15RnJN?=
 =?utf-8?B?a0VJcnhMQ1lObDhsQUNpZ0ZTNHZaQ3d6Qll4OGl5MWVMSklHa054VFZHeGZH?=
 =?utf-8?B?N3Q0YnRGUFBsOXhXSWxsZnVBZjhMZGxTUTgzVGd4UlZCTThIeVJoRzNLTUsz?=
 =?utf-8?B?bk90ZG5QOGZHTWY4SEp0dkE5RjQvQWFyV0NxbUxMMkg2Nnd2dWlJeDJodDlM?=
 =?utf-8?B?dFFwcTVCMTY1YXRkOVJuekpDb0U3NlFPSDI4UURnSmFVVHhkbFAwMVlpNnV3?=
 =?utf-8?B?MklxUFpsc3pNL3k5bUx4U044WXUxOFVUcWl5SHJoOHA0clVWWVFSQXdsSlpI?=
 =?utf-8?B?T3haSTdjNlF1dVhFSEtDQVpydnNRWnhnb3RtOTlxYXlQQkpXVmxGNmdJU2hi?=
 =?utf-8?B?RHliRTJsdkxUaVVyR0FoVnhZeEFSdDZ0bDdUQ1Z3UHVOTFR0Rk1oeFV2R1kv?=
 =?utf-8?B?UDZlTTE0dWJWUTFKL0gwVFd4RFFXVzgxMGhXaExkSXlMcHZPMmJhVUNzeVlq?=
 =?utf-8?B?Z3R2WC90WVFIZW1OeUMrK09Jc01rMDU4V2IrRFM0N2IyckdKMEZScnV3UGtJ?=
 =?utf-8?B?M2ZWM2ZJc2h6TFY2MHl0Ry9HY2Jjdjlqamg3WjQ0VWJManVMemdSZ0ZrdEQ0?=
 =?utf-8?B?L1NiajYwWExZNzNpUWZFUmVzdnpWa0taSmc5S3NuekpZakpmSTAyaUNHZFZs?=
 =?utf-8?B?V2pSazZFbXFhdktIUnExL1o3bEplTS9rZGhCb0ttRklqYW5mb09tTklMUDJZ?=
 =?utf-8?B?Smh2cDhjdGE4VHFCVWdDTXBaSkNsMzBXSGJjcmZqVjhjQmtYenl0RDJhdmtQ?=
 =?utf-8?B?eEhmWURSaGo2NWRrblZiSXliMVlQTFpITERZS0t2TjdZY1lEVmtVZmY0blZr?=
 =?utf-8?B?eVB0TGRiWFNOZnhHWjdoUVAvb2Zlb0xxWUpsZHFxVzl1UEdpdmpCdk42RG1W?=
 =?utf-8?B?VS80VzRzV2NHZ0E4MXkzSkRRVHgwZzd5Ukk1TXE3N3c0K0YyY2lsT0FZZUlL?=
 =?utf-8?B?V3B1dytHQXZlMnRMVjFGemYwM3ZwUnN4QkhHL3pvQ1diUTE2c1BrajN2bzha?=
 =?utf-8?B?VW9NYVdqRWtWSHdJSHlMenhPdWVMWEY2K3lOajBQSXh4LzVHbXdYRFZqcG8w?=
 =?utf-8?B?Nk1nMjd4Z29QNlFHRHhjZW0rekN0bHA0YmNuc0xHTjh3dDlvTEN1cmxYZ1Z1?=
 =?utf-8?B?WjZmcC9heUlZZ0lERXI4UUdSL2o5TmlIRks2Um1Pb0szS3JzMytXR2FsSmdF?=
 =?utf-8?Q?N44Swbks?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f9ed88-b216-42f6-b662-08d8c6dbdae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 18:04:44.4551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QhE90MmPmFW0m/9dIO9XUnXltkfQ8em7/zH7thzUblmhsNcg/oKIH4JkiMLlW//z5pLxX99jNgBunv7TUk35+UY/+qfLwgjDfxsR36ffx4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3920
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3Zlbiwgc2VlIGJlbG93DQoNCj4gPg0KPiA+IElmIGxhbjc0M3hfcnhfaW5pdF9yaW5nX2Vs
ZW1lbnQgZmFpbHMgdG8gYWxsb2NhdGUgYW4gc2tiLCBUaGVuDQo+ID4gbGFuNzQzeF9yeF9yZXVz
ZV9yaW5nX2VsZW1lbnQgd2lsbCBiZSBjYWxsZWQuDQo+ID4gQnV0IHRoYXQgZnVuY3Rpb24gZXhw
ZWN0cyB0aGUgc2tiIGlzIGFscmVhZHkgYWxsb2NhdGVkIGFuZCBkbWEgbWFwcGVkLg0KPiA+IEJ1
dCB0aGUgZG1hIHdhcyB1bm1hcHBlZCBhYm92ZS4NCj4gDQo+IEdvb2QgY2F0Y2guIEkgdGhpbmsg
eW91J3JlIHJpZ2h0LCB0aGUgc2tiIGFsbG9jYXRpb24gYWx3YXlzIGhhcyB0byBjb21lIGJlZm9y
ZQ0KPiB0aGUgdW5tYXAuIEJlY2F1c2UgaWYgd2UgdW5tYXAsIGFuZCB0aGVuIHRoZSBza2IgYWxs
b2NhdGlvbiBmYWlscywgdGhlcmUgaXMNCj4gbm8gZ3VhcmFudGVlIHRoYXQgd2UgY2FuIHJlbWFw
IHRoZSBvbGQgc2tiIHdlJ3ZlIGp1c3QgdW5tYXBwZWQgKGl0IGNvdWxkDQo+IGZhaWwpLg0KPiBB
bmQgdGhlbiB3ZSdkIGVuZCB1cCB3aXRoIGEgYnJva2VuIGRyaXZlci4NCj4gDQo+IEJVVCBJIGFj
dHVhbGx5IGpvaW5lZCBza2IgYWxsb2MgYW5kIGluaXRfcmluZ19lbGVtZW50LCBiZWNhdXNlIG9m
IGEgdmVyeQ0KPiBzdWJ0bGUgc3luY2hyb25pemF0aW9uIGJ1ZyBJIHdhcyBzZWVpbmc6IGlmIHNv
bWVvbmUgY2hhbmdlcyB0aGUgbXR1DQo+IF9pbl9iZXR3ZWVuXyBza2IgYWxsb2MgYW5kIGluaXRf
cmluZ19lbGVtZW50LCB0aGluZ3Mgd2lsbCBnbyBoYXl3aXJlLA0KPiBiZWNhdXNlIHRoZSBza2Ig
YW5kIG1hcHBpbmcgbGVuZ3RocyB3b3VsZCBiZSBkaWZmZXJlbnQgIQ0KPiANCj4gV2UgY291bGQg
Zml4IHRoYXQgYnkgdXNpbmcgYSBzcGlubG9jayBJIGd1ZXNzLCBidXQgc3luY2hyb25pemF0aW9u
IHByaW1pdGl2ZXMgaW4NCj4gImhvdCBwYXRocyIgbGlrZSB0aGVzZSBhcmUgZmFyIGZyb20gaWRl
YWwuLi4gV291bGQgYmUgbmljZSBpZiB3ZSBjb3VsZCBhdm9pZA0KPiB0aGF0Lg0KPiANCj4gSGVy
ZSdzIGFuIGlkZWE6IHdoYXQgaWYgd2UgZm9sZCAidW5tYXAgZnJvbSBkbWEiIGludG8gaW5pdF9y
aW5nX2VsZW1lbnQoKT8NCj4gVGhhdCB3YXksIHdlIGdldCB0aGUgYmVzdCBvZiBib3RoIHdvcmxk
czogbGVuZ3RoIGNhbm5vdCBjaGFuZ2UgaW4gdGhlDQo+IG1pZGRsZSwgYW5kIHRoZSBmdW5jdGlv
biBjYW4gYWx3YXlzICJiYWNrIG91dCIgd2l0aG91dCB0b3VjaGluZyB0aGUgcmluZw0KPiBlbGVt
ZW50IGluIGNhc2UgYW4gYWxsb2NhdGlvbiBvciBtYXBwaW5nIGZhaWxzLg0KPiANCj4gUHNldWRv
LWNvZGU6DQo+IA0KPiBpbml0X3JpbmdfZWxlbWVudCgpIHsNCj4gICAgIC8qIHNpbmdsZSAic2Ft
cGxpbmciIG9mIG10dSwgc28gbm8gc3luY2hyb25pemF0aW9uIHJlcXVpcmVkICovDQo+ICAgICBs
ZW5ndGggPSBuZXRkZXYtPm10dSArIEVUSF9ITEVOICsgNCArIFJYX0hFQURfUEFERElORzsNCj4g
DQo+ICAgICBza2IgPSBhbGxvYyhsZW5ndGgpOw0KPiAgICAgaWYgKCFza2IpIHJldHVybiBGQUlM
Ow0KPiAgICAgZG1hX3B0ciA9IGRtYV9tYXAoc2tiLCBsZW5ndGgpOw0KPiAgICAgaWYgKCFkbWFf
cHRyKSB7DQo+ICAgICAgICAgZnJlZShza2IpOw0KPiAgICAgICAgIHJldHVybiBGQUlMOw0KPiAg
ICAgfQ0KPiAgICAgaWYgKGJ1ZmZlcl9pbmZvLT5kbWFfcHRyKQ0KPiAgICAgICAgIGRtYV91bm1h
cChidWZmZXJfaW5mby0+ZG1hX3B0ciwgYnVmZmVyX2luZm8tPmJ1ZmZlcl9sZW5ndGgpOw0KPiAg
ICAgYnVmZmVyX2luZm8tPnNrYiA9IHNrYjsNCj4gICAgIGJ1ZmZlcl9pbmZvLT5kbWFfcHRyID0g
ZG1hX3B0cjsNCj4gICAgIGJ1ZmZlcl9pbmZvLT5idWZmZXJfbGVuZ3RoID0gbGVuZ3RoOw0KPiAN
Cj4gICAgIHJldHVybiBTVUNDRVNTOw0KPiB9DQo+IA0KPiBXaGF0IGRvIHlvdSB0aGluaz8NCg0K
WWVzLCBJIGJlbGlldmUgdGhpcyB3aWxsIHdvcmsuDQoNCj4gDQo+ID4NCj4gPiBBbHNvIGlmIGxh
bjc0M3hfcnhfaW5pdF9yaW5nX2VsZW1lbnQgZmFpbHMgdG8gYWxsb2NhdGUgYW4gc2tiLg0KPiA+
IFRoZW4gY29udHJvbCB3aWxsIGp1bXAgdG8gcHJvY2Vzc19leHRlbnNpb24gYW5kIHRoZXJlZm9y
IHRoZSBjdXJyZW50bHkNCj4gPiByZWNlaXZlZCBza2Igd2lsbCBub3QgYmUgYWRkZWQgdG8gdGhl
IHNrYiBsaXN0Lg0KPiA+IEkgYXNzdW1lIHRoYXQgd291bGQgY29ycnVwdCB0aGUgcGFja2V0PyBP
ciBhbSBJIG1pc3Npbmcgc29tZXRoaW5nPw0KPiA+DQo+IA0KPiBZZXMgaWYgYW4gc2tiIGFsbG9j
IGZhaWx1cmUgaW4gdGhlIG1pZGRsZSBvZiBhIG11bHRpLWJ1ZmZlciBmcmFtZSwgd2lsbCBjb3Jy
dXB0DQo+IHRoZSBwYWNrZXQgaW5zaWRlIHRoZSBmcmFtZS4gQSBjaHVuayB3aWxsIGJlIG1pc3Np
bmcuIEkgaGFkIGFzc3VtZWQgdGhhdCB0aGlzDQo+IHdvdWxkIGJlIGNhdWdodCBieSBhbiB1cHBl
ciBuZXR3b3JrIGxheWVyLCBzb21lIGNoZWNrc3VtIHdvdWxkIGJlDQo+IGluY29ycmVjdD8NCj4g
DQo+IEFyZSB0aGVyZSBjdXJyZW50IG5ldHdvcmtpbmcgZGV2aWNlcyB0aGF0IHdvdWxkIHNlbmQg
YSBjb3JydXB0ZWQgcGFja2V0IHRvDQo+IExpbnV4IGlmIHRoZXJlIGlzIGEgY29ycnVwdGlvbiBv
biB0aGUgcGh5c2ljYWwgbGluaz8gRXNwZWNpYWxseSBpZiB0aGV5IGRvbid0DQo+IHN1cHBvcnQg
Y2hlY2tzdW1taW5nPw0KPiANCj4gTWF5YmUgbXkgYXNzdW1wdGlvbiBpcyBuYWl2ZS4NCj4gSSds
bCBmaXggdGhpcyB1cCBpZiB5b3UgYmVsaWV2ZSB0aGF0IGl0IGNvdWxkIGJlIGFuIGlzc3VlLg0K
DQpZZXMgdGhlIHVwcGVyIGxheWVycyB3aWxsIGNhdGNoIGl0IGFuZCBkcm9wIGl0Lg0KQnV0IGlm
IHdlIGFscmVhZHkga25vdyB0aGUgcGFja2V0IGlzIGNvcnJ1cHRlZCwgSSB0aGluayBpdCB3b3Vs
ZCBiZSBiZXR0ZXIgaWYgd2UNCmRyb3BwZWQgaXQgaGVyZSwgdG8gYXZvaWQgdW5uZWNlc3Nhcnkg
cHJvY2Vzc2luZyB1cHN0cmVhbS4NCg0KLi4uDQo+IA0KPiBSWF9QUk9DRVNTX1JFU1VMVF9YWFgg
Y2FuIG5vdyBvbmx5IHRha2UgdHdvIHZhbHVlcyAoUkVDRUlWRUQgYW5kDQo+IE5PVEhJTkdfVE9f
RE8pLCBzbyBpbiB0aGVvcnkgaXQgY291bGQgYmUgcmVwbGFjZWQgYnkgYSBib29sLiBCdXQgcGVy
aGFwcw0KPiB3ZSBzaG91bGQga2VlcCB0aGUgY3VycmVudCBuYW1lcywgYmVjYXVzZSB0aGV5IGFy
ZSBjbGVhcmVyIHRvIHRoZSByZWFkZXI/DQo+IA0KSSdtIG9rIGlmIHlvdSB3YW50IHRvIGNoYW5n
ZSBpdCB0b28gYSBib29sLiANCg0K
