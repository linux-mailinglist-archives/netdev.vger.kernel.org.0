Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513F02701D1
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIRQN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:13:57 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3319 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgIRQNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:13:53 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64dc940000>; Fri, 18 Sep 2020 09:13:08 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 16:13:52 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 16:13:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNoH8A5aM6zy6bYDaR7KSHUlJzZpUBbs4rCyWuKXrZQfIZ7WjZMT/LWqNVY1PgaDFgy8vIeKebff1xCfJcg+po8SD87/PfWY34yjZBYjwcAWzG6Dt0wR55HZLCey5Gup2I+UoiK/iMkMnGE0Wuv1fQQicUvLxlAN/eRz176bWaoqIpxnSwQqvH+dBWt6lu+8pO5YaXyaYzfRFRE5M5bEZQHZucM10yacyL1c3L/J46c5wVrcuVbYAjdgEh46RP/THuuk6zIJ0K7ZJcWEh9r4fFXWk2TQAWb2M4AT/6UPxzAmPUwH8KAWoxScMpEpCBmE7RS0x4VRz/MCw6pcH9dpig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL40tOyms0qNwWnsEhWXMy8J30ePFxrgmGgHmRFDgtc=;
 b=dT7PDRO6empLIrZ3QCQaouME41LnhabS7zCA/OK75KP6Sar0HQxCwsaLfI8vOV/iIzP1/dEJoAy3iDWThcDeyhKTAzE7CWVXXkbIWOYVQjGFHdk/ucxpMICzln9EN7o9f7L9KisfJMr8tE8C3UWs5sMe/DtBWSy7AzFyZOOtbHRIKVJFxp2nteHne2sU82MeFn5RtAdppHYTpMRoDFQH2DC6cb5nwYVFRw9YhPq20j3pisNjfLyGDOYzTmWgSeweRdtkXrD/OGUEHLM3C9AImMBFhSgJbj6sxZyXOAWPvQ/9mFYMQbEeLg0E564CzqnPo5QT0aOGyGKy5WL4aMjoqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2645.namprd12.prod.outlook.com (2603:10b6:a03:61::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Fri, 18 Sep
 2020 16:13:50 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.027; Fri, 18 Sep 2020
 16:13:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
Thread-Topic: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
Thread-Index: AQHWjRbfsBFsIsWtkkyNl1+R6ZtbG6ltQJQAgACEJpCAAL4hAIAACqxQ
Date:   Fri, 18 Sep 2020 16:13:49 +0000
Message-ID: <BY5PR12MB432298572152955D2ACAA2A3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-2-parav@nvidia.com>
 <7b4627d3-2a69-5700-e985-2fe5c56f03cb@gmail.com>
 <BY5PR12MB43220E910463577F0D792965DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <f89dca1d-4517-bf4a-b3f0-4c3a076dd2ab@gmail.com>
In-Reply-To: <f89dca1d-4517-bf4a-b3f0-4c3a076dd2ab@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3046386f-c0eb-4ec0-4d2b-08d85bedd469
x-ms-traffictypediagnostic: BYAPR12MB2645:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB26452A162BE399C5677294C9DC3F0@BYAPR12MB2645.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YQiPh2VVzcAmQyx7uUCle9cQzs+SfVzabea+QhPoDzOJbU4ED6njcUpgCE+3GZt27nmgdF9Uaq63Q+ZMsaM2xWPCl9PO75jk1prkX/PG1BDmnLVrp1N00x1VTxslVXDsnVdmV+g4T264fEBVrF/svD+5hxoKCOuJ0yQhmWI5VpKHHzeyLRbbvdIRAeAPoAklVoDiXg/TtzkVgUEb45UPHSfBv32Jbr3UgkiOlv54VAVJtwz/lKW9NgrFV2WCEe6bmGWFgS0nqWx9K98CMt/AZZXK3hvdbGanuwfwmtsdgz49OqJrUtdvhn1BUFrZcLpr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(478600001)(86362001)(8676002)(55236004)(53546011)(4326008)(8936002)(6506007)(26005)(7696005)(33656002)(71200400001)(76116006)(66556008)(66476007)(83380400001)(66946007)(9686003)(55016002)(186003)(66446008)(64756008)(110136005)(316002)(5660300002)(107886003)(2906002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fShZz9HEsP8nUrWOyceA1hDG8C8TMiE3mLI2AnV0ekU1VLep9D8SCKS5itoFGgjoowgJvC94LRj43f5kyxuHJ7IUVWh3/TJECyNoXWR4pw35rAaKazAhxHdhQ++ChvdOnDV/0VP7eQTsyjOmikFKurDYY28/xkP8+r07HWh05NX/9R9tNJP/OFyOE4sSn9uHqedGcVWloaOA3w2zG1Jwwt+b35Lq7tjlJh+MKY1vMX7TP+XJEZQhTpPqkcdf9t485+WlfW6p30qWLX2FepCJvT/a/iLiEVGdIAQuBXEA0IXBhDgTFY5qGo+VmZbnx46bXi9Fou3N16K1jD4jEmIc5g/0l6JfAG28nAR5O+lm8tqX4D0O5H0dm1BSCopKcR7d6flzjMKMyR6gdrV2B0bL+r2l1gmnJZRg4DSdeCZOEywx1SRgMRUnK3GG5k1WsddpSFffihjRexBBrqgKS4JO3Ta/Qvg6VO+WbCruEvbyx8riUkg8xTUGanE9Fl5LD12IAzn3YQm2tqieG4PgcJnm7DVrUeS2QEhtmOnC0ecAuv8DYM54Tuq2TIiKoV9NMLIQkEg7hni6E1hg/Wyd+LNqdpE+dmd91ZgKWfNrX73lRDCOTMvwgBVxfJQef1lu5d8TPB5/Co/YYX2kfITSCFjjAg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3046386f-c0eb-4ec0-4d2b-08d85bedd469
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 16:13:49.9603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TIVAwGseTNyqYrXPHcZ/UFs74Um9beYBmI1pqLlDfK3/rzSIQRqIhEmMaSCNNob/mLEA1clEAaB3lYz6fh91Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2645
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600445588; bh=cL40tOyms0qNwWnsEhWXMy8J30ePFxrgmGgHmRFDgtc=;
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
        b=LIkCjlTjDmsVAFSVT3mLpsuARGhL+lhm7fpioS89g08B0+2K18UEw497q2gsJw18o
         peqcDmTYhb5bphuULQOoVRJB9bs1sW0pBqJHgDBLT7UShC1VuqwXt7NnsB5gWo7bhH
         tEgskT53t6yM2tttbiDhlBLso38gAoqQJV9KLd59CZqPB6WbpFLfh78ssV2FS6zDSe
         yV4KJHGN0fr80velj3Ij4XWtOfuyUGpD4anMT8HKhr+QcMYEV/mowXX3dPXxytpgWH
         ljSIiq5zOq0r5W/WpbnPwC2GsLhSam9KVHCMSrk4/P79PqWryem2e1r579H/GDrO7G
         hcvOpyqhXvnSw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBT
ZW50OiBGcmlkYXksIFNlcHRlbWJlciAxOCwgMjAyMCA4OjQ1IFBNDQo+IA0KPiBPbiA5LzE3LzIw
IDEwOjE4IFBNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4NCj4gPj4gRnJvbTogRGF2aWQgQWhl
cm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiA+PiBTZW50OiBGcmlkYXksIFNlcHRlbWJlciAxOCwg
MjAyMCAxOjMyIEFNDQo+ID4+DQo+ID4+IE9uIDkvMTcvMjAgMTE6MjAgQU0sIFBhcmF2IFBhbmRp
dCB3cm90ZToNCj4gPj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9kZXZsaW5rLmggYi9pbmNs
dWRlL25ldC9kZXZsaW5rLmggaW5kZXgNCj4gPj4+IDQ4YjFjMWVmMWViZC4uMWVkYjU1ODEyNWIw
IDEwMDY0NA0KPiA+Pj4gLS0tIGEvaW5jbHVkZS9uZXQvZGV2bGluay5oDQo+ID4+PiArKysgYi9p
bmNsdWRlL25ldC9kZXZsaW5rLmgNCj4gPj4+IEBAIC04Myw2ICs4MywyMCBAQCBzdHJ1Y3QgZGV2
bGlua19wb3J0X3BjaV92Zl9hdHRycyB7DQo+ID4+PiAgCXU4IGV4dGVybmFsOjE7DQo+ID4+PiAg
fTsNCj4gPj4+DQo+ID4+PiArLyoqDQo+ID4+PiArICogc3RydWN0IGRldmxpbmtfcG9ydF9wY2lf
c2ZfYXR0cnMgLSBkZXZsaW5rIHBvcnQncyBQQ0kgU0YNCj4gPj4+ICthdHRyaWJ1dGVzDQo+ID4+
PiArICogQGNvbnRyb2xsZXI6IEFzc29jaWF0ZWQgY29udHJvbGxlciBudW1iZXINCj4gPj4+ICsg
KiBAcGY6IEFzc29jaWF0ZWQgUENJIFBGIG51bWJlciBmb3IgdGhpcyBwb3J0Lg0KPiA+Pj4gKyAq
IEBzZjogQXNzb2NpYXRlZCBQQ0kgU0YgZm9yIG9mIHRoZSBQQ0kgUEYgZm9yIHRoaXMgcG9ydC4N
Cj4gPj4+ICsgKiBAZXh0ZXJuYWw6IHdoZW4gc2V0LCBpbmRpY2F0ZXMgaWYgYSBwb3J0IGlzIGZv
ciBhbiBleHRlcm5hbA0KPiA+Pj4gK2NvbnRyb2xsZXIgICovIHN0cnVjdCBkZXZsaW5rX3BvcnRf
cGNpX3NmX2F0dHJzIHsNCj4gPj4+ICsJdTMyIGNvbnRyb2xsZXI7DQo+ID4+PiArCXUxNiBwZjsN
Cj4gPj4+ICsJdTMyIHNmOw0KPiA+Pg0KPiA+PiBXaHkgYSB1MzI/IERvIHlvdSBleHBlY3QgdG8g
c3VwcG9ydCB0aGF0IG1hbnkgU0ZzPyBTZWVtcyBsaWtlIGV2ZW4gYQ0KPiA+PiB1MTYgaXMgbW9y
ZSB0aGFuIHlvdSBjYW4gYWRlcXVhdGVseSBuYW1lIHdpdGhpbiBhbiBJRk5BTUVTWiBidWZmZXIu
DQo+ID4+DQo+ID4gSSB0aGluayB1MTYgaXMgbGlrZWx5IGVub3VnaCwgd2hpY2ggbGV0IHVzZSBj
cmVhdGVzIDY0SyBTRiBwb3J0cyB3aGljaA0KPiA+IGlzIGEgbG90LiA6LSkgV2FzIGxpdHRsZSBj
b25jZXJuZWQgdGhhdCBpdCBzaG91bGRuJ3QgZmFsbCBzaG9ydCBpbiBmZXcgeWVhcnMuIFNvDQo+
IHBpY2tlZCB1MzIuDQo+ID4gVXNlcnMgd2lsbCBiZSBhYmxlIHRvIG1ha2UgdXNlIG9mIGFsdGVy
bmF0aXZlIG5hbWVzIHNvIGp1c3QgYmVjYXVzZQ0KPiBJRk5BTUVTWiBpcyAxNiBjaGFyYWN0ZXJz
LCBkbyBub3Qgd2FudCB0byBsaW1pdCBzZm51bSBzaXplLg0KPiA+IFdoYXQgZG8geW91IHRoaW5r
Pw0KPiA+DQo+ID4+DQo+ID4+PiArCXU4IGV4dGVybmFsOjE7DQo+ID4+PiArfTsNCj4gPj4+ICsN
Cj4gPj4+ICAvKioNCj4gPj4+ICAgKiBzdHJ1Y3QgZGV2bGlua19wb3J0X2F0dHJzIC0gZGV2bGlu
ayBwb3J0IG9iamVjdA0KPiA+Pj4gICAqIEBmbGF2b3VyOiBmbGF2b3VyIG9mIHRoZSBwb3J0DQo+
ID4+DQo+ID4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZGV2bGluay5jIGIvbmV0L2Nv
cmUvZGV2bGluay5jIGluZGV4DQo+ID4+PiBlNWI3MWYzYzJkNGQuLmZhZGE2NjBmZDUxNSAxMDA2
NDQNCj4gPj4+IC0tLSBhL25ldC9jb3JlL2RldmxpbmsuYw0KPiA+Pj4gKysrIGIvbmV0L2NvcmUv
ZGV2bGluay5jDQo+ID4+PiBAQCAtNzg1NSw2ICs3ODg5LDkgQEAgc3RhdGljIGludA0KPiA+PiBf
X2RldmxpbmtfcG9ydF9waHlzX3BvcnRfbmFtZV9nZXQoc3RydWN0IGRldmxpbmtfcG9ydCAqZGV2
bGlua19wb3J0LA0KPiA+Pj4gIAkJbiA9IHNucHJpbnRmKG5hbWUsIGxlbiwgInBmJXV2ZiV1IiwN
Cj4gPj4+ICAJCQkgICAgIGF0dHJzLT5wY2lfdmYucGYsIGF0dHJzLT5wY2lfdmYudmYpOw0KPiA+
Pj4gIAkJYnJlYWs7DQo+ID4+PiArCWNhc2UgREVWTElOS19QT1JUX0ZMQVZPVVJfUENJX1NGOg0K
PiA+Pj4gKwkJbiA9IHNucHJpbnRmKG5hbWUsIGxlbiwgInBmJXVzZiV1IiwgYXR0cnMtPnBjaV9z
Zi5wZiwgYXR0cnMtDQo+ID4+PiBwY2lfc2Yuc2YpOw0KPiA+Pj4gKwkJYnJlYWs7DQo+ID4+PiAg
CX0NCj4gPj4+DQo+ID4+PiAgCWlmIChuID49IGxlbikNCj4gPj4+DQo+ID4+DQo+ID4+IEFuZCBh
cyBJIG5vdGVkIGJlZm9yZSwgdGhpcyBmdW5jdGlvbiBjb250aW51ZXMgdG8gZ3JvdyBkZXZpY2Ug
bmFtZXMNCj4gPj4gYW5kIGl0IGlzIGdvaW5nIHRvIHNwaWxsIG92ZXIgdGhlIElGTkFNRVNaIGJ1
ZmZlciBhbmQgRUlOVkFMIGlzIGdvaW5nDQo+ID4+IHRvIGJlIGNvbmZ1c2luZy4gSXQgcmVhbGx5
IG5lZWRzIGJldHRlciBlcnJvciBoYW5kbGluZyBiYWNrIHRvIHVzZXJzIChub3QNCj4ga2VybmVs
IGJ1ZmZlcnMpLg0KPiA+IEFsdGVybmF0aXZlIG5hbWVzIFsxXSBzaG91bGQgaGVscCB0byBvdmVy
Y29tZSB0aGUgbGltaXRhdGlvbiBvZiBJRk5BTUVTWi4NCj4gPiBGb3IgZXJyb3IgY29kZSBFSU5W
QUwsIHNob3VsZCBpdCBiZSBFTk9TUEM/DQo+ID4gSWYgc28sIHNob3VsZCBJIGluc2VydCBhIHBy
ZS1wYXRjaCBpbiB0aGlzIHNlcmllcz8NCj4gPg0KPiA+IFsxXSBpcCBsaW5rIHByb3BlcnR5IGFk
ZCBkZXYgREVWSUNFIFsgYWx0bmFtZSBOQU1FIC4uIF0NCj4gPg0KPiANCj4gWW91IGtlZXAgYWRk
aW5nIHBhdGNoZXMgdGhhdCBleHRlbmQgdGhlIHRlbXBsYXRlIGJhc2VkIG5hbWVzLiBUaG9zZSBh
cmUNCj4gZ29pbmcgdG8gY2F1c2Ugb2RkIEVJTlZBTCBmYWlsdXJlcyAodGhlIGFic29sdXRlIHdv
cnN0IGtpbmQgb2YgY29uZmlndXJhdGlvbg0KPiBmYWlsdXJlKSB3aXRoIG5vIHdheSBmb3IgYSB1
c2VyIHRvIHVuZGVyc3RhbmQgd2h5IHRoZSBjb21tYW5kIGlzIGZhaWxpbmcsIGFuZA0KPiB5b3Ug
bmVlZCB0byBoYW5kbGUgdGhhdC4gUmV0dXJuaW5nIGFuIGV4dGFjayBtZXNzYWdlIGJhY2sgdG8g
dGhlIHVzZXIgaXMNCj4gcHJlZmVycmVkLg0KU3VyZSwgbWFrZSBzZW5zZS4NCkkgd2lsbCBydW4g
b25lIHNob3J0IHNlcmllcyBhZnRlciB0aGlzIG9uZSwgdG8gcmV0dXJuIGV4dGFjayBpbiBiZWxv
dyBjb2RlIGZsb3cgYW5kIG90aGVyIHdoZXJlIGV4dGFjayByZXR1cm4gaXMgcG9zc2libGUuDQpJ
biBzeXNmcyBmbG93IGl0IGlzIGlycmVsZXZhbnQgYW55d2F5Lg0KcnRubF9nZXRsaW5rKCkNCiAg
cnRubF9waHlzX3BvcnRfbmFtZV9maWxsKCkNCiAgICAgZGV2X2dldF9waHlzX3BvcnRfbmFtZSgp
DQogICAgICAgbmRvX3BoeXNfcG9ydF9uYW1lKCkNCg0KaXMgdGhhdCBvaz8NClRoaXMgc2VyaWVz
IGlzIG5vdCByZWFsbHkgbWFraW5nIHBoeXNfcG9ydF9uYW1lIGFueSB3b3JzZSBleGNlcHQgdGhh
dCBzZm51bSBmaWVsZCB3aWR0aCBpcyBiaXQgbGFyZ2VyIHRoYW4gdmZudW0uDQoNCk5vdyBjb21p
bmcgYmFjayB0byBwaHlzX3BvcnRfbmFtZSBub3QgZml0dGluZyBpbiAxNSBjaGFyYWN0ZXJzIHdo
aWNoIGNhbiB0cmlnZ2VyIC1FSU5WQUwgZXJyb3IgaXMgdmVyeSBzbGltIGluIG1vc3Qgc2FuZSBj
YXNlcy4NCkxldCdzIHRha2UgYW4gZXhhbXBsZS4NCkEgY29udHJvbGxlciBpbiB2YWxpZCByYW5n
ZSBvZiAwIHRvIDE2LA0KUEYgaW4gcmFuZ2Ugb2YgMCB0byA3LA0KVkYgaW4gcmFuZ2Ugb2YgMCB0
byAyNTUsDQpTRiBpbiByYW5nZSBvZiAwIHRvIDY1NTM2LA0KDQpXaWxsIGdlbmVyYXRlIFZGIHBo
eXNfcG9ydF9uYW1lPWMxNnBmN3ZmMjU1ICgxMSBjaGFycyArIDEgbnVsbCkNClNGIHBoeXNfcG9y
dCBuYW1lID0gYzE2cGY3c2Y2NTUzNSAoMTMgY2hhcnMgKyAxIG51bGwpDQpTbyB5ZXMsIGV0aCBk
ZXYgbmFtZSB3b24ndCBmaXQgaW4gYnV0IHBoeXNfcG9ydF9uYW1lIGZhaWx1cmUgaXMgYWxtb3N0
IG5pbC4NCg0KPiANCj4gWWVzLCB0aGUgYWx0bmFtZXMgcHJvdmlkZXMgYSBzb2x1dGlvbiBhZnRl
ciB0aGUgdGhlIG5ldGRldmljZSBoYXMgYmVlbg0KPiBjcmVhdGVkLCBidXQgSSBkbyBub3Qgc2Vl
IGhvdyB0aGF0IHdvcmtzIHdoZW4gdGhlIG5ldGRldmljZSBpcyBjcmVhdGVkIGFzDQo+IHBhcnQg
b2YgZGV2bGluayBjb21tYW5kcyB1c2luZyB0aGUgdGVtcGxhdGUgbmFtZXMgYXBwcm9hY2guDQpz
eXN0ZW1kL3VkZXYgdmVyc2lvbiB2MjQ1IHVuZGVyc3RhbmRzIHRoZSBwYXJlbnQgUENJIGRldmlj
ZSBvZiBuZXRkZXYgYW5kIHBoeXNfcG9ydF9uYW1lIHRvIGNvbnN0cnVjdCBhIHVuaXF1ZSBuZXRk
ZXZpY2UgbmFtZS4NCg0KVGhpcyBpcyB0aGUgZXhhbXBsZSBmcm9tIHRoaXMgcGF0Y2ggc2VyaWVz
IGZvciBQRiBwb3J0Lg0KDQp1ZGV2YWRtIHRlc3QtYnVpbHRpbiBuZXRfaWQgL3N5cy9jbGFzcy9u
ZXQvZXRoMA0KTG9hZCBtb2R1bGUgaW5kZXgNClBhcnNlZCBjb25maWd1cmF0aW9uIGZpbGUgL3Vz
ci9saWIvc3lzdGVtZC9uZXR3b3JrLzk5LWRlZmF1bHQubGluaw0KQ3JlYXRlZCBsaW5rIGNvbmZp
Z3VyYXRpb24gY29udGV4dC4NClVzaW5nIGRlZmF1bHQgaW50ZXJmYWNlIG5hbWluZyBzY2hlbWUg
J3YyNDUnLg0KSURfTkVUX05BTUlOR19TQ0hFTUU9djI0NQ0KSURfTkVUX05BTUVfUEFUSD1lbmkx
MG5wZjANClVubG9hZCBtb2R1bGUgaW5kZXgNClVubG9hZGVkIGxpbmsgY29uZmlndXJhdGlvbiBj
b250ZXh0Lg0KDQpBbmQgZm9yIFNGIHBvcnQsDQoNCnVkZXZhZG0gdGVzdC1idWlsdGluIG5ldF9p
ZCAvc3lzL2NsYXNzL25ldC9ldGgxDQpMb2FkIG1vZHVsZSBpbmRleA0KUGFyc2VkIGNvbmZpZ3Vy
YXRpb24gZmlsZSAvdXNyL2xpYi9zeXN0ZW1kL25ldHdvcmsvOTktZGVmYXVsdC5saW5rDQpDcmVh
dGVkIGxpbmsgY29uZmlndXJhdGlvbiBjb250ZXh0Lg0KVXNpbmcgZGVmYXVsdCBpbnRlcmZhY2Ug
bmFtaW5nIHNjaGVtZSAndjI0NScuDQpJRF9ORVRfTkFNSU5HX1NDSEVNRT12MjQ1DQpJRF9ORVRf
TkFNRV9QQVRIPWVuaTEwbnBmMHNmNDQNClVubG9hZCBtb2R1bGUgaW5kZXgNClVubG9hZGVkIGxp
bmsgY29uZmlndXJhdGlvbiBjb250ZXh0Lg0KDQpTaW1pbGFyIFZGIG5hbWluZyBpbiBwbGFjZXMg
Zm9yIEkgdGhpbmsgbW9yZSB0aGFuIGEgeWVhciBub3cuDQo=
