Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241F72D2369
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgLHF7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 00:59:55 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19968 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgLHF7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 00:59:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fcf16320000>; Mon, 07 Dec 2020 21:59:14 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Dec
 2020 05:59:13 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 8 Dec 2020 05:59:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJp2Dv/RVyrpn/Wii06eVoZXDx3nVkT95mfoPoHOnzd4l9q5331+KTKHfvo14ZsXidmMeudlpVcwK8XTX5JZUhe8jL3llEI07gVYuxqlfCUme0YA2SxcvKirkWR4mhsyNeINUXgQqReXmg4euY4eztRBGl9rUZOzo7m7kBpCZaV3xpShoDzYuTEjTf3xuugOZJNiVfBRIYGv5RKqyEyoZfSvTebUp6LU/LLsdxRV25u04Kla8OaykdXZ6Gr7sir4SNnCcZqMgMM5SkJsEsHcHbnyg37KKDMOATIr0qPW27Q/BfTNx0LpDP4+lUQtxfCKvvabOoI6Iy7Vp727hBpbyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLlnVN+N6Pf5FLq3QWGp/x6UjyTy+m3KUz+6/sYyj/4=;
 b=Cs3LsUm3y8+NI6nPnb8aK37Pv5cU/2DIBEGMYmLbtb9X8Yi6fwQ+I84Jw+QxpVxFd3uzMIKO0w3TLF5j5MwM4KcKXn3edhsPH7Fvdsi8PstXfc1uOLNxYxSiSf+3VtoTtLEJ1acB/2qbnhVFd/DLW3n0Ad6yRs0/D6FKNW+qvM9KW3xpWsZIvNmur9CaoZY58m6IR9H6z+Pbzfievuzhxw9Kpx4w5DAqV68g5Oz9T24LXFxEtZAglhRS7te2PpPUhHbo16xdfwS3mGZzgz5jQf5LmYaiwsAgL53+bjn9pSxW6PY2RgpOBmU/ZwiuBFYUMWK079tsYLLQrnNtAuLIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3368.namprd12.prod.outlook.com (2603:10b6:a03:dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 8 Dec
 2020 05:59:12 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Tue, 8 Dec 2020
 05:59:12 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v5] devlink: Add devlink port documentation
Thread-Topic: [PATCH net-next v5] devlink: Add devlink port documentation
Thread-Index: AQHWzOZVI1p8r74Ujk2uFJRyW2dhJansZUAAgABOzPA=
Date:   Tue, 8 Dec 2020 05:59:11 +0000
Message-ID: <BY5PR12MB4322CDFCECDCEC9184A36499DCCD0@BY5PR12MB4322.namprd12.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 8b4fa492-3ac2-471b-6786-08d89b3e62ce
x-ms-traffictypediagnostic: BYAPR12MB3368:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3368B371C8C771EAC1A8E5B0DCCD0@BYAPR12MB3368.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WbHIUo638mUGdxUUYMyM52eREMUI8aNUjLgYa3+NPUe5+9Dg6tU2Cts3sPKfMKzeAG/pIYB8lHQOKP161at/oFM1cRe8e5JPsA7xSh/zZ5rECVJcHLI4QuacFniafG4tCNudE0aIq/BmDVlzHpgjB226o8CiCgCa2wZ7mWpO2LCxpWlqoiR9Q7faj1nKJA0dBbPnKuCy1CeJIJG3q9IljbaWwhvO3saR4IrDnI4c8mPCIxHPhK9MLqiHMl1cMsITs/rHyAJz/zwmenZl7dBbqTgStaD+8xzMl4D8M0k3yLjhKJ2vcrpA6CUcgV69zFHh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(52536014)(7696005)(66946007)(66476007)(66556008)(64756008)(66446008)(6506007)(76116006)(55236004)(186003)(26005)(8936002)(316002)(478600001)(8676002)(54906003)(110136005)(83380400001)(4744005)(5660300002)(107886003)(86362001)(4326008)(71200400001)(2906002)(33656002)(9686003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UWFCd3JnekJBalJOanRZWU01T25YYUNBd2Z3NVBLRkp6aFN5QWM5d3BxTEpn?=
 =?utf-8?B?OHNNU3lLcXl3VVY0dUVhSjl0b3d3M3VaRm1idHcrNGlCTlBxZDhVL25aLzB4?=
 =?utf-8?B?Z0FGVll3aTRRNmdoN1phT2xZQjgrQ2ZIS2ZaeS9KbUV0S2JOSzdQZzZ5emt4?=
 =?utf-8?B?ck4vRkFNc0ZndlVQcGRoQUl4Sm1oc1hQVEgweEUrZy9seC90Q2F5NUdwS2pT?=
 =?utf-8?B?YndjZVBMbkRBdC9RMHRKVlZvRC9JZHFJcmpGWFZWTFdEUmFEdHhjSm91N3hB?=
 =?utf-8?B?M3lnRnN6Q1BPWkxCUGlENUVQQXZrOVBSMTBJMVBrbnU0V1ZWb05IaTVueHl0?=
 =?utf-8?B?bXMwYStiRkhzUWhwanNTRXNDUHpRbWo1aldadUlzcU9xam80OWdGaWc2WlNa?=
 =?utf-8?B?RHY5UWtHNWVYNi9kVVpiUGtJMU5qYWpkc1M1anpjWk1JZmJ4ZnhHYnIxL3VN?=
 =?utf-8?B?dFBlZUM1TEdhd0c5YnBDbWd0MHZmRExFSjhrT0lqTW50YXNPeC9hY0llTFhG?=
 =?utf-8?B?VFJ1cDN0L2xyVldZbmFsZmdnR1Y4YTlDRW1zYXBoRVAyY0JFcXRndm1aQkE3?=
 =?utf-8?B?Z2NhVEtVWEJ5ZjUyK1pQMkVFWXVkVmFQT1pOUEUxMXdQRmRkRWZQNmhhT2cw?=
 =?utf-8?B?Qi9oSWZ6NTA2QjhSZzJWRk01ck5NK3RnZHlHZkxENWRRd3hSTHpQR1hjeGd5?=
 =?utf-8?B?ZGhWZjZGOUhOcVVnOFFKL0ZNVG02R1NXa3kvZHpHVm9KT0hMOE83WlVCaGdE?=
 =?utf-8?B?c3pob3lIRXVON3p6VWNXQTBqdTZSd1Q2M0R2bTRMSXdtT3d5azRNdVl0MXB5?=
 =?utf-8?B?b1BYV09MRnJuMHgyRDFHaS9YZ2JESXo1cTlDUVora2NTeXR6K1k5MHNQdjNl?=
 =?utf-8?B?UWNSMjVFZ2NralBDVHZhNkZHYXJ5TGpQZlhEdEZ3ODJGd3FWZkMzd0RWemNi?=
 =?utf-8?B?YUwwSGp0M3RkbXpZK0ZUdG90dFROcjVTUjhwZHc2bkFpYk5SdGJ0Z0FaSnd4?=
 =?utf-8?B?djlVQWRVMHR3eGQrRVpSM3hpSVdVeVppNGVlaUdRem12d2lMeG4rdHJaOGFl?=
 =?utf-8?B?NmpFSSs4SmVCT3o4VjU3dFpJTzRjY3IvM3loTnIra0I3bmNuV1pkSFV2L1Bi?=
 =?utf-8?B?Snc2ZWJ4U1VPUFdOUFdRWTRRZUlubW5kWEpnazlmK0wyYU1Vdm1iMzdvNElD?=
 =?utf-8?B?eWpsZFRaTXlvK2pyWlo4N1ErLzJnK2NjNHhXeHdmRENDUlNvM2lGZ1Y4bjBr?=
 =?utf-8?B?TENIMklUQWlVR2dPSGN2Mlp5QjI0cTZoYzJPTkJzU05RRmw1YTFXTGVOa0dN?=
 =?utf-8?Q?7SgyglzSg5QAI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b4fa492-3ac2-471b-6786-08d89b3e62ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 05:59:11.9841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6nKFTblqtBj3Gdzi/USjOmgkgS/J2fLXmetyOkQAQFUJrrGDmu4kprZ+NONaIYwnLyqeVR93flnxfMeiqbBEpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3368
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607407154; bh=PLlnVN+N6Pf5FLq3QWGp/x6UjyTy+m3KUz+6/sYyj/4=;
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
        b=WsaANM33fGNLIEksnSi9ahndEFWbD/BuctOUacykxD1/S2+U+7FtPX6ui/Gn6Opxh
         bBIL5XLmw1vZ4vn4PEsoZJZ2c9qRdXHlkOxuygcvbsZGtxezfnDqNb/boscquN91Ii
         C/juy8S7jfhjcxS8XvUXSUjMF4JmXw3+/TlVRiLbt3UnBpoQsoDMErkMQWSYUyih8t
         d9z2PwBQ2bjdqw9qeeg7lXGtGXIu9TqbZb0Whl+smTyA7O7DVlm0qVxDohULc6+ug8
         AY+9C2o+05AnoLCUxRt+poe0hfTD171HoKnzCV4n7BTtg/ENS/7iaOFfSET0JqSE0S
         yF0338nerFyPQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmFuZHksDQoNCj4gRnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+
DQo+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDgsIDIwMjAgNjo0NSBBTQ0KPiANCj4gPiArQW4g
ZXN3aXRjaCBvbiB0aGUgUENJIGRldmljZSBtYXkgc3VwcHBvcnQgcG9ydHMgb2YgbXVsdGlwbGUg
Y29udHJvbGxlcnMuDQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBz
dXBwb3J0DQo+IA0KPiA+ICsNCj4gPiArQW4gZXhhbXBsZSB2aWV3IG9mIHR3byBjb250cm9sbGVy
IHN5c3RlbXM6Og0KPiANCj4gSSB0aGluayB0aGF0IHRoaXMgaXMNCj4gDQo+ICAgQW4gZXhhbXBs
ZSB2aWV3IG9mIGEgdHdvLWNvbnRyb2xsZXIgc3lzdGVtOjoNCj4gDQo+IGluc3RlYWQgb2YgMiBj
b250cm9sbGVyIHN5c3RlbXMuICA/DQoNClJlcGhyYXNpbmcgaXQgYXMgIkFuIGV4YW1wbGUgdmll
dyBvZiBhIHN5c3RlbSB3aXRoIHR3byBjb250cm9sbGVycyIgYWxvbmcgd2l0aCBvdGhlciBjb21t
ZW50cy4NClNpbmNlIFNhZWVkIGlzIHNlbmRpbmcgdGhlIHNmIHBhdGNoc2V0IHdoaWNoIGFsc28g
bmVlZHMgcG9ydCBkb2N1bWVudGF0aW9uLCBJIGFtIHNlbmRpbmcgdjYgb2YgdGhpcyBwYXRjaCBh
bG9uZyB3aXRoIHRoZSBjaGFuZ2UgbG9nIGluIHRoZSBzdWJmdW5jdGlvbiBwYXRjaHNldC4NCg==
