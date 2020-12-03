Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D916E2CCE45
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 06:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgLCFHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 00:07:38 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19961 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgLCFHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 00:07:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc872700004>; Wed, 02 Dec 2020 21:06:56 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 05:06:51 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 3 Dec 2020 05:06:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsXcR5pzGrLbAwAPbsTP9Dz0IRicIoWIrpy9IfqfYrqkeqVdEGjzCmoe5LwxF3JskHZ4jLMA0savhPRW6hMBXANneaq9uT5gcbphexpJJuKs/5uJ0br9XGj312J4QedXaAcBqvJEP/zylZgiLMZjHixzXWMWXKQV0vtKuF4S/hNizN6+EaQEvRWGmNDkkMND6kwXLpYePOLVXAgLlEbELHbjSJCu7Mt8igqLCTAL6xFEE+NEQUNz78QZ7HCstWceD8fLlKLGA8rJVddHJpmYw53i21vRNR+IcPs06OuuHfb0w3TCqob5HC9IhZeeb1AJiOP7uuSFjSYO30SEJpDyyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvAJtP1VMwk7yE3i+W1uOWfTVAQHMwbXDIyXQUDx95g=;
 b=SqpOh9aIE72c0wxmkSypoWBrKyps9kq3iWmPXad3WU2iuTS/HPPLSW0fkWr+VpFwGWlKn9+1ZgyIaRukTdqGZ/RBJ/yGx11zI/9ZUjNTs1Uz0on/qYtLm4fz4u1FJ5PBf2h3G30JbqCGJn8+0z/M1V3d4JFyL8VHAIda+Tdvudz7QVQaE0+Z4VGagogAd2lh/A/fnLiW0nLxjFot8+XWiSvxhUGlINeiN8UHkrR26brK6kT5jZQtjhL4auAOq5e5GnpZ3DDhvSnxU526XxHeYj0HkCmlQnv9zP38MCKuVWjJOjHf6Erl4U48v7x7p+wNf0O+ONyL5GmyUAtIxSp4xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2998.namprd12.prod.outlook.com (2603:10b6:a03:dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Thu, 3 Dec
 2020 05:06:50 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Thu, 3 Dec 2020
 05:06:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v3] devlink: Add devlink port documentation
Thread-Topic: [PATCH net-next v3] devlink: Add devlink port documentation
Thread-Index: AQHWyLKkMIcI4dDkc0yBgNv3Oa2Dq6nkpkgAgAAkruA=
Date:   Thu, 3 Dec 2020 05:06:50 +0000
Message-ID: <BY5PR12MB43222477EECDCC3D90FD6A84DCF20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164119.571362-1-parav@nvidia.com>
 <20201202135337.937538-1-parav@nvidia.com>
 <13de3998-1e0f-9a53-4b75-53fd1e74ecee@infradead.org>
In-Reply-To: <13de3998-1e0f-9a53-4b75-53fd1e74ecee@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.130.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acfb8f6d-64c8-4b83-f8b1-08d897493e1b
x-ms-traffictypediagnostic: BYAPR12MB2998:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2998D5F6554A83CBB2798B97DCF20@BYAPR12MB2998.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h81qAXpoKz+mUAO1UJw9GjcV2w/uGg2f/qUQKQ334WnOYgCbZMI/Agts612JSL94oQkbyzH8W9ZMpnbcEwHqTb5Igus83YbVVLoJ9DkM0euX/1D+HD5sji7MUdFzHwn0loAPEkMbJQwvsqGhUXnEQeR0LgXxuxsWvkSPL+hAI4iZgoXJ6uJD8nDc3lsR/057UruLX7qYBcBGE88ObqrE4jghxK9t9g8HWdu4Z9I5HWDc7XgGjFsaxxP2aXhHD0EXdKQtbruRl89N6dcnIWn1XXCf+XyCcilZtcBqUGdEM8Qrgl4+eN2FXDwyvg9ePzr9sDBjDqY8cYQK/zGLolu5fg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(4326008)(76116006)(7696005)(186003)(478600001)(8936002)(9686003)(55016002)(66946007)(86362001)(316002)(110136005)(66446008)(71200400001)(83380400001)(64756008)(52536014)(33656002)(54906003)(53546011)(6506007)(107886003)(66476007)(26005)(2906002)(8676002)(66556008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VGMxQUR5NGsyd1drQWJWblE0SGhHNFlEYW5maVBBVElTQXRBUHNjckRCdm56?=
 =?utf-8?B?N3RPdUcxcDJ1YWR3RmFCS1VWY0p3UmJNSFkzdlcvZlg4LzhHVzRrc09VczY1?=
 =?utf-8?B?NHMySnA2Q3hQZEwzQ0ZsemdVWVg0YTBtbWNOdE11ZCthSEdlNlBhT1dHNFE5?=
 =?utf-8?B?OWFhOGdtZDFIR2FNU0QvRjdPenlueGkveE8xM2RQRnhJR3BuZVZ4SzdVYkQ1?=
 =?utf-8?B?Vk5LcmVjVWNEWmVvQjNYcHQ0T0FvVHVML05uVTJjczVxSkpDeUVjQ0J4THhZ?=
 =?utf-8?B?QnhUZGFqcE8xUFd3Y0pBM1oyTEhCOWw1N3ZFVXZaNUxVSGwxTVBLTHp6aDFC?=
 =?utf-8?B?ZTY1VDE0d2VLdThVY2szeFhLZ2d1eGIxS0o4U3JQR0xhV05MVUZZYXpmWDcv?=
 =?utf-8?B?bmVtdXBEZi9LRERuTmFmRHd0cHRQQTd0WnkrWS92eE52SW0yODN4ZGVNQjhY?=
 =?utf-8?B?eStJQzNCSHRFQnlvdklHU0ovdTNqUENYMS9JUk5QZUtoelN3K0tOOENRdEp3?=
 =?utf-8?B?czB5U2ljK25PdlBzbkhUNkgxMnl0Szk5eUQwVkJ2S0wrWWFyR2JtenZEeXBu?=
 =?utf-8?B?Wk95MkhwWThua1hTSmk3c2V2cVkxZVNNZFc0L0xWMVJKN0EvbUkwYkpOdUNM?=
 =?utf-8?B?b0FNTmFFcEtkTDdvY1VvQzZHelhYVjlwaVJuTklVbjJDNjVZWXV3WUd0eWp2?=
 =?utf-8?B?ZHJ4QnI1M3piMWZCRmxsa0xxRkY1b1lZcytFT2Z3Njh2ekVQN3BVZHh3Y21Y?=
 =?utf-8?B?T1RidG1zRUt6SjJNdndEaVF6emw0UTVhS3N4SFNyZkFPV2VUV3NjZDJNd05I?=
 =?utf-8?B?UWFMbk9oR1VQaElydjFpbFE1ejcxbW9xNnhXNWpPbUVTRjNnOEU0SGVVUk9I?=
 =?utf-8?B?TlhUbmlVaVpwUzJBTmU2aENzQ3o3dFpBbUZWQVdLVjM1WTE4TlV0bml5YkpB?=
 =?utf-8?B?WUZXZ2VLelZaaUp3R3BlaWRnd3RyaVdyeGVERVNtSTNRU3MyUWdzM3lEcDc5?=
 =?utf-8?B?RXdVem1kczFzeXcyZ2d3Ky9qOGdnVGJ6amJPYnVYMDQvdndwQTdLWTZCV2Ey?=
 =?utf-8?B?bUR4YWpWeEVvdHczaUpKNytMcFF4MzRMTDJaL3dISWxDNjAyZzAzcnE2Q3JQ?=
 =?utf-8?B?VTdheHRiNmtSZytyOHJHcWdmaG1KS05QS1NSU3U2TXk2ajBMQ01JVEE3bmZE?=
 =?utf-8?B?bmcwREVLbUVGVWVDR0UrTHZhNWErTkh0TTRzTXI3dkFLajJJOVgxZ216TTdI?=
 =?utf-8?B?bjZGYXBDVVdFc25SeU51aURObFh3cWtEVHRkeWZIUjA3YmFYWDEyYmFMTXlu?=
 =?utf-8?Q?OXxfX59I8voHD2LPY54v0zHechlVdNmqH5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acfb8f6d-64c8-4b83-f8b1-08d897493e1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 05:06:50.2496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3IJcjQZTFaE32k8BeAjgDf+XPN1yUM2SAie8VDYKWYQWrWDeVKr3RBhAhBjzMTxF5UuHUebk1fu9Wa7YHlrmtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2998
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606972016; bh=yvAJtP1VMwk7yE3i+W1uOWfTVAQHMwbXDIyXQUDx95g=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=EVnS9xMBMZPyxf0vDtSmPZk04CDJzbPq9zlb2DYSnd4g1E4IsRr3JbDr71/6DWA8p
         6xiv6QXkZMKuotpmbTW/onItaZMzQ5BulOwkpiXEPpakEBKPv9arwBSK0vURW4aXUq
         RcQTaoA5zePz/Ns5wJyNMXiJfAS+8TNeldDRa/ZaFzSjzgWCcqlLjO0TvsLllzGuzf
         2YluY6Do5Cwemfi/heHs9svPU/aLB0yIqFwW1U6Ww5dvraajPYM52dLBVhD0XwQu+k
         oAnFBtvbzr7LJfujBgqKpAobzVK5f0J31K/Lo1AEL5g0qH/1ottXybosy4u428KKat
         nrKvhmmnzxZ8w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQo+IFNlbnQ6
IFRodXJzZGF5LCBEZWNlbWJlciAzLCAyMDIwIDc6NTcgQU0NCj4gDQo+IEhpLS0NCj4gDQo+IE9u
IDEyLzIvMjAgNTo1MyBBTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IEFkZGVkIGRvY3VtZW50
YXRpb24gZm9yIGRldmxpbmsgcG9ydCBhbmQgcG9ydCBmdW5jdGlvbiByZWxhdGVkIGNvbW1hbmRz
Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEuY29t
Pg0KPiA+IFJldmlld2VkLWJ5OiBKaXJpIFBpcmtvIDxqaXJpQG52aWRpYS5jb20+DQo+ID4gUmV2
aWV3ZWQtYnk6IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiA+IC0t
LQ0KPiA+IENoYW5nZWxvZzoNCj4gPiB2Mi0+djM6DQo+ID4gIC0gcmVwaGFzZWQgbWFueSBsaW5l
cw0KPiANCj4gICAgICByZXBocmFzZWQNCj4gDQo+ID4gIC0gZmlyc3QgcGFyYWdyYXBoIG5vdyBk
ZXNjcmliZSBkZXZsaW5rIHBvcnQNCj4gPiAgLSBpbnN0ZWFkIG9mIHNheWluZyBQQ0kgZGV2aWNl
L2Z1bmN0aW9uLCB1c2luZyBQQ0kgZnVuY3Rpb24gZXZlcnkNCj4gPiAgICB3aGVyZQ0KPiA+ICAt
IGNoYW5nZWQgJ3BoeXNpY2FsIGxpbmsgbGF5ZXInIHRvICdsaW5rIGxheWVyJw0KPiA+ICAtIG1h
ZGUgZGV2bGluayBwb3J0IHR5cGUgZGVzY3JpcHRpb24gbW9yZSBjbGVhcg0KPiA+ICAtIG1hZGUg
ZGV2bGluayBwb3J0IGZsYXZvdXIgZGVzY3JpcHRpb24gbW9yZSBjbGVhcg0KPiA+ICAtIG1vdmVk
IGRldmxpbmsgcG9ydCB0eXBlIHRhYmxlIGFmdGVyIHBvcnQgZmxhdm91cg0KPiA+ICAtIGFkZGVk
IGRlc2NyaXB0aW9uIGZvciB0aGUgZXhhbXBsZSBkaWFncmFtDQo+ID4gIC0gZGVzY3JpYmUgQ1BV
IHBvcnQgdGhhdCBpdHMgbGlua2VkIHRvIERTQQ0KPiA+ICAtIG1hZGUgZGV2bGluayBwb3J0IGRl
c2NyaXB0aW9uIGZvciBlc3dpdGNoIHBvcnQgbW9yZSBjbGVhcg0KPiA+IHYxLT52MjoNCj4gPiAg
LSBSZW1vdmVkIGR1cGxpY2F0ZSB0YWJsZSBlbnRyaWVzIGZvciBERVZMSU5LX1BPUlRfRkxBVk9V
Ul9WSVJUVUFMLg0KPiA+ICAtIHJlcGxhY2VkICdjb25zaXN0IG9mJyB0byAnY29uc2lzdGluZycN
Cj4gPiAgLSBjaGFuZ2VkICdjYW4gYmUnIHRvICdjYW4gYmUgb2YnDQo+ID4gLS0tDQo+ID4gIC4u
Li9uZXR3b3JraW5nL2RldmxpbmsvZGV2bGluay1wb3J0LnJzdCAgICAgICB8IDExMSArKysrKysr
KysrKysrKysrKysNCj4gPiAgRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2RldmxpbmsvaW5kZXgu
cnN0ICAgIHwgICAxICsNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMTIgaW5zZXJ0aW9ucygrKQ0K
PiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2Rldmxpbmsv
ZGV2bGluay1wb3J0LnJzdA0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vbmV0
d29ya2luZy9kZXZsaW5rL2RldmxpbmstcG9ydC5yc3QNCj4gPiBiL0RvY3VtZW50YXRpb24vbmV0
d29ya2luZy9kZXZsaW5rL2RldmxpbmstcG9ydC5yc3QNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0
NA0KPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uODQwN2JiZTljZTg4DQo+ID4gLS0tIC9kZXYvbnVs
bA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9kZXZsaW5rL2RldmxpbmstcG9y
dC5yc3QNCj4gPiBAQCAtMCwwICsxLDExMSBAQA0KPiA+ICsuLiBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogR1BMLTIuMA0KPiA+ICsNCj4gPiArPT09PT09PT09PT09DQo+ID4gK0RldmxpbmsgUG9y
dA0KPiA+ICs9PT09PT09PT09PT0NCj4gPiArDQo+ID4gK2BgZGV2bGluay1wb3J0YGAgaXMgYSBw
b3J0IHRoYXQgZXhpc3Qgb24gdGhlIGRldmljZS4gQSBkZXZsaW5rIHBvcnQNCj4gPiArY2FuDQo+
IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGV4aXN0cw0KPiANCj4gPiAr
YmUgb2Ygb25lIGFtb25nIG1hbnkgZmxhdm91cnMuIEEgZGV2bGluayBwb3J0IGZsYXZvdXIgYWxv
bmcgd2l0aCBwb3J0DQo+ID4gK2F0dHJpYnV0ZXMgZGVzY3JpYmUgd2hhdCBhIHBvcnQgcmVwcmVz
ZW50cy4NCj4gPiArDQo+ID4gK0EgZGV2aWNlIGRyaXZlciB3aG8gaW50ZW50cyB0byBwdWJsaXNo
IGEgZGV2bGluayBwb3J0LCBzZXRzIHRoZQ0KPiANCj4gICAgICAgICAgICAgICAgICAgIHRoYXQg
aW50ZW5kcyAgICAgICAgICAgICAgICAgICAgICAgICBebm8gY29tbWENCj4gDQo+ID4gK2Rldmxp
bmsgcG9ydCBhdHRyaWJ1dGVzIGFuZCByZWdpc3RlcnMgdGhlIGRldmxpbmsgcG9ydC4NCj4gPiAr
DQo+ID4gK0RldmxpbmsgcG9ydCBmbGF2b3VycyBhcmUgZGVzY3JpYmVkIGJlbG93Lg0KPiA+ICsN
Cj4gPiArLi4gbGlzdC10YWJsZTo6IExpc3Qgb2YgZGV2bGluayBwb3J0IGZsYXZvdXJzDQo+ID4g
KyAgIDp3aWR0aHM6IDMzIDkwDQo+ID4gKw0KPiA+ICsgICAqIC0gRmxhdm91cg0KPiA+ICsgICAg
IC0gRGVzY3JpcHRpb24NCj4gPiArICAgKiAtIGBgREVWTElOS19QT1JUX0ZMQVZPVVJfUEhZU0lD
QUxgYA0KPiA+ICsgICAgIC0gQW55IGtpbmQgb2YgcGh5c2ljYWwgbmV0d29ya2luZyBwb3J0LiBU
aGlzIGNhbiBiZSBhIGVzd2l0Y2gNCj4gPiArIHBoeXNpY2FsDQo+IA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhbg0KPiANCj4g
PiArICAgICAgIHBvcnQgb3IgYW55IG90aGVyIHBoeXNpY2FsIHBvcnQgb24gdGhlIGRldmljZS4N
Cj4gPiArICAgKiAtIGBgREVWTElOS19QT1JUX0ZMQVZPVVJfRFNBYGANCj4gPiArICAgICAtIFRo
aXMgaW5kaWNhdGVzIGEgRFNBIGludGVyY29ubmVjdCBwb3J0Lg0KPiA+ICsgICAqIC0gYGBERVZM
SU5LX1BPUlRfRkxBVk9VUl9DUFVgYA0KPiA+ICsgICAgIC0gVGhpcyBpbmRpY2F0ZXMgYSBDUFUg
cG9ydCBhcHBsaWNhYmxlIG9ubHkgdG8gRFNBLg0KPiA+ICsgICAqIC0gYGBERVZMSU5LX1BPUlRf
RkxBVk9VUl9QQ0lfUEZgYA0KPiA+ICsgICAgIC0gVGhpcyBpbmRpY2F0ZXMgYW4gZXN3aXRjaCBw
b3J0IHJlcHJlc2VudGluZyBhIG5ldHdvcmtpbmcgcG9ydCBvZg0KPiA+ICsgICAgICAgUENJIHBo
eXNpY2FsIGZ1bmN0aW9uIChQRikuDQo+ID4gKyAgICogLSBgYERFVkxJTktfUE9SVF9GTEFWT1VS
X1BDSV9WRmBgDQo+ID4gKyAgICAgLSBUaGlzIGluZGljYXRlcyBhbiBlc3dpdGNoIHBvcnQgcmVw
cmVzZW50aW5nIGEgbmV0d29ya2luZyBwb3J0IG9mDQo+ID4gKyAgICAgICBQQ0kgdmlydHVhbCBm
dW5jdGlvbiAoVkYpLg0KPiA+ICsgICAqIC0gYGBERVZMSU5LX1BPUlRfRkxBVk9VUl9WSVJUVUFM
YGANCj4gPiArICAgICAtIFRoaXMgaW5kaWNhdGVzIGEgdmlydHVhbCBwb3J0IGZvciB0aGUgdmly
dHVhbCBQQ0kgZGV2aWNlIHN1Y2ggYXMgUENJIFZGLg0KPiA+ICsNCj4gPiArQSBkZXZsaW5rIHBv
cnQgdHlwZXMgYXJlIGRlc2NyaWJlZCBiZWxvdy4NCj4gDQo+ICAgVGhlIGRldmxpbmsgcG9ydCB0
eXBlcw0KPiANCj4gPiArDQo+ID4gKy4uIGxpc3QtdGFibGU6OiBMaXN0IG9mIGRldmxpbmsgcG9y
dCB0eXBlcw0KPiA+ICsgICA6d2lkdGhzOiAyMyA5MA0KPiA+ICsNCj4gPiArICAgKiAtIFR5cGUN
Cj4gPiArICAgICAtIERlc2NyaXB0aW9uDQo+ID4gKyAgICogLSBgYERFVkxJTktfUE9SVF9UWVBF
X0VUSGBgDQo+ID4gKyAgICAgLSBEcml2ZXIgc2hvdWxkIHNldCB0aGlzIHBvcnQgdHlwZSB3aGVu
IGEgbGluayBsYXllciBvZiB0aGUgcG9ydCBpcyBFdGhlcm5ldC4NCj4gPiArICAgKiAtIGBgREVW
TElOS19QT1JUX1RZUEVfSUJgYA0KPiA+ICsgICAgIC0gRHJpdmVyIHNob3VsZCBzZXQgdGhpcyBw
b3J0IHR5cGUgd2hlbiBhIGxpbmsgbGF5ZXIgb2YgdGhlIHBvcnQgaXMgSW5maW5pQmFuZC4NCj4g
PiArICAgKiAtIGBgREVWTElOS19QT1JUX1RZUEVfQVVUT2BgDQo+ID4gKyAgICAgLSBUaGlzIHR5
cGUgaXMgaW5kaWNhdGVkIGJ5IHRoZSB1c2VyIHdoZW4gdXNlciBwcmVmZXJzIHRvIHNldCB0aGUg
cG9ydCB0eXBlDQo+ID4gKyAgICAgICB0byBiZSBhdXRvbWF0aWNhbGx5IGRldGVjdGVkIGJ5IHRo
ZSBkZXZpY2UgZHJpdmVyLg0KPiA+ICsNCj4gPiArQSBjb250cm9sbGVyIGNvbnNpc3Qgb2Ygb25l
IG9yIG1vcmUgUENJIGZ1bmN0aW9ucy4gU3VjaCBQQ0kgZnVuY3Rpb24NCj4gPiArY2FuIGhhdmUg
b25lDQo+IA0KPiAgICAgICAgICAgICAgICAgY29uc2lzdHMNCj4gDQo+ID4gK29yIG1vcmUgbmV0
d29ya2luZyBwb3J0cy4gQSBuZXR3b3JraW5nIHBvcnQgb2Ygc3VjaCBQQ0kgZnVuY3Rpb24gaXMN
Cj4gPiArcmVwcmVzZW50ZWQgYnkgdGhlIGVzd2l0Y2ggZGV2bGluayBwb3J0LiBBIGRldmxpbmsg
aW5zdGFuY2UgaG9sZHMNCj4gPiArcG9ydHMgb2YgdHdvIHR5cGVzIG9mIGNvbnRyb2xsZXJzLg0K
PiA+ICsNCj4gPiArKDEpIGNvbnRyb2xsZXIgZGlzY292ZXJlZCBvbiBzYW1lIHN5c3RlbSB3aGVy
ZSBlc3dpdGNoIHJlc2lkZXM6DQo+ID4gK1RoaXMgaXMgdGhlIGNhc2Ugd2hlcmUgUENJIFBGL1ZG
IG9mIGEgY29udHJvbGxlciBhbmQgZGV2bGluayBlc3dpdGNoDQo+ID4gK2luc3RhbmNlIGJvdGgg
YXJlIGxvY2F0ZWQgb24gYSBzaW5nbGUgc3lzdGVtLg0KPiA+ICsNCj4gPiArKDIpIGNvbnRyb2xs
ZXIgbG9jYXRlZCBvbiBleHRlcm5hbCBob3N0IHN5c3RlbS4NCj4gPiArVGhpcyBpcyB0aGUgY2Fz
ZSB3aGVyZSBhIGNvbnRyb2xsZXIgaXMgbG9jYXRlZCBpbiBvbmUgc3lzdGVtIGFuZCBpdHMNCj4g
PiArZGV2bGluayBlc3dpdGNoIHBvcnRzIGFyZSBsb2NhdGVkIGluIGEgZGlmZmVyZW50IHN5c3Rl
bS4gU3VjaA0KPiA+ICtjb250cm9sbGVyIGlzIGNhbGxlZCBleHRlcm5hbCBjb250cm9sbGVyLg0K
PiA+ICsNCj4gPiArQW4gZXhhbXBsZSB2aWV3IG9mIHR3byBjb250cm9sbGVyIHN5c3RlbXM6Og0K
PiA+ICsNCj4gPiArSW4gdGhpcyBleGFtcGxlIGEgY29udHJvbGxlciB3aGljaCBjb250YWlucyB0
aGUgZXN3aXRjaCBpcyBsb2NhbA0KPiA+ICtjb250cm9sbGVyIHdpdGggY29udHJvbGxlciBudW1i
ZXIgPSAwLiBUaGUgc2Vjb25kIGlzIGEgZXh0ZXJuYWwNCj4gPiArY29udHJvbGxlciBoYXZpbmcg
Y29udHJvbGxlciBudW1iZXIgPSAxLiBFc3dpdGNoIGRldmxpbmsgaW5zdGFuY2UgaGFzDQo+ID4g
K3JlcHJlc2VudG9yIGRldmxpbmsgcG9ydHMgZm9yIHRoZSBQQ0kgZnVuY3Rpb25zIG9mIGJvdGgg
dGhlIGNvbnRyb2xsZXJzLg0KPiANCj4gSSBmaW5kIHRoYXQgc2VudGVuY2UgY29uZnVzaW5nIGJ1
dCBJIGRvbid0IGtub3cgaG93IHRvIGZpeCBpdC4NCj4gDQpXaWxsIHJld3JpdGUgaXQgYXMgYmVs
b3cgYW5kIGFsc28gYWRkcmVzcyBhYm92ZSBjb21tZW50cy4NCg0KSW4gdGhpcyBleGFtcGxlLCBl
eHRlcm5hbCBjb250cm9sbGVyIChpZGVudGlmaWVkIGJ5IGNvbnRyb2xsZXIgbnVtYmVyID0gMSkg
ZG9lc24ndCBoYXZlIGVzd2l0Y2guDQpMb2NhbCBjb250cm9sbGVyIChpZGVudGlmaWVkIGJ5IGNv
bnRyb2xsZXIgbnVtYmVyID0gMCkgaGFzIHRoZSBlc3dpdGNoLiBEZXZsaW5rIGluc3RhbmNlIG9u
IGxvY2FsDQpDb250cm9sbGVyIGhhcyBlc3dpdGNoIGRldmxpbmsgcG9ydHMgcmVwcmVzZW50aW5n
IG5ldHdvcmtpbmcgcG9ydHMgZm9yIGJvdGggdGhlIGNvbnRyb2xsZXJzLg0KDQo+ID4gKw0KPiA+
ICsgICAgICAgICAgICAgICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICsgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ICsgICAgICAg
ICAgICAgICAgIHwgICAgICAgICAgIC0tLS0tLS0tLSAtLS0tLS0tLS0gICAgICAgICAtLS0tLS0t
IC0tLS0tLS0gfA0KPiA+ICsgICAgLS0tLS0tLS0tLS0gIHwgICAgICAgICAgIHwgdmYocykgfCB8
IHNmKHMpIHwgICAgICAgICB8dmYocyl8IHxzZihzKXwgfA0KPiA+ICsgICAgfCBzZXJ2ZXIgIHwg
IHwgLS0tLS0tLSAgIC0tLS0vLS0tLSAtLS0vLS0tLS0gLS0tLS0tLSAtLS0vLS0tIC0tLS8tLS0g
fA0KPiA+ICsgICAgfCBwY2kgcmMgIHw9PT0gfCBwZjAgfF9fX19fXy9fX19fX19fXy8gICAgICAg
fCBwZjEgfF9fXy9fX19fX19fLyAgICAgfA0KPiA+ICsgICAgfCBjb25uZWN0IHwgIHwgLS0tLS0t
LSAgICAgICAgICAgICAgICAgICAgICAgLS0tLS0tLSAgICAgICAgICAgICAgICAgfA0KPiA+ICsg
ICAgLS0tLS0tLS0tLS0gIHwgICAgIHwgY29udHJvbGxlcl9udW09MSAobm8gZXN3aXRjaCkgICAg
ICAgICAgICAgICAgICAgfA0KPiA+ICsgICAgICAgICAgICAgICAgIC0tLS0tLXwtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICsgICAgICAgICAg
ICAgICAgIChpbnRlcm5hbCB3aXJlKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHwNCj4g
PiArICAgICAgICAgICAgICAgICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiArICAgICAgICAgICAgICAgICB8IGRldmxpbmsgZXN3
aXRjaCBwb3J0cyBhbmQgcmVwcyAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4gPiArICAgICAg
ICAgICAgICAgICB8IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tIHwNCj4gPiArICAgICAgICAgICAgICAgICB8IHxjdHJsLTAgfCBjdHJsLTAgfCBj
dHJsLTAgfCBjdHJsLTAgfCBjdHJsLTAgfGN0cmwtMCB8IHwNCj4gPiArICAgICAgICAgICAgICAg
ICB8IHxwZjAgICAgfCBwZjB2Zk4gfCBwZjBzZk4gfCBwZjEgICAgfCBwZjF2Zk4gfHBmMXNmTiB8
IHwNCj4gPiArICAgICAgICAgICAgICAgICB8IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIHwNCj4gPiArICAgICAgICAgICAgICAgICB8IHxjdHJs
LTEgfCBjdHJsLTEgfCBjdHJsLTEgfCBjdHJsLTEgfCBjdHJsLTEgfGN0cmwtMSB8IHwNCj4gPiAr
ICAgICAgICAgICAgICAgICB8IHxwZjAgICAgfCBwZjB2Zk4gfCBwZjBzZk4gfCBwZjEgICAgfCBw
ZjF2Zk4gfHBmMXNmTiB8IHwNCj4gPiArICAgICAgICAgICAgICAgICB8IC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIHwNCj4gPiArICAgICAgICAg
ICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwNCj4gPiArICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4gPiArICAgICAgICAgICAgICAgICB8
ICAgICAgICAgICAtLS0tLS0tLS0gLS0tLS0tLS0tICAgICAgICAgLS0tLS0tLSAtLS0tLS0tIHwN
Cj4gPiArICAgICAgICAgICAgICAgICB8ICAgICAgICAgICB8IHZmKHMpIHwgfCBzZihzKSB8ICAg
ICAgICAgfHZmKHMpfCB8c2Yocyl8IHwNCj4gPiArICAgICAgICAgICAgICAgICB8IC0tLS0tLS0g
ICAtLS0tLy0tLS0gLS0tLy0tLS0tIC0tLS0tLS0gLS0tLy0tLSAtLS0vLS0tIHwNCj4gPiArICAg
ICAgICAgICAgICAgICB8IHwgcGYwIHxfX19fX18vX19fX19fX18vICAgICAgIHwgcGYxIHxfX18v
X19fX19fXy8gICAgIHwNCj4gPiArICAgICAgICAgICAgICAgICB8IC0tLS0tLS0gICAgICAgICAg
ICAgICAgICAgICAgIC0tLS0tLS0gICAgICAgICAgICAgICAgIHwNCj4gPiArICAgICAgICAgICAg
ICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwNCj4gPiArICAgICAgICAgICAgICAgICB8ICBsb2NhbCBjb250cm9sbGVyX251bT0wIChl
c3dpdGNoKSAgICAgICAgICAgICAgICAgICAgIHwNCj4gPiArDQo+ID4gKyAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiArDQo+ID4g
K1BvcnQgZnVuY3Rpb24gY29uZmlndXJhdGlvbg0KPiA+ICs9PT09PT09PT09PT09PT09PT09PT09
PT09PT0NCj4gPiArDQo+ID4gK1doZW4gYSBwb3J0IGZsYXZvciBpcyBgYERFVkxJTktfUE9SVF9G
TEFWT1VSX1BDSV9QRmBgIG9yDQo+ID4gK2BgREVWTElOS19QT1JUX0ZMQVZPVVJfUENJX1ZGYGAs
IGl0IHJlcHJlc2VudHMgdGhlIG5ldHdvcmtpbmcgcG9ydCBvZg0KPiA+ICthIFBDSSBmdW5jdGlv
bi4gQSB1c2VyIGNhbiBjb25maWd1cmUgdGhlIHBvcnQgZnVuY3Rpb24gYXR0cmlidXRlcw0KPiA+
ICtiZWZvcmUgZW51bWVyYXRpbmcgdGhlIGZ1bmN0aW9uLiBGb3IgZXhhbXBsZSB1c2VyIG1heSBz
ZXQgdGhlDQo+ID4gK2hhcmR3YXJlIGFkZHJlc3Mgb2YgdGhlIGZ1bmN0aW9uIHJlcHJlc2VudGVk
IGJ5IHRoZSBkZXZsaW5rIHBvcnQgZnVuY3Rpb24uDQo+IA0KPiB0aGFua3MuDQpUaGFua3MgZm9y
IHRoZSByZXZpZXcgUmFuZHkuDQoNCj4gLS0NCj4gflJhbmR5DQoNCg==
