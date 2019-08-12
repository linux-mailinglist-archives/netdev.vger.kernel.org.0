Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547CB8A8A0
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 22:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfHLUsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 16:48:45 -0400
Received: from mail-eopbgr20068.outbound.protection.outlook.com ([40.107.2.68]:40706
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726663AbfHLUsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 16:48:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QM5XDbicJK9v+6uCA3iVTgjZ8NQyigx1WUQmwOSPnusefEb4EiTd0yyyMXryr0RDa5E+vw7LvVtqVPYAmD3m28UxrKdZv69TwdTfJZNk/p3gQgtPE0x22ERlbnJ++LR8iYx6apZ1Wt6w5ynJniltV9EZzQoa/Awx+JJ5BlwmPmlDVOONc1uPq3FHsr/u5PcLO4YeS3O6ILf7FVbN8oK+4hK/saBu8YQZ1dxWUpnREyAvTmqaAQ2B5tlUC6nJpzvi43CboiwffmwCAfGQin6PN52yrNi3bv/qTvStyhpw354gaTjUUUcik8sB3Bd3Mr0sfWlAvrnmzzTFUmi/x1/a0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oub8XEy4R9WBouLgIdmZtTCnYCC+3Y2jOXVLmV70Bag=;
 b=YN6D7ZZzrQVpbX3cDgsaZEI+qXdn3PNgWUpaU3/RxbxvbIMzi0kdBoRo5UDXomHAMhe/sJC2a4a/Hxwsd5wcy35OURVEWkMu0jYb1LuHFzb2rNkLp/OEGicK6ke4WkqNWci/UnL9/WJy+sNVFDBRYypfUnc7UhjXEp+12WoO2rrgSp8LfFHz2tI/09lYc5KuEmCS5rIgz3T5TTmVwvARQcbU3I4iqfaGu73eCMAgTYrqiG125pNEd2m7mTb+5GWoTCrMcreZ/xrJB/4svWDWvFbR7lRmMcWcgfCFCsVUKa/X4jXkri8Z6maMCwO/uYPrwVy7e3hcqjHSA0HsZoj7yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oub8XEy4R9WBouLgIdmZtTCnYCC+3Y2jOXVLmV70Bag=;
 b=ZAtmqycftwt0yUPOtu6gj3P9Qet8O5/XvRS3Lz3zRMA1Lb3iPbsvmQqrzP7ydw2kj9Zg5wK3Mz88Uzsn0GhTOhZHESjHoEqa89eG778xyR0rPbAEPeHdVjM8G8muITg7uJpZ/GedZp5PsjyyjOZ4ODcRndPyyTUvkOX7G0MBl9M=
Received: from DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM (20.179.12.155) by
 DB8PR10MB3499.EURPRD10.PROD.OUTLOOK.COM (10.186.165.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Mon, 12 Aug 2019 20:48:40 +0000
Received: from DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::51de:e266:582:d0c1]) by DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::51de:e266:582:d0c1%6]) with mapi id 15.20.2157.021; Mon, 12 Aug 2019
 20:48:40 +0000
From:   Fejes Ferenc <fejes@inf.elte.hu>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Error when loading BPF_CGROUP_INET_EGRESS program with bpftool
Thread-Topic: Error when loading BPF_CGROUP_INET_EGRESS program with bpftool
Thread-Index: AQHVUOwCsMyGQq9J8Eq5fTM6eAC0Wqb31WIAgAAnVoA=
Date:   Mon, 12 Aug 2019 20:48:40 +0000
Message-ID: <CAAej5NbwZ80MNQYxP4NiJXheAn1DcSgm+O3zQQgCoP03HGHEgQ@mail.gmail.com>
References: <CAAej5NbkQDpDXEtsROmLmNidSP8qN3VRE56s3z91zHw9XjtNZA@mail.gmail.com>
 <CAEf4BzZ27SnYkQ=psqxeWadLhnspojiJGQrGB0JRuPkP+GTiNQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ27SnYkQ=psqxeWadLhnspojiJGQrGB0JRuPkP+GTiNQ@mail.gmail.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0094.namprd04.prod.outlook.com
 (2603:10b6:805:f2::35) To DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:b2::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fejes@inf.elte.hu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVxIspjcVMQw2gjjfZOVU0NbrZJ8DiAo3dkUOpMTpie2bdyNqQj
        z7FwC2WJb+gPlYW9uL+IEbBQjS8AqTzdSz0YJ7s=
x-google-smtp-source: APXvYqyy27xp1sq1Za8b/pbsvcwFWj5exE8Ri2NKto5Yb9wsG4YZzXu3Pv5FmNgFeWtuB0NGbsu43WIZOhN4NRKelUM=
x-received: by 2002:a5e:8b0c:: with SMTP id g12mr31786288iok.56.1565642914247;
 Mon, 12 Aug 2019 13:48:34 -0700 (PDT)
x-gmail-original-message-id: <CAAej5NbwZ80MNQYxP4NiJXheAn1DcSgm+O3zQQgCoP03HGHEgQ@mail.gmail.com>
x-originating-ip: [209.85.210.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7533a99-ec9f-465e-9dcc-08d71f66748d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7025125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB8PR10MB3499;
x-ms-traffictypediagnostic: DB8PR10MB3499:
x-microsoft-antispam-prvs: <DB8PR10MB3499F718B483B0865DF75B71E1D30@DB8PR10MB3499.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39850400004)(396003)(366004)(136003)(51914003)(199004)(189003)(76176011)(66476007)(66556008)(26005)(53546011)(6506007)(229853002)(14454004)(386003)(66446008)(2906002)(7736002)(508600001)(11346002)(3846002)(486006)(52116002)(6436002)(186003)(64756008)(6116002)(61266001)(86362001)(5024004)(476003)(66946007)(8936002)(446003)(66066001)(102836004)(14444005)(256004)(53936002)(66574012)(99286004)(95326003)(498394004)(5660300002)(8676002)(81156014)(81166006)(4326008)(71200400001)(55446002)(6486002)(6862004)(305945005)(9686003)(25786009)(316002)(6246003)(61726006)(786003)(71190400001)(6512007)(67856001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR10MB3499;H:DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: inf.elte.hu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Wx0dN4tJS62GFul99ecvIWWLjwTDUU1jEnJ3hJFL9DPIM1ugDWQ3qLbaTFA7nYJSYOYKR00OiSYQmam3sARVREM7n1F8nUhuO814XiDM49sc9MK1qNtoeMreEVz0qYNKcmX2Bmye2n81XV3AIOIW0WeR2iqf+n4rk5a4owXioYCK2eY60yJbv4seFpXm8+wUXE2X6/WYUGevvbZlUGybbKyvRzNkMq7SMYHDzQyidAB5hFfI4mH4VmzZljmAOp5g1zmv8RPuwRhN6bPxalKy9/CJeYYhq5anuI092z8n9/yJTCcIKbV/Xkz/msqkbvfhiJuu3hrKs8Or5sqB8+rS15jh23mdWGfwqXu5jH0P+CvuN8p/GfPtB7mc7YbjdMBwqX+PhyipVDhGcxBILNNCyebqiMxqnel25F9zDBzPRSc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E658FD8DE9B0A048BD456945F4BA2A7A@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: b7533a99-ec9f-465e-9dcc-08d71f66748d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 20:48:40.0476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ce+YDze9FYlNrqJ+BhlUbGcR4Zoyb7mq+Kivc+aRjFgoFRx2cz4HqEB42mtO4Z1eStYdXmxgprrykyPdSwjnyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3499
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB0aGUgYW5zd2VyLCBJIHJlYWxseSBhcHByZWNpYXRlIGl0LiBJIHRyaWVkIG9t
aXR0aW5nDQoiY2dyb3VwL3NrYiIgdG8gbGV0IGxpYmJwZiBndWVzcyB0aGUgYXR0YWNoIHR5cGUs
IGJ1dCBJIGdvdCB0aGUgc2FtZQ0KZXJyb3IuIFJlYWxseSBpbnRlcmVzdGluZywgYmVjYXVzZSBJ
IGdvdCB0aGUgZXJyb3INCj4gbGliYnBmOiBmYWlsZWQgdG8gbG9hZCBwcm9ncmFtICdjZ3JvdXBf
c2tiL2VncmVzcycNCndpY2ggaXMgd2VpcmQgYmVjYXVzZSBpdCBzaG93cyB0aGF0IGxpYmJwZiBn
dWVzcyB0aGUgcHJvZ3JhbSB0eXBlDQpjb3JyZWN0bHkuIFNvIHNvbWV0aGluZyBkZWZpbml0ZWx5
IG9uIG15IHNpZGUgLSB0aGFuayB5b3UgZm9yIHZlcmlmeW5nDQp0aGF0IC0gSSB0cnkgdG8gaW52
ZXN0aWdhdGUgaXQhDQoNCkZlcmVuYw0KQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWkubmFrcnlpa29A
Z21haWwuY29tPiBlenQgw61ydGEgKGlkxZFwb250OiAyMDE5Lg0KYXVnLiAxMi4sIEgsIDIwOjI3
KToNCj4NCj4gT24gTW9uLCBBdWcgMTIsIDIwMTkgYXQgMTo1OSBBTSBGZWplcyBGZXJlbmMgPGZl
amVzQGluZi5lbHRlLmh1PiB3cm90ZToNCj4gPg0KPiA+IEdyZWV0aW5ncyENCj4gPg0KPiA+IEkg
Zm91bmQgYSBzdHJhbmdlIGVycm9yIHdoZW4gSSB0cmllZCB0byBsb2FkIGEgQlBGX0NHUk9VUF9J
TkVUX0VHUkVTUw0KPiA+IHByb2cgd2l0aCBicGZ0b29sLiBMb2FkaW5nIHRoZSBzYW1lIHByb2dy
YW0gZnJvbSBDIGNvZGUgd2l0aA0KPiA+IGJwZl9wcm9nX2xvYWRfeGF0dHIgd29ya3Mgd2l0aG91
dCBwcm9ibGVtLg0KPiA+DQo+ID4gVGhlIGVycm9yIG1lc3NhZ2UgSSBnb3Q6DQo+ID4gYnBmdG9v
bCBwcm9nIGxvYWRhbGwgaGJtX2tlcm4ubyAvc3lzL2ZzL2JwZi9oYm0gdHlwZSBjZ3JvdXAvc2ti
DQo+DQo+IFlvdSBuZWVkICJjZ3JvdXBfc2tiL2VncmVzcyIgaW5zdGVhZCBvZiAiY2dyb3VwL3Nr
YiIgKG9yIHRyeSBqdXN0DQo+IGRyb3BwaW5nIGl0LCBicGZ0b29sIHdpbGwgdHJ5IHRvIGd1ZXNz
IHRoZSB0eXBlIGZyb20gcHJvZ3JhbSdzIHNlY3Rpb24NCj4gbmFtZSwgd2hpY2ggd291bGQgYmUg
Y29ycmVjdCBpbiB0aGlzIGNhc2UpLg0KPg0KPiA+IGxpYmJwZjogbG9hZCBicGYgcHJvZ3JhbSBm
YWlsZWQ6IEludmFsaWQgYXJndW1lbnQNCj4gPiBsaWJicGY6IC0tIEJFR0lOIERVTVAgTE9HIC0t
LQ0KPiA+IGxpYmJwZjoNCj4gPiA7IHJldHVybiBBTExPV19QS1QgfCBSRURVQ0VfQ1c7DQo+ID4g
MDogKGI3KSByMCA9IDMNCj4gPiAxOiAoOTUpIGV4aXQNCj4gPiBBdCBwcm9ncmFtIGV4aXQgdGhl
IHJlZ2lzdGVyIFIwIGhhcyB2YWx1ZSAoMHgzOyAweDApIHNob3VsZCBoYXZlIGJlZW4NCj4gPiBp
biAoMHgwOyAweDEpDQo+ID4gcHJvY2Vzc2VkIDIgaW5zbnMgKGxpbWl0IDEwMDAwMDApIG1heF9z
dGF0ZXNfcGVyX2luc24gMCB0b3RhbF9zdGF0ZXMgMA0KPiA+IHBlYWtfc3RhdGVzIDAgbWFya19y
ZWFkIDANCj4gPg0KPiA+IGxpYmJwZjogLS0gRU5EIExPRyAtLQ0KPiA+IGxpYmJwZjogZmFpbGVk
IHRvIGxvYWQgcHJvZ3JhbSAnY2dyb3VwX3NrYi9lZ3Jlc3MnDQo+ID4gbGliYnBmOiBmYWlsZWQg
dG8gbG9hZCBvYmplY3QgJ2hibV9rZXJuLm8nDQo+ID4gRXJyb3I6IGZhaWxlZCB0byBsb2FkIG9i
amVjdCBmaWxlDQo+ID4NCj4gPg0KPiA+IE15IGVudmlyb25tZW50OiA1LjMtcmMzIC8gbmV0LW5l
eHQgbWFzdGVyIChib3RoIHByb2R1Y2luZyB0aGUgZXJyb3IpLg0KPiA+IExpYmJwZiBhbmQgYnBm
dG9vbCBpbnN0YWxsZWQgZnJvbSB0aGUga2VybmVsIHNvdXJjZSAoY2xlYW5lZCBhbmQNCj4gPiBy
ZWluc3RhbGxlZCB3aGVuIEkgdHJpZWQgYSBuZXcga2VybmVsKS4gSSBjb21waWxlZCB0aGUgcHJv
Z3JhbSB3aXRoDQo+ID4gQ2xhbmcgOCwgb24gVWJ1bnR1IDE5LjEwIHNlcnZlciBpbWFnZSwgdGhl
IHNvdXJjZToNCj4gPg0KPiA+ICNpbmNsdWRlIDxsaW51eC9icGYuaD4NCj4gPiAjaW5jbHVkZSAi
YnBmX2hlbHBlcnMuaCINCj4gPg0KPiA+ICNkZWZpbmUgRFJPUF9QS1QgICAgICAgIDANCj4gPiAj
ZGVmaW5lIEFMTE9XX1BLVCAgICAgICAxDQo+ID4gI2RlZmluZSBSRURVQ0VfQ1cgICAgICAgMg0K
PiA+DQo+ID4gU0VDKCJjZ3JvdXBfc2tiL2VncmVzcyIpDQo+ID4gaW50IGhibShzdHJ1Y3QgX19z
a19idWZmICpza2IpDQo+ID4gew0KPiA+ICAgICAgICAgcmV0dXJuIEFMTE9XX1BLVCB8IFJFRFVD
RV9DVzsNCj4gPiB9DQo+ID4gY2hhciBfbGljZW5zZVtdIFNFQygibGljZW5zZSIpID0gIkdQTCI7
DQo+ID4NCj4gPg0KPiA+IEkgYWxzbyB0cmllZCB0byB0cmFjZSBkb3duIHRoZSBidWcgd2l0aCBn
ZGIuIEl0IHNlZW1zIGxpa2UgdGhlDQo+ID4gc2VjdGlvbl9uYW1lcyBhcnJheSBpbiBsaWJicGYu
YyBmaWxsZWQgd2l0aCBnYXJiYWdlLCBlc3BlY2lhbGx5IHRoZQ0KPg0KPiBJIGRpZCB0aGUgc2Ft
ZSwgc2VjdGlvbl9uYW1lcyBhcHBlYXJzIHRvIGJlIGNvcnJlY3QsIG5vdCBzdXJlIHdoYXQgd2Fz
DQo+IGdvaW5nIG9uIGluIHlvdXIgY2FzZS4gVGhlIHByb2JsZW0gaXMgdGhhdCAiY2dyb3VwL3Nr
YiIsIHdoaWNoIHlvdQ0KPiBwcm92aWRlZCBvbiBjb21tYW5kIGxpbmUsIG92ZXJyaWRlcyB0aGlz
IHNlY3Rpb24gbmFtZSBhbmQgZm9yY2VzDQo+IGJwZnRvb2wgdG8gZ3Vlc3MgcHJvZ3JhbSB0eXBl
IGFzIEJQRl9DR1JPVVBfSU5FVF9JTkdSRVNTLCB3aGljaA0KPiByZXN0cmljdHMgcmV0dXJuIGNv
ZGVzIHRvIGp1c3QgMCBvciAxLCB3aGlsZSBmb3INCj4gQlBGX0NHUk9VUF9JTkVUX0VHUkVTUyBp
IGlzIFswLCAzXS4NCj4NCj4gPiBleHBlY3RlZF9hdHRhY2hfdHlwZSBmaWVsZHMgKGluIG15IGNh
c2UsIHRoaXMgY29udGFpbnMNCj4gPiBCUEZfQ0dST1VQX0lORVRfSU5HUkVTUyBpbnN0ZWFkIG9m
IEJQRl9DR1JPVVBfSU5FVF9FR1JFU1MpLg0KPiA+DQo+ID4gVGhhbmtzIQ0K
