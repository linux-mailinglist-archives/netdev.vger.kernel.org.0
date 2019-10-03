Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CB7CA0F2
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbfJCPM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:12:29 -0400
Received: from mail-eopbgr1400092.outbound.protection.outlook.com ([40.107.140.92]:44032
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbfJCPM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 11:12:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeWp63NJL4odvR3EecDLyOvCGXhYVtBtZRiwjtKiSyCCcBGHXV8KtbQtf4ti1//r/RAMtAM5GgZmlEtSWqyDYLLESlSJ2fl8drriymGfoJ3W8i2QpMYihLjRTYWY/otDqQ9Qb92Hrdv2C3aE2yahvbIu3FSeGuSpxk8MqLwxT3eKN6BbjxB84af43/JJV5i0IEfbNE5bVqlSgI2BeBfGh27i9v6tOfDbn/mCZUNeI0e0Pizt6o3EQkIlUsgVjwvTZh0evZaO1/X0/twPZzF1KfSrvUnLiLrsp4I5TJIuIFtuyfc+en+M5+fL5FOBHLSVdixrIWbyui5Mk3m/6eSxQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMP90xpm/oH2VOa0gugfuxfjypFjWSjoxGrA3o2IXuE=;
 b=c/V5xpPIEb7gZqWXgMxFDiySSEkIdHBdRl8g7hhlexvm1YJlT/hF8c1A+xI9s7zyGstkQt6NpoS1M2AjQ0HKD5vaZh28CokxuLbtWYp/dsJ1xKB8XvYopg/P5JOU8UB1rv4KPIDd3xasSuGVB3HYneTIK6MmMwswUp9dBSz0r9PAMhafpbLSuKCMTdL8BlTWf4SmGZN+O7j2nX3Wn9ta62SkGyjDXDySxvPq3aiOxghji9kyjJkzyLc/iY6pCFsmogwtb/ujyW5q8L3p6fqm6sKWhJqwbtQ6xZyCx9tBBuUlEBCHo9TpjBmg1mDbG8pWppb7oj8C4Gjg2QMEpYGiKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMP90xpm/oH2VOa0gugfuxfjypFjWSjoxGrA3o2IXuE=;
 b=TSMsih4Ad7xs9HCK5XrD2ci2wl6rkJspuD/ArGbDBQgWshySP91yma+VS80/mNngeuikSyck1pCUnvu6upp/MFLLDrFz0NN/oFhFE++02Vqb0xwdxq8+H3kH/5zybRda39lmM/ARpFV5OtSbrKfFE2PdDSmw8GvUgK6xjEGvvpQ=
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com (52.134.248.22) by
 OSAPR01MB5042.jpnprd01.prod.outlook.com (20.179.177.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 15:12:25 +0000
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::f193:eee6:cb3b:a3b5]) by OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::f193:eee6:cb3b:a3b5%3]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 15:12:25 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Rob Herring <robh@kernel.org>
CC:     "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: ptp: Add binding doc for IDT ClockMatrix
 based PTP clock
Thread-Topic: [PATCH 1/2] dt-bindings: ptp: Add binding doc for IDT
 ClockMatrix based PTP clock
Thread-Index: AQHVbly6xWB76P+IOkSrUCgqrhtfFqdGbPUAgAKwMIA=
Date:   Thu, 3 Oct 2019 15:12:24 +0000
Message-ID: <20191003145546.GA19695@renesas.com>
References: <1568837198-27211-1-git-send-email-vincent.cheng.xh@renesas.com>
 <5d93ce84.1c69fb81.8e964.4dc1@mx.google.com>
In-Reply-To: <5d93ce84.1c69fb81.8e964.4dc1@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BYAPR11CA0087.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::28) To OSAPR01MB3025.jpnprd01.prod.outlook.com
 (2603:1096:604:2::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87415c58-eac8-46ef-7ecb-08d7481418bd
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: OSAPR01MB5042:
x-microsoft-antispam-prvs: <OSAPR01MB5042BA66C4EBB3DABE6F43E1D29F0@OSAPR01MB5042.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(189003)(199004)(1076003)(6436002)(229853002)(446003)(11346002)(6486002)(256004)(2906002)(71200400001)(71190400001)(36756003)(7736002)(5660300002)(305945005)(4326008)(99286004)(486006)(2616005)(476003)(6512007)(186003)(52116002)(76176011)(102836004)(386003)(6506007)(6246003)(26005)(54906003)(66066001)(86362001)(6916009)(33656002)(25786009)(8936002)(3846002)(6116002)(66946007)(66446008)(64756008)(66556008)(66476007)(81166006)(81156014)(8676002)(14454004)(478600001)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSAPR01MB5042;H:OSAPR01MB3025.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jDFYV/+jK7bJXxGfylBCv7vZEU02Z1FGPsKgp/97H80SyPxQBgNbekPayRD1FWtKPFIN4NcgbXVZjZVuBz9TPpc/coJpLbjK4D3l1v1fU0v68zJX5YnazE212Y5dJC6ZxVACVOCosZoYHmHKw6N/nfT6wfsyAJj2UZaXzU68JW6izscBLDnj5DJXZIvEr3io4Md4moX8wnuG3GcecC7vy+/CgMfHs1TOSi2qDSw8cOegpiS0uPxFiq92wfgr+ppweBqwfyaNCJcbwbjshKtCZwfrBqZQEP/ebYEjpQlS4E9qXYgSucenmC66p9Wn2Am/rJzwMnjjr2jnAOQrJzu0sMhM1qM29CdX475wXqGFp81kLq04MVhxWWQkYjf4pJQAFtdbJRKaUz3TPoxmSDhsbS04STIw0rMcnfttAAX7ufo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <440A9CE6CF761845BBB59B4D03E3A6CC@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87415c58-eac8-46ef-7ecb-08d7481418bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 15:12:25.0030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7z4CmbHWJpyFDWcYHElyFcKh56ffolmLFhTacZSQG5fDgUTGEHXmbkju6OdsF0aRqvbDRxMJFf7E05sG37k2OJwuSInM1CQ9JrIlZcDnNnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB5042
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBPY3QgMDEsIDIwMTkgYXQgMDY6MDk6MDZQTSBFRFQsIFJvYiBIZXJyaW5nIHdyb3Rl
Og0KPk9uIFdlZCwgU2VwIDE4LCAyMDE5IGF0IDA0OjA2OjM3UE0gLTA0MDAsIHZpbmNlbnQuY2hl
bmcueGhAcmVuZXNhcy5jb20gd3JvdGU6DQo+PiBGcm9tOiBWaW5jZW50IENoZW5nIDx2aW5jZW50
LmNoZW5nLnhoQHJlbmVzYXMuY29tPg0KDQpIaSBSb2IsDQoNCldlbGNvbWUgYmFjay4gIFRoYW5r
LXlvdSBmb3IgcHJvdmlkaW5nIGZlZWRiYWNrLg0KDQo+PiANCj4+IEFkZCBkZXZpY2UgdHJlZSBi
aW5kaW5nIGRvYyBmb3IgdGhlIElEVCBDbG9ja01hdHJpeCBQVFAgY2xvY2sgZHJpdmVyLg0KPg0K
PkJpbmRpbmdzIGFyZSBmb3IgaC93LCBub3QgZHJpdmVycy4uLg0KDQpZZXMsIHdpbGwgcmVtb3Zl
ICdkcml2ZXInLg0KDQo+PiAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3B0cC9w
dHAtaWR0Y20udHh0IHwgMTUgKysrKysrKysrKysrKysrDQo+PiAgMSBmaWxlIGNoYW5nZWQsIDE1
IGluc2VydGlvbnMoKykNCj4+ICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL3B0cC9wdHAtaWR0Y20udHh0DQo+DQo+UGxlYXNlIG1ha2UgdGhpcyBh
IERUIHNjaGVtYS4NCg0KU3VyZSwgd2lsbCBnaXZlIGl0IGEgdHJ5Lg0KDQo+PiArICAtIGNvbXBh
dGlibGUgIFNob3VsZCBiZSAiaWR0LDhhMzQwMHgtcHRwIiBmb3IgU3lzdGVtIFN5bmNocm9uaXpl
cg0KPj4gKyAgICAgICAgICAgICAgICBTaG91bGQgYmUgImlkdCw4YTM0MDF4LXB0cCIgZm9yIFBv
cnQgU3luY2hyb25pemVyDQo+PiArICAgICAgICAgICAgICAgIFNob3VsZCBiZSAiaWR0LDhhMzQw
NHgtcHRwIiBmb3IgVW5pdmVyc2FsIEZyZXF1ZW5jeSBUcmFuc2xhdG9yIChVRlQpDQo+DQo+SWYg
UFRQIGlzIHRoZSBvbmx5IGZ1bmN0aW9uIG9mIHRoZSBjaGlwLCB5b3UgZG9uJ3QgbmVlZCB0byBh
cHBlbmQgDQo+Jy1wdHAnLg0KDQpPa2F5LCB3aWxsIHJlbW92ZSAnLXB0cCcuICBUaGFua3MuDQoN
Cg0KPldoYXQncyB0aGUgJ3gnIGZvcj8gV2UgZ2VuZXJhbGx5IGRvbid0IHVzZSB3aWxkY2FyZHMg
aW4gY29tcGF0aWJsZSANCj5zdHJpbmdzLg0KDQpXZSB3ZXJlIGhvcGluZyB0byB1c2UgJ3gnIHRv
IHJlcHJlc2VudCBhIHNpbmdsZSBkcml2ZXIgdG8gbWF0Y2ggdGhlIHZhcmlvdXMNCnBhcnQgbnVt
YmVycyA4QTM0MDAxLCA4QTM0MDAyLCA4QTM0MDAzLCA4QTM0MDA0LCA4QTM0MDExLCA4QTM0MDEy
LCBldGMuDQoNCldoYXQgc2hvdWxkIGJlIHVzZWQgaW5zdGVhZCBvZiAneCc/DQoNClRoYW5rcywN
ClZpbmNlbnQNCg==
