Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8CB2CA795
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390265AbgLAP7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:59:40 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19804 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389215AbgLAP7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:59:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc668430002>; Tue, 01 Dec 2020 07:58:59 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 15:58:59 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 1 Dec 2020 15:58:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXNOQ8pJ3e+1gNA2hjlSXGVfBSZmr3tTIlcLxDcCzRCVjrKuF3Pz+qYA6QzNtl6NMsf1g3X1GueM+0ict6MOO3e+AaYsNLkmhSVs/KefjhP9HbD0S6v+9uJSzLrElDrmBOwZZHl9HhXerP8kUWqyyxir/aX8Pgtwvn6Hq5nrlLejLSzpB9OxyZGTXG1s2sRIeQt1D+qOmSp37OHN4pfayA1EuyjT74mv8WCsTtS8XMazKC9xrVAvqtsritJ1r8SdVCwVwYCQBiwE/eCqhKSugbzndSCJYrqQnePv1wxK1qMLT9zzVqOCeRgmKHKGnh0kQpBrPfah43HDe9sy2c1VQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ygu9k+EKjBwSg/3bh7MFTM5Tu86V4Wxdf4vcBkmC/4=;
 b=S8/EadRX3AhpFdkON2TGO52L/vdTga4/NvfAcugJhts6IGuXleifxcQbXKMY5Ufjm6yR74MHqSxEtsTSwdl+IphgYA1hkkCqU8T0frq718s/a7931jszUf1WI8WClFyPt+Zk1pf1ysMj03Y45qk1haITI5tdGbNAClnAx00NN7YXXbFVH+nUErhYKm5NgDHV/LYPkOWwIoeBS0t2l2d7PlhklPnzIssRuZdfyMrpsBoHZxUT9yzK7TwSelr+JZDcha4B5kFkcUsXhCKUTzeBuH4+fBlWTeCxtKSBBQ9P+RNHSM3uNaw5s1Tluk59CAQOpGkiDQf+EoZBHaonIvJBrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2872.namprd12.prod.outlook.com (2603:10b6:a03:12e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Tue, 1 Dec
 2020 15:58:57 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Tue, 1 Dec 2020
 15:58:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yongji Xie <xieyongji@bytedance.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Topic: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Index: AQHWuL6/zQf/qaV5ZkSpuhr8mZ5CmKnbcCaAgAAhUQCABJD4AIAAOuMAgAGGmoCAADrXgIAAFskggAAyq4CAABrrUA==
Date:   Tue, 1 Dec 2020 15:58:56 +0000
Message-ID: <BY5PR12MB4322C80FB3C76B85A2D095CCDCF40@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com>
 <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com>
 <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
 <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
 <CACycT3tTCmEzY37E5196Q2mqME2v+KpAp7Snn8wK4XtRKHEqEw@mail.gmail.com>
In-Reply-To: <CACycT3tTCmEzY37E5196Q2mqME2v+KpAp7Snn8wK4XtRKHEqEw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20050c2e-aca3-47ff-9919-08d8961202a1
x-ms-traffictypediagnostic: BYAPR12MB2872:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2872A637896DE0E9AA2D03B5DCF40@BYAPR12MB2872.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PuECggeTNhASlMlo7OavoaKuWgY0ocTqDEawhNgmSdMFoRDvPU6bN7S/Ui9XYiRMoX+5SIARhw509unzIYyRfFAyDKdsjeGc4/pXC09PrhS5o31KAvOnPtYxQOoH6wA4tObSydihtEEyOa5dg3CP6i6AJOPR0GccxhrUJ8bo7ENMz0/ibos0pHjgPw62N3i5OEn5qza2eBYUx+ftuKsrfzdmXBPek8hkBmyHe0olzizngwzydcC7em6G0Q0BC8LPGRg/XGh7j5ClRFPq5Is4tDBwnZI3Fp8YoybBV2nxDwVok5cXGcDT14uGVEaJto59
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(7696005)(316002)(478600001)(6916009)(54906003)(8936002)(8676002)(71200400001)(2906002)(4326008)(55016002)(9686003)(83380400001)(55236004)(86362001)(33656002)(76116006)(64756008)(66556008)(66476007)(186003)(66946007)(66446008)(53546011)(6506007)(52536014)(5660300002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TElaTzZmUFI4SDBBRm9Lc3BDZHBVTUgxalA0ajRBRWpZcGw1dTZ1TmIydjYy?=
 =?utf-8?B?aXltNVZROEordjVWNlUyNTBUOXFrZDh1cVpoQ25lZ3BzcFp6L0FMU1FEejdO?=
 =?utf-8?B?MW43MTdFUlJ3WnlWNnlOSTRLb0Z0N2ZMRUxxVGNMVzVpUC83MFJ6REVLeG5i?=
 =?utf-8?B?bzdBU29aTWpOYnV5RFBGeWFuU3hPT2FxT3lqNjZCVkI2aFN2dUI4TVJheEpK?=
 =?utf-8?B?WUwxWG01Uk5xMjZKV2gzZnJhd2lEV3VyOVd0Q2dtT1JUQ2w5NHJDRkFQQkNl?=
 =?utf-8?B?REMzVmhyQ0RQdWZRSDh1Q2M0aFBEaTZJcjZVd1Q3ZDJIdGJlVElndVo1cjg0?=
 =?utf-8?B?YlJzR1I1Rk1YY0s3UkYzc1BGZENPR0t5S3oyZ3ZUZjNEaEpUOCszM2Zlc0hT?=
 =?utf-8?B?eUpwS1pVNGVCb1h4YXZKZFJEQUc3Z3hCR3hxTXg4RmVHRytEdzdKSFVvZ0Fx?=
 =?utf-8?B?WVRTWmpmdldlcUJySlFGWHBqdkxlRk44MXErOGxFTmRETWszWW90RDVrL3kx?=
 =?utf-8?B?ZmRMNlFVK0xBUTl2bjFoSmVaMzNENHZkWnFRZjl5Q245ampZRWJDaFh6b3Bz?=
 =?utf-8?B?bXAzbVM4NkFkTHlaTWZXdCs1KzFoZ2FoM1NVWFcxTWxJQWpYd1JYcEszQ2RN?=
 =?utf-8?B?K25md0MwSk9Kb0ZLSEt1NDJ3eWxjblZvaDM4eFhOOTFub1lEVG9wMk9ZRVFs?=
 =?utf-8?B?aEJocnRaQzdBY0svNWdaVTNGT1JMNjhUVWM2bk1KVzFoWmxpZldxWkNKa1lu?=
 =?utf-8?B?dFc5b0JYKzFqN3RPL3NlUDdUWXp0MFVJYkRWVG5qL3hWOGlnZ0E3a2kxSzU5?=
 =?utf-8?B?YzRoY2xMWkg1RzY5VktDc0V1YXJDM1A4bFFtdSsvUXZSQ2xFUFdtL2toWjZH?=
 =?utf-8?B?UFp2eW5CQ25pQjNFS3VKU2crZHlmeHYvcHEvTDBBdXUvS1o5MUgwd1lKenYy?=
 =?utf-8?B?dmFzMVBnRFhhdlNBYXkzYTJEWHJVQjgxak1UUjVGTE9QTVcrbWhFbzgvYkh4?=
 =?utf-8?B?bnYzM3QrVE8zQVNxZWpPMkdZNTlsNmVud3huYlZSU2txbjFLdXNFWER2bGFU?=
 =?utf-8?B?dlczNWRXLzNxQndjZmZWb1c5bHYzQllVTlRseE5LOUoyTyt5TWpBb2M3L0Vj?=
 =?utf-8?B?R0tlOWpSeHE0RWVOOWhWZGdGR1ozRXg4c3JPV1FvZHZJbVhsWFZoNENhTkZZ?=
 =?utf-8?B?aTZHT0xqOWUzeFVLMm9pK0ZELzhSMWx0ODFrOUw1MzZKNVp3QmU3YUZEOFJ5?=
 =?utf-8?B?RXB1Y2NUc3V1cU1mbGNRMnRKbXMwcm5jS0YvaW1lc2tzYlhLNnBCRERrbDNB?=
 =?utf-8?Q?CPtKAXkE6AYU8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20050c2e-aca3-47ff-9919-08d8961202a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 15:58:56.9721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Jz+0e3/+QoEDkRh1sRARwgIqPaPKiLK1YOFKc1rLOalmQ/dPJpUQAXUFh1pla6E75z/gpVQBKKt/OyXM6zQNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2872
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606838339; bh=6Ygu9k+EKjBwSg/3bh7MFTM5Tu86V4Wxdf4vcBkmC/4=;
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
        b=nNtt1t4xgNii5quH2yLcaK8jPCDrW48ApLAxIx+ijvuLX/87H6BcEUq82edIZdhlB
         cF/WJPZUECJKkf+bjFvHbXs4KHLDxvN5YL15f7kHz2ZRBbeWaWnC0d9owQOhUy1cwb
         v6Z7Z22yCRD6AHLTyuCk5MMOl+3bHGjniLNqvlztfP24WrcFur9uoAfx6HUMxyjXMF
         QzqWb6PulQj+X0A+cvEe5lHfZnBtE66IyJSKS+wH1zqMqnSpWpGUecKT3jyIseq6jC
         iHDGTSltmJpvbus4XEWd6afbIrXt67r6Fx2NS4uA/sv68jt9WbuovDNPZy24shamPQ
         ZP8qhvu/P21Qg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWW9uZ2ppIFhpZSA8eGlleW9uZ2ppQGJ5dGVkYW5jZS5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIERlY2VtYmVyIDEsIDIwMjAgNzo0OSBQTQ0KPiANCj4gT24gVHVlLCBEZWMgMSwg
MjAyMCBhdCA3OjMyIFBNIFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4gd3JvdGU6DQo+
ID4NCj4gPg0KPiA+DQo+ID4gPiBGcm9tOiBZb25namkgWGllIDx4aWV5b25namlAYnl0ZWRhbmNl
LmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDEsIDIwMjAgMzoyNiBQTQ0KPiA+
ID4NCj4gPiA+IE9uIFR1ZSwgRGVjIDEsIDIwMjAgYXQgMjoyNSBQTSBKYXNvbiBXYW5nIDxqYXNv
d2FuZ0ByZWRoYXQuY29tPg0KPiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gT24g
MjAyMC8xMS8zMCDkuIvljYgzOjA3LCBZb25namkgWGllIHdyb3RlOg0KPiA+ID4gPiA+Pj4gVGhh
bmtzIGZvciBhZGRpbmcgbWUsIEphc29uIQ0KPiA+ID4gPiA+Pj4NCj4gPiA+ID4gPj4+IE5vdyBJ
J20gd29ya2luZyBvbiBhIHYyIHBhdGNoc2V0IGZvciBWRFVTRSAodkRQQSBEZXZpY2UgaW4NCj4g
PiA+ID4gPj4+IFVzZXJzcGFjZSkgWzFdLiBUaGlzIHRvb2wgaXMgdmVyeSB1c2VmdWwgZm9yIHRo
ZSB2ZHVzZSBkZXZpY2UuDQo+ID4gPiA+ID4+PiBTbyBJJ20gY29uc2lkZXJpbmcgaW50ZWdyYXRp
bmcgdGhpcyBpbnRvIG15IHYyIHBhdGNoc2V0LiBCdXQNCj4gPiA+ID4gPj4+IHRoZXJlIGlzIG9u
ZSBwcm9ibGVt77yaDQo+ID4gPiA+ID4+Pg0KPiA+ID4gPiA+Pj4gSW4gdGhpcyB0b29sLCB2ZHBh
IGRldmljZSBjb25maWcgYWN0aW9uIGFuZCBlbmFibGUgYWN0aW9uIGFyZQ0KPiA+ID4gPiA+Pj4g
Y29tYmluZWQgaW50byBvbmUgbmV0bGluayBtc2c6IFZEUEFfQ01EX0RFVl9ORVcuIEJ1dCBpbg0K
PiB2ZHVzZQ0KPiA+ID4gPiA+Pj4gY2FzZSwgaXQgbmVlZHMgdG8gYmUgc3BsaXR0ZWQgYmVjYXVz
ZSBhIGNoYXJkZXYgc2hvdWxkIGJlDQo+ID4gPiA+ID4+PiBjcmVhdGVkIGFuZCBvcGVuZWQgYnkg
YSB1c2Vyc3BhY2UgcHJvY2VzcyBiZWZvcmUgd2UgZW5hYmxlIHRoZQ0KPiA+ID4gPiA+Pj4gdmRw
YSBkZXZpY2UgKGNhbGwgdmRwYV9yZWdpc3Rlcl9kZXZpY2UoKSkuDQo+ID4gPiA+ID4+Pg0KPiA+
ID4gPiA+Pj4gU28gSSdkIGxpa2UgdG8ga25vdyB3aGV0aGVyIGl0J3MgcG9zc2libGUgKG9yIGhh
dmUgc29tZSBwbGFucykNCj4gPiA+ID4gPj4+IHRvIGFkZCB0d28gbmV3IG5ldGxpbmsgbXNncyBz
b21ldGhpbmcgbGlrZToNCj4gPiA+ID4gPj4+IFZEUEFfQ01EX0RFVl9FTkFCTEUNCj4gPiA+IGFu
ZA0KPiA+ID4gPiA+Pj4gVkRQQV9DTURfREVWX0RJU0FCTEUgdG8gbWFrZSB0aGUgY29uZmlnIHBh
dGggbW9yZSBmbGV4aWJsZS4NCj4gPiA+ID4gPj4+DQo+ID4gPiA+ID4+IEFjdHVhbGx5LCB3ZSd2
ZSBkaXNjdXNzZWQgc3VjaCBpbnRlcm1lZGlhdGUgc3RlcCBpbiBzb21lIGVhcmx5DQo+ID4gPiA+
ID4+IGRpc2N1c3Npb24uIEl0IGxvb2tzIHRvIG1lIFZEVVNFIGNvdWxkIGJlIG9uZSBvZiB0aGUg
dXNlcnMgb2YgdGhpcy4NCj4gPiA+ID4gPj4NCj4gPiA+ID4gPj4gT3IgSSB3b25kZXIgd2hldGhl
ciB3ZSBjYW4gc3dpdGNoIHRvIHVzZSBhbm9ueW1vdXMgaW5vZGUoZmQpDQo+ID4gPiA+ID4+IGZv
ciBWRFVTRSB0aGVuIGZldGNoaW5nIGl0IHZpYSBhbiBWRFVTRV9HRVRfREVWSUNFX0ZEIGlvY3Rs
Pw0KPiA+ID4gPiA+Pg0KPiA+ID4gPiA+IFllcywgd2UgY2FuLiBBY3R1YWxseSB0aGUgY3VycmVu
dCBpbXBsZW1lbnRhdGlvbiBpbiBWRFVTRSBpcw0KPiA+ID4gPiA+IGxpa2UgdGhpcy4gIEJ1dCBz
ZWVtcyBsaWtlIHRoaXMgaXMgc3RpbGwgYSBpbnRlcm1lZGlhdGUgc3RlcC4NCj4gPiA+ID4gPiBU
aGUgZmQgc2hvdWxkIGJlIGJpbmRlZCB0byBhIG5hbWUgb3Igc29tZXRoaW5nIGVsc2Ugd2hpY2gg
bmVlZA0KPiA+ID4gPiA+IHRvIGJlIGNvbmZpZ3VyZWQgYmVmb3JlLg0KPiA+ID4gPg0KPiA+ID4g
Pg0KPiA+ID4gPiBUaGUgbmFtZSBjb3VsZCBiZSBzcGVjaWZpZWQgdmlhIHRoZSBuZXRsaW5rLiBJ
dCBsb29rcyB0byBtZSB0aGUNCj4gPiA+ID4gcmVhbCBpc3N1ZSBpcyB0aGF0IHVudGlsIHRoZSBk
ZXZpY2UgaXMgY29ubmVjdGVkIHdpdGggYSB1c2Vyc3BhY2UsDQo+ID4gPiA+IGl0IGNhbid0IGJl
IHVzZWQuIFNvIHdlIGFsc28gbmVlZCB0byBmYWlsIHRoZSBlbmFibGluZyBpZiBpdCBkb2Vzbid0
DQo+IG9wZW5lZC4NCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBZZXMsIHRoYXQncyB0cnVlLiBTbyB5
b3UgbWVhbiB3ZSBjYW4gZmlyc3RseSB0cnkgdG8gZmV0Y2ggdGhlIGZkDQo+ID4gPiBiaW5kZWQg
dG8gYSBuYW1lL3ZkdXNlX2lkIHZpYSBhbiBWRFVTRV9HRVRfREVWSUNFX0ZELCB0aGVuIHVzZSB0
aGUNCj4gPiA+IG5hbWUvdmR1c2VfaWQgYXMgYSBhdHRyaWJ1dGUgdG8gY3JlYXRlIHZkcGEgZGV2
aWNlPyBJdCBsb29rcyBmaW5lIHRvIG1lLg0KPiA+DQo+ID4gSSBwcm9iYWJseSBkbyBub3Qgd2Vs
bCB1bmRlcnN0YW5kLiBJIHRyaWVkIHJlYWRpbmcgcGF0Y2ggWzFdIGFuZCBmZXcgdGhpbmdzDQo+
IGRvIG5vdCBsb29rIGNvcnJlY3QgYXMgYmVsb3cuDQo+ID4gQ3JlYXRpbmcgdGhlIHZkcGEgZGV2
aWNlIG9uIHRoZSBidXMgZGV2aWNlIGFuZCBkZXN0cm95aW5nIHRoZSBkZXZpY2UgZnJvbQ0KPiB0
aGUgd29ya3F1ZXVlIHNlZW1zIHVubmVjZXNzYXJ5IGFuZCByYWN5Lg0KPiA+DQo+ID4gSXQgc2Vl
bXMgdmR1c2UgZHJpdmVyIG5lZWRzDQo+ID4gVGhpcyBpcyBzb21ldGhpbmcgc2hvdWxkIGJlIGRv
bmUgYXMgcGFydCBvZiB0aGUgdmRwYSBkZXYgYWRkIGNvbW1hbmQsDQo+IGluc3RlYWQgb2YgY29u
bmVjdGluZyB0d28gc2lkZXMgc2VwYXJhdGVseSBhbmQgZW5zdXJpbmcgcmFjZSBmcmVlIGFjY2Vz
cyB0bw0KPiBpdC4NCj4gPg0KPiA+IFNvIFZEVVNFX0RFVl9TVEFSVCBhbmQgVkRVU0VfREVWX1NU
T1Agc2hvdWxkIHBvc3NpYmx5IGJlIGF2b2lkZWQuDQo+ID4NCj4gDQo+IFllcywgd2UgY2FuIGF2
b2lkIHRoZXNlIHR3byBpb2N0bHMgd2l0aCB0aGUgaGVscCBvZiB0aGUgbWFuYWdlbWVudCB0b29s
Lg0KPiANCj4gPiAkIHZkcGEgZGV2IGFkZCBwYXJlbnRkZXYgdmR1c2VfbWdtdGRldiB0eXBlIG5l
dCBuYW1lIGZvbzINCj4gPg0KPiA+IFdoZW4gYWJvdmUgY29tbWFuZCBpcyBleGVjdXRlZCBpdCBj
cmVhdGVzIG5lY2Vzc2FyeSB2ZHBhIGRldmljZSBmb28yDQo+IG9uIHRoZSBidXMuDQo+ID4gV2hl
biB1c2VyIGJpbmRzIGZvbzIgZGV2aWNlIHdpdGggdGhlIHZkdXNlIGRyaXZlciwgaW4gdGhlIHBy
b2JlKCksIGl0DQo+IGNyZWF0ZXMgcmVzcGVjdGl2ZSBjaGFyIGRldmljZSB0byBhY2Nlc3MgaXQg
ZnJvbSB1c2VyIHNwYWNlLg0KPg0KSSBzZWUuIFNvIHZkdXNlIGNhbm5vdCB3b3JrIHdpdGggYW55
IGV4aXN0aW5nIHZkcGEgZGV2aWNlcyBsaWtlIGlmYywgbWx4NSBvciBuZXRkZXZzaW0uDQpJdCBo
YXMgaXRzIG93biBpbXBsZW1lbnRhdGlvbiBzaW1pbGFyIHRvIGZ1c2Ugd2l0aCBpdHMgb3duIGJh
Y2tlbmQgb2YgY2hvaWNlLg0KTW9yZSBiZWxvdy4NCg0KPiBCdXQgdmR1c2UgZHJpdmVyIGlzIG5v
dCBhIHZkcGEgYnVzIGRyaXZlci4gSXQgd29ya3MgbGlrZSB2ZHBhc2ltIGRyaXZlciwgYnV0DQo+
IG9mZmxvYWRzIHRoZSBkYXRhIHBsYW5lIGFuZCBjb250cm9sIHBsYW5lIHRvIGEgdXNlciBzcGFj
ZSBwcm9jZXNzLg0KDQpJbiB0aGF0IGNhc2UgdG8gZHJhdyBwYXJhbGxlbCBsaW5lcywNCg0KMS4g
bmV0ZGV2c2ltOg0KKGEpIGNyZWF0ZSByZXNvdXJjZXMgaW4ga2VybmVsIHN3DQooYikgZGF0YXBh
dGggc2ltdWxhdGVzIGluIGtlcm5lbA0KDQoyLiBpZmMgKyBtbHg1IHZkcGEgZGV2Og0KKGEpIGNy
ZWF0ZXMgcmVzb3VyY2UgaW4gaHcNCihiKSBkYXRhIHBhdGggaXMgaW4gaHcNCg0KMy4gdmR1c2U6
DQooYSkgY3JlYXRlcyByZXNvdXJjZXMgaW4gdXNlcnNwYWNlIHN3DQooYikgZGF0YSBwYXRoIGlz
IGluIHVzZXIgc3BhY2UuDQpoZW5jZSBjcmVhdGVzIGRhdGEgcGF0aCByZXNvdXJjZXMgZm9yIHVz
ZXIgc3BhY2UuDQpTbyBjaGFyIGRldmljZSBpcyBjcmVhdGVkLCByZW1vdmVkIGFzIHJlc3VsdCBv
ZiB2ZHBhIGRldmljZSBjcmVhdGlvbi4NCg0KRm9yIGV4YW1wbGUsDQokIHZkcGEgZGV2IGFkZCBw
YXJlbnRkZXYgdmR1c2VfbWdtdGRldiB0eXBlIG5ldCBuYW1lIGZvbzINCg0KQWJvdmUgY29tbWFu
ZCB3aWxsIGNyZWF0ZSBjaGFyIGRldmljZSBmb3IgdXNlciBzcGFjZS4NCg0KU2ltaWxhciBjb21t
YW5kIGZvciBpZmMvbWx4NSB3b3VsZCBoYXZlIGNyZWF0ZWQgc2ltaWxhciBjaGFubmVsIGZvciBy
ZXN0IG9mIHRoZSBjb25maWcgY29tbWFuZHMgaW4gaHcuDQp2ZHVzZSBjaGFubmVsID0gY2hhciBk
ZXZpY2UsIGV2ZW50ZmQgZXRjLg0KaWZjL21seDUgaHcgY2hhbm5lbCA9IGJhciwgaXJxLCBjb21t
YW5kIGludGVyZmFjZSBldGMNCk5ldGRldiBzaW0gY2hhbm5lbCA9IHN3IGRpcmVjdCBjYWxscw0K
DQpEb2VzIGl0IG1ha2Ugc2Vuc2U/DQo=
