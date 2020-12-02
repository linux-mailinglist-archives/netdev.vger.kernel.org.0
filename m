Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B322CB4F6
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 07:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgLBGZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 01:25:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15707 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbgLBGZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 01:25:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc733190000>; Tue, 01 Dec 2020 22:24:25 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Dec
 2020 06:24:24 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 2 Dec 2020 06:24:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WplNwjgjQwPP4UamwcRckzsYgLmMFEJz5/4wjXc/K2P8juAooOQfHPIYDTewWQR0dBIpB+fh3WlhdNvJ3dFnw83jyCsDR6Qm2X1o0oWjfoU9NjB7pLAaT/bYCq0QTw4D8OkkwrD3uwEDcxeEny9RLGUJLxV15imdJ9uuxs2Dr0Z9ETkHFKh9dr6hr84vD0zk8KQCssNVqBglfK+qmPAzEAYL4a4rLtRbvDECpD4sE1nuT2mAqTjrEMo9PC2getg/2nczqLs9SyOqdIlDvlnv8P+FUsvS18F4VVZdt9XQq4i0FEiZmmdBvvV5WMV87Wrn2biWjExy7DkHZRNGMTlc+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuO7ml5P433fjV0tLVWG8vLhOJ0yzRinn2i24OXbCnw=;
 b=NXKlKiSwjRQWt02pJjQHrhmyk2jDlCDkDr/r6AGdgPRc9p3sO1U15fVMF4aTewdKxPKkmzjz9hTZC9lsTIbOG9ENcpXcZg2GM/CufJ52OVOVyLlOKqMHvamwGPRUTozJ2sf8DX1ZQvBSxQzZoI08fMOkYjaWaiqTrlRVlC+E+zk1HGkj2Qqd3UA1xUT0KpN9hAGZnZfycctcJgrUs6pBDhnwz82iZ798W9j+xbuly7rAg7cW+i8anRhZdPUioQsPWdpBO40uFkZOMk56ABGbc1AXCOs1wdckCWhGFuEhRDwddC44RBDGXplgeTNLBjxeKpySqU8WCYNbJjwycerGNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2774.namprd12.prod.outlook.com (2603:10b6:a03:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Wed, 2 Dec
 2020 06:24:22 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 06:24:22 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        Yongji Xie <xieyongji@bytedance.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Topic: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Index: AQHWuL6/zQf/qaV5ZkSpuhr8mZ5CmKnbcCaAgAAhUQCABJD4AIAAOuMAgAGGmoCAADrXgIAAFskggAAyq4CAABrrUIAAwhSAgAARXgCAABZIAIAACAEw
Date:   Wed, 2 Dec 2020 06:24:22 +0000
Message-ID: <BY5PR12MB432217EEF5D58C1757BB620DDCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com>
 <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com>
 <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
 <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
 <CACycT3tTCmEzY37E5196Q2mqME2v+KpAp7Snn8wK4XtRKHEqEw@mail.gmail.com>
 <BY5PR12MB4322C80FB3C76B85A2D095CCDCF40@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CACycT3vNXvNVUP+oqzv-MMgtzneeeZUoMaDVtEws7VizH0V+mA@mail.gmail.com>
 <BY5PR12MB4322446CDB07B3CC5603F7D1DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
 <3d91bf80-1a35-9f79-dbca-596358acc0a7@redhat.com>
In-Reply-To: <3d91bf80-1a35-9f79-dbca-596358acc0a7@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d4189ad-5314-4e58-fef8-08d8968ae884
x-ms-traffictypediagnostic: BYAPR12MB2774:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB27740C4F97E6AA87B151CA19DCF30@BYAPR12MB2774.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AmpXl+rmAlPmSLzfj2DPXsAuVcimJkINPO6wUis8IUZqMCo/qJy+ZRLAkr860gO//T5fp1eb3pLRLoXiaC+HbxAZELSYBO4iExJXya77klXZuZ3oIkfNxv5T/+kT31OYXGpIXUBLGwJz2MnJT+ke+B6iJMmFFt2z42cs9XKhU1Qn1MUVFC5XddyiHRp+tGWDK9NHZhCbvkErkacgJy5zrf4pnKIPl2Epy9S1KCw9rTYKTP0GqkXYBSg0XX39UD0ODiTMDD7mKl0P8OsiHfECwrh3iwuQNBZYw26Aucx/OzVbEC99E9eBlUuSiVSHHZ0tjEwCGl60S/TdFJ5Y7Pyq1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(366004)(33656002)(55016002)(83380400001)(186003)(66946007)(76116006)(5660300002)(64756008)(66556008)(316002)(66476007)(52536014)(110136005)(54906003)(4326008)(2906002)(8936002)(478600001)(7696005)(8676002)(26005)(55236004)(66446008)(71200400001)(9686003)(6506007)(86362001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MkdJRGY2azF1cDBsZ2g5dVE1TWlZNng4TWJaQ21CWjg5UnJYYjNVcUduc0kv?=
 =?utf-8?B?Z0F6L0t2ZFBTd1N5TkxRd3hKQ292WStqN3R0TVNrdjNEY3EzditGUUxocGxm?=
 =?utf-8?B?QUd2Zk9pUy9DOVFYYzBwYW1MV2JrTEhXczJwTHZvY2pwdEM2WW4xakg0Tng2?=
 =?utf-8?B?Ylg0REh5U2ljR1p4WmVjV255N1NaMjRWZHBLL1BBcVVyS0dMcUtDUkJicjZD?=
 =?utf-8?B?Z0NGeHNRSUJ2MzVQS29mNjRHNGZ4TnBnMEtna3JiT2xKS0xNR1hQVEVEaWV4?=
 =?utf-8?B?WWVuemQrcUtzQmY5QWpBYTVzVkxNQmZ1Mi9KNGVWVGdGY3pMd0twYXdDSDh6?=
 =?utf-8?B?OTdnMkJkVHhXNWxEaVRBeUNPN2FMU2NPb0V3a0F4NVU4NUNMMERSZ2NRd0Vj?=
 =?utf-8?B?ZWpIejE4NUJoUEtwY21UVmg0dmtvWmFvTDFXNGMrQzZYdVQwV1J4Q1pmMkZp?=
 =?utf-8?B?K0d0UzFMNkpHQ3QrQklsSUJ0NnNTNHJvU1VvdnVsd1VRUXJyY2RydGRWa0ZC?=
 =?utf-8?B?d3ZYdCsvRENjQ1hXcTZ6bWNKb1NDMG1JRlY2aW1GZzk2ZEtUeUNhZWNwdXE3?=
 =?utf-8?B?TzNUeDZYYWZ6RXdZMysweFhXSWJFY29EMmFsclkyQmZZcW94SVkwZ1FiWldX?=
 =?utf-8?B?cm0xZHhWeWExbGpKb1hxaGs1U0YzUTRoeDNwQWk4Rm1TTzVYUFNFc2F0ckJR?=
 =?utf-8?B?NTFWNDR2dGFJb0R3MFpJQURmb1E2eHIvMGVuMCtqTHpTQ3BqbVpGZmtkUFgv?=
 =?utf-8?B?ZDNjMFpXT2hBSElQbXJPbzBYYTc5aWJhRVdzZ2ViVHNSeEZPbThZZDVPSEpr?=
 =?utf-8?B?WGx3V3o2RzZOZXZtL0wrWE11L2xndXpxWHBlTkp2SnJRMVdpc0NyWW5WVjcz?=
 =?utf-8?B?K1g1WWYvUVc5WXZYbVZwazlOS1ZmRi90Rm41YXc2S3ZuZWo0Kzdkd21MWEdS?=
 =?utf-8?B?QUNya1djNm43bXBMMlJKUTNxVk1zS2VwRStQTFVXVHQ5VlVETmxPbkQ2VUFr?=
 =?utf-8?B?V3BSN2padXRxL3V5NEVjK0pmZU8vajc3a1ZBUVEvQTB5bkt2Q3N6SXRmSVJs?=
 =?utf-8?B?QVFNMllvNzdCWVEzak5qTlo0a28wQW1EZE5JU3R6M09FMEdnbEdONCs5RjJ1?=
 =?utf-8?B?aXVBT3RwN2d0eVJhc0RNUi9yS2hzRlBFdW5lSjVERFduRmlJR0hkOTl5Rjhj?=
 =?utf-8?B?QlIzaHVSajdrZGZJM2ZsUktDd1lTeHYwRGQ5MEZzU21xRHg1cE95Ry9hb3g3?=
 =?utf-8?B?blVqZmtqQ0RHMXArREJzd1g1cXF6czY2eS9KWGtxSHJMd2hsT25hWUdkR3VQ?=
 =?utf-8?Q?j6Eq1We2U5ss4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4189ad-5314-4e58-fef8-08d8968ae884
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 06:24:22.2732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paIMSbdZxWymP4WwF+UD980X9rRsmp6E/7EdNYbbUZsXecuEyInR12G3l8mq41K0dkbBubMx+JrEvaRTY7dAjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2774
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606890265; bh=RuO7ml5P433fjV0tLVWG8vLhOJ0yzRinn2i24OXbCnw=;
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
        b=gnYG/CWVVdzS39azIJ2c54MlbT7L7zSW6i3zOzEog/NyFjx028DKhIeBRY79lrbKz
         GNVLN8TSqBiLZhui5tOjwzzIgkNAIMyqtkX5c6y958gebUiYBjG+ZUPNhAezJAIuvt
         34fcV14/1p/AD0gQ/OP3R0HWPToNO/VQJvu0eaMwqmITV6hnS5QgVB5r38feCpBYJW
         Qd/5NmSbcJ9f9b24EQqZ43RezKOhKNeMzqLWJzg+XMEiKLjMDRCZf8aBDuJSBO2lK7
         gepesCvCFA4GeL6WvAXHW1+bu/Cybi4Echab6+pC3RGfi7KQLlXXMBD46kMv+uqD/X
         r8GnBdSYQvwEw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogV2Vk
bmVzZGF5LCBEZWNlbWJlciAyLCAyMDIwIDExOjIxIEFNDQo+IA0KPiBPbiAyMDIwLzEyLzIg5LiL
5Y2IMTI6NTMsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPg0KPiA+PiBGcm9tOiBZb25namkgWGll
IDx4aWV5b25namlAYnl0ZWRhbmNlLmNvbT4NCj4gPj4gU2VudDogV2VkbmVzZGF5LCBEZWNlbWJl
ciAyLCAyMDIwIDk6MDAgQU0NCj4gPj4NCj4gPj4gT24gVHVlLCBEZWMgMSwgMjAyMCBhdCAxMTo1
OSBQTSBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+Pj4NCj4gPj4+
DQo+ID4+Pj4gRnJvbTogWW9uZ2ppIFhpZSA8eGlleW9uZ2ppQGJ5dGVkYW5jZS5jb20+DQo+ID4+
Pj4gU2VudDogVHVlc2RheSwgRGVjZW1iZXIgMSwgMjAyMCA3OjQ5IFBNDQo+ID4+Pj4NCj4gPj4+
PiBPbiBUdWUsIERlYyAxLCAyMDIwIGF0IDc6MzIgUE0gUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlk
aWEuY29tPg0KPiB3cm90ZToNCj4gPj4+Pj4NCj4gPj4+Pj4NCj4gPj4+Pj4+IEZyb206IFlvbmdq
aSBYaWUgPHhpZXlvbmdqaUBieXRlZGFuY2UuY29tPg0KPiA+Pj4+Pj4gU2VudDogVHVlc2RheSwg
RGVjZW1iZXIgMSwgMjAyMCAzOjI2IFBNDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gT24gVHVlLCBEZWMg
MSwgMjAyMCBhdCAyOjI1IFBNIEphc29uIFdhbmcNCj4gPGphc293YW5nQHJlZGhhdC5jb20+DQo+
ID4+Pj4gd3JvdGU6DQo+ID4+Pj4+Pj4NCj4gPj4+Pj4+PiBPbiAyMDIwLzExLzMwIOS4i+WNiDM6
MDcsIFlvbmdqaSBYaWUgd3JvdGU6DQo+ID4+Pj4+Pj4+Pj4gVGhhbmtzIGZvciBhZGRpbmcgbWUs
IEphc29uIQ0KPiA+Pj4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+Pj4gTm93IEknbSB3b3JraW5nIG9uIGEg
djIgcGF0Y2hzZXQgZm9yIFZEVVNFICh2RFBBIERldmljZSBpbg0KPiA+Pj4+Pj4+Pj4+IFVzZXJz
cGFjZSkgWzFdLiBUaGlzIHRvb2wgaXMgdmVyeSB1c2VmdWwgZm9yIHRoZSB2ZHVzZSBkZXZpY2Uu
DQo+ID4+Pj4+Pj4+Pj4gU28gSSdtIGNvbnNpZGVyaW5nIGludGVncmF0aW5nIHRoaXMgaW50byBt
eSB2MiBwYXRjaHNldC4NCj4gPj4+Pj4+Pj4+PiBCdXQgdGhlcmUgaXMgb25lIHByb2JsZW3vvJoN
Cj4gPj4+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+Pj4+IEluIHRoaXMgdG9vbCwgdmRwYSBkZXZpY2UgY29u
ZmlnIGFjdGlvbiBhbmQgZW5hYmxlIGFjdGlvbiBhcmUNCj4gPj4+Pj4+Pj4+PiBjb21iaW5lZCBp
bnRvIG9uZSBuZXRsaW5rIG1zZzogVkRQQV9DTURfREVWX05FVy4gQnV0IGluDQo+ID4+Pj4gdmR1
c2UNCj4gPj4+Pj4+Pj4+PiBjYXNlLCBpdCBuZWVkcyB0byBiZSBzcGxpdHRlZCBiZWNhdXNlIGEg
Y2hhcmRldiBzaG91bGQgYmUNCj4gPj4+Pj4+Pj4+PiBjcmVhdGVkIGFuZCBvcGVuZWQgYnkgYSB1
c2Vyc3BhY2UgcHJvY2VzcyBiZWZvcmUgd2UgZW5hYmxlDQo+ID4+Pj4+Pj4+Pj4gdGhlIHZkcGEg
ZGV2aWNlIChjYWxsIHZkcGFfcmVnaXN0ZXJfZGV2aWNlKCkpLg0KPiA+Pj4+Pj4+Pj4+DQo+ID4+
Pj4+Pj4+Pj4gU28gSSdkIGxpa2UgdG8ga25vdyB3aGV0aGVyIGl0J3MgcG9zc2libGUgKG9yIGhh
dmUgc29tZQ0KPiA+Pj4+Pj4+Pj4+IHBsYW5zKSB0byBhZGQgdHdvIG5ldyBuZXRsaW5rIG1zZ3Mg
c29tZXRoaW5nIGxpa2U6DQo+ID4+Pj4+Pj4+Pj4gVkRQQV9DTURfREVWX0VOQUJMRQ0KPiA+Pj4+
Pj4gYW5kDQo+ID4+Pj4+Pj4+Pj4gVkRQQV9DTURfREVWX0RJU0FCTEUgdG8gbWFrZSB0aGUgY29u
ZmlnIHBhdGggbW9yZQ0KPiBmbGV4aWJsZS4NCj4gPj4+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+Pj4gQWN0
dWFsbHksIHdlJ3ZlIGRpc2N1c3NlZCBzdWNoIGludGVybWVkaWF0ZSBzdGVwIGluIHNvbWUgZWFy
bHkNCj4gPj4+Pj4+Pj4+IGRpc2N1c3Npb24uIEl0IGxvb2tzIHRvIG1lIFZEVVNFIGNvdWxkIGJl
IG9uZSBvZiB0aGUgdXNlcnMgb2YNCj4gPj4gdGhpcy4NCj4gPj4+Pj4+Pj4+IE9yIEkgd29uZGVy
IHdoZXRoZXIgd2UgY2FuIHN3aXRjaCB0byB1c2UgYW5vbnltb3VzDQo+ID4+Pj4+Pj4+PiBpbm9k
ZShmZCkgZm9yIFZEVVNFIHRoZW4gZmV0Y2hpbmcgaXQgdmlhIGFuDQo+ID4+Pj4+Pj4+PiBWRFVT
RV9HRVRfREVWSUNFX0ZEDQo+ID4+IGlvY3RsPw0KPiA+Pj4+Pj4+PiBZZXMsIHdlIGNhbi4gQWN0
dWFsbHkgdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24gaW4gVkRVU0UgaXMNCj4gPj4+Pj4+Pj4g
bGlrZSB0aGlzLiAgQnV0IHNlZW1zIGxpa2UgdGhpcyBpcyBzdGlsbCBhIGludGVybWVkaWF0ZSBz
dGVwLg0KPiA+Pj4+Pj4+PiBUaGUgZmQgc2hvdWxkIGJlIGJpbmRlZCB0byBhIG5hbWUgb3Igc29t
ZXRoaW5nIGVsc2Ugd2hpY2ggbmVlZA0KPiA+Pj4+Pj4+PiB0byBiZSBjb25maWd1cmVkIGJlZm9y
ZS4NCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IFRoZSBuYW1lIGNvdWxkIGJlIHNwZWNpZmllZCB2aWEg
dGhlIG5ldGxpbmsuIEl0IGxvb2tzIHRvIG1lIHRoZQ0KPiA+Pj4+Pj4+IHJlYWwgaXNzdWUgaXMg
dGhhdCB1bnRpbCB0aGUgZGV2aWNlIGlzIGNvbm5lY3RlZCB3aXRoIGENCj4gPj4+Pj4+PiB1c2Vy
c3BhY2UsIGl0IGNhbid0IGJlIHVzZWQuIFNvIHdlIGFsc28gbmVlZCB0byBmYWlsIHRoZQ0KPiA+
Pj4+Pj4+IGVuYWJsaW5nIGlmIGl0IGRvZXNuJ3QNCj4gPj4+PiBvcGVuZWQuDQo+ID4+Pj4+PiBZ
ZXMsIHRoYXQncyB0cnVlLiBTbyB5b3UgbWVhbiB3ZSBjYW4gZmlyc3RseSB0cnkgdG8gZmV0Y2gg
dGhlIGZkDQo+ID4+Pj4+PiBiaW5kZWQgdG8gYSBuYW1lL3ZkdXNlX2lkIHZpYSBhbiBWRFVTRV9H
RVRfREVWSUNFX0ZELCB0aGVuDQo+IHVzZQ0KPiA+Pj4+Pj4gdGhlIG5hbWUvdmR1c2VfaWQgYXMg
YSBhdHRyaWJ1dGUgdG8gY3JlYXRlIHZkcGEgZGV2aWNlPyBJdCBsb29rcw0KPiA+Pj4+Pj4gZmlu
ZSB0bw0KPiA+PiBtZS4NCj4gPj4+Pj4gSSBwcm9iYWJseSBkbyBub3Qgd2VsbCB1bmRlcnN0YW5k
LiBJIHRyaWVkIHJlYWRpbmcgcGF0Y2ggWzFdIGFuZA0KPiA+Pj4+PiBmZXcgdGhpbmdzDQo+ID4+
Pj4gZG8gbm90IGxvb2sgY29ycmVjdCBhcyBiZWxvdy4NCj4gPj4+Pj4gQ3JlYXRpbmcgdGhlIHZk
cGEgZGV2aWNlIG9uIHRoZSBidXMgZGV2aWNlIGFuZCBkZXN0cm95aW5nIHRoZQ0KPiA+Pj4+PiBk
ZXZpY2UgZnJvbQ0KPiA+Pj4+IHRoZSB3b3JrcXVldWUgc2VlbXMgdW5uZWNlc3NhcnkgYW5kIHJh
Y3kuDQo+ID4+Pj4+IEl0IHNlZW1zIHZkdXNlIGRyaXZlciBuZWVkcw0KPiA+Pj4+PiBUaGlzIGlz
IHNvbWV0aGluZyBzaG91bGQgYmUgZG9uZSBhcyBwYXJ0IG9mIHRoZSB2ZHBhIGRldiBhZGQNCj4g
Pj4+Pj4gY29tbWFuZCwNCj4gPj4+PiBpbnN0ZWFkIG9mIGNvbm5lY3RpbmcgdHdvIHNpZGVzIHNl
cGFyYXRlbHkgYW5kIGVuc3VyaW5nIHJhY2UgZnJlZQ0KPiA+Pj4+IGFjY2VzcyB0byBpdC4NCj4g
Pj4+Pj4gU28gVkRVU0VfREVWX1NUQVJUIGFuZCBWRFVTRV9ERVZfU1RPUCBzaG91bGQgcG9zc2li
bHkgYmUNCj4gYXZvaWRlZC4NCj4gPj4+Pj4NCj4gPj4+PiBZZXMsIHdlIGNhbiBhdm9pZCB0aGVz
ZSB0d28gaW9jdGxzIHdpdGggdGhlIGhlbHAgb2YgdGhlIG1hbmFnZW1lbnQNCj4gdG9vbC4NCj4g
Pj4+Pg0KPiA+Pj4+PiAkIHZkcGEgZGV2IGFkZCBwYXJlbnRkZXYgdmR1c2VfbWdtdGRldiB0eXBl
IG5ldCBuYW1lIGZvbzINCj4gPj4+Pj4NCj4gPj4+Pj4gV2hlbiBhYm92ZSBjb21tYW5kIGlzIGV4
ZWN1dGVkIGl0IGNyZWF0ZXMgbmVjZXNzYXJ5IHZkcGEgZGV2aWNlDQo+ID4+Pj4+IGZvbzINCj4g
Pj4+PiBvbiB0aGUgYnVzLg0KPiA+Pj4+PiBXaGVuIHVzZXIgYmluZHMgZm9vMiBkZXZpY2Ugd2l0
aCB0aGUgdmR1c2UgZHJpdmVyLCBpbiB0aGUgcHJvYmUoKSwNCj4gPj4+Pj4gaXQNCj4gPj4+PiBj
cmVhdGVzIHJlc3BlY3RpdmUgY2hhciBkZXZpY2UgdG8gYWNjZXNzIGl0IGZyb20gdXNlciBzcGFj
ZS4NCj4gPj4+Pg0KPiA+Pj4gSSBzZWUuIFNvIHZkdXNlIGNhbm5vdCB3b3JrIHdpdGggYW55IGV4
aXN0aW5nIHZkcGEgZGV2aWNlcyBsaWtlIGlmYywNCj4gPj4+IG1seDUgb3INCj4gPj4gbmV0ZGV2
c2ltLg0KPiA+Pj4gSXQgaGFzIGl0cyBvd24gaW1wbGVtZW50YXRpb24gc2ltaWxhciB0byBmdXNl
IHdpdGggaXRzIG93biBiYWNrZW5kIG9mDQo+IGNob2ljZS4NCj4gPj4+IE1vcmUgYmVsb3cuDQo+
ID4+Pg0KPiA+Pj4+IEJ1dCB2ZHVzZSBkcml2ZXIgaXMgbm90IGEgdmRwYSBidXMgZHJpdmVyLiBJ
dCB3b3JrcyBsaWtlIHZkcGFzaW0NCj4gPj4+PiBkcml2ZXIsIGJ1dCBvZmZsb2FkcyB0aGUgZGF0
YSBwbGFuZSBhbmQgY29udHJvbCBwbGFuZSB0byBhIHVzZXIgc3BhY2UNCj4gcHJvY2Vzcy4NCj4g
Pj4+IEluIHRoYXQgY2FzZSB0byBkcmF3IHBhcmFsbGVsIGxpbmVzLA0KPiA+Pj4NCj4gPj4+IDEu
IG5ldGRldnNpbToNCj4gPj4+IChhKSBjcmVhdGUgcmVzb3VyY2VzIGluIGtlcm5lbCBzdw0KPiA+
Pj4gKGIpIGRhdGFwYXRoIHNpbXVsYXRlcyBpbiBrZXJuZWwNCj4gPj4+DQo+ID4+PiAyLiBpZmMg
KyBtbHg1IHZkcGEgZGV2Og0KPiA+Pj4gKGEpIGNyZWF0ZXMgcmVzb3VyY2UgaW4gaHcNCj4gPj4+
IChiKSBkYXRhIHBhdGggaXMgaW4gaHcNCj4gPj4+DQo+ID4+PiAzLiB2ZHVzZToNCj4gPj4+IChh
KSBjcmVhdGVzIHJlc291cmNlcyBpbiB1c2Vyc3BhY2Ugc3cNCj4gPj4+IChiKSBkYXRhIHBhdGgg
aXMgaW4gdXNlciBzcGFjZS4NCj4gPj4+IGhlbmNlIGNyZWF0ZXMgZGF0YSBwYXRoIHJlc291cmNl
cyBmb3IgdXNlciBzcGFjZS4NCj4gPj4+IFNvIGNoYXIgZGV2aWNlIGlzIGNyZWF0ZWQsIHJlbW92
ZWQgYXMgcmVzdWx0IG9mIHZkcGEgZGV2aWNlIGNyZWF0aW9uLg0KPiA+Pj4NCj4gPj4+IEZvciBl
eGFtcGxlLA0KPiA+Pj4gJCB2ZHBhIGRldiBhZGQgcGFyZW50ZGV2IHZkdXNlX21nbXRkZXYgdHlw
ZSBuZXQgbmFtZSBmb28yDQo+ID4+Pg0KPiA+Pj4gQWJvdmUgY29tbWFuZCB3aWxsIGNyZWF0ZSBj
aGFyIGRldmljZSBmb3IgdXNlciBzcGFjZS4NCj4gPj4+DQo+ID4+PiBTaW1pbGFyIGNvbW1hbmQg
Zm9yIGlmYy9tbHg1IHdvdWxkIGhhdmUgY3JlYXRlZCBzaW1pbGFyIGNoYW5uZWwgZm9yDQo+ID4+
PiByZXN0IG9mDQo+ID4+IHRoZSBjb25maWcgY29tbWFuZHMgaW4gaHcuDQo+ID4+PiB2ZHVzZSBj
aGFubmVsID0gY2hhciBkZXZpY2UsIGV2ZW50ZmQgZXRjLg0KPiA+Pj4gaWZjL21seDUgaHcgY2hh
bm5lbCA9IGJhciwgaXJxLCBjb21tYW5kIGludGVyZmFjZSBldGMgTmV0ZGV2IHNpbQ0KPiA+Pj4g
Y2hhbm5lbCA9IHN3IGRpcmVjdCBjYWxscw0KPiA+Pj4NCj4gPj4+IERvZXMgaXQgbWFrZSBzZW5z
ZT8NCj4gPj4gSW4gbXkgdW5kZXJzdGFuZGluZywgdG8gbWFrZSB2ZHBhIHdvcmssIHdlIG5lZWQg
YSBiYWNrZW5kIChkYXRhcGF0aA0KPiA+PiByZXNvdXJjZXMpIGFuZCBhIGZyb250ZW5kIChhIHZk
cGEgZGV2aWNlIGF0dGFjaGVkIHRvIGEgdmRwYSBidXMpLiBJbg0KPiA+PiB0aGUgYWJvdmUgZXhh
bXBsZSwgaXQgbG9va3MgbGlrZSB3ZSB1c2UgdGhlIGNvbW1hbmQgInZkcGEgZGV2IGFkZCAuLi4i
DQo+ID4+ICAgdG8gY3JlYXRlIGEgYmFja2VuZCwgc28gZG8gd2UgbmVlZCBhbm90aGVyIGNvbW1h
bmQgdG8gY3JlYXRlIGENCj4gZnJvbnRlbmQ/DQo+ID4+DQo+ID4gRm9yIGJsb2NrIGRldmljZSB0
aGVyZSBpcyBjZXJ0YWlubHkgc29tZSBiYWNrZW5kIHRvIHByb2Nlc3MgdGhlIElPcy4NCj4gPiBT
b21ldGltZXMgYmFja2VuZCB0byBiZSBzZXR1cCBmaXJzdCwgYmVmb3JlIGl0cyBmcm9udCBlbmQg
aXMgZXhwb3NlZC4NCj4gPiAidmRwYSBkZXYgYWRkIiBpcyB0aGUgZnJvbnQgZW5kIGNvbW1hbmQg
d2hvIGNvbm5lY3RzIHRvIHRoZSBiYWNrZW5kDQo+IChpbXBsaWNpdGx5KSBmb3IgbmV0d29yayBk
ZXZpY2UuDQo+ID4NCj4gPiB2aG9zdC0+dmRwYV9ibG9ja19kZXZpY2UtPmJhY2tlbmRfaW9fcHJv
Y2Vzc29yICh1c3IsaHcsa2VybmVsKS4NCj4gPg0KPiA+IEFuZCBpdCBuZWVkcyBhIHdheSB0byBj
b25uZWN0IHRvIGJhY2tlbmQgd2hlbiBleHBsaWNpdGx5IHNwZWNpZmllZCBkdXJpbmcNCj4gY3Jl
YXRpb24gdGltZS4NCj4gPiBTb21ldGhpbmcgbGlrZSwNCj4gPiAkIHZkcGEgZGV2IGFkZCBwYXJl
bnRkZXYgdmRwYV92ZHVzZSB0eXBlIGJsb2NrIG5hbWUgZm9vMyBoYW5kbGUNCj4gPHV1aWQ+DQo+
ID4gSW4gYWJvdmUgZXhhbXBsZSBzb21lIHZlbmRvciBkZXZpY2Ugc3BlY2lmaWMgdW5pcXVlIGhh
bmRsZSBpcyBwYXNzZWQNCj4gYmFzZWQgb24gYmFja2VuZCBzZXR1cCBpbiBoYXJkd2FyZS91c2Vy
IHNwYWNlLg0KPiA+DQo+ID4gSW4gYmVsb3cgMyBleGFtcGxlcywgdmRwYSBibG9jayBzaW11bGF0
b3IgaXMgY29ubmVjdGluZyB0byBiYWNrZW5kIGJsb2NrDQo+IG9yIGZpbGUuDQo+ID4NCj4gPiAk
IHZkcGEgZGV2IGFkZCBwYXJlbnRkZXYgdmRwYV9ibG9ja3NpbSB0eXBlIGJsb2NrIG5hbWUgZm9v
NCBibG9ja2Rldg0KPiA+IC9kZXYvemVybw0KPiA+DQo+ID4gJCB2ZHBhIGRldiBhZGQgcGFyZW50
ZGV2IHZkcGFfYmxvY2tzaW0gdHlwZSBibG9jayBuYW1lIGZvbzUgYmxvY2tkZXYNCj4gPiAvZGV2
L3NkYTIgc2l6ZT0xMDBNIG9mZnNldD0xME0NCj4gPg0KPiA+ICQgdmRwYSBkZXYgYWRkIHBhcmVu
dGRldiB2ZHBhX2Jsb2NrIGZpbGViYWNrZW5kX3NpbSB0eXBlIGJsb2NrIG5hbWUNCj4gPiBmb282
IGZpbGUgL3Jvb3QvZmlsZV9iYWNrZW5kLnR4dA0KPiA+DQo+ID4gT3IgbWF5IGJlIGJhY2tlbmQg
Y29ubmVjdHMgdG8gdGhlIGNyZWF0ZWQgdmRwYSBkZXZpY2UgaXMgYm91bmQgdG8gdGhlDQo+IGRy
aXZlci4NCj4gPiBDYW4gdmR1c2UgYXR0YWNoIHRvIHRoZSBjcmVhdGVkIHZkcGEgYmxvY2sgZGV2
aWNlIHRocm91Z2ggdGhlIGNoYXIgZGV2aWNlDQo+IGFuZCBlc3RhYmxpc2ggdGhlIGNoYW5uZWwg
dG8gcmVjZWl2ZSBJT3MsIGFuZCB0byBzZXR1cCB0aGUgYmxvY2sgY29uZmlnIHNwYWNlPw0KPiAN
Cj4gDQo+IEkgdGhpbmsgaXQgY2FuIHdvcmsuDQo+IA0KPiBBbm90aGVyIHRoaW5nIEkgd29uZGVy
IGl0IHRoYXQsIGRvIHdlIGNvbnNpZGVyIG1vcmUgdGhhbiBvbmUgVkRVU0UNCj4gcGFyZW50ZGV2
KG9yIG1hbmFnZW1lbnQgZGV2KT8gVGhpcyBhbGxvd3MgdXMgdG8gaGF2ZSBzZXBhcmF0ZWQgZGV2
aWNlcw0KPiBpbXBsZW1lbnRlZCB2aWEgZGlmZmVyZW50IHByb2Nlc3Nlcy4NCk11bHRpcGxlIHBh
cmVudGRldiBzaG91bGQgYmUgcG9zc2libGUgcGVyIG9uZSBkcml2ZXIuIGZvciBleGFtcGxlIG1s
eDVfdmRwYS5rbyB3aWxsIGNyZWF0ZSBtdWx0aXBsZSBwYXJlbnQgZGV2LCBvbmUgZm9yIGVhY2gg
UENJIFZGcywgU0ZzLg0KdmRwYSBkZXYgYWRkIGNhbiBjZXJ0YWlubHkgdXNlIG9uZSBwYXJlbnQv
bWdtdCBkZXYgdG8gY3JlYXRlIG11bHRpcGxlIHZkcGEgZGV2aWNlcy4NCk5vdCBzdXJlIHdoeSBk
byB3ZSBuZWVkIHRvIGNyZWF0ZSBtdWx0aXBsZSBwYXJlbnQgZGV2IGZvciB0aGF0Lg0KSSBndWVz
cyB0aGVyZSBpcyBqdXN0IG9uZSBwYXJlbnQvbWdtdC4gZGV2IGZvciBWRFVTRS4gV2hhdCB3aWxs
IGVhY2ggbWdtdGRldiBkbyBkaWZmZXJlbnRseT8NCkRlbXV4IG9mIElPcywgZXZlbnRzIHdpbGwg
YmUgcGVyIGluZGl2aWR1YWwgY2hhciBkZXYgbGV2ZWw/DQoNCj4gDQo+IElmIHllcywgVkRVU0Ug
aW9jdGwgbmVlZHMgdG8gYmUgZXh0ZW5kZWQgdG8gcmVnaXN0ZXIvdW5yZWdpc3RlciBwYXJlbnRk
ZXYuDQo+IA0KPiBUaGFua3MNCj4gDQo+IA0KPiA+DQo+ID4+IFRoYW5rcywNCj4gPj4gWW9uZ2pp
DQoNCg==
