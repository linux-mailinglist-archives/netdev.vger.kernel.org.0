Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2796AA9EA
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 19:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390178AbfIERXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 13:23:38 -0400
Received: from us-smtp-delivery-168.mimecast.com ([63.128.21.168]:52242 "EHLO
        us-smtp-delivery-168.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732000AbfIERXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 13:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
        s=mimecast20190405; t=1567704216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gf6jfM7rdt5Q4+6guZE62JzUBQ9yVcnMN5zBZSqZvig=;
        b=ChmBqPy1ItRQNXwlWvDhx815dQdpNoI4IFIHhFKLeC6Z11Kxm+3ux9UtSWIj7NY83axTM0
        gBcb3pYCY/3ZVcm0OUhlQw4P/tKyAe3aj+BOOBVyLLbvahOJt+EYv51oTSzFABuRMo4ZAB
        Z3jSBpZ12dX9zFIGZVsgXLs/o4RT+/A=
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01lp2055.outbound.protection.outlook.com [104.47.33.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-BJgYo9w9OjyOHSO1FD-7lw-1; Thu, 05 Sep 2019 13:06:23 -0400
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3659.namprd06.prod.outlook.com (10.167.236.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Thu, 5 Sep 2019 17:06:17 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::60b3:e38a:69b0:3f95]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::60b3:e38a:69b0:3f95%7]) with mapi id 15.20.2241.014; Thu, 5 Sep 2019
 17:06:17 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "vitaly.gaiduk@cloudbear.ru" <vitaly.gaiduk@cloudbear.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC:     "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] net: phy: dp83867: Add documentation for SGMII mode
 type
Thread-Topic: [PATCH 1/2] net: phy: dp83867: Add documentation for SGMII mode
 type
Thread-Index: AQHVZAe9yk928RLMPka3wG1dYOEMaacdUGUA
Date:   Thu, 5 Sep 2019 17:06:17 +0000
Message-ID: <1567703176.6344.4.camel@impinj.com>
References: <1567700761-14195-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
         <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
In-Reply-To: <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [216.207.205.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53904907-2f58-4aca-ee8c-08d732235dce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR0601MB3659;
x-ms-traffictypediagnostic: MWHPR0601MB3659:
x-microsoft-antispam-prvs: <MWHPR0601MB36599C9E052F795EFC031910D3BB0@MWHPR0601MB3659.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(136003)(396003)(39850400004)(376002)(199004)(189003)(71200400001)(64756008)(3846002)(316002)(66446008)(6246003)(53936002)(71190400001)(99286004)(54906003)(256004)(6512007)(66556008)(66476007)(110136005)(66066001)(478600001)(4326008)(14454004)(25786009)(2906002)(6436002)(6486002)(229853002)(5660300002)(36756003)(6506007)(7736002)(8676002)(305945005)(26005)(476003)(11346002)(2616005)(446003)(486006)(76176011)(102836004)(6116002)(91956017)(66946007)(76116006)(14444005)(186003)(2201001)(103116003)(81156014)(81166006)(8936002)(86362001)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3659;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y01FR+au3D4natsqwzSZb3wU2I53LAkzRp7w6cfU8yBL2tH52JhNkQjxMg5m3LIsFMii1Eoqk1Tf6tcGknEEoCHXHPv277M773/ExhNJi4cTSOQp+9lwjWg5Vm5Ja08k0VdmM3KMpZZb+zI/Nanpwq2Yb4JGlqE0W8mo1H5u5z/J/SLG8URKDMquXwXq6HnIx+m7f/OO1cQ7g52pS03TjGT3iHfkiH06VTr8rHKHpCv+9lH9UmRcWzcJx2zm61lkIxj2057/6ItNKizmMRnacCZPGwnlV0wYbAKZtb3KPgZ34uYQhHkuSBmOEzhqr6T1YPg6YLkphcMyytfUN7EZe+Ak7vpNl+DDgppw+TmmICxpTHjzr/B24eUWrI6xLhlqWb82gBiCBjcZzuCbs6Eobk+GTb0gpiF8TCPoXHkrMuM=
x-ms-exchange-transport-forked: True
Content-ID: <A5BA510434E86445A2548D318A9B8682@namprd06.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53904907-2f58-4aca-ee8c-08d732235dce
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 17:06:17.3532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jvHCVECOOlmP7xarwEf8MTmkUzibuspuJforPob25HeiwAfk0/O0vWUk59O+KYOtATkqUQ2N64w2Ywg4at25ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3659
X-MC-Unique: BJgYo9w9OjyOHSO1FD-7lw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA5LTA1IGF0IDE5OjI2ICswMzAwLCBWaXRhbHkgR2FpZHVrIHdyb3RlOg0K
PiBBZGQgZG9jdW1lbnRhdGlvbiBvZiB0aSxzZ21paS10eXBlIHdoaWNoIGNhbiBiZSB1c2VkIHRv
IHNlbGVjdA0KPiBTR01JSSBtb2RlIHR5cGUgKDQgb3IgNi13aXJlKS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFZpdGFseSBHYWlkdWsgPHZpdGFseS5nYWlkdWtAY2xvdWRiZWFyLnJ1Pg0KPiAtLS0N
Cj4gIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGksZHA4Mzg2Ny50eHQg
fCAxICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGksZHA4Mzg2Ny50eHQg
Yi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3RpLGRwODM4NjcudHh0DQo+
IGluZGV4IGRiNmFhM2YyMjE1Yi4uMThlN2ZkNTI4OTdmIDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3RpLGRwODM4NjcudHh0DQo+ICsrKyBiL0Rv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGksZHA4Mzg2Ny50eHQNCj4gQEAg
LTM3LDYgKzM3LDcgQEAgT3B0aW9uYWwgcHJvcGVydHk6DQo+ICAJCQkgICAgICBmb3IgYXBwbGlj
YWJsZSB2YWx1ZXMuICBUaGUgQ0xLX09VVCBwaW4gY2FuIGFsc28NCj4gIAkJCSAgICAgIGJlIGRp
c2FibGVkIGJ5IHRoaXMgcHJvcGVydHkuICBXaGVuIG9taXR0ZWQsIHRoZQ0KPiAgCQkJICAgICAg
UEhZJ3MgZGVmYXVsdCB3aWxsIGJlIGxlZnQgYXMgaXMuDQo+ICsJLSB0aSxzZ21paS10eXBlIC0g
VGhpcyBkZW5vdGVzIHRoZSBmYWN0IHdoaWNoIFNHTUlJIG1vZGUgaXMgdXNlZCAoNCBvciA2LXdp
cmUpLg0KDQpSZWFsbHkgc2hvdWxkIGV4cGxhaW4gd2hhdCBraW5kIG9mIHZhbHVlIGl0IGlzIGFu
ZCB3aGF0IHRoZSB2YWx1ZXMNCm1lYW4uICBJLmUuLCBzaG91bGQgdGhpcyBiZSB0aSxzZ2ltaWkt
dHlwZSA9IDw0PiB0byBzZWxlY3QgNCB3aXJlPw0KDQpNYXliZSBhIGJvb2xlYW4sICJzZ21paS1j
bG9jayIsIHRvIGluZGljYXRlIHRoZSBwcmVzZW5jZSBvZiBzZ21paSByeA0KY2xvY2sgbGluZXMs
IHdvdWxkIG1ha2UgbW9yZSBzZW5zZT8NCg0KSSBhbHNvIHdvbmRlciBpZiBwaHktbW9kZSA9ICJz
Z21paS1jbGsiIG9yICJzZ21paS02d2lyZSIsIHZzIHRoZQ0KZXhpc3RpbmcgcGh5LW1vZGUgPSAi
c2dtaWkiLCBtaWdodCBhbHNvIGJlIGEgYmV0dGVyIHdheSB0byBkZXNjcmliZQ0KdGhpcyBpbnN0
ZWFkIG9mIGEgbmV3IHByb3BlcnR5Lg0K

