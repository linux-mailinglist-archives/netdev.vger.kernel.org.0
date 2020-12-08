Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989892D23EB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgLHGwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:52:23 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:7643 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgLHGwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 01:52:23 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fcf227d0000>; Tue, 08 Dec 2020 14:51:41 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Dec
 2020 06:51:40 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 8 Dec 2020 06:51:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ox68MV7t67cCnF62Wrp4EFT/jdWRYjVKN4jHOkOu5Alxm2hVUB8Dmq3h1Bjt5eoBkBDvfVpJVZlSJm75hwykd2CDYD7pvTzcjbL/T9BxTUo6Mi2H7+AZBHYDWs5I3jqaWKPIfwi4LBX4fIZJ9Y6znF/RmVgaZxGPUndFvc+zXHSG9UqLXVyrVd7/48M3MzA2o1a0cZPkiebRvDeXdHpBMlakiP1Y2CkCCTyBsK3AqLUDMwqgwQ+YE/NRtlBzwIg69jqTsrmSbaPXtOvB4Uqmk4YqXxdEyM+zSyIkS+F4Ahyqh9yCME8YPCwA6E0ubobI3loHRN9U1oPMv1g3A2FGCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkSi6iuCZ07p+IudzV27XVdkPE6fCZNEcQz7Ec6npZY=;
 b=gyu6Driz5YPHh79cgZEK3NYKWKSwhMESjnOiKF9XtA0tinsGAZbzVTvSNgOwGvDNdszP8oAMKJuttQ7TteeqMa1Sfcl9ZVldpjAeBiLH2by2imd2s8WfFc8+JvN6Fm2jIXDOcPG6OTTzh2lT0Py+bD7Rnsj9HEKn/xNntWz1bIA/r/8Rbn5I04U5dyC9y0g5qNcwmdFWjZ2LnQ1jiV4Jth1caxz4oqnI76WNwVQYmsPb0zejjPJxHpxjdKKg1V1pXxUDCGHTfI1hozbfsG1eIJ+VBDIOi9PDDgPn/YQLOqAFv1HldiTcJGBCyWL0TrTsGhqx58Kdt4aic2s58ofclQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4036.namprd12.prod.outlook.com (2603:10b6:a03:210::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 06:51:37 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Tue, 8 Dec 2020
 06:51:37 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v5] devlink: Add devlink port documentation
Thread-Topic: [PATCH net-next v5] devlink: Add devlink port documentation
Thread-Index: AQHWzOZVI1p8r74Ujk2uFJRyW2dhJansZUAAgABdyJA=
Date:   Tue, 8 Dec 2020 06:51:37 +0000
Message-ID: <BY5PR12MB432225162ECED10369E209F6DCCD0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164119.571362-1-parav@nvidia.com>
 <20201207221342.553976-1-parav@nvidia.com>
 <02fd2fa9-f93e-a60b-6fc3-f309495ccf99@infradead.org>
In-Reply-To: <02fd2fa9-f93e-a60b-6fc3-f309495ccf99@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 586ae8a6-02f9-477c-24b2-08d89b45b58a
x-ms-traffictypediagnostic: BY5PR12MB4036:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB40360018C83C0CF90D21C938DCCD0@BY5PR12MB4036.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3S0S39lRK5HJw+Yj7uw1VOPV/NHXfPlpArfTZ0Z0zz8dAqY+vw4p/2+8nEu6ZKtSie6sK3YVt4/LpXWrZwU+HHL0p2+6LF5VGfdxhF5xREqTdwp8e58jHpaL3Wt3rfLWWFreSIu51DWS9GCb09JCKiK0jBiP5/d8OvsZx3VXhtet2qy0QRdCCWaCbZ+HwzypZwscJQASE40wNnyin7PsbRGyDR2v6232FDr5KnKouUD3oD7nPB9kPzc2yuaIQMTqpctHEmuuiY9ei7C2YRJqFj1mXXXwRNkabX7u97k6FPwhz+McPSyfFhW/N0lHNP9II3PFtPITAYZRjWU31GaaHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(110136005)(55016002)(66446008)(53546011)(66556008)(86362001)(33656002)(186003)(8936002)(66946007)(76116006)(55236004)(107886003)(66476007)(71200400001)(5660300002)(54906003)(316002)(2906002)(8676002)(6506007)(64756008)(4326008)(26005)(478600001)(7696005)(9686003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?K3RxV0dZYnNGWHNxb25ad2cvZGtGSjdVaWhTalZ3RS9WRm83eGQwWXZDRUtw?=
 =?utf-8?B?ZmhoK0RlT3Z0d0JNaUFQN3dOTjdZSENpdXdzM3B5N3JyQkNLdzJaTEltWEEv?=
 =?utf-8?B?ZFJRR0hBTkJ3eGpqbHlLK2YxQ2NWeFBJRWJ6MlJDWUx3dnVjQzh0anAvc1lE?=
 =?utf-8?B?ck5UM2RLMkI0M05JSFdaV1ZtYXNrRlZYem1iNkM4Q1NGekd3aWZLa01oeU9M?=
 =?utf-8?B?ejFKMjM4SzlDRHdnMk5lL3ErWFVPVTR4TU1kVXR2Y0lXb1FnZllvMXJoUy9L?=
 =?utf-8?B?VzdwZFFBYkNNUWFTaUptQ1dpVjVJWVRvVjM0d3gxSjlPTDluM3NXcnBycEN0?=
 =?utf-8?B?NStjd0U5UVgzeVdDajZSaXJ3dUplaVdrOVVCM05NVVJTU2E4cWl0dkI3Z2hW?=
 =?utf-8?B?SzM5R0lCK3Y0cUFkZG9HK3ZXNmN6TllYN0p4WmZhQVd6dUNhaXowRTBhZG5K?=
 =?utf-8?B?YVppdjdnSWlaUXB5aFZsVjdkeUtTUm5NbHVKMEhxdko0a1JiOGRva2ZXVGR4?=
 =?utf-8?B?WWtodTRoRU8zQkprN0hOam00QzdyMnF0VDhlWE1nbXRXcHJjdGRGZzBYZXUr?=
 =?utf-8?B?YlJFWEY5UXgvc083WHdXd2lqeXdiSmp6VHhlQlhGdWlUajhPSC9YWS9ndDE0?=
 =?utf-8?B?cVZXTmxPMnFKajdkNEdNOE9tQ0RWSFJFREhOUWhTSFJTVUg1Q1dhVnlaRkdm?=
 =?utf-8?B?Sk9jTG5PSTFKTlhXU2FNOVBNeFpCV1N2ZWFkN2REQWl0N3BKU0E0VXVScjQw?=
 =?utf-8?B?QnYyTFVCT1B5V0dmb3dMam1yV1lmZ2dnZlJvTkx6Y21IOVIrUXl1UUVRMG1n?=
 =?utf-8?B?SkhRWHZuOVlEV25XbVVOMm1qYzlYWUpmby8vOEJNRE9lVGQwRjZMSXNWOUJW?=
 =?utf-8?B?RHdSdXc2ZWJwVVRUNGxaRU9JazhwYzBSOXpRREI1VjkyTDFjaTVOWDVJd3Yx?=
 =?utf-8?B?aDF4VG9vUmRlM2lCbXJUd21GYURacVhrV3FDNFY5K0c5RkZXMFJSRk9VWEla?=
 =?utf-8?B?WFl3cnFaRDdFU2tJNVlLWW50TC8wWEZXQTcycGRnYmtZckVvZDBJak9LVWE5?=
 =?utf-8?B?TzlhRWNFY0plUVBBNkN4QW9LYjBSM21idXhyMjhUeGdtVTl3bDVqQWlZOERr?=
 =?utf-8?B?K3JQT3JscFZnOC9MRXZ6MmRtMmVzbk9Jc0puK1A2UXJhSW9udjBtaXdHZlND?=
 =?utf-8?B?NDFzN1Q3MnNNYnBjSzR6dGMxV0UwaGwxRWo0bHM2NldBbUtnaGh1VEluSVVq?=
 =?utf-8?B?SkZEVVZDYy9aWlUwVW51ck1IcEM5Qk5Fd0VjS0h6TmNwK2JPbksvMjV0MUxD?=
 =?utf-8?Q?YlRojXq+3solw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 586ae8a6-02f9-477c-24b2-08d89b45b58a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 06:51:37.2349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QldCMcST+pX4YSqq+EcPnlThTljRdxBWdlC1iyFhJgzzfH9gY+IqUJV5nE/aIeBGjyx1yxNufo2b2lQ5l+Xihw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4036
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607410301; bh=GkSi6iuCZ07p+IudzV27XVdkPE6fCZNEcQz7Ec6npZY=;
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
        b=EwdARl07jmKoM3rT2KIAP/EtMTdDOXaEQGCxRqFuTxV78VhOAhoevc0CbubzZ5y40
         RGLPwFb7tgaBk7Y5ddzHt8VLuuRbW4+osDpmbQrhG5UJwqKfSucoNOlenFpdrDtcow
         PHl8Dz9T124VOpOR24nZhrB0lhDJoCF9ne2io77A/AaE85/ejU42mFA8QMfpRhQy7j
         qX9LZlKehitXhjFvOjdD0QW/bISVYYfxAUpluFHGX3ZnxImGqxMOq3l9+ntH6mHja/
         WbOjnbqWxDOjhQCSRI6rdu9vqE9ql7Rr1EW6jm1jQvzo8MPvCTDkHE7Tt38K3L4nBi
         jWmPpoatnkogA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQo+IFNlbnQ6
IFR1ZXNkYXksIERlY2VtYmVyIDgsIDIwMjAgNjo0NSBBTQ0KPiANCj4gSGktLQ0KPiANCj4gT24g
MTIvNy8yMCAyOjEzIFBNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gQWRkZWQgZG9jdW1lbnRh
dGlvbiBmb3IgZGV2bGluayBwb3J0IGFuZCBwb3J0IGZ1bmN0aW9uIHJlbGF0ZWQNCj4gY29tbWFu
ZHMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5j
b20+DQo+ID4gUmV2aWV3ZWQtYnk6IEppcmkgUGlya28gPGppcmlAbnZpZGlhLmNvbT4NCj4gPiBS
ZXZpZXdlZC1ieTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+ID4g
LS0tDQo+ID4gQ2hhbmdlbG9nOg0KPiA+IHY0LT52NToNCj4gPiAgLSBkZXNjcmliZWQgbG9naWNh
bGx5IGluZ3Jlc3MgYW5kIGVncmVzcyBwb2ludCBvZiBkZXZsaW5rIHBvcnQNCj4gPiAgLSByZW1v
dmVkIG5ldHdvcmtpbmcgZnJvbSBkZXZsaW5rIHBvcnQgZGVzY3JpcHRpb24NCj4gPiAgLSByZXBo
cmFzZWQgcG9ydCB0eXBlIGRlc2NyaXB0aW9uDQo+ID4gIC0gaW50cm9kdWUgUENJIGNvbnRyb2xs
ZXIgc2VjdGlvbiBhbmQgZGVzY3JpcHRpb24NCj4gDQo+ICAgICAgaW50cm9kdWNlDQo+IA0KPiA+
ICAtIHJlcGhyYXNlZCBjb250cm9sbGVyLCBkZXZpY2UsIGZ1bmN0aW9uIGRlc2NyaXB0aW9uDQo+
ID4gIC0gcmVtb3ZlZCBjb25mdXNpbmcgZXN3aXRjaCB0byBzeXN0ZW0gd29yZGluZw0KPiA+ICAt
IHJlcGhyYXNlZCBwb3J0IGZ1bmN0aW9uIGRlc2NyaXB0aW9uDQo+ID4gIC0gYWRkZWQgZXhhbXBs
ZSBvZiBtYWMgYWRkcmVzcyBpbiBwb3J0IGZ1bmN0aW9uIGF0dHJpYnV0ZSBkZXNjcmlwdGlvbg0K
PiANCj4gPiAtLS0NCj4gPiAgLi4uL25ldHdvcmtpbmcvZGV2bGluay9kZXZsaW5rLXBvcnQucnN0
ICAgICAgIHwgMTE2ICsrKysrKysrKysrKysrKysrKw0KPiA+ICBEb2N1bWVudGF0aW9uL25ldHdv
cmtpbmcvZGV2bGluay9pbmRleC5yc3QgICAgfCAgIDEgKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQs
IDExNyBpbnNlcnRpb25zKCspDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9u
L25ldHdvcmtpbmcvZGV2bGluay9kZXZsaW5rLXBvcnQucnN0DQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2RldmxpbmsvZGV2bGluay1wb3J0LnJzdA0KPiA+
IGIvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2RldmxpbmsvZGV2bGluay1wb3J0LnJzdA0KPiA+
IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi5kY2U4N2QyYzA3
YWMNCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5n
L2RldmxpbmsvZGV2bGluay1wb3J0LnJzdA0KPiA+IEBAIC0wLDAgKzEsMTE2IEBADQo+ID4gKy4u
IFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ID4gKw0KPiA+ICs9PT09PT09PT09
PT0NCj4gPiArRGV2bGluayBQb3J0DQo+ID4gKz09PT09PT09PT09PQ0KPiA+ICsNCj4gPiArYGBk
ZXZsaW5rLXBvcnRgYCBpcyBhIHBvcnQgdGhhdCBleGlzdHMgb24gdGhlIGRldmljZS4gSXQgaGFz
IGENCj4gPiArbG9naWNhbGx5IHNlcGFyYXRlIGluZ3Jlc3MvZWdyZXNzIHBvaW50IG9mIHRoZSBk
ZXZpY2UuIEEgZGV2bGluayBwb3J0DQo+ID4gK2NhbiBiZSBvZiBvbmUNCj4gDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwb3J0IGNh
biBiZSBhbnkgb25lDQo+ICAgIG9mIG1hbnkgZmxhdm91cnMuDQo+IA0KPiA+ICthbW9uZyBtYW55
IGZsYXZvdXJzLiBBIGRldmxpbmsgcG9ydCBmbGF2b3VyIGFsb25nIHdpdGggcG9ydA0KPiA+ICth
dHRyaWJ1dGVzIGRlc2NyaWJlIHdoYXQgYSBwb3J0IHJlcHJlc2VudHMuDQo+ID4gKw0KPiA+ICtB
IGRldmljZSBkcml2ZXIgdGhhdCBpbnRlbmRzIHRvIHB1Ymxpc2ggYSBkZXZsaW5rIHBvcnQgc2V0
cyB0aGUNCj4gPiArZGV2bGluayBwb3J0IGF0dHJpYnV0ZXMgYW5kIHJlZ2lzdGVycyB0aGUgZGV2
bGluayBwb3J0Lg0KPiA+ICsNCj4gPiArRGV2bGluayBwb3J0IGZsYXZvdXJzIGFyZSBkZXNjcmli
ZWQgYmVsb3cuDQo+ID4gKw0KPiA+ICsuLiBsaXN0LXRhYmxlOjogTGlzdCBvZiBkZXZsaW5rIHBv
cnQgZmxhdm91cnMNCj4gPiArICAgOndpZHRoczogMzMgOTANCj4gPiArDQo+ID4gKyAgICogLSBG
bGF2b3VyDQo+ID4gKyAgICAgLSBEZXNjcmlwdGlvbg0KPiA+ICsgICAqIC0gYGBERVZMSU5LX1BP
UlRfRkxBVk9VUl9QSFlTSUNBTGBgDQo+ID4gKyAgICAgLSBBbnkga2luZCBvZiBwaHlzaWNhbCBu
ZXR3b3JraW5nIHBvcnQuIFRoaXMgY2FuIGJlIGFuIGVzd2l0Y2ggcGh5c2ljYWwNCj4gPiArICAg
ICAgIHBvcnQgb3IgYW55IG90aGVyIHBoeXNpY2FsIHBvcnQgb24gdGhlIGRldmljZS4NCj4gPiAr
ICAgKiAtIGBgREVWTElOS19QT1JUX0ZMQVZPVVJfRFNBYGANCj4gPiArICAgICAtIFRoaXMgaW5k
aWNhdGVzIGEgRFNBIGludGVyY29ubmVjdCBwb3J0Lg0KPiA+ICsgICAqIC0gYGBERVZMSU5LX1BP
UlRfRkxBVk9VUl9DUFVgYA0KPiA+ICsgICAgIC0gVGhpcyBpbmRpY2F0ZXMgYSBDUFUgcG9ydCBh
cHBsaWNhYmxlIG9ubHkgdG8gRFNBLg0KPiA+ICsgICAqIC0gYGBERVZMSU5LX1BPUlRfRkxBVk9V
Ul9QQ0lfUEZgYA0KPiA+ICsgICAgIC0gVGhpcyBpbmRpY2F0ZXMgYW4gZXN3aXRjaCBwb3J0IHJl
cHJlc2VudGluZyBhIG5ldHdvcmtpbmcgcG9ydCBvZg0KPiA+ICsgICAgICAgUENJIHBoeXNpY2Fs
IGZ1bmN0aW9uIChQRikuDQpJIGZvcmdvdCB0byByZW1vdmUgJ25ldHdvcmtpbmcnIGZyb20gdGhl
IG5ldHdvcmtpbmcgcG9ydCBoZXJlLg0KV2lsbCBpbmNsdWRlIHRoaXMgZml4IHRoaXMgaW4gdjYg
aW4gU2FlZWQncyBzdWJmdW5jdGlvbiBwYXRjaHNldCBhbG9uZyB3aXRoIGFkZHJlc3NpbmcgUmFu
ZHkncyBjb21tZW50cy4NCg==
