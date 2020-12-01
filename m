Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08CC2CA170
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 12:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgLALdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:33:24 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:18061 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbgLALdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 06:33:23 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc629d80003>; Tue, 01 Dec 2020 19:32:40 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 11:32:40 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 1 Dec 2020 11:32:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqABHpvu2Rq1k+LGMMCRJl3TwFfqTvF614pFYx/cD5RhUHY5vMfFFFrR8VXsNkkK8Nr9A3XXPnRq1w9HhGqO4Tj+1pKE+Acqes9DnyX4JHKL4O4hzktofLq0PVXUHwPHtFvcAbrpSmBGYuF+GX0NhNLmuHpfG3ztkJ0o9kOOJPbLm7zvg9TLZOls0TCTTIUJdKcZzmMnRu7vV0Q0io/WjWTvJ9NEr+h33yQ/Scf0d+Z8KTCsFKl/S9CR1xrWFXmtclEyHNCBvHYPP3jXymHinhqSb4zi0mhksb8ESkXDhXaa4lWe7SfoA4QnqTVN4QqdPu9AGSKvQhcVnrFENw7lVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBFCOJcyaUs1bFom9zGLNas35M6HaZwdA1kF84oQ2ZM=;
 b=hbjEuRvA9iTM+AhLcxnT4hHG+MlqvqJQ4MWuQcnmj0uS95askB2IO0ZqO/jhGvvhw/12ErUpdu+UhKjrk+GvIKXHf2Z/NV9IZkyw6tvpqR/pXyziWRTbGp9yIcPMlV8JYoZmo0bXywrEuqcFl9AI+kqrwQqj0Tlnu+83giWCZV2pWrlpeiQJ0k/lE7yKNu8kwcFeKzM2bdkNWmJWUi7pPUuJslPTDQQOjsksKr1QsgUaYzQaGBmKtGmIna7lpKuzBK9ND1ytba7rQXoF6ISit7Y6L/5fdTmOrVrbAJhNgmTN0o8sQXSq17g57CkWrOMuHc1eXGgzt9c0qxUxF6KIjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4330.namprd12.prod.outlook.com (2603:10b6:5:21d::20)
 by DM5PR1201MB0236.namprd12.prod.outlook.com (2603:10b6:4:57::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Tue, 1 Dec
 2020 11:32:37 +0000
Received: from DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::f811:79fe:8617:5622]) by DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::f811:79fe:8617:5622%9]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 11:32:37 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yongji Xie <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Topic: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Index: AQHWuL6/zQf/qaV5ZkSpuhr8mZ5CmKnbcCaAgAAhUQCABJD4AIAAOuMAgAGGmoCAADrXgIAAFskg
Date:   Tue, 1 Dec 2020 11:32:37 +0000
Message-ID: <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com>
 <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com>
 <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
In-Reply-To: <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc8d0066-23a5-4edf-72fc-08d895ecce3f
x-ms-traffictypediagnostic: DM5PR1201MB0236:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB023612172F5DCAEB36F55171DCF40@DM5PR1201MB0236.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YiWwO/ydEtiFS8Fof4nFf1pcT7ix+20vmRFSoh1123oKXKrUkXONPFlejoxlsx5Dx8wYpflzuMujJxrKZo8Ex+M7QM7+3tnYMza12gSfo7wZ5Dio7TZ9Lo5Sn21TfysLQmoc+Kd3GHmnG0VHa2a/JjkYKTnUxHhl+U6e4M5gjLzaB5V2ZqtQUD4tFmONzeLSozDt6XcUzqYAOV2gueEz8lvyhTfrQFV0/tKGMTMhsPqChdpZcr+TLESvWq2Ru2WkBlryp0ZDLPibaGP0uOHS5x3IwvLbixIqRghN2ETHthN3X/PvVYegnbwdjR5jvvUhRhm7+WEaR/T0TR4cNNX9HbrR39eu83JBP7RJUjq/GjgV2heB/kiLNa87qrwevv/WwTRffQ+lFe61CgAUbF4HUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(55016002)(83380400001)(5660300002)(110136005)(54906003)(71200400001)(53546011)(9686003)(316002)(6506007)(55236004)(966005)(66476007)(66946007)(66446008)(66556008)(64756008)(478600001)(8936002)(8676002)(86362001)(76116006)(186003)(33656002)(26005)(7696005)(52536014)(4326008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z2tqSHEzR2E0TG9qQ1h6Z3Z6YTN4WURKVEMwVVZHdDVabW93NHRTM1FseGp2?=
 =?utf-8?B?WWtxT2FTTmlLc2FlT0I0YlE3eGR1Y0RpSVFxaDZlOEl2bmZEKys2SC85dGhI?=
 =?utf-8?B?dkJuWUk1MUxXK3ZKUEw1SkhCWVFVYlNtdlhiN0lmWEJZVThvSUhyazUzbFJu?=
 =?utf-8?B?dkI2SHFCWkF4YlhhNjVSNGQweDJPNlFzbTBGTDl0ZzFtcEJpOGo2ekhKV1Ay?=
 =?utf-8?B?S0loTzJXcS9OSE0reGtsYU92TUVVZ2FyTm5EWlEwTmx6N1dzQmRLWWNPcHdZ?=
 =?utf-8?B?REFSRFdneU5SYzJwSWlRTDZDYUVFS2tpMmtORXlSb3dhYmVoUS9zN01KNzdw?=
 =?utf-8?B?K3hpRzRCcU1jSksyV2pZUTFqOHEzN0dRTDFBWkFpSVR4K2QrYzd6ekhEKzlH?=
 =?utf-8?B?emVxMWJQcllCT0lrUno4YlM3dHFoSGwzY1ByNjJma3FIeFYvWC83WU9EODNt?=
 =?utf-8?B?SThOSHVpK29KT0JNbENiNDNnTGRVTmtGazZLSmpuU0VqZElGU09tTGVoUXJx?=
 =?utf-8?B?QmdPYWhMcThLNjVYbk5oMy9DQzQzcktJamg2K2V3SnphT2xOOFowaXZKVW1H?=
 =?utf-8?B?OFJXQ1gvbzAxMTdkdm9QK2V2UDZpTlBuL2VyaFdYSWRQRWkwT0FTd04vVFND?=
 =?utf-8?B?cTFtd3dSdzZiN0MwVytpQVBmd1NjVFNtcDI4VUkyWmpRd2lZZ3JkK1RMQmN2?=
 =?utf-8?B?NzFWSEN2QWdsa3NoY1p4WUZ3Ykw5cDR4Ulh2azFMcHNpbkpnS252dzlhakVF?=
 =?utf-8?B?NGZmU0JEVVpZekh6RS9jK0ZqSTJTUG5iWWZ5QTZTbVRtVWdQSmYrbHRrbnBZ?=
 =?utf-8?B?N2duM0pudVpsNUhnbjgwK1VERzVxbWplQm00WlMxNE1KN2FSM3RlOW1mSlFI?=
 =?utf-8?B?Yk4wcVNpNC9LNnZTVTB6MVo1N1RxNjdxbDgxeE82b25nbGk1a0FUbkJCWHRE?=
 =?utf-8?B?ekRTbkNvK0QweGV3QVNGVzJJNFJTbWZyMHB0Z2ZPTGR1MWNpOTZPemtsNVRj?=
 =?utf-8?B?YkVOWm1YSmRuVm9Uc01WOFBHcU9KZi8zaDM0Ui9qYXo4ak5JdkJlVWF5RC9O?=
 =?utf-8?B?QzFFdGVkaHBOV21CRjl3RlNrZVBmMnBNU21TOFVmNGdTQi9OYStldndQTjJx?=
 =?utf-8?B?MFFxYk40STE4UVZUdVpFMWs2bXdUQ0ttMFgxYXRtSE9KdVpSWlBRTmlMbXI3?=
 =?utf-8?B?ZGNNVWVGVHpHNEcxaHZrQlJsY3NkeVVITDMwb0hSQ0tJWC93N0pzblpobzM0?=
 =?utf-8?B?WHBMRnV3RlU2SVZocDI4azR3bmZGUFJJSklYSHVZNE9qYkF3bE9VRTEzc2pl?=
 =?utf-8?Q?LFQmydOTtYEDk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8d0066-23a5-4edf-72fc-08d895ecce3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 11:32:37.6387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i70RUFHRNo5n/46Z8byJP+p4G18sWHa1gxVChP9Mzgl499P749WNvXwHlOTqWkT3UBqfXLAtN6YEUUOEypoFyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0236
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606822360; bh=YBFCOJcyaUs1bFom9zGLNas35M6HaZwdA1kF84oQ2ZM=;
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
        b=MYWERwD8zClVA7KAgsZ3HYgQMJhv+DJhGVFrKAjaJPB/G/NkP5jVKt2jp8k1Op9V7
         EK1VnFhE5Aca7aniQFx0xV++62wrazF+q+a8yYVVAE9xHJvuQJtsss62Iwk+5dBPmE
         K5NzDEuXSTtmqZHPRUyskSP4+dL3xIbpQzViEPQJ+LoKoXvx92ZW7NWj+A1IRWuDB2
         HfTimIKJo9xH6QypL3atVgElFmYxXyJOCCF2aAHDiiaI/NwfESwozQ+KFRQS1EKOkt
         IGt2AABekwUQg5DG38dLqH9Ees6ZoZqz53KZbvLMvpmlPjTVqeXCI+ivd9nJ4XUw2c
         JeMdEKTO75fOw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWW9uZ2ppIFhpZSA8eGlleW9uZ2ppQGJ5dGVkYW5jZS5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIERlY2VtYmVyIDEsIDIwMjAgMzoyNiBQTQ0KPiANCj4gT24gVHVlLCBEZWMgMSwg
MjAyMCBhdCAyOjI1IFBNIEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+IHdyb3RlOg0K
PiA+DQo+ID4NCj4gPiBPbiAyMDIwLzExLzMwIOS4i+WNiDM6MDcsIFlvbmdqaSBYaWUgd3JvdGU6
DQo+ID4gPj4+IFRoYW5rcyBmb3IgYWRkaW5nIG1lLCBKYXNvbiENCj4gPiA+Pj4NCj4gPiA+Pj4g
Tm93IEknbSB3b3JraW5nIG9uIGEgdjIgcGF0Y2hzZXQgZm9yIFZEVVNFICh2RFBBIERldmljZSBp
bg0KPiA+ID4+PiBVc2Vyc3BhY2UpIFsxXS4gVGhpcyB0b29sIGlzIHZlcnkgdXNlZnVsIGZvciB0
aGUgdmR1c2UgZGV2aWNlLiBTbw0KPiA+ID4+PiBJJ20gY29uc2lkZXJpbmcgaW50ZWdyYXRpbmcg
dGhpcyBpbnRvIG15IHYyIHBhdGNoc2V0LiBCdXQgdGhlcmUgaXMNCj4gPiA+Pj4gb25lIHByb2Js
ZW3vvJoNCj4gPiA+Pj4NCj4gPiA+Pj4gSW4gdGhpcyB0b29sLCB2ZHBhIGRldmljZSBjb25maWcg
YWN0aW9uIGFuZCBlbmFibGUgYWN0aW9uIGFyZQ0KPiA+ID4+PiBjb21iaW5lZCBpbnRvIG9uZSBu
ZXRsaW5rIG1zZzogVkRQQV9DTURfREVWX05FVy4gQnV0IGluIHZkdXNlDQo+ID4gPj4+IGNhc2Us
IGl0IG5lZWRzIHRvIGJlIHNwbGl0dGVkIGJlY2F1c2UgYSBjaGFyZGV2IHNob3VsZCBiZSBjcmVh
dGVkDQo+ID4gPj4+IGFuZCBvcGVuZWQgYnkgYSB1c2Vyc3BhY2UgcHJvY2VzcyBiZWZvcmUgd2Ug
ZW5hYmxlIHRoZSB2ZHBhIGRldmljZQ0KPiA+ID4+PiAoY2FsbCB2ZHBhX3JlZ2lzdGVyX2Rldmlj
ZSgpKS4NCj4gPiA+Pj4NCj4gPiA+Pj4gU28gSSdkIGxpa2UgdG8ga25vdyB3aGV0aGVyIGl0J3Mg
cG9zc2libGUgKG9yIGhhdmUgc29tZSBwbGFucykgdG8NCj4gPiA+Pj4gYWRkIHR3byBuZXcgbmV0
bGluayBtc2dzIHNvbWV0aGluZyBsaWtlOiBWRFBBX0NNRF9ERVZfRU5BQkxFDQo+IGFuZA0KPiA+
ID4+PiBWRFBBX0NNRF9ERVZfRElTQUJMRSB0byBtYWtlIHRoZSBjb25maWcgcGF0aCBtb3JlIGZs
ZXhpYmxlLg0KPiA+ID4+Pg0KPiA+ID4+IEFjdHVhbGx5LCB3ZSd2ZSBkaXNjdXNzZWQgc3VjaCBp
bnRlcm1lZGlhdGUgc3RlcCBpbiBzb21lIGVhcmx5DQo+ID4gPj4gZGlzY3Vzc2lvbi4gSXQgbG9v
a3MgdG8gbWUgVkRVU0UgY291bGQgYmUgb25lIG9mIHRoZSB1c2VycyBvZiB0aGlzLg0KPiA+ID4+
DQo+ID4gPj4gT3IgSSB3b25kZXIgd2hldGhlciB3ZSBjYW4gc3dpdGNoIHRvIHVzZSBhbm9ueW1v
dXMgaW5vZGUoZmQpIGZvcg0KPiA+ID4+IFZEVVNFIHRoZW4gZmV0Y2hpbmcgaXQgdmlhIGFuIFZE
VVNFX0dFVF9ERVZJQ0VfRkQgaW9jdGw/DQo+ID4gPj4NCj4gPiA+IFllcywgd2UgY2FuLiBBY3R1
YWxseSB0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBpbiBWRFVTRSBpcyBsaWtlDQo+ID4gPiB0
aGlzLiAgQnV0IHNlZW1zIGxpa2UgdGhpcyBpcyBzdGlsbCBhIGludGVybWVkaWF0ZSBzdGVwLiBU
aGUgZmQNCj4gPiA+IHNob3VsZCBiZSBiaW5kZWQgdG8gYSBuYW1lIG9yIHNvbWV0aGluZyBlbHNl
IHdoaWNoIG5lZWQgdG8gYmUNCj4gPiA+IGNvbmZpZ3VyZWQgYmVmb3JlLg0KPiA+DQo+ID4NCj4g
PiBUaGUgbmFtZSBjb3VsZCBiZSBzcGVjaWZpZWQgdmlhIHRoZSBuZXRsaW5rLiBJdCBsb29rcyB0
byBtZSB0aGUgcmVhbA0KPiA+IGlzc3VlIGlzIHRoYXQgdW50aWwgdGhlIGRldmljZSBpcyBjb25u
ZWN0ZWQgd2l0aCBhIHVzZXJzcGFjZSwgaXQgY2FuJ3QNCj4gPiBiZSB1c2VkLiBTbyB3ZSBhbHNv
IG5lZWQgdG8gZmFpbCB0aGUgZW5hYmxpbmcgaWYgaXQgZG9lc24ndCBvcGVuZWQuDQo+ID4NCj4g
DQo+IFllcywgdGhhdCdzIHRydWUuIFNvIHlvdSBtZWFuIHdlIGNhbiBmaXJzdGx5IHRyeSB0byBm
ZXRjaCB0aGUgZmQgYmluZGVkIHRvIGENCj4gbmFtZS92ZHVzZV9pZCB2aWEgYW4gVkRVU0VfR0VU
X0RFVklDRV9GRCwgdGhlbiB1c2UgdGhlDQo+IG5hbWUvdmR1c2VfaWQgYXMgYSBhdHRyaWJ1dGUg
dG8gY3JlYXRlIHZkcGEgZGV2aWNlPyBJdCBsb29rcyBmaW5lIHRvIG1lLg0KDQpJIHByb2JhYmx5
IGRvIG5vdCB3ZWxsIHVuZGVyc3RhbmQuIEkgdHJpZWQgcmVhZGluZyBwYXRjaCBbMV0gYW5kIGZl
dyB0aGluZ3MgZG8gbm90IGxvb2sgY29ycmVjdCBhcyBiZWxvdy4NCkNyZWF0aW5nIHRoZSB2ZHBh
IGRldmljZSBvbiB0aGUgYnVzIGRldmljZSBhbmQgZGVzdHJveWluZyB0aGUgZGV2aWNlIGZyb20g
dGhlIHdvcmtxdWV1ZSBzZWVtcyB1bm5lY2Vzc2FyeSBhbmQgcmFjeS4NCg0KSXQgc2VlbXMgdmR1
c2UgZHJpdmVyIG5lZWRzIA0KVGhpcyBpcyBzb21ldGhpbmcgc2hvdWxkIGJlIGRvbmUgYXMgcGFy
dCBvZiB0aGUgdmRwYSBkZXYgYWRkIGNvbW1hbmQsIGluc3RlYWQgb2YgY29ubmVjdGluZyB0d28g
c2lkZXMgc2VwYXJhdGVseSBhbmQgZW5zdXJpbmcgcmFjZSBmcmVlIGFjY2VzcyB0byBpdC4NCg0K
U28gVkRVU0VfREVWX1NUQVJUIGFuZCBWRFVTRV9ERVZfU1RPUCBzaG91bGQgcG9zc2libHkgYmUg
YXZvaWRlZC4NCg0KJCB2ZHBhIGRldiBhZGQgcGFyZW50ZGV2IHZkdXNlX21nbXRkZXYgdHlwZSBu
ZXQgbmFtZSBmb28yDQoNCldoZW4gYWJvdmUgY29tbWFuZCBpcyBleGVjdXRlZCBpdCBjcmVhdGVz
IG5lY2Vzc2FyeSB2ZHBhIGRldmljZSBmb28yIG9uIHRoZSBidXMuDQpXaGVuIHVzZXIgYmluZHMg
Zm9vMiBkZXZpY2Ugd2l0aCB0aGUgdmR1c2UgZHJpdmVyLCBpbiB0aGUgcHJvYmUoKSwgaXQgY3Jl
YXRlcyByZXNwZWN0aXZlIGNoYXIgZGV2aWNlIHRvIGFjY2VzcyBpdCBmcm9tIHVzZXIgc3BhY2Uu
DQpEZXBlbmRpbmcgb24gd2hpY2ggZHJpdmVyIGZvbzIgZGV2aWNlIGlzIGJvdW5kIGl0LCBpdCBj
YW4gYmUgdXNlZCwgZWl0aGVyIHZpYSAoYSkgZXhpc3Rpbmcgdmhvc3Qgc3RhY2sgIG9yIChiKSBz
b21lIHZkcGEgTmV0ZGV2IGRyaXZlcj8gKG5vdCBzdXJlIGl0cyBjdXJyZW50IHN0YXRlKSwgb3Ig
KGMpIHZkdXNlIHVzZXIgc3BhY2UuDQoNClRoaXMgd2lsbCBoYXZlIHNhbmUgbW9kZWwgdG8gbWUg
d2l0aG91dCByYWNlcyB1bmxlc3MgSSBhbSBtaXNzaW5nIHNvbWV0aGluZyBmdW5kYW1lbnRhbCBo
ZXJlLg0KVGhpcyB3YXkgdGhlcmUgYXJlIG5vdCB0d28gd2F5cyB0byBjcmVhdGUgdmRwYSBkZXZp
Y2VzIGZyb20gdXNlciBzcGFjZS4NCkNvbnN1bWVycyBjYW4gYmUgb2YgZGlmZmVyZW50IHR5cGVz
ICh2aG9zdCwgdmR1c2UgZXRjKSBvZiB0aGUgYnVzIGRldmljZSBhcyBhYm92ZSBtZW50aW9uZWQu
DQoNClsxXSBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC1tbS9tc2cyMzE1ODEu
aHRtbA0KDQo=
