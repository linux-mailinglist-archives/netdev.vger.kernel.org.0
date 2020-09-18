Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA55B26F553
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 07:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgIRFLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 01:11:07 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:37365 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgIRFLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 01:11:07 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6441670000>; Fri, 18 Sep 2020 13:11:03 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 05:11:00 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 05:11:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goo0y84U2If6ziMhf+sPq/1uIvf8MYbgXxHnbeJDGVaT/1hJ9dn1/8OCWxwabzidf/Cq1CAU5pxoS4ZCIE8R8ZxVFEuH/bDfePZ30PUCY8yMqqhPJRw5UfIReen45HU4By8D2u4FkJwsSfzYppPTmtNTYXzgrwLewsIn6Zjy5KaG/TPOlbpZfNGo1UKp6SHaVqcP31oJUUQCCbPyXo+3boLOztDdaljD+vAnV1pW+rr7WB51rK55Z1uxlfnIIK7wgQC6ZXBNTvxXHDUwPQ8xP0ZrDnEUm7fF24K7kILY+eZCocsv/Db+CnwCpG8w18ZW7r6cLAg/GCEVbidSGdwplA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xz9zjmdBAL9a6OpTL09DJcL/SgTsTlGOYFHH932Vmk=;
 b=A7XdppxeqWSem/Q65H5ZJMjNt2/zs7+L7lEMu6uK+1eSHNcsL/Z7zzSa6tnv6oWEBeAbqvMU75zSI7vuUuQZVLKtDwOxrO5OmIwAf7inEQ1o9uGMBbg871F113otKK9/vshxCHRuyER0h5EodAMdNqL7xQs5d42j+zIGKoxnKsLt8qK8MYp3KBfZQ0BIr+KsMJc7QlS/JY8yCei10Wun15U4/zmGomjR0ru5hXBrejNnL12Xh0mb2aStZvMU+GDauxx0A0PJvlC1GkTEkd1DCy5HXKTfiyEd/iF4ZtvCph/hP6dENHDYu21UWLAH/QpHUgelLCxVjaizVhKG6vkDHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3078.namprd12.prod.outlook.com (2603:10b6:a03:a8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Fri, 18 Sep
 2020 05:10:57 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 05:10:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 8/8] netdevsim: Add support for add and delete
 PCI SF port
Thread-Topic: [PATCH net-next v2 8/8] netdevsim: Add support for add and
 delete PCI SF port
Thread-Index: AQHWjRbiZXOkBXXnYkS4YkdYcsgPfqltSM4AgABzn/CAAAO2gIAADdQQgAAHF4CAAAQWEA==
Date:   Fri, 18 Sep 2020 05:10:57 +0000
Message-ID: <BY5PR12MB43225AA5A5E42E76C03F645BDC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-9-parav@nvidia.com>
 <e14f216f-19d9-7b4a-39ff-94ea89cd36c0@gmail.com>
 <BY5PR12MB43222EEBBC3B008918B82B98DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <c95859c8-e9cf-d218-e186-4f5d570c1298@gmail.com>
 <BY5PR12MB43220D8961B4F676CBA65A55DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <0b11ae28-3868-ee9f-184a-8cb577f717fc@intel.com>
In-Reply-To: <0b11ae28-3868-ee9f-184a-8cb577f717fc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3a520d0-38b0-4089-ee2e-08d85b913a4f
x-ms-traffictypediagnostic: BYAPR12MB3078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB30781ADAFD6E0CACFB11858ADC3F0@BYAPR12MB3078.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NbPudI/PGGlQbQd4nJH58mBrmSiShtwAenxYTAIJ07O8kP/KWOy1XeKVxXktjobpr5vT0DqehTLFsCN4MOv+UZJGwbg19PsQWwFBnP5OjsaD4OYo97iQaWNgQ4aG5CrlQBYOlbKo9ih3TM5tCZdEscYmAKdpfQ9nL4rSrK/5f0WOsNMv3YiJ5nfeVMqSrYiPwksdtn3oc6mabAnVCzTis7FncdF8BObCbq2b6GHuajM1vqMZHw3+x9aFPKMCv+Wg0cyMn7hObp900WCjjD03zCFq1waRTNr7MaJydYSN1ypk5+oF8CDSXxbpSmE6yOXwmteUg6kYGLXqziaWjdC4GDuhGtf8r+HgPT7wdWb7Knnf0NgTAUQLD9X/kx8KSuPojHEf6CMAbubHQv1zg87G6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(55016002)(71200400001)(9686003)(52536014)(76116006)(5660300002)(6506007)(53546011)(4326008)(33656002)(55236004)(2906002)(8676002)(966005)(86362001)(26005)(186003)(8936002)(110136005)(7696005)(316002)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vBmUaW2n2dwb2f/6BvC4wDa+1RwGGYJlZ732uextPfRTzX15GU5z0DvZH3iqJ6xO6VW3SJrehQU8uMXDZuFaF8JaGDqHkEBfbGQrV2qzisROnRiQhl2tMIP2rwUbXXpSzY0DcJZL77xBa3T5iLEiNVSK1WnzJDGeVmCVm/u5iZ63nMS8XY4PSB1vT1WzDitVeqjvlFM0WoEr1Empvgf3xTBStB2+U0p9KVhAZtKt4/048YbFGUu5Q+XJKshEdUYdaqeJn8I+pPgJ5ySOqi0mFgYdGNo8+pCq0NcyBehjny3YOU9DAQhb/cg+8/LilyxEPsait8EfRQB6y7PWaLY7C+EBmLy0oa5VqxtWjPJooroNF2ElWAlHXWGlVA08O8dM5Aw7mtmiw0nv3/ZkA2grHgBliP0IBLdiVKa5lXJyI7GqaKeSKpj3sA2SjyLvBhWkgSIsA2qjD4XpBZtWmRQmgqwZtjGBsrBIIU8nC+p12pBUhUW1nfUKh5UWpKTPCQ/tUNN+SFMp/xDhC7UOROoHzfkbz10PsyzqMd4suEyDkPzACZBtjccejs3FitSNmJibC90a+dLLlnUbbZLuE/Jtoc5ivxPsZAD6MN1BhUb3F8yw+nE/ssJjWp9u2nDwZTZrC8aJT3gaYBUGAqCDzOIesg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a520d0-38b0-4089-ee2e-08d85b913a4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 05:10:57.8612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z5W3rYrdzKN39fZqN5lX5Uy9T5flXnSuzuCpi9LU0Evtho1J3O9Ic4J6hQiXsakpKPuHLzV5xW8LL0qfojLq2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3078
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600405863; bh=6xz9zjmdBAL9a6OpTL09DJcL/SgTsTlGOYFHH932Vmk=;
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
        b=Bi/m6S1ktq+OIPYoSs7ipQqkWyXb3ZP24KLeJH8h/6fgKcjOLmmdTbPu895wLz+oy
         EjWKsIUE6ZQRNA01q6TEZmaPPOlBlOAjmOaAXi0ENWH4daOyJEji5/6WSTdsXFI61n
         6ZFExZbeWgD4Fwb7TdZmrc9awm9K+YBJVRAL/AXoBH3mnuI9CKZSwlbKv817/msSC9
         /nT2xEqo5vSpkxA3eqVxjyxnIN+9QU2Yso4oOuMLbk52lHLdDHQAc4KXwbR83ZbxLY
         ecBVj7NWtYTyKH91qVoslIEj9XMMxTOgBKxhqiyy2RMMBQYCy2NZLF0ItcQGQNugfW
         B7RipPJlB0OFA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogU2FtdWRyYWxhLCBTcmlkaGFyIDxzcmlkaGFyLnNhbXVkcmFsYUBpbnRlbC5j
b20+DQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDE4LCAyMDIwIDEwOjIzIEFNDQo+IA0KPiAN
Cj4gT24gOS8xNy8yMDIwIDk6NDEgUE0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiBIaSBEYXZp
ZCwNCj4gPg0KPiA+PiBGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+DQo+ID4+
IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDE4LCAyMDIwIDk6MDggQU0NCj4gPj4NCj4gPj4gT24g
OS8xNy8yMCA5OjI5IFBNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+Pj4+IEV4YW1wbGVzOg0K
PiA+Pj4+Pg0KPiA+Pj4+PiBDcmVhdGUgYSBQQ0kgUEYgYW5kIFBDSSBTRiBwb3J0Lg0KPiA+Pj4+
PiAkIGRldmxpbmsgcG9ydCBhZGQgbmV0ZGV2c2ltL25ldGRldnNpbTEwLzEwIGZsYXZvdXIgcGNp
cGYgcGZudW0gMA0KPiA+Pj4+PiAkIGRldmxpbmsgcG9ydCBhZGQgbmV0ZGV2c2ltL25ldGRldnNp
bTEwLzExIGZsYXZvdXIgcGNpc2YgcGZudW0gMA0KPiA+Pj4+PiBzZm51bQ0KPiA+Pj4+PiA0NCAk
IGRldmxpbmsgcG9ydCBzaG93IG5ldGRldnNpbS9uZXRkZXZzaW0xMC8xMQ0KPiA+Pj4+PiBuZXRk
ZXZzaW0vbmV0ZGV2c2ltMTAvMTE6IHR5cGUgZXRoIG5ldGRldiBlbmkxMG5wZjBzZjQ0IGZsYXZv
dXINCj4gPj4+Pj4gcGNpc2YNCj4gPj4+PiBjb250cm9sbGVyIDAgcGZudW0gMCBzZm51bSA0NCBl
eHRlcm5hbCB0cnVlIHNwbGl0dGFibGUgZmFsc2UNCj4gPj4+Pj4gICAgZnVuY3Rpb246DQo+ID4+
Pj4+ICAgICAgaHdfYWRkciAwMDowMDowMDowMDowMDowMCBzdGF0ZSBpbmFjdGl2ZQ0KPiA+Pj4+
Pg0KPiA+Pj4+PiAkIGRldmxpbmsgcG9ydCBmdW5jdGlvbiBzZXQgbmV0ZGV2c2ltL25ldGRldnNp
bTEwLzExIGh3X2FkZHINCj4gPj4+Pj4gMDA6MTE6MjI6MzM6NDQ6NTUgc3RhdGUgYWN0aXZlDQo+
ID4+Pj4+DQo+ID4+Pj4+ICQgZGV2bGluayBwb3J0IHNob3cgbmV0ZGV2c2ltL25ldGRldnNpbTEw
LzExIC1qcCB7DQo+ID4+Pj4+ICAgICAgInBvcnQiOiB7DQo+ID4+Pj4+ICAgICAgICAgICJuZXRk
ZXZzaW0vbmV0ZGV2c2ltMTAvMTEiOiB7DQo+ID4+Pj4+ICAgICAgICAgICAgICAidHlwZSI6ICJl
dGgiLA0KPiA+Pj4+PiAgICAgICAgICAgICAgIm5ldGRldiI6ICJlbmkxMG5wZjBzZjQ0IiwNCj4g
Pj4+Pg0KPiA+Pj4+IEkgY291bGQgYmUgbWlzc2luZyBzb21ldGhpbmcsIGJ1dCBpdCBkb2VzIG5v
dCBzZWVtIGxpa2UgdGhpcyBwYXRjaA0KPiA+Pj4+IGNyZWF0ZXMgdGhlIG5ldGRldmljZSBmb3Ig
dGhlIHN1YmZ1bmN0aW9uLg0KPiA+Pj4+DQo+ID4+PiBUaGUgc2YgcG9ydCBjcmVhdGVkIGhlcmUg
aXMgdGhlIGVzd2l0Y2ggcG9ydCB3aXRoIGEgdmFsaWQgc3dpdGNoIGlkDQo+ID4+PiBzaW1pbGFy
IHRvIFBGDQo+ID4+IGFuZCBwaHlzaWNhbCBwb3J0Lg0KPiA+Pj4gU28gdGhlIG5ldGRldiBjcmVh
dGVkIGlzIHRoZSByZXByZXNlbnRvciBuZXRkZXZpY2UuDQo+ID4+PiBJdCBpcyBjcmVhdGVkIHVu
aWZvcm1seSBmb3Igc3ViZnVuY3Rpb24gYW5kIHBmIHBvcnQgZmxhdm91cnMuDQo+ID4+DQo+ID4+
IFRvIGJlIGNsZWFyOiBJZiBJIHJ1biB0aGUgZGV2bGluayBjb21tYW5kcyB0byBjcmVhdGUgYSBz
dWItZnVuY3Rpb24sDQo+ID4+IGBpcCBsaW5rIHNob3dgIHNob3VsZCBsaXN0IGEgbmV0X2Rldmlj
ZSB0aGF0IGNvcnJlc3BvbmRzIHRvIHRoZSBzdWItZnVuY3Rpb24/DQo+ID4NCj4gPiBJbiB0aGlz
IHNlcmllcyBvbmx5IHJlcHJlc2VudG9yIG5ldGRldmljZSBjb3JyZXNwb25kcyB0byBzdWItZnVu
Y3Rpb24gd2lsbCBiZQ0KPiB2aXNpYmxlIGluIGlwIGxpbmsgc2hvdywgaS5lLiBlbmkxMG5wZjBz
ZjQ0Lg0KPiANCj4gVGhpcyBzaG91bGQgYmUgT0sgaWYgdGhlIGVTd2l0Y2ggbW9kZSBpcyBjaGFu
Z2VkIHRvIHN3aXRjaGRldi4NCj4gQnV0IGkgdGhpbmsgaXQgc2hvdWxkIGJlIHBvc3NpYmxlIHRv
IGNyZWF0ZSBhIHN1YmZ1bmN0aW9uIGV2ZW4gaW4gbGVnYWN5IG1vZGUNCj4gd2hlcmUgcmVwcmVz
ZW50b3IgbmV0ZGV2IGlzIG5vdCBjcmVhdGVkLg0KDQpzd2l0Y2hfaWQgaXMgb3B0aW9uYWwgYXR0
cmlidXRlIG9mIHRoZSBkZXZsaW5rIHBvcnQuDQpJdCBpcyBhcHBsaWNhYmxlIG9ubHkgd2hlbiBp
dCBpcyBlc3dpdGNoIHBvcnQgaW4gc3dpdGNoZGV2IG1vZGUuDQoNCj4gDQo+ID4NCj4gPiBOZXRk
ZXZzaW0gaXMgb25seSBzaW11bGF0aW5nIHRoZSBlc3dpdGNoIHNpZGUgb3IgY29udHJvbCBwYXRo
IGF0IHByZXNlbnQgZm9yDQo+IHBmL3ZmL3NmIHBvcnRzLg0KPiA+IFNvIG90aGVyIGVuZCBvZiB0
aGlzIHBvcnQgKG5ldGRldmljZS9yZG1hIGRldmljZS92ZHBhIGRldmljZSkgYXJlIG5vdCB5ZXQN
Cj4gY3JlYXRlZC4NCj4gPg0KPiA+IFN1YmZ1bmN0aW9uIHdpbGwgYmUgYW5jaG9yZWQgb24gdmly
dGJ1cyBkZXNjcmliZWQgaW4gUkZDIFsxXSwgd2hpY2ggaXMgbm90IHlldA0KPiBpbi1rZXJuZWwg
eWV0Lg0KPiA+IEdyZXAgZm9yICJldmVyeSBTRiBhIGRldmljZSBpcyBjcmVhdGVkIG9uIHZpcnRi
dXMiIHRvIGp1bXAgdG8gdGhpcyBwYXJ0IG9mIHRoZQ0KPiBsb25nIFJGQy4NCj4gPg0KPiA+IFsx
XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMDA1MTkwOTIyNTguR0Y0NjU1QG5h
bm9wc3ljaG8vDQo+ID4NCg==
