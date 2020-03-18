Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F321894BD
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgCREFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:05:09 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:6166
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726219AbgCREFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 00:05:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEbeDjs1VB0rD+2AP8axIMzVj1mb59QxbpI3eFDm3LJYr0aDjSLPRaVN1CbDbItPKI6T5/xucJznWOvpH3BnSx4lHHoySaPSNVwM/wS/wmm4b5vwj6C1Evbf7aiUq6QtV04CEF9X4dTS+xlwy76/Jhoxksp9e75pdvk4XTAy+AjqpOUkdvPpaQgIVwRDp8W5Pop98rRIwldsLriNr0Ck8z0AyQnRwKdt4E8PmVBd0pfZKVblvmRx7O6+sKO8+zAP83VWW9OCfQJbeNjCufZA/+dB0z9VLtjT2P2yGNpXcEO00hIdbtXZOCDCpIk9GR9OAAV/3lx/wwrnWKjv4EVy5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPXZwbC9T4n8EXPbRGQ2kTBWJKq/1zoxry86sirHyy0=;
 b=JyK0zb1BC758zBunHJfO323wCcQihCnAkxWOunUn+2OLKQgPVuXIcRhumIGtp/fPKoKzNnlFGpCoUsWl66CiixumOcaNbr+mnpwhFCjtm8aTFgjnZksFTP6rd7Zd30t8qzSHw+pwEV24pVf/8FWJdtsswhEphRLbw/vnA5sNOlygdvIWHrN9xfsDHTzu8/acdys3v1TGOmrXj287iYfwBra3+WovQruqyS46Ehb1WiR4aIW0l3H+Yp83wilv/dI4XSwoZ9tEVqUiAAj48Z4Kzr8UKeivmbNH9eKdidlKEV6mxl0oxcccTRqjNRRocexlUKtuhtUVj5oHyDQJRdnSEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPXZwbC9T4n8EXPbRGQ2kTBWJKq/1zoxry86sirHyy0=;
 b=RjCw+Er4HbSdoale1u2NWI3sy6P9barr+s+PtIty8NEZVANpQwg0Ws/tLGDS85zsBWvPhRUnce6bapzaGOr1VXH4ZeSgU4k5H9yGd0pbVavS9LekyZXmuT2OKkJWwXO5v3CADo2VEs9WqYs9farKoEeM5lJCvWW6joJcvQIyWHA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6733.eurprd05.prod.outlook.com (10.186.163.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 04:05:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 04:05:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Paul Blakey <paulb@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Topic: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Index: AQHVr0HWrJ3tUt3ylke6yfGwXQxlbqezP/qAgAD6fYCACo6eAICMWk4AgAMxNICAAAGygA==
Date:   Wed, 18 Mar 2020 04:05:05 +0000
Message-ID: <bbfe6e031a0b70c5143f759469154a0714af0dd5.camel@mellanox.com>
References: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
         <1575972525-20046-2-git-send-email-wenxu@ucloud.cn>
         <140d29e0-712a-31b0-e7b0-e4f8af29d4a8@mellanox.com>
         <a96ffa33-e680-d92c-3c5c-f86b7b9e12bb@ucloud.cn>
         <62c3d7ec655b0209d2f5d573070e484ac561033c.camel@mellanox.com>
         <02ad5abe-8a1c-8e39-3c8e-e78c3186ef79@ucloud.cn>
         <94f07fd5a39e22ced54162d77b1089f46544030d.camel@mellanox.com>
In-Reply-To: <94f07fd5a39e22ced54162d77b1089f46544030d.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32437f34-9b17-44b0-e18b-08d7caf18a71
x-ms-traffictypediagnostic: VI1PR05MB6733:|VI1PR05MB6733:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB673374640A65FBD0E620728BBEF70@VI1PR05MB6733.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(199004)(2616005)(91956017)(2906002)(66556008)(66476007)(86362001)(66946007)(76116006)(6486002)(64756008)(66446008)(81156014)(36756003)(5660300002)(4326008)(6512007)(8676002)(966005)(4001150100001)(316002)(8936002)(478600001)(71200400001)(6636002)(186003)(6506007)(53546011)(26005)(110136005)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6733;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oT4mltKwSpghzVPKTOTF3+lKRy/RhOD943mFnYKHO5BqIpO2micA7CYqL0iuxlIor3JPoK2QmNYVoGcBDvZB0a4onLaant64yHR6VyKePnkdUGmRvaw55eWHfdzjiBXGxSlY2NHzl/aMD4cL2TJVQXZWmntnZNr8l2kK2NxIPZDHrZuzrJ1iIuwScPzA4t7EValRZb3BmLfpIyHXUOehAwEq49wQsB6JOwpIC7RsZk0PQDE/QFdib20mLxhttcozmff43jFUVm9DHZmeDGRyjPULx9VbZAsnnS9q42ZnS1WkWh/M+/Nt88rLwv21fVmXu1ZnRVhxLywmoZ+TiNBFI+hSX+pokk/FBAAmelpnhACoryqFrQyZuSGxYYfUqTHu3uLkeLgIMG4x2zlb94Hzz7qCFQmdVMkP5Nuuy3APc8FTLdSMYtIaHj2MIREiTrLAQjNImgPNQoFLHdlY+aX7luBfi+0N+Sa7S1zY31yg8okzvm2F+TTUg4Pp2AMTA/mON/yQGThgWeQNJWbso38dog==
x-ms-exchange-antispam-messagedata: +jyNVKrWWN6NynJTjAMjaYwWqtPWqJcjunaltB8NwNtQC4VKIgWDjqPOMUJ+pAJgS3ggrbfQCtHLs4uMUSffJURaEG/J7dYI6vRwEwSqyMWzunr+QLgJrnMPRLUp7l01sFbH8mnqbAxP+2z30rPIYQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BCE565CF85410429D0DC13AE446D5CB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32437f34-9b17-44b0-e18b-08d7caf18a71
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 04:05:05.4153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aNY619h4sHGe8XJhRVES3bOAV14i9vWnLIjKtsPFXahn2MzIXmVwDMmpHn0OguwcucraCzk7ufLWHHcnvz0dqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6733
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAzLTE3IGF0IDIwOjU4IC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gT24gTW9uLCAyMDIwLTAzLTE2IGF0IDExOjE0ICswODAwLCB3ZW54dSB3cm90ZToNCj4gPiBP
biAxMi8xOC8yMDE5IDM6NTQgQU0sIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPiA+ID4gT24gV2Vk
LCAyMDE5LTEyLTExIGF0IDEwOjQxICswODAwLCB3ZW54dSB3cm90ZToNCj4gPiA+ID4gT24gMTIv
MTAvMjAxOSA3OjQ0IFBNLCBQYXVsIEJsYWtleSB3cm90ZToNCj4gPiA+ID4gPiBPbiAxMi8xMC8y
MDE5IDEyOjA4IFBNLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6DQo+ID4gPiA+ID4gPiBGcm9tOiB3
ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBBZGQgbWx4
NWVfcmVwX2luZHJfc2V0dXBfZnRfY2IgdG8gc3VwcG9ydCBpbmRyIGJsb2NrIHNldHVwDQo+ID4g
PiA+ID4gPiBpbiBGVCBtb2RlLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBTaWduZWQtb2Zm
LWJ5OiB3ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KPiA+ID4gPiA+ID4gLS0tDQo+ID4gPiBbLi4u
XQ0KPiA+ID4gDQo+ID4gPiA+ID4gK2NjIFNhZWVkDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gVGhpcyBsb29rcyBnb29kIHRvIG1lLCBidXQgaXQgc2hvdWxkIGJlIG9uIHRvcCBv
ZiBhIHBhdGNoDQo+ID4gPiA+ID4gdGhhdA0KPiA+ID4gPiA+IHdpbGwgDQo+ID4gPiA+ID4gYWN0
dWFsIGFsbG93cyB0aGUgaW5kaXJlY3QgQklORCBpZiB0aGUgbmZ0DQo+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gdGFibGUgZGV2aWNlIGlzIGEgdHVubmVsIGRldmljZS4gSXMgdGhhdCB1cHN0cmVhbT8g
SWYgc28NCj4gPiA+ID4gPiB3aGljaA0KPiA+ID4gPiA+IHBhdGNoPw0KPiA+ID4gPiA+IA0KPiA+
ID4gPiA+IA0KPiA+ID4gPiA+IEN1cnJlbnRseSAoNS41LjAtcmMxKyksIG5mdF9yZWdpc3Rlcl9m
bG93dGFibGVfbmV0X2hvb2tzDQo+ID4gPiA+ID4gY2FsbHMgDQo+ID4gPiA+ID4gbmZfZmxvd190
YWJsZV9vZmZsb2FkX3NldHVwIHdoaWNoIHdpbGwgc2VlDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
dGhhdCB0aGUgdHVubmVsIGRldmljZSBkb2Vzbid0IGhhdmUgbmRvX3NldHVwX3RjIGFuZCByZXR1
cm4gDQo+ID4gPiA+ID4gLUVPUE5PVFNVUFBPUlRFRC4NCj4gPiA+ID4gVGhlIHJlbGF0ZWQgcGF0
Y2ggIGh0dHA6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wYXRjaC8xMjA2OTM1Lw0KPiA+ID4gPiAN
Cj4gPiA+ID4gaXMgd2FpdGluZyBmb3IgdXBzdHJlYW0NCj4gPiA+ID4gDQo+ID4gPiBUaGUgbmV0
ZmlsdGVyIHBhdGNoIGlzIHN0aWxsIHVuZGVyLXJldmlldywgb25jZSBhY2NlcHRlZCBpIHdpbGwN
Cj4gPiA+IGFwcGx5DQo+ID4gPiB0aGlzIHNlcmllcy4NCj4gPiA+IA0KPiA+ID4gVGhhbmtzLA0K
PiA+ID4gU2FlZWQuDQo+ID4gPiANCj4gPiBIaSBTYWVlZCwNCj4gPiANCj4gPiANCj4gPiBTb3Jy
eSBmb3Igc28gbG9uZyB0aW1lIHRvIHVwZGF0ZS4gVGhlIG5ldGZpbHRlciBwYXRjaCBpcyBhbHJl
YWR5DQo+ID4gYWNjZXB0ZWQuICBUaGlzIHNlcmllcyBpcyBhbHNvDQo+ID4gDQo+ID4gbm90IG91
dCBvZiBkYXRlIGFuZCBjYW4gYXBwbHkgdG8gbmV0LW5leHQuICBJZiB5b3UgZmVlbCBvayAgcGxl
YXNlDQo+ID4gYXBwbHkgaXQgdGhhbmtzLg0KPiA+IA0KPiA+IA0KPiA+IFRoZSBuZXRmaWx0ZXIg
cGF0Y2g6DQo+ID4gDQo+ID4gaHR0cDovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNoLzEyNDI4
MTUvDQo+ID4gDQo+ID4gQlINCj4gPiANCj4gPiB3ZW54dQ0KPiA+IA0KPiANCj4gQXBwbGllZCB0
byBuZXQtbmV4dC1tbHg1LCAgZG9pbmcgc29tZSBidWlsZCB0ZXN0aW5nIG5vdywgYW5kIHdpbGwN
Cj4gbWFrZQ0KPiB0aGlzIHJ1biBpbiByZWdyZXNzaW9uIGZvciBhIGNvdXBsZSBvZiBkYXlzIHVu
dGlsIG15IG5leHQgcHVsbA0KPiByZXF1ZXN0DQo+IHRvIG5ldC1uZXh0Lg0KPiANCg0KaG1tbSwg
aSB3YXMgdG9vIG9wdGltaXN0aWMsIHBhdGNoZXMgZ290IGJsb2NrZWQgYnkgQ0ksIGFwcGFyZW50
bHkgc29tZQ0KY2hhbmdlcyBpbiBtbHg1IGVzd2l0Y2ggQVBJIGFyZSBjYXVzaW5nIHRoZSBmb2xs
b3dpbmcgZmFpbHVyZSwgbW9zdA0KbGlrZWx5IGR1ZSB0byB0aGUgaW50cm9kdWN0aW9uIG9mIGVz
d2l0Y2hfY2hhaW5zIEFQSS4NCg0KMDU6NTc6NDcgbWFrZSAtcyAtaiA5NiBDQz0vdXNyL2xsdm0v
YmluL2NsYW5nDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvDQowNTo1
ODoxNCBlcnJvcjogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3Jl
cC5jOjc1Mjo4Og0KZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uICdtbHg1
X2Vzd2l0Y2hfcHJpb3Nfc3VwcG9ydGVkJw0KWy1XZXJyb3IsLVdpbXBsaWNpdC1mdW5jdGlvbi1k
ZWNsYXJhdGlvbl0NCjA1OjU4OjE0IGVycm9yOiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fcmVwLmM6NzUyOjg6DQpub3RlOiBkaWQgeW91IG1lYW4gJ21seDVfZXN3
X2NoYWluc19wcmlvc19zdXBwb3J0ZWQnPw0KMDU6NTg6MTQgDQoNCg0KUGxlYXNlIHJlYmFzZSBh
bmQgcmUtdGVzdCwgSSBjYW4gaGVscCB5b3Ugd2l0aCBtb3JlIGRldGFpbHMgaWYgeW91DQpuZWVk
Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg0KPiBUaGFua3MsDQo+IHNhZWVkLg0K
