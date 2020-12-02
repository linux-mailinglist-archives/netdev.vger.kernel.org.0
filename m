Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7768D2CBB54
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 12:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgLBLNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 06:13:52 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19149 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgLBLNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 06:13:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc776c70000>; Wed, 02 Dec 2020 03:13:11 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Dec
 2020 11:13:11 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 2 Dec 2020 11:13:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odxP3DHMbaG+TPvBRJWiXhcu09elSPKwAqCB56j0z7Tapkd+0JiSdvD0ceViTR9feMBPMtnVyq+YBMVnODLHhotyk0foCzJYUS4VeHyDHapX+J7nX28G5wFmPnLtjdwOQsNUkREFaNHPNqUzoHjdHYPvHxAl4wkXfT9KWd10lqCpQ63ixVLcwsc4rawW0gDqR8bcmD4PArq88oqBa6Jrd6am3o8VniISLlD6FRymN03FxDeZsKSOuJVfLIOKnpiBLpCmaWYnYzdaXOoJG45OHzHMKc5UUwJQzDXi+C7JHY6Q2rwjXIIcSNoji7pT6X+gWdREh39MOmaYxDGYgAzWdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Td48a6kSnFawjmApwKTSwU9aBWvRzoIB2dbBsbT4lvc=;
 b=eaf9G7ZZ5ESBpMrQ6GD5M5T/eoy9KVq2r6H1dLXNMuoVYMnN6mckJghH2T5s5OyrFfzDUJY8tjfUreeVcBq/IC0OF5BVJJPNwl5Jk7P/fSeXlZAoJndJiyl28oeBbcVdsHbtksP9Ltugy4zundtXRi2YJY0CxvjXQZnK8L9+R+vofRX3wXjIogazSmvLsN4C+mviuhvRwwCc34mThPmQP0cxbL6ZiHaDiDZ2yw6wmUPyqfWhyc+eLK76rDzcRba6nmtuJH2+2GoFJsYq8Ri4lzewmAZpUA6YYM2k5NP31ipmuwbuuijGK8r1qj9ljjfO1hFiqC+fY32PTg0WT2WaSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3730.namprd12.prod.outlook.com (2603:10b6:a03:1ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Wed, 2 Dec
 2020 11:13:09 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 11:13:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yongji Xie <xieyongji@bytedance.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Topic: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Index: AQHWuL6/zQf/qaV5ZkSpuhr8mZ5CmKnbcCaAgAAhUQCABJD4AIAAOuMAgAGGmoCAADrXgIAAFskggAAyq4CAABrrUIAAwhSAgAARXgCAAFEUAIAAHYCw
Date:   Wed, 2 Dec 2020 11:13:09 +0000
Message-ID: <BY5PR12MB43226BFFC334789D799F66D5DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
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
 <CACycT3uV8e61kVF6Q8zE5VVK_Okp03e=WNRcUffdkFeeFpfKDQ@mail.gmail.com>
In-Reply-To: <CACycT3uV8e61kVF6Q8zE5VVK_Okp03e=WNRcUffdkFeeFpfKDQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30f5f5d1-7fb8-4a08-924a-08d896b34044
x-ms-traffictypediagnostic: BY5PR12MB3730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3730A7F96CA8B32DCD4454CDDCF30@BY5PR12MB3730.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VDXvtTDJ/uwrBskNgPkeq13xIpdk0cdK1LtfqOiTT5Nnf74OMP5OunEgL8N3Kg5xrmxXlORbz0VRVkR2pX4TF79Pc4SCDrX6nTQxwgwieGmuQ4QhZOw9gMGOt7d1SYcQCB/sEc53Z/KieNl5Hc2raYc8uLT52EKjbTBOva9RjJ9oalIKtZF59M7zIpMA7PQcWqH8RdgBymtwTjCQSsVFf5uOuG+WK84P4FT7DRBqzkusdcnehkdzvWjiRpMM0hW/NUVFBeF7/6+PR0UJUAcfcIRH9OhgaF0/hhKEuL6q5YM7ucEhNg/BiA390fmGX5kgHcQSIifW43ujprogAZyG4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(55016002)(9686003)(2906002)(33656002)(83380400001)(478600001)(66556008)(52536014)(66446008)(64756008)(66946007)(76116006)(66476007)(4326008)(5660300002)(8936002)(8676002)(6916009)(86362001)(316002)(55236004)(54906003)(53546011)(7696005)(6506007)(26005)(71200400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QW05d1ZlN21pbElkZHZaNWN6bC94V1dTM21hNW5LUG4xdHZHUGhSQkZTRk1v?=
 =?utf-8?B?Vm96eU5xWHJKRUMxRFhqQWRPbC9iSTFTbXc4S2ZLMCtrajhkQ1RrRGlqdnVC?=
 =?utf-8?B?VjBBMFpqY2xyN2Jmc1ErNndueVdkU1hCVW9DMUFlZThsREJYbjZKdmlnNWJX?=
 =?utf-8?B?TkFDK3plL3VGVnR4SWJKbXJYa1hUZU9wUFllR3ZIN2YwemUzQmJodFlmTnpB?=
 =?utf-8?B?djQ0Z0kzK0I3ZmllOG8yT3MvK1RkczQrcGVZNjU0Z1ZYYTB1U3lMcGxTTFR2?=
 =?utf-8?B?SEs3ZllzSDYvWU1wMks1K0wyVmE4MjZ2MWw5Q3FJd3Bzcng4RGhDZWR2TXEz?=
 =?utf-8?B?RE8rbzNmalJTL1Q1cTZyeGdNNllZajZGMVlyRDlBQ3RGZFFPcmFrVDZ5OTZy?=
 =?utf-8?B?MzBCNjc3a3BiUXBVUk1uYWRIL3ladmZVNUV2UFFtM1JPTmlXdGZUaDArTnJi?=
 =?utf-8?B?TE5pYmV6Z2JhY0NmRUdFYzI3Z1NxN05rNE4zUE5NZllVOTBSeUtwbDRBOUVa?=
 =?utf-8?B?cDJxVEo1S3RlSWV0WkNjandjejFDdzQxUjlaTjhKQUttUkdEVk16Z0ovS1Zz?=
 =?utf-8?B?Ny9oMk40aHVDS2lIdzk5ZmI3My9yaE5ha0ZVZGJzMHdDNXhaZmRIU2MzZlA5?=
 =?utf-8?B?aTlPMGpzU29jZHkwb0U1dGZRejFSaHhpalNXMmEwOStEVEswc212SDZ5V0x0?=
 =?utf-8?B?MFhJbUxhdWt0ejBuN2p3bHlsNEs3NW9pcW5KTktNd2hnQ2l4SldpcXgzdmVp?=
 =?utf-8?B?bitTczFMMDJYdXlFTnd2RWY0YXhlUG5PY2NxNEJCRHRIQlRidFB0RGhhY2Jv?=
 =?utf-8?B?VU42cHRzNDNrVGs4cE9kaGZGeWdTOTBSRmlIRUhvV3dXVGtYZVhYa3E1b2VZ?=
 =?utf-8?B?aFU1aDgrazdHM28raXc2K3Ard25VaVd6azJvMTR2Q0U2bXAvbzVqSllFUDlG?=
 =?utf-8?B?UmNpMEMzc0V4bjBwOGs3WnB2bDNMUTlWSHdmVUpGR2l0ZWxROVVLZGUvZGxP?=
 =?utf-8?B?ZWVPYjJpT212ZlhUVTY1NVQ4M3J4Y3dvQmVWaEM3aVc1K05aL2ZDUng1UVda?=
 =?utf-8?B?OCtWcmgwU3UzZmNDOEt4b09ydGcvaXh5a3BPc1NpWXZlTko4UUU1WGFybkJF?=
 =?utf-8?B?SElWSlpZeE9neGlkbVBmR2p1eHRuNjJJQldhS0VUZ0JHYkVzeWNwOXV4cTdP?=
 =?utf-8?B?dVFKdzhMR3EwQnZuSlJYdEJ0a0k3eDVzeHQ3SmJRM2c3VWhPTXovVjFCck14?=
 =?utf-8?B?Snd6UTNXVzRGdlVmcGhRZUk0M2JDdFRWYU0yOXRpMUF5cmJWcmZCQ2lVWUlR?=
 =?utf-8?Q?6Z6nqli5egfBI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f5f5d1-7fb8-4a08-924a-08d896b34044
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 11:13:09.3228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q/gJnzXQrR0YocBIlwey47rKFf4+Y8L61aZkQcP/KMMHRMrlPUFlGrAANl2WFxC3lvOFgVWQLawQy1b59VjQlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3730
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606907591; bh=Td48a6kSnFawjmApwKTSwU9aBWvRzoIB2dbBsbT4lvc=;
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
        b=JOvYFaI2D56N35gHsJ6XzAsjBaRN5VkpWFY4Oorm/bm/XWNI4Ay7bzLsV+ui+Agqy
         35bFCT2Plo7XppRg9Jmj5eGGj8RmS/iQD3gwcpEEIgKIB46Vc5WyQmoLUkSp7eOMIq
         uGBdHIYSykmxMpj6ByFIMqEfjBMyoP2H4UVxIXF/EKwN0qFqbsOsO8FjVg2zTRkOdM
         OdQAZVaos9Mj2KBvQITiPSYl7VsVxm47Eq0evOzIJtyPBRR7E8dsZdocSFxJ07B4Tt
         bTqusKFJTVzkcKIFUbi/7XY/xr8eT6zDGmS7Y1uXzHDTA0n/OXu/o5RBncdCI/WK29
         yipI+ZqO5/gtA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWW9uZ2ppIFhpZSA8eGlleW9uZ2ppQGJ5dGVkYW5jZS5jb20+DQo+IFNlbnQ6
IFdlZG5lc2RheSwgRGVjZW1iZXIgMiwgMjAyMCAyOjUyIFBNDQo+IA0KPiBPbiBXZWQsIERlYyAy
LCAyMDIwIGF0IDEyOjUzIFBNIFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPg0KPiA+DQo+ID4gPiBGcm9tOiBZb25namkgWGllIDx4aWV5b25namlAYnl0ZWRh
bmNlLmNvbT4NCj4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgMiwgMjAyMCA5OjAwIEFN
DQo+ID4gPg0KPiA+ID4gT24gVHVlLCBEZWMgMSwgMjAyMCBhdCAxMTo1OSBQTSBQYXJhdiBQYW5k
aXQgPHBhcmF2QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPg0K
PiA+ID4gPiA+IEZyb206IFlvbmdqaSBYaWUgPHhpZXlvbmdqaUBieXRlZGFuY2UuY29tPg0KPiA+
ID4gPiA+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDEsIDIwMjAgNzo0OSBQTQ0KPiA+ID4gPiA+
DQo+ID4gPiA+ID4gT24gVHVlLCBEZWMgMSwgMjAyMCBhdCA3OjMyIFBNIFBhcmF2IFBhbmRpdCA8
cGFyYXZAbnZpZGlhLmNvbT4NCj4gd3JvdGU6DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+IEZyb206IFlvbmdqaSBYaWUgPHhpZXlvbmdqaUBieXRl
ZGFuY2UuY29tPg0KPiA+ID4gPiA+ID4gPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAxLCAyMDIw
IDM6MjYgUE0NCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gT24gVHVlLCBEZWMgMSwgMjAy
MCBhdCAyOjI1IFBNIEphc29uIFdhbmcNCj4gPiA+ID4gPiA+ID4gPGphc293YW5nQHJlZGhhdC5j
b20+DQo+ID4gPiA+ID4gd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gPiA+IE9uIDIwMjAvMTEvMzAg5LiL5Y2IMzowNywgWW9uZ2ppIFhpZSB3cm90
ZToNCj4gPiA+ID4gPiA+ID4gPiA+Pj4gVGhhbmtzIGZvciBhZGRpbmcgbWUsIEphc29uIQ0KPiA+
ID4gPiA+ID4gPiA+ID4+Pg0KPiA+ID4gPiA+ID4gPiA+ID4+PiBOb3cgSSdtIHdvcmtpbmcgb24g
YSB2MiBwYXRjaHNldCBmb3IgVkRVU0UgKHZEUEENCj4gPiA+ID4gPiA+ID4gPiA+Pj4gRGV2aWNl
IGluDQo+ID4gPiA+ID4gPiA+ID4gPj4+IFVzZXJzcGFjZSkgWzFdLiBUaGlzIHRvb2wgaXMgdmVy
eSB1c2VmdWwgZm9yIHRoZSB2ZHVzZSBkZXZpY2UuDQo+ID4gPiA+ID4gPiA+ID4gPj4+IFNvIEkn
bSBjb25zaWRlcmluZyBpbnRlZ3JhdGluZyB0aGlzIGludG8gbXkgdjIgcGF0Y2hzZXQuDQo+ID4g
PiA+ID4gPiA+ID4gPj4+IEJ1dCB0aGVyZSBpcyBvbmUgcHJvYmxlbe+8mg0KPiA+ID4gPiA+ID4g
PiA+ID4+Pg0KPiA+ID4gPiA+ID4gPiA+ID4+PiBJbiB0aGlzIHRvb2wsIHZkcGEgZGV2aWNlIGNv
bmZpZyBhY3Rpb24gYW5kIGVuYWJsZQ0KPiA+ID4gPiA+ID4gPiA+ID4+PiBhY3Rpb24gYXJlIGNv
bWJpbmVkIGludG8gb25lIG5ldGxpbmsgbXNnOg0KPiA+ID4gPiA+ID4gPiA+ID4+PiBWRFBBX0NN
RF9ERVZfTkVXLiBCdXQgaW4NCj4gPiA+ID4gPiB2ZHVzZQ0KPiA+ID4gPiA+ID4gPiA+ID4+PiBj
YXNlLCBpdCBuZWVkcyB0byBiZSBzcGxpdHRlZCBiZWNhdXNlIGEgY2hhcmRldiBzaG91bGQNCj4g
PiA+ID4gPiA+ID4gPiA+Pj4gYmUgY3JlYXRlZCBhbmQgb3BlbmVkIGJ5IGEgdXNlcnNwYWNlIHBy
b2Nlc3MgYmVmb3JlIHdlDQo+ID4gPiA+ID4gPiA+ID4gPj4+IGVuYWJsZSB0aGUgdmRwYSBkZXZp
Y2UgKGNhbGwgdmRwYV9yZWdpc3Rlcl9kZXZpY2UoKSkuDQo+ID4gPiA+ID4gPiA+ID4gPj4+DQo+
ID4gPiA+ID4gPiA+ID4gPj4+IFNvIEknZCBsaWtlIHRvIGtub3cgd2hldGhlciBpdCdzIHBvc3Np
YmxlIChvciBoYXZlDQo+ID4gPiA+ID4gPiA+ID4gPj4+IHNvbWUNCj4gPiA+ID4gPiA+ID4gPiA+
Pj4gcGxhbnMpIHRvIGFkZCB0d28gbmV3IG5ldGxpbmsgbXNncyBzb21ldGhpbmcgbGlrZToNCj4g
PiA+ID4gPiA+ID4gPiA+Pj4gVkRQQV9DTURfREVWX0VOQUJMRQ0KPiA+ID4gPiA+ID4gPiBhbmQN
Cj4gPiA+ID4gPiA+ID4gPiA+Pj4gVkRQQV9DTURfREVWX0RJU0FCTEUgdG8gbWFrZSB0aGUgY29u
ZmlnIHBhdGggbW9yZQ0KPiBmbGV4aWJsZS4NCj4gPiA+ID4gPiA+ID4gPiA+Pj4NCj4gPiA+ID4g
PiA+ID4gPiA+PiBBY3R1YWxseSwgd2UndmUgZGlzY3Vzc2VkIHN1Y2ggaW50ZXJtZWRpYXRlIHN0
ZXAgaW4NCj4gPiA+ID4gPiA+ID4gPiA+PiBzb21lIGVhcmx5IGRpc2N1c3Npb24uIEl0IGxvb2tz
IHRvIG1lIFZEVVNFIGNvdWxkIGJlDQo+ID4gPiA+ID4gPiA+ID4gPj4gb25lIG9mIHRoZSB1c2Vy
cyBvZg0KPiA+ID4gdGhpcy4NCj4gPiA+ID4gPiA+ID4gPiA+Pg0KPiA+ID4gPiA+ID4gPiA+ID4+
IE9yIEkgd29uZGVyIHdoZXRoZXIgd2UgY2FuIHN3aXRjaCB0byB1c2UgYW5vbnltb3VzDQo+ID4g
PiA+ID4gPiA+ID4gPj4gaW5vZGUoZmQpIGZvciBWRFVTRSB0aGVuIGZldGNoaW5nIGl0IHZpYSBh
bg0KPiA+ID4gPiA+ID4gPiA+ID4+IFZEVVNFX0dFVF9ERVZJQ0VfRkQNCj4gPiA+IGlvY3RsPw0K
PiA+ID4gPiA+ID4gPiA+ID4+DQo+ID4gPiA+ID4gPiA+ID4gPiBZZXMsIHdlIGNhbi4gQWN0dWFs
bHkgdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24gaW4NCj4gPiA+ID4gPiA+ID4gPiA+IFZEVVNF
IGlzIGxpa2UgdGhpcy4gIEJ1dCBzZWVtcyBsaWtlIHRoaXMgaXMgc3RpbGwgYSBpbnRlcm1lZGlh
dGUNCj4gc3RlcC4NCj4gPiA+ID4gPiA+ID4gPiA+IFRoZSBmZCBzaG91bGQgYmUgYmluZGVkIHRv
IGEgbmFtZSBvciBzb21ldGhpbmcgZWxzZQ0KPiA+ID4gPiA+ID4gPiA+ID4gd2hpY2ggbmVlZCB0
byBiZSBjb25maWd1cmVkIGJlZm9yZS4NCj4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+
DQo+ID4gPiA+ID4gPiA+ID4gVGhlIG5hbWUgY291bGQgYmUgc3BlY2lmaWVkIHZpYSB0aGUgbmV0
bGluay4gSXQgbG9va3MgdG8NCj4gPiA+ID4gPiA+ID4gPiBtZSB0aGUgcmVhbCBpc3N1ZSBpcyB0
aGF0IHVudGlsIHRoZSBkZXZpY2UgaXMgY29ubmVjdGVkDQo+ID4gPiA+ID4gPiA+ID4gd2l0aCBh
IHVzZXJzcGFjZSwgaXQgY2FuJ3QgYmUgdXNlZC4gU28gd2UgYWxzbyBuZWVkIHRvDQo+ID4gPiA+
ID4gPiA+ID4gZmFpbCB0aGUgZW5hYmxpbmcgaWYgaXQgZG9lc24ndA0KPiA+ID4gPiA+IG9wZW5l
ZC4NCj4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBZZXMsIHRo
YXQncyB0cnVlLiBTbyB5b3UgbWVhbiB3ZSBjYW4gZmlyc3RseSB0cnkgdG8gZmV0Y2gNCj4gPiA+
ID4gPiA+ID4gdGhlIGZkIGJpbmRlZCB0byBhIG5hbWUvdmR1c2VfaWQgdmlhIGFuIFZEVVNFX0dF
VF9ERVZJQ0VfRkQsDQo+ID4gPiA+ID4gPiA+IHRoZW4gdXNlIHRoZSBuYW1lL3ZkdXNlX2lkIGFz
IGEgYXR0cmlidXRlIHRvIGNyZWF0ZSB2ZHBhDQo+ID4gPiA+ID4gPiA+IGRldmljZT8gSXQgbG9v
a3MgZmluZSB0bw0KPiA+ID4gbWUuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gSSBwcm9iYWJs
eSBkbyBub3Qgd2VsbCB1bmRlcnN0YW5kLiBJIHRyaWVkIHJlYWRpbmcgcGF0Y2ggWzFdDQo+ID4g
PiA+ID4gPiBhbmQgZmV3IHRoaW5ncw0KPiA+ID4gPiA+IGRvIG5vdCBsb29rIGNvcnJlY3QgYXMg
YmVsb3cuDQo+ID4gPiA+ID4gPiBDcmVhdGluZyB0aGUgdmRwYSBkZXZpY2Ugb24gdGhlIGJ1cyBk
ZXZpY2UgYW5kIGRlc3Ryb3lpbmcgdGhlDQo+ID4gPiA+ID4gPiBkZXZpY2UgZnJvbQ0KPiA+ID4g
PiA+IHRoZSB3b3JrcXVldWUgc2VlbXMgdW5uZWNlc3NhcnkgYW5kIHJhY3kuDQo+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gSXQgc2VlbXMgdmR1c2UgZHJpdmVyIG5lZWRzDQo+ID4gPiA+ID4gPiBU
aGlzIGlzIHNvbWV0aGluZyBzaG91bGQgYmUgZG9uZSBhcyBwYXJ0IG9mIHRoZSB2ZHBhIGRldiBh
ZGQNCj4gPiA+ID4gPiA+IGNvbW1hbmQsDQo+ID4gPiA+ID4gaW5zdGVhZCBvZiBjb25uZWN0aW5n
IHR3byBzaWRlcyBzZXBhcmF0ZWx5IGFuZCBlbnN1cmluZyByYWNlDQo+ID4gPiA+ID4gZnJlZSBh
Y2Nlc3MgdG8gaXQuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gU28gVkRVU0VfREVWX1NUQVJU
IGFuZCBWRFVTRV9ERVZfU1RPUCBzaG91bGQgcG9zc2libHkgYmUNCj4gYXZvaWRlZC4NCj4gPiA+
ID4gPiA+DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBZZXMsIHdlIGNhbiBhdm9pZCB0aGVzZSB0d28g
aW9jdGxzIHdpdGggdGhlIGhlbHAgb2YgdGhlIG1hbmFnZW1lbnQNCj4gdG9vbC4NCj4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gJCB2ZHBhIGRldiBhZGQgcGFyZW50ZGV2IHZkdXNlX21nbXRkZXYgdHlw
ZSBuZXQgbmFtZSBmb28yDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gV2hlbiBhYm92ZSBjb21t
YW5kIGlzIGV4ZWN1dGVkIGl0IGNyZWF0ZXMgbmVjZXNzYXJ5IHZkcGENCj4gPiA+ID4gPiA+IGRl
dmljZQ0KPiA+ID4gPiA+ID4gZm9vMg0KPiA+ID4gPiA+IG9uIHRoZSBidXMuDQo+ID4gPiA+ID4g
PiBXaGVuIHVzZXIgYmluZHMgZm9vMiBkZXZpY2Ugd2l0aCB0aGUgdmR1c2UgZHJpdmVyLCBpbiB0
aGUNCj4gPiA+ID4gPiA+IHByb2JlKCksIGl0DQo+ID4gPiA+ID4gY3JlYXRlcyByZXNwZWN0aXZl
IGNoYXIgZGV2aWNlIHRvIGFjY2VzcyBpdCBmcm9tIHVzZXIgc3BhY2UuDQo+ID4gPiA+ID4NCj4g
PiA+ID4gSSBzZWUuIFNvIHZkdXNlIGNhbm5vdCB3b3JrIHdpdGggYW55IGV4aXN0aW5nIHZkcGEg
ZGV2aWNlcyBsaWtlDQo+ID4gPiA+IGlmYywgbWx4NSBvcg0KPiA+ID4gbmV0ZGV2c2ltLg0KPiA+
ID4gPiBJdCBoYXMgaXRzIG93biBpbXBsZW1lbnRhdGlvbiBzaW1pbGFyIHRvIGZ1c2Ugd2l0aCBp
dHMgb3duIGJhY2tlbmQgb2YNCj4gY2hvaWNlLg0KPiA+ID4gPiBNb3JlIGJlbG93Lg0KPiA+ID4g
Pg0KPiA+ID4gPiA+IEJ1dCB2ZHVzZSBkcml2ZXIgaXMgbm90IGEgdmRwYSBidXMgZHJpdmVyLiBJ
dCB3b3JrcyBsaWtlIHZkcGFzaW0NCj4gPiA+ID4gPiBkcml2ZXIsIGJ1dCBvZmZsb2FkcyB0aGUg
ZGF0YSBwbGFuZSBhbmQgY29udHJvbCBwbGFuZSB0byBhIHVzZXIgc3BhY2UNCj4gcHJvY2Vzcy4N
Cj4gPiA+ID4NCj4gPiA+ID4gSW4gdGhhdCBjYXNlIHRvIGRyYXcgcGFyYWxsZWwgbGluZXMsDQo+
ID4gPiA+DQo+ID4gPiA+IDEuIG5ldGRldnNpbToNCj4gPiA+ID4gKGEpIGNyZWF0ZSByZXNvdXJj
ZXMgaW4ga2VybmVsIHN3DQo+ID4gPiA+IChiKSBkYXRhcGF0aCBzaW11bGF0ZXMgaW4ga2VybmVs
DQo+ID4gPiA+DQo+ID4gPiA+IDIuIGlmYyArIG1seDUgdmRwYSBkZXY6DQo+ID4gPiA+IChhKSBj
cmVhdGVzIHJlc291cmNlIGluIGh3DQo+ID4gPiA+IChiKSBkYXRhIHBhdGggaXMgaW4gaHcNCj4g
PiA+ID4NCj4gPiA+ID4gMy4gdmR1c2U6DQo+ID4gPiA+IChhKSBjcmVhdGVzIHJlc291cmNlcyBp
biB1c2Vyc3BhY2Ugc3cNCj4gPiA+ID4gKGIpIGRhdGEgcGF0aCBpcyBpbiB1c2VyIHNwYWNlLg0K
PiA+ID4gPiBoZW5jZSBjcmVhdGVzIGRhdGEgcGF0aCByZXNvdXJjZXMgZm9yIHVzZXIgc3BhY2Uu
DQo+ID4gPiA+IFNvIGNoYXIgZGV2aWNlIGlzIGNyZWF0ZWQsIHJlbW92ZWQgYXMgcmVzdWx0IG9m
IHZkcGEgZGV2aWNlIGNyZWF0aW9uLg0KPiA+ID4gPg0KPiA+ID4gPiBGb3IgZXhhbXBsZSwNCj4g
PiA+ID4gJCB2ZHBhIGRldiBhZGQgcGFyZW50ZGV2IHZkdXNlX21nbXRkZXYgdHlwZSBuZXQgbmFt
ZSBmb28yDQo+ID4gPiA+DQo+ID4gPiA+IEFib3ZlIGNvbW1hbmQgd2lsbCBjcmVhdGUgY2hhciBk
ZXZpY2UgZm9yIHVzZXIgc3BhY2UuDQo+ID4gPiA+DQo+ID4gPiA+IFNpbWlsYXIgY29tbWFuZCBm
b3IgaWZjL21seDUgd291bGQgaGF2ZSBjcmVhdGVkIHNpbWlsYXIgY2hhbm5lbA0KPiA+ID4gPiBm
b3IgcmVzdCBvZg0KPiA+ID4gdGhlIGNvbmZpZyBjb21tYW5kcyBpbiBody4NCj4gPiA+ID4gdmR1
c2UgY2hhbm5lbCA9IGNoYXIgZGV2aWNlLCBldmVudGZkIGV0Yy4NCj4gPiA+ID4gaWZjL21seDUg
aHcgY2hhbm5lbCA9IGJhciwgaXJxLCBjb21tYW5kIGludGVyZmFjZSBldGMgTmV0ZGV2IHNpbQ0K
PiA+ID4gPiBjaGFubmVsID0gc3cgZGlyZWN0IGNhbGxzDQo+ID4gPiA+DQo+ID4gPiA+IERvZXMg
aXQgbWFrZSBzZW5zZT8NCj4gPiA+DQo+ID4gPiBJbiBteSB1bmRlcnN0YW5kaW5nLCB0byBtYWtl
IHZkcGEgd29yaywgd2UgbmVlZCBhIGJhY2tlbmQgKGRhdGFwYXRoDQo+ID4gPiByZXNvdXJjZXMp
IGFuZCBhIGZyb250ZW5kIChhIHZkcGEgZGV2aWNlIGF0dGFjaGVkIHRvIGEgdmRwYSBidXMpLiBJ
bg0KPiA+ID4gdGhlIGFib3ZlIGV4YW1wbGUsIGl0IGxvb2tzIGxpa2Ugd2UgdXNlIHRoZSBjb21t
YW5kICJ2ZHBhIGRldiBhZGQgLi4uIg0KPiA+ID4gIHRvIGNyZWF0ZSBhIGJhY2tlbmQsIHNvIGRv
IHdlIG5lZWQgYW5vdGhlciBjb21tYW5kIHRvIGNyZWF0ZSBhDQo+IGZyb250ZW5kPw0KPiA+ID4N
Cj4gPiBGb3IgYmxvY2sgZGV2aWNlIHRoZXJlIGlzIGNlcnRhaW5seSBzb21lIGJhY2tlbmQgdG8g
cHJvY2VzcyB0aGUgSU9zLg0KPiA+IFNvbWV0aW1lcyBiYWNrZW5kIHRvIGJlIHNldHVwIGZpcnN0
LCBiZWZvcmUgaXRzIGZyb250IGVuZCBpcyBleHBvc2VkLg0KPiANCj4gWWVzLCB0aGUgYmFja2Vu
ZCBuZWVkIHRvIGJlIHNldHVwIGZpcnN0bHksIHRoaXMgaXMgdmVuZG9yIGRldmljZSBzcGVjaWZp
Yywgbm90DQo+IHZkcGEgc3BlY2lmaWMuDQo+IA0KPiA+ICJ2ZHBhIGRldiBhZGQiIGlzIHRoZSBm
cm9udCBlbmQgY29tbWFuZCB3aG8gY29ubmVjdHMgdG8gdGhlIGJhY2tlbmQNCj4gKGltcGxpY2l0
bHkpIGZvciBuZXR3b3JrIGRldmljZS4NCj4gPg0KPiA+IHZob3N0LT52ZHBhX2Jsb2NrX2Rldmlj
ZS0+YmFja2VuZF9pb19wcm9jZXNzb3IgKHVzcixodyxrZXJuZWwpLg0KPiA+DQo+ID4gQW5kIGl0
IG5lZWRzIGEgd2F5IHRvIGNvbm5lY3QgdG8gYmFja2VuZCB3aGVuIGV4cGxpY2l0bHkgc3BlY2lm
aWVkIGR1cmluZw0KPiBjcmVhdGlvbiB0aW1lLg0KPiA+IFNvbWV0aGluZyBsaWtlLA0KPiA+ICQg
dmRwYSBkZXYgYWRkIHBhcmVudGRldiB2ZHBhX3ZkdXNlIHR5cGUgYmxvY2sgbmFtZSBmb28zIGhh
bmRsZQ0KPiA8dXVpZD4NCj4gPiBJbiBhYm92ZSBleGFtcGxlIHNvbWUgdmVuZG9yIGRldmljZSBz
cGVjaWZpYyB1bmlxdWUgaGFuZGxlIGlzIHBhc3NlZA0KPiBiYXNlZCBvbiBiYWNrZW5kIHNldHVw
IGluIGhhcmR3YXJlL3VzZXIgc3BhY2UuDQo+ID4NCj4gDQo+IFllcywgd2UgY2FuIHdvcmsgbGlr
ZSB0aGlzLiBBZnRlciB3ZSBzZXR1cCBhIGJhY2tlbmQgdGhyb3VnaCBhbiBhbm9ueW1vdXMNCj4g
aW5vZGUoZmQpIGZyb20gL2Rldi92ZHVzZSwgd2UgY2FuIGdldCBhIHVuaXF1ZSBoYW5kbGUuIFRo
ZW4gdXNlIGl0IHRvDQo+IGNyZWF0ZSBhIGZyb250ZW5kIHdoaWNoIHdpbGwgY29ubmVjdCB0byB0
aGUgc3BlY2lmaWMgYmFja2VuZC4NCg0KSSBkbyBub3QgZnVsbHkgdW5kZXJzdGFuZCB0aGUgaW5v
ZGUuIEJ1dCBJIGFzc3VtZSB0aGlzIGlzIHNvbWUgdW5pcXVlIGhhbmRsZSBzYXkgdXVpZCBvciBz
b21ldGhpbmcgdGhhdCBib3RoIHNpZGVzIGJhY2tlbmQgYW5kIHZkcGEgZGV2aWNlIHVuZGVyc3Rh
bmQuDQpJdCBjYW5ub3QgYmUgc29tZSBrZXJuZWwgaW50ZXJuYWwgaGFuZGxlIGV4cG9zZSB0byB1
c2VyIHNwYWNlLg0KDQo+IA0KPiA+IEluIGJlbG93IDMgZXhhbXBsZXMsIHZkcGEgYmxvY2sgc2lt
dWxhdG9yIGlzIGNvbm5lY3RpbmcgdG8gYmFja2VuZCBibG9jaw0KPiBvciBmaWxlLg0KPiA+DQo+
ID4gJCB2ZHBhIGRldiBhZGQgcGFyZW50ZGV2IHZkcGFfYmxvY2tzaW0gdHlwZSBibG9jayBuYW1l
IGZvbzQgYmxvY2tkZXYNCj4gPiAvZGV2L3plcm8NCj4gPg0KPiA+ICQgdmRwYSBkZXYgYWRkIHBh
cmVudGRldiB2ZHBhX2Jsb2Nrc2ltIHR5cGUgYmxvY2sgbmFtZSBmb281IGJsb2NrZGV2DQo+ID4g
L2Rldi9zZGEyIHNpemU9MTAwTSBvZmZzZXQ9MTBNDQo+ID4NCj4gPiAkIHZkcGEgZGV2IGFkZCBw
YXJlbnRkZXYgdmRwYV9ibG9jayBmaWxlYmFja2VuZF9zaW0gdHlwZSBibG9jayBuYW1lDQo+ID4g
Zm9vNiBmaWxlIC9yb290L2ZpbGVfYmFja2VuZC50eHQNCj4gPg0KPiA+IE9yIG1heSBiZSBiYWNr
ZW5kIGNvbm5lY3RzIHRvIHRoZSBjcmVhdGVkIHZkcGEgZGV2aWNlIGlzIGJvdW5kIHRvIHRoZQ0K
PiBkcml2ZXIuDQo+ID4gQ2FuIHZkdXNlIGF0dGFjaCB0byB0aGUgY3JlYXRlZCB2ZHBhIGJsb2Nr
IGRldmljZSB0aHJvdWdoIHRoZSBjaGFyIGRldmljZQ0KPiBhbmQgZXN0YWJsaXNoIHRoZSBjaGFu
bmVsIHRvIHJlY2VpdmUgSU9zLCBhbmQgdG8gc2V0dXAgdGhlIGJsb2NrIGNvbmZpZyBzcGFjZT8N
Cj4gPg0KPiANCj4gSG93IHRvIGNyZWF0ZSB0aGUgdmRwYSBibG9jayBkZXZpY2U/IElmIHdlIHVz
ZSB0aGUgY29tbWFuZCAidmRwYSBkZXYNCj4gYWRkLi4iLCB0aGUgY29tbWFuZCB3aWxsIGhhbmcg
dGhlcmUgdW50aWwgYSB2ZHVzZSBwcm9jZXNzIGF0dGFjaGVzIHRvIHRoZQ0KPiB2ZHBhIGJsb2Nr
IGRldmljZS4NCkkgd2FzIHN1Z2dlc3RpbmcgdGhhdCB2ZHBhIGRldmljZSBpcyBjcmVhdGVkLCBi
dXQgaXQgZG9lc27igJl0IGhhdmUgYmFja2VuZCBhdHRhY2hlZCB0byBpdC4NCkl0IGlzIGF0dGFj
aGVkIHRvIHRoZSBiYWNrZW5kIHdoZW4gaW9jdGwoKSBzaWRlIGRvZXMgZW5vdWdoIHNldHVwLiBU
aGlzIHN0YXRlIGlzIGhhbmRsZWQgaW50ZXJuYWxseSB0aGUgdmR1c2UgZHJpdmVyLg0KDQpCdXQg
dGhlIGFib3ZlIG1ldGhvZCBvZiBwcmVwYXJpbmcgYmFja2VuZCBsb29rcyBtb3JlIHNhbmUuDQoN
ClJlZ2FyZGxlc3Mgb2Ygd2hpY2ggbWV0aG9kIGlzIHByZWZlcnJlZCwgdmR1c2UgZHJpdmVyIG11
c3QgbmVlZCBhIHN0YXRlIHRvIGRldGFjaCB0aGUgdmRwYSBidXMgZGV2aWNlIHF1ZXVlcyBldGMg
ZnJvbSB0aGUgdXNlciBzcGFjZS4NClRoaXMgaXMgbmVlZGVkIGJlY2F1c2UgdXNlciBzcGFjZSBw
cm9jZXNzIGNhbiB0ZXJtaW5hdGUgYW55dGltZSByZXN1bHRpbmcgaW4gZGV0YWNoaW5nIGRwYSBi
dXMgZGV2aWNlIGluX3VzZSBieSB0aGUgdmhvc3Qgc2lkZS4NCg==
