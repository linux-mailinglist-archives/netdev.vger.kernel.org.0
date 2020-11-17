Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CD22B6EEE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgKQTlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:41:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2830 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgKQTlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:41:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb4274e0001>; Tue, 17 Nov 2020 11:41:02 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 19:41:11 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 17 Nov 2020 19:41:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5JLNGKBMG45L9zkB+IUi/wL/KtMweGcoDMg0qCh7DuTreZBsAb+/4lPtxgwVMmSvLnybAERsQNTjdhB+ibg8SkJ0uPpZ9+aAGGr1XqxypkgANK4VanuKlbohKgtXhht9irT/wIPc5nbZe+FGFqCHlPfGIm4s4NS4Dcp5+MOFadl6wh8GBS4Vc1h3gMecdAcdfG8QOqy1vtIf2pqwWMQNQ9sxw2p2yhj4J6fCUAKazyBKXpyGt91E8YD21Md8tRW1uqP1ka/+bJqQCE9JE6UeCacMOaUbnzJdk8+AbVOH8GnvMlP9ZoeLv1YYQS9H0giVbKUnUOxLmG6xHuphSmIEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRXDLlU836JL6Wst/iRa1qpVIa67RLiFh03xVO0oeuk=;
 b=TMmqhvJ0Ydo5uk4S1pFJf0ARBpgqM/TvpZdsy9tL3fLnyB+4awlhOHmANjSLT0OkDgJhM1gWVC3WNxscx7VIyD/n9ytolg1h0904hoD02exhXCok6kaXIauDgr/YyXtWego2SRD4h9xb4H6bykbyYOJEKmEz3B/rWkkKoE5uSEeNHOwWpG//MiCNFFhxe41l2pNF9tliUjqsjwunGmCpVF5dWas+vQ9l/+XJP2jjPQoavvrPgz44sm9MVgCS99fcbzG5YX+E9V8OX92+CEd9gCXzB5Vpzct2vr7hz3uOXCpVLIlTEUQxYGVOw/67MKmJutw02YsVZzxOmgVBR8INsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4917.namprd12.prod.outlook.com (2603:10b6:a03:1d1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Tue, 17 Nov
 2020 19:41:10 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53%7]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 19:41:10 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: [PATCH 0/7] Introduce vdpa management tool
Thread-Topic: [PATCH 0/7] Introduce vdpa management tool
Thread-Index: AQHWuL6/zQf/qaV5ZkSpuhr8mZ5CmKnKh76AgAI1YkA=
Date:   Tue, 17 Nov 2020 19:41:09 +0000
Message-ID: <BY5PR12MB4322C2DC5E9C8250CE2EBEFEDCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <CAJSP0QXN2VGgKwQ_qL3Fr0dAYDviZcFDgUrE8FhHZwBm9wpBoQ@mail.gmail.com>
In-Reply-To: <CAJSP0QXN2VGgKwQ_qL3Fr0dAYDviZcFDgUrE8FhHZwBm9wpBoQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a24b1d1-57b7-4591-a818-08d88b30bbfc
x-ms-traffictypediagnostic: BY5PR12MB4917:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB49177234CBED15780679EC8EDCE20@BY5PR12MB4917.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CQTjYFUa2f+W5jaCmvfAdxBNPz7CVm/czED8XS5amHeFQCr3gSZjj10vsnjTO1mOIrfCb3NG9ZoRlGg5n7NF207VyGna9ruTj6i9Tcgk8vajKb81c3bkwbgD0KkInGSb/MUIccqmDxsjrht7L5ZM39V7Q3jQtroh6U4jWxtE423oXxRo3+uaQ4h22E5r+ivw8gqkpcihwT95fUe5B/Gk3U82Flp5fIjoiQCWeu6dNmaZ4eLf5qVbUVwSyQWu/WynwNPRS6qhNZhTRQoIPKO52oLGhpsqpkrAVj+nwNkO5TTV6JENuG/FJxfagfSVJDXJ7lLE6+A5MmzYufrQE7I3UQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(8676002)(33656002)(4326008)(54906003)(5660300002)(316002)(52536014)(8936002)(86362001)(66446008)(478600001)(64756008)(71200400001)(55236004)(186003)(6916009)(66476007)(76116006)(7696005)(66946007)(66556008)(6506007)(55016002)(26005)(2906002)(9686003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: piRcIhYcXgHRMDhEojQJIJOcm3KzVzcnIrU18b0bEvmzfZnAfu0YiZoLyPJwWZuozXJKrU8aLycBoWceo67t89S4Nh6EK2rBoJFKTPFJ8/PgunmBJ5qUL3XN510E50LCCm384HdMCYpDm2YXibJRywlgfgEA087R/wHDIvxZlHyS0VndVZ+QGzdsnOR00M3nmV9B5OZQqAYBPF3/sQeUxrhop3eXMb0Q2jP58pNurMWWWDBLVXeS2JKIGktkyyxb8duMy5jSbFDOjhP6tqI9qnaPEKZirk7poLxay3zWc4pDcdpAs0zA+vy0evuDo9xUyTgbrnyb8dow/ovsHQzu8PKnrNQFuGE9qftaygf8lTOOgIeJnvLZg1e2lnR3kqBnBVzn1+YrKAMBJitaOGCR416BJA0PXtsoFeX9a01WcIyAcBfE45tXdRsow6Bc8PU7v/Luo4eguhyZK00cA9TGZvqWsZYgcRKNyrqJK8fJs3Ka6mjxM3eKYJKHsctlO8K23v07p1vi4DmhIgyS+expHu7hg2qWWVwtmLZhJ7PyxvnetjRub/flM/OkfBK2xyp/P0xFr7RgGco0wLarIjiqYzwsfDKQ7W+FT4f/F/zhoXCbHS78SEAiPkT4cd5SFzB0T2YTOsm83mR+4Bvq4eP5vA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a24b1d1-57b7-4591-a818-08d88b30bbfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 19:41:10.0189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yyy/NJX29tco6McAJadytVrIaYM7D57c1lwAiXSKh57hRirXBIqDwzrr5I1pvZ3D4bzZd47itmTZEE2zc+QZ4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4917
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605642062; bh=JRXDLlU836JL6Wst/iRa1qpVIa67RLiFh03xVO0oeuk=;
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
        b=M5mJlTNUPeTRGOMgwfRD0qQbi2akyYIgY1Pv8nYii5+rlggf+U3VUC82Togm6kNpi
         6L4YmrEoPt3JExWRU6J5GpW0usI+O5dMRppDs0TSrjq6j62O3xt5PPog8GUs8beAvf
         /kX0QvMLyhfgPuKNBhClwN2aMmG8mM1j0snagWvo4dj6yJrdjv9SdFiLvftKcDx786
         4xpNUaVpwwblkbC1my84NbyORrYyAR1AwAmr7wRtRMpHG2loIFXPTmyeg2EXM7Vo3i
         4a1p5/aTTZns3phdY70j2+lGOxLSh3pm+X7hqsQWt86XghxaWrh8uXHV86T6tU6nid
         0FllDfQ8CA5qw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUBnbWFpbC5jb20+DQo+IFNlbnQ6
IE1vbmRheSwgTm92ZW1iZXIgMTYsIDIwMjAgMzoxMSBQTQ0KPiBHcmVhdCEgQSBmZXcgcXVlc3Rp
b25zIGFuZCBjb21tZW50czoNCj4gDQo+IEhvdyBhcmUgY29uZmlndXJhdGlvbiBwYXJhbWV0ZXJz
IHBhc3NlZCBpbiBkdXJpbmcgZGV2aWNlIGNyZWF0aW9uIChlLmcuDQo+IE1BQyBhZGRyZXNzLCBu
dW1iZXIgb2YgcXVldWVzKT8NCkR1cmluZyBkZXZpY2UgY3JlYXRpb24gdGltZSBtb3JlIHBhcmFt
ZXRlcnMgdG8gYmUgYWRkZWQuDQo+IA0KPiBDYW4gY29uZmlndXJhdGlvbiBwYXJhbWV0ZXJzIGJl
IGNoYW5nZWQgYXQgcnVudGltZSAoZS5nLiBsaW5rIHVwL2Rvd24pPw0KPiANCkZvciByZXByZXNl
bnRvciBlc3dpdGNoIGJhc2VkIGRldmljZXMsIGl0IGlzIHVzdWFsbHkgY29udHJvbGxlZCB0aHJv
dWdoIGl0Lg0KRm9yIG90aGVycywgSSBoYXZlbid0IHRob3VnaHQgYWJvdXQgaXQuIElmIHRoZSBk
ZXZpY2Ugc3VwcG9ydHMgaXQsIEkgYmVsaWV2ZSBzby4NCklmIG11bHRpcGxlIHZwZGEgZGV2aWNl
cyBhcmUgY3JlYXRlZCBvdmVyIHNpbmdsZSBWRi9QRi9TRiwgdmlydHVhbGl6aW5nIHRoZSBsaW5r
IGZvciB1cC9kb3duIChub3QganVzdCBjaGFuZ2luZyB0aGUgdmRwYSBjb25maWcgYml0cykgY2Fu
IGJlIGEgY2hhbGxlbmdlLg0KDQo+IERvZXMgdGhlIGNvbmZpZ3VyYXRpb24gcGFyYW1ldGVyIGlu
dGVyZmFjZSBkaXN0aW5ndWlzaCBiZXR3ZWVuIHN0YW5kYXJkDQo+IGFuZCB2ZW5kb3Itc3BlY2lm
aWMgcGFyYW1ldGVycz8gQXJlIHRoZXkgbmFtZXNwYWNlZCB0byBwcmV2ZW50IG5hbWluZw0KPiBj
b2xsaXNpb25zPw0KRG8geW91IGhhdmUgYW4gZXhhbXBsZSBvZiB2ZW5kb3Igc3BlY2lmaWMgcGFy
YW1ldGVycz8NClNpbmNlIHRoaXMgdG9vbCBleHBvc2VzIHZpcnRpbyBjb21wbGlhbnQgdmRwYSBk
ZXZpY2VzLCBJIGRpZG4ndCBjb25zaWRlciBhbnkgdmVuZG9yIHNwZWNpZmljIHBhcmFtcy4NCg0K
PiANCj4gSG93IGFyZSBzb2Z0d2FyZS1vbmx5IHBhcmVudCBkcml2ZXJzIHN1cHBvcnRlZD8gSXQn
cyBraW5kIG9mIGEgc2hhbWUgdG8NCj4gbW9kcHJvYmUgdW5jb25kaXRpb25hbGx5IGlmIHRoZXkg
d29uJ3QgYmUgdXNlZC4gRG9lcyB2ZHBhdG9vbCBoYXZlIHNvbWUNCj4gd2F5IG9mIHJlcXVlc3Rp
bmcgbG9hZGluZyBhIHBhcmVudCBkcml2ZXI/IFRoYXQgd2F5IHNvZnR3YXJlIGRyaXZlcnMgY2Fu
IGJlDQo+IGxvYWRlZCBvbiBkZW1hbmQuDQpXZWxsLCBzaW5jZSBlYWNoIHBhcmVudCBvciBtYW5h
Z2VtZW50IGRldmljZSByZWdpc3RlcnMgZm9yIGl0LCBhbmQgdGhlaXIgdHlwZSBpcyBzYW1lLCB0
aGVyZSBpc24ndCBhIHdheSByaWdodCBub3QgdG8gYXV0byBsb2FkIHRoZSBtb2R1bGUuDQpUaGlz
IHdpbGwgcmVxdWlyZSB1c2VyIHRvIGxlYXJuIHdoYXQgdHlwZSBvZiB2ZW5kb3IgZGV2aWNlIGRy
aXZlciB0byBiZSBsb2FkZWQsIHdoaWNoIGtpbmRzIG9mIGRlZmVhdHMgdGhlIHB1cnBvc2UuDQoN
Cj4gDQo+IFdoYXQgaXMgdGhlIGJlbmVmaXQgb2YgbWFraW5nIGl0IHBhcnQgb2YgaXByb3V0ZTI/
IElmIHRoZXJlIGlzIG5vdCBhIHNpZ25pZmljYW50DQo+IGFkdmFudGFnZSBsaWtlIHNoYXJpbmcg
Y29kZSwgdGhlbiBJIHN1Z2dlc3QgdXNpbmcgYSBzZXBhcmF0ZSByZXBvc2l0b3J5IGFuZA0KPiBw
YWNrYWdlIHNvIHZkcGF0b29sIGNhbiBiZSBpbnN0YWxsZWQgc2VwYXJhdGVseSAoZS5nLiBldmVu
IG9uIEFGX1ZTT0NLLQ0KPiBvbmx5IGd1ZXN0cyB3aXRob3V0IEV0aGVybmV0KS4NCkdpdmVuIHRo
YXQgdmRwYSB0b29sIGludGVudHMgdG8gY3JlYXRlIG5ldHdvcmsgc3BlY2lmaWMgZGV2aWNlcywg
aXByb3V0ZTIgc2VlbXMgYSBiZXR0ZXIgZml0IHRoYW4gYSBvd24gcmVwb3NpdG9yeS4NCkl0IG1h
aW5seSB1c2VzIGxpYm1ubC4NCg0KPiANCj4gU3RlZmFuDQo=
