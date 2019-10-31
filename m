Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A933AEAD4B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfJaKUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:20:51 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:53002 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726864AbfJaKUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:20:50 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 78322C0486;
        Thu, 31 Oct 2019 10:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572517250; bh=DIS/hz3fcdOHAB+JarYMn8Tqo4NvGgGcGDenZsezEOU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=MDGWqrT79CILMwc1PNop6gtADGFjClSUaY2Uw59JNnVRkTQxJaRm0hAh1xweAhXUW
         EZ5xuI4/f4/q4Y9XijVid4v3yfNF8d9AA0GoG3Q7HaazUxokv6mmJKuNxkMJA1VUqN
         mnj4YJnPsSqEyGRU9zEJMrpYVr+bthBvr1ISeyvvc9BGEDApfkhFd5wtnsmQoXRgR8
         pzxmnnMZJImVkK5NgI5D7x9JmQx/cJeoTP3lqxHi8plA6THCI4Vv+2KPtmfuK5ugH+
         rTsz7/HTLM9LS3PIGxY463XCjKHZUQQMtWIJPuFG0AMDmfcXZyKePTuSSTQKCvVZpx
         DMRJTe1ZH744w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id E7224A007F;
        Thu, 31 Oct 2019 10:20:44 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 31 Oct 2019 03:20:40 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 31 Oct 2019 03:20:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbG+4a9hjwTS/0y8xFlZmVMTZQ24mPGW6AHbcC0hvioFteZ72cv6EaSniVDPiaWLvefOZkLZxMNn0hcQyd4cOR7TKcIM0FWpKzweAqU6pqNH7KHEvO98jlaZXMxCwzSgi66K0NxXLplXKLypAA/Vy0ePQ9IukHJdOMba1UeHb/SfS1eA8zRWmv1aOwzlx3S7MQeplfYqazRs2d4qqEDrYb1Ghgp0JqwtJgC4qmpwPZz8u2YTmpKcnpBmo/YTpP9pJ2pCj9N1O9KqsWWMQFwqI6iLVIIsXJbKVBK+4QpSaWQNvl+gcFBg54pHfXjoUD0RtieN5DuzOjgLKDJTc7zw9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIS/hz3fcdOHAB+JarYMn8Tqo4NvGgGcGDenZsezEOU=;
 b=RX/fW87Qyv8l0VRpjmmENZ2O1HGTLmVp//CGjEqYMS+ovxbqsMUNjlDb+6Nv747tMabkBWy7whtHpPHtueZjyp2xUf8CcGSM+AqwuJw7dVRDM6TrSozPK4se1PW1pQ5amd4gTunL9usPWEGmS8q1EyZE9Btsz0NgxPSEqxLoMcNnWJS/uPxdmnoXZpIKGQn+VcoEF2Dp76KIVasN5/0wugTNHhJlydH1K491we/nLQ772a46Y5g0j7/AO5q2hr7y0S1VXZst+ERsGO8c3T4QUC2pHtSDDxqCSsxJwHQ5uU8dJhZ+6ydiYfflSfmylrCI4tl7AlziTY3VrQ/pD0O/Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIS/hz3fcdOHAB+JarYMn8Tqo4NvGgGcGDenZsezEOU=;
 b=NjVM1q04pB5pBu/jCQ13qfBrgCfVLlCWs2g4BSRhVoXvNoXUP+U6HCrXyy7ZQiFW4vUZF/4IM2v4APPq66q36UjSoZ68Az++QsBDbSmACnOenEV/ZXuXjYiWAHn+xd0JS2+bRyS8y61QsuC/3mbYGZ7uvHF1SsNP8RoPzSniYe8=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3587.namprd12.prod.outlook.com (20.178.210.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.17; Thu, 31 Oct 2019 10:20:37 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8%5]) with mapi id 15.20.2408.018; Thu, 31 Oct 2019
 10:20:37 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Josh Hunt <johunt@akamai.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Subject: RE: USO / UFO status ?
Thread-Topic: USO / UFO status ?
Thread-Index: AdWPLBeus8XJlFS/Sue5aUntLc/tSwALvOGAAANGMQAAGxmwMA==
Date:   Thu, 31 Oct 2019 10:20:36 +0000
Message-ID: <BN8PR12MB3266E16EB6BAD0A3A1938426D3630@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <BN8PR12MB326699DDA44E0EABB5C422E4D3600@BN8PR12MB3266.namprd12.prod.outlook.com>
 <CA+FuTSdVsTgcpB9=CEb=O369qUR58d-zEz5vmv+9nR+-DJFM6Q@mail.gmail.com>
 <99c9e80e-7e97-8490-fb43-b159fe6e8d7b@akamai.com>
In-Reply-To: <99c9e80e-7e97-8490-fb43-b159fe6e8d7b@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4540140-e374-440c-b51c-08d75debf8e8
x-ms-traffictypediagnostic: BN8PR12MB3587:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3587816147EAB67809ED1DCBD3630@BN8PR12MB3587.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(396003)(346002)(376002)(189003)(199004)(25786009)(3846002)(11346002)(14454004)(55016002)(4326008)(6436002)(6246003)(8676002)(81166006)(76176011)(107886003)(6636002)(9686003)(7696005)(6116002)(102836004)(26005)(186003)(99286004)(33656002)(2906002)(6506007)(486006)(476003)(81156014)(53546011)(8936002)(229853002)(446003)(74316002)(305945005)(478600001)(71200400001)(7736002)(110136005)(316002)(5024004)(54906003)(256004)(86362001)(66066001)(52536014)(66946007)(66556008)(66476007)(64756008)(76116006)(66446008)(5660300002)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3587;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j0TtPhxD9uti0jKDNsQAnBR7V4PPCvvzWrAbBVrjNcSRXbtDNwcAja/BBqozlzfpLuHzR/C7+0w5sKyjPHNtrhfBUVNkPn0M/uUq/W/seewrBtdLzHxn8giet7+muRYHzZEdU5Knqs/7HhsYnEXh85FAUllCi2ijoMZdrWmFP/+95XCFDjk/crb00FHGk/lusRKbCpDSUPy2izhS/6H1X2PLWnomeAYLht/YZkF5Q5qbk4dpO7pzKVTSHwsFeoUVBSRZnqNBeTQmja88ciLXWaTzLN6J41UwUNSGCCjmtTvpKSWuLf2JawvUDmsKVZW9hGLCOLalMp7LU9QqfCRb2Nle0cjMrcsCmBTaP94eCiEwQ8sYTro7FQx7zve/nY70z2Beio9O71/ImDsslDm2edrvYxul3MKI6VoyVZ5H78lwlfPCl1X4vHL9cbL6V0G+
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d4540140-e374-440c-b51c-08d75debf8e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 10:20:36.7354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oi5kNgXeJfd+k5KeVlQdgW8F3defha+wz1cEWDLd8gu2ywro088Jl6izX1+OTwStFiAe5hlCfkN8i49bvaHR0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3587
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IGJvdGggZm9yIHRoZSBmZWVkYmFjayENCg0KRnJvbTogSm9zaCBIdW50IDxqb2h1
bnRAYWthbWFpLmNvbT4NCkRhdGU6IE9jdC8zMC8yMDE5LCAyMToyMjozMiAoVVRDKzAwOjAwKQ0K
DQo+IE9uIDEwLzMwLzE5IDEyOjQ4IFBNLCBXaWxsZW0gZGUgQnJ1aWpuIHdyb3RlOg0KPiA+IE9u
IFdlZCwgT2N0IDMwLCAyMDE5IGF0IDM6MTYgUE0gSm9zZSBBYnJldSA8Sm9zZS5BYnJldUBzeW5v
cHN5cy5jb20+IHdyb3RlOg0KPiA+Pg0KPiA+PiBIaSBuZXRkZXYsDQo+ID4+DQo+ID4+IFdoYXQn
cyB0aGUgc3RhdHVzIG9mIFVEUCBTZWdtZW50YXRpb24gT2ZmbG9hZCAoVVNPKSBhbmQgVURQDQo+
ID4+IEZyYWdtZW50YXRpb24gT2ZmbG9hZGluZyAoVUZPKSBvbiBjdXJyZW50IG1haW5saW5lID8N
Cj4gPj4NCj4gPj4gSSBzZWUgdGhhdCBORVRJRl9GX0dTT19VRFBfTDQgaXMgb25seSBzdXBwb3J0
ZWQgYnkgTWVsbGFub3ggTklDJ3MgYnV0IEkNCj4gPj4gYWxzbyBzYXcgc29tZSBwYXRjaGVzIGZy
b20gSW50ZWwgc3VibWl0dGluZyB0aGUgc3VwcG9ydC4gSXMgdGhlcmUgYW55DQo+ID4+IHRvb2wg
dG8gdGVzdCB0aGlzIChiZXNpZGVzIHRoZSAtbmV0IHNlbGZ0ZXN0cykgPw0KPiA+IA0KPiA+IFVE
UCBzZWdtZW50YXRpb24gb2ZmbG9hZCB3aXRoIFVEUF9TRUdNRU5UIGlzIGFsd2F5cyBhdmFpbGFi
bGUgd2l0aA0KPiA+IHNvZnR3YXJlIHNlZ21lbnRhdGlvbi4gVGhlIG9ubHkgZHJpdmVyIHdpdGgg
aGFyZHdhcmUgb2ZmbG9hZCAoVVNPKQ0KPiA+IG1lcmdlZCBzbyBmYXIgaXMgaW5kZWVkIG1seDUu
IFBhdGNoZXMgZm9yIHZhcmlvdXMgSW50ZWwgTklDcyBhcmUgaW4NCj4gPiByZXZpZXcuDQo+ID4g
DQo+IA0KPiBJIHJlY2VudGx5IGFkZGVkIFVEUCBHU08gb2ZmbG9hZCBzdXBwb3J0IGZvciBpeGdi
ZSwgaWdiLCBhbmQgaTQwZS4gSSBzYXcgDQo+IHRoYXQgSmVmZiBzZW50IHRoZSBwYXRjaGVzIHRv
IERhdmUgZWFybGllciB0b2RheSB0YXJnZXRpbmcgbmV0LW5leHQgc28gDQo+IHlvdSBzaG91bGQg
YmUgYWJsZSB0byB0ZXN0IHdpdGggdGhvc2Ugb25jZSB0aGV5IGxhbmQgaW4gbmV0LW5leHQuDQoN
CldlbGwsIEknbSBtb3JlIGludGVyZXN0ZWQgaW4gaW1wbGVtZW50aW5nIGl0IGluIHN0bW1hYy4g
SSBoYXZlIHNvbWUgSFcgDQp0aGF0IHN1cHBvcnRzIFVTTyBhbmQgVUZPLg0KDQo+IEkgYWxzbyB3
cm90ZSBhIHdyYXBwZXIgc2NyaXB0IGFyb3VuZCB0aGUgc2VsZnRlc3QgYmVuY2htYXJrIGNvZGUg
dG8gZG8gDQo+IG15IHRlc3Rpbmcgd2l0aCwgYW5kIGJlbGlldmUgdGhlIEludGVsIGZvbGtzIHVz
ZWQgaXQgYXMgcGFydCBvZiB0aGVpciANCj4gdmFsaWRhdGlvbiBhcyB3ZWxsLiBZb3UgY2FuIGZp
bmQgaXQgYXR0YWNoZWQgdG8gdGhpcyB0aHJlYWQ6DQoNClRoYW5rcyENCg0KLS0tDQpUaGFua3Ms
DQpKb3NlIE1pZ3VlbCBBYnJldQ0K
