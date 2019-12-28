Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC5112BE2A
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 18:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfL1RZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 12:25:45 -0500
Received: from mail-eopbgr1400115.outbound.protection.outlook.com ([40.107.140.115]:28448
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbfL1RZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Dec 2019 12:25:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIO19QNln4E/012yJVOq7I9dD9H1HUkW6MZsalO14TuvQBX101jY+M36ITfS90wO5iSI48OmPfu+F/pfGCZ0u9tQehoZFoHN3UYOVyvI30vj+h9y5LBHGAlCiFMxjakNaWRScGpr6JEI/tKthSzhZ3CTdtaA6b7CxPaXOf1P8aQ2HegoobFBW7un3uZ+NwsdvLf0Xa8PMsu7Hhf8q/T7fxaqrr5dl5PtMh7oaI2QP0KBUP+18bR2N2Z/V47XQuhkNIQjUJm1oI577d4tRFb6LEhxoE4eZPjeMiL3ndb75gc28EVBDxmVrbWn9aCiXK1uxaRQ3/uMGeznvDdLX3MKFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmPS+eJ9uGWqI/mVfgW4UvT/VlMQsQqDzLQVek7Va+I=;
 b=RfCEe+T5f6/AFPWdxL9ipm0PDE2c7qNqQL+hwtTeyNyuPUGJBDwyeKc6LsUR/Vy39bGDeWeL6VRRAIIwm9o28NcNoDsSCKdKAjBzYHAyejpJ+RQhBI3fi+d29lzckvVvQeUGsqBhocQcag3XBQaXhuExtUghO4RWDm6lsMCTIbz+Y+Od3mvH5XcPSCDUO0E4fQ7VKtUXge5OvEtywAUmw/CP/sQsxIHjYerqRujTNULMRZyzzewOQOhkKq5jhkPM/BQn55fRxUJMl04UV0ptygVgHqzfuAdi8H6SQCNPbrSDsIErlik3zHdB311XIT/BnmYq/NWNGhRPeT959o5vXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmPS+eJ9uGWqI/mVfgW4UvT/VlMQsQqDzLQVek7Va+I=;
 b=lIARy5cfEJV3yWIWn7+0IYltNVSPp694EW19EPqAocApNgYQKPL6TAR6JvDsA2f0Xmd7bzUVNswOiwLiAX2E9V9lILz1rTl34qZw09z11O0qrxSM6X3wYftYE1uiRPqj7XogMdDRYWdSJpo+EZrf8yXLy8ZXycC7ZyPwV1TeONI=
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com (52.134.248.22) by
 OSAPR01MB2418.jpnprd01.prod.outlook.com (52.134.247.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Sat, 28 Dec 2019 17:25:27 +0000
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::52c:1c46:6bf0:f01f]) by OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::52c:1c46:6bf0:f01f%4]) with mapi id 15.20.2581.007; Sat, 28 Dec 2019
 17:25:27 +0000
Received: from renesas.com (173.195.53.163) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Sat, 28 Dec 2019 17:25:24 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Rob Herring <robh@kernel.org>
CC:     "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] dt-bindings: ptp: Rename ptp-idtcm.yaml to
 ptp-cm.yaml
Thread-Topic: [PATCH net-next 1/3] dt-bindings: ptp: Rename ptp-idtcm.yaml to
 ptp-cm.yaml
Thread-Index: AQHVtJdOIeGtsyMqZEGT92+XB+h0vKfM2mOAgAMD9IA=
Date:   Sat, 28 Dec 2019 17:25:26 +0000
Message-ID: <20191228172447.GA3223@renesas.com>
References: <1576558988-20837-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1576558988-20837-2-git-send-email-vincent.cheng.xh@renesas.com>
 <20191226192217.GA17727@bogus>
In-Reply-To: <20191226192217.GA17727@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To OSAPR01MB3025.jpnprd01.prod.outlook.com
 (2603:1096:604:2::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6c85d20a-e9a0-432c-8408-08d78bbaedc2
x-ms-traffictypediagnostic: OSAPR01MB2418:
x-microsoft-antispam-prvs: <OSAPR01MB2418BE51E89410D013322E7DD2250@OSAPR01MB2418.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 02652BD10A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39840400004)(136003)(396003)(366004)(346002)(376002)(189003)(199004)(33656002)(26005)(2616005)(66556008)(4326008)(64756008)(66446008)(66476007)(66946007)(316002)(8886007)(71200400001)(16526019)(6916009)(2906002)(186003)(956004)(8936002)(52116002)(7696005)(55016002)(478600001)(36756003)(1076003)(54906003)(8676002)(81166006)(81156014)(5660300002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:OSAPR01MB2418;H:OSAPR01MB3025.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UxICnll+v3dM2tvzfX53VDqTdSLWYuyN2SKCH77PuTqHFWALjJwwQguL4gsw18wSh+S70JVkJoyngfIUDByX4AAWLNukgjBWUIRmnn9VeUEtLPAHb+dJjP5ttJD2n5fcFLPRIxsIKGSs9c8Wf7TFN0IdGQk4AquRHHZO3a+LFgik/Drwla0CSW6pLAAivhN3LxmvRnb/P2BRtGANNon1DtSFKBWNVITNW9J5Jezaq0HhMNhUxecdafkPO2sYa6eQ+9GmuM2kuyFtosCkqHE7Qr8cRcL/zhQs4Eayh1BhV2wxW7VbwzIMX2jaF3wKckDb4UjLYDe9jCJsgk2bbxcTZQSK/GW4YUZV5GedRgVsZTemrvZg46XtEhT5V1frLkdjj5lVnfpReV1oPhFBiS7g8ZoCblTv1eyXNK0/y4y4ZXVrhhikCTXTNIPe1JM2euhX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D45D545BAB230419AA1BA58E5E16EFD@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c85d20a-e9a0-432c-8408-08d78bbaedc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2019 17:25:26.8308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cnhanQn9fh5Y4h8naZu/Z56VvNcJ9Ax4yHpZ2q2FLWiBu4doi6U/l2zOICgq/PX4hs9fXtIRRZQq61XRvzhV7K+2Ya+giPcIYqRikwO6Egk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2418
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBEZWMgMjYsIDIwMTkgYXQgMDI6MjI6MTdQTSBFU1QsIFJvYiBIZXJyaW5nIHdyb3Rl
Og0KPk9uIFR1ZSwgRGVjIDE3LCAyMDE5IGF0IDEyOjAzOjA2QU0gLTA1MDAsIHZpbmNlbnQuY2hl
bmcueGhAcmVuZXNhcy5jb20gd3JvdGU6DQo+PiBGcm9tOiBWaW5jZW50IENoZW5nIDx2aW5jZW50
LmNoZW5nLnhoQHJlbmVzYXMuY29tPg0KPj4gDQo+PiBSZW5lc2FzIEVsZWN0cm9uaWNzIENvcnBv
cmF0aW9uIGNvbXBsZXRlZCBhY3F1aXNpdGlvbiBvZiBJRFQgaW4gMjAxOS4NCj4+IA0KPj4gVGhp
cyBwYXRjaCByZW1vdmVzIElEVCByZWZlcmVuY2VzIG9yIHJlcGxhY2VzIElEVCB3aXRoIFJlbmVz
YXMuDQo+PiBSZW5hbWVkIHB0cC1pZHRjbS55YW1sIHRvIHB0cC1jbS55YW1sLg0KPj4gDQo+PiBT
aWduZWQtb2ZmLWJ5OiBWaW5jZW50IENoZW5nIDx2aW5jZW50LmNoZW5nLnhoQHJlbmVzYXMuY29t
Pg0KPj4gLS0tDQo+PiAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3B0cC9wdHAt
Y20ueWFtbCAgfCA2OSArKysrKysrKysrKysrKysrKysrKysrDQo+PiAgLi4uL2RldmljZXRyZWUv
YmluZGluZ3MvcHRwL3B0cC1pZHRjbS55YW1sICAgICAgICAgfCA2OSAtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQo+PiAgMiBmaWxlcyBjaGFuZ2VkLCA2OSBpbnNlcnRpb25zKCspLCA2OSBkZWxldGlv
bnMoLSkNCj4+ICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL3B0cC9wdHAtY20ueWFtbA0KPj4gIGRlbGV0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcHRwL3B0cC1pZHRjbS55YW1sDQo+PiANCj4+ICsgIGNv
bXBhdGlibGU6DQo+PiArICAgIGVudW06DQo+PiArICAgICAgIyBGb3IgU3lzdGVtIFN5bmNocm9u
aXplcg0KPj4gKyAgICAgIC0gcmVuZXNhcyw4YTM0MDAwDQo+PiArICAgICAgLSByZW5lc2FzLDhh
MzQwMDENCj4+ICsgICAgICAtIHJlbmVzYXMsOGEzNDAwMg0KPj4gKyAgICAgIC0gcmVuZXNhcyw4
YTM0MDAzDQo+PiArICAgICAgLSByZW5lc2FzLDhhMzQwMDQNCj4+ICsgICAgICAtIHJlbmVzYXMs
OGEzNDAwNQ0KPj4gKyAgICAgIC0gcmVuZXNhcyw4YTM0MDA2DQo+PiArICAgICAgLSByZW5lc2Fz
LDhhMzQwMDcNCj4+ICsgICAgICAtIHJlbmVzYXMsOGEzNDAwOA0KPj4gKyAgICAgIC0gcmVuZXNh
cyw4YTM0MDA5DQo+DQo+DQo+PiAtICBjb21wYXRpYmxlOg0KPj4gLSAgICBlbnVtOg0KPj4gLSAg
ICAgICMgRm9yIFN5c3RlbSBTeW5jaHJvbml6ZXINCj4+IC0gICAgICAtIGlkdCw4YTM0MDAwDQo+
PiAtICAgICAgLSBpZHQsOGEzNDAwMQ0KPj4gLSAgICAgIC0gaWR0LDhhMzQwMDINCj4+IC0gICAg
ICAtIGlkdCw4YTM0MDAzDQo+PiAtICAgICAgLSBpZHQsOGEzNDAwNA0KPj4gLSAgICAgIC0gaWR0
LDhhMzQwMDUNCj4+IC0gICAgICAtIGlkdCw4YTM0MDA2DQo+PiAtICAgICAgLSBpZHQsOGEzNDAw
Nw0KPj4gLSAgICAgIC0gaWR0LDhhMzQwMDgNCj4+IC0gICAgICAtIGlkdCw4YTM0MDA5DQo+DQo+
TkFLLiBZb3UgY2FuJ3QgY2hhbmdlIHRoaXMgYXMgaXQgaXMgYW4gQUJJLg0KDQpPa2F5LCB0aGFu
ay15b3UuICBUaGlzIGhhcyBiZSByZW1vdmVkIGluIHYyIHBhdGNoIG9mIHRoZSBzZXJpZXMuDQoN
ClZpbmNlbnQNCg==
