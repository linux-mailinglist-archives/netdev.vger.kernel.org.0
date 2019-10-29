Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2416BE8B5D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 16:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389639AbfJ2PAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 11:00:16 -0400
Received: from mail-eopbgr1410117.outbound.protection.outlook.com ([40.107.141.117]:60896
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389387AbfJ2PAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 11:00:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zmk5EPlX9W+1tb6F20if+FbKIwC2Mu8f8n7OM4RSWhgzM5PDWZ8M2WHqx52Hna/ES9OUD5ispY6l1t8FfR+HPV6zGvdeJH/tx3d9tU915zWNLb7jtk33+4fvW9PHYJOiWwo3b1i1nj/Dcuogmob7VLQmDFM9QaIPRstkWtTpsH0NWkBobNnrfpkXQLsb0bvG13mBP8DYwPvpfax7Uoh4BzRlAJrd6FSGirnoIN8xfrjxqt56trwdm6yuWVaSHNT4POufk390waVS6UzPYq7x02C00axRxMC8V8YG9lNWr8udYH6w/2jCIoXBKKTK0Aqq6mlJjF4c1OlPVO2GjhTSEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kvmof0V5pmkmn0KGFNBv/2xFL15c0FBGq89Kc09t8eM=;
 b=Snu0ZwkrC4t+MVOKauqsyBukaykSbg6vpCeByZZZuxZeHJPQixvLBzrKuS2CnwnlYwHCvqQxXnGFjn8l0wwieGKFA4NYllSvFbbYBBJeQjE/mms25bC+hYma+q+zgReOcS6JxEEnZ4M8Ghz1QZWaJK6APgAQJbv3zKtulWZwkvl99mFwo0tywTEH7hcqhgg6o8TDFeOQlpdU+4PdypGDEkDAR9NywBfKMmJxb1GKM2tYNojtEeSA/U3WySUEyxGphguBoM1n+kNXXo5Y82UhNTGt+CA2J6rLj2qW5B9ur5PDtBZJFjKb+mepbXVBuTeAKAFPFd6Tvdoode0BGgcXRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kvmof0V5pmkmn0KGFNBv/2xFL15c0FBGq89Kc09t8eM=;
 b=ezQBmeJbKQBmk+lTLLEWO5J4yWRnL7VioaQls8MUcWgOQnU/DoKIXUiJGE7ytrD1BgbHkaQZzPwQXLR66aUJVHC73L9r5kuT55wvEowJllL5Q4QdMjM9Mehn7gb+ZFQhrudzfYPcsL7fRB6ivNFBKoUa9QbO41CUd3eC8Zqo9tw=
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com (52.134.248.22) by
 OSAPR01MB2067.jpnprd01.prod.outlook.com (52.134.236.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Tue, 29 Oct 2019 15:00:09 +0000
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::f193:eee6:cb3b:a3b5]) by OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::f193:eee6:cb3b:a3b5%3]) with mapi id 15.20.2387.028; Tue, 29 Oct 2019
 15:00:09 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Rob Herring <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: ptp: Add bindings doc for IDT
 ClockMatrix based PTP clock
Thread-Topic: [PATCH v3 1/2] dt-bindings: ptp: Add bindings doc for IDT
 ClockMatrix based PTP clock
Thread-Index: AQHViEnsnceJntXJaUCNpjtJej9X26drxUsAgAX9LYA=
Date:   Tue, 29 Oct 2019 15:00:08 +0000
Message-ID: <20191029145953.GA29825@renesas.com>
References: <1571687868-22834-1-git-send-email-vincent.cheng.xh@renesas.com>
 <20191025193228.GA31398@bogus>
In-Reply-To: <20191025193228.GA31398@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: MWHPR14CA0040.namprd14.prod.outlook.com
 (2603:10b6:300:12b::26) To OSAPR01MB3025.jpnprd01.prod.outlook.com
 (2603:1096:604:2::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 310d0869-5317-4848-e423-08d75c80b096
x-ms-traffictypediagnostic: OSAPR01MB2067:
x-microsoft-antispam-prvs: <OSAPR01MB206717FE2FFFBC8CD4E70219D2610@OSAPR01MB2067.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(189003)(199004)(51874003)(2616005)(5660300002)(478600001)(6486002)(36756003)(7736002)(14444005)(316002)(6916009)(256004)(4326008)(99286004)(14454004)(6436002)(1076003)(26005)(54906003)(186003)(229853002)(76176011)(64756008)(305945005)(6246003)(386003)(33656002)(52116002)(81166006)(476003)(486006)(66446008)(25786009)(66946007)(66476007)(66556008)(3846002)(81156014)(8936002)(2906002)(66066001)(86362001)(71190400001)(8676002)(102836004)(6512007)(446003)(71200400001)(11346002)(6506007)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSAPR01MB2067;H:OSAPR01MB3025.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1bNDr84TeTm3luYN5WpKhBzfs09zJp69WG1lI8FxFQMSMko3a09JVyDLmY1Ss8eNySzRCEMF3nRQ2pbxE44Gai4dzAcfPDOQaDIpmPTQWj2NyaKgU/nejzcsDwFO45Ae3YFgqjor/AP2/LU7MRpnlnO7+b2/ynv7YoZy37n+gp6wSYAkuLkRSMh1fvBmN55udAdcWyQ9j1W94ymoP18UIkrP5XwzcBOtQ7XliZ+PaxxAoUc7GqFQfyVYRj1p2JBmmCKQ+HWib4jR7GZ69yqZGuafJw/OU8EqUs0fHDx6mQZl1pbqqJpfaPaVkw23bOdbTK1GsvKnhPg/PKd8zvW24Bm+Gxa2+RfV/2uB2ztee94/slBZbcaD6VjBeCsI62FQ1/zcsF5OHivZYosnPL/uv0DPWQvtyW3Faeylj1AGjNFeLI1GvuQ32ctYCvYC3PZj
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F720A537515CB2489DC612E4443CE80D@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 310d0869-5317-4848-e423-08d75c80b096
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 15:00:08.7131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: udCXJRehcSoZpkrQtEz+BPXhWhqodJLgKO/UEUZBpShLm0pgw01QAWX4YYJ6e+YiMzqQNhL5tk7eRdk88sKVlXwtCBLKrypiqgLDGbVpqJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2067
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBPY3QgMjUsIDIwMTkgYXQgMDM6MzI6MjhQTSBFRFQsIFJvYiBIZXJyaW5nIHdyb3Rl
Og0KPk9uIE1vbiwgT2N0IDIxLCAyMDE5IGF0IDAzOjU3OjQ3UE0gLTA0MDAsIHZpbmNlbnQuY2hl
bmcueGhAcmVuZXNhcy5jb20gd3JvdGU6DQo+PiBGcm9tOiBWaW5jZW50IENoZW5nIDx2aW5jZW50
LmNoZW5nLnhoQHJlbmVzYXMuY29tPg0KPj4gDQo+PiBBZGQgZGV2aWNlIHRyZWUgYmluZGluZyBk
b2MgZm9yIHRoZSBJRFQgQ2xvY2tNYXRyaXggUFRQIGNsb2NrLg0KPj4gDQo+PiArDQo+PiArZXhh
bXBsZXM6DQo+PiArICAtIHwNCj4+ICsgICAgcGhjQDViIHsNCj4NCj5wdHBANWINCj4NCj5FeGFt
cGxlcyBhcmUgYnVpbHQgbm93IGFuZCB0aGlzIGZhaWxzOg0KPg0KPkRvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9wdHAvcHRwLWlkdGNtLmV4YW1wbGUuZHRzOjE5LjE1LTI4OiANCj5X
YXJuaW5nIChyZWdfZm9ybWF0KTogL2V4YW1wbGUtMC9waGNANWI6cmVnOiBwcm9wZXJ0eSBoYXMg
aW52YWxpZCBsZW5ndGggKDQgYnl0ZXMpICgjYWRkcmVzcy1jZWxscyA9PSAxLCAjc2l6ZS1jZWxs
cyA9PSAxKQ0KPg0KPlRoZSBwcm9ibGVtIGlzIGkyYyBkZXZpY2VzIG5lZWQgdG8gYmUgc2hvd24g
dW5kZXIgYW4gaTJjIGJ1cyBub2RlLg0KPg0KPj4gKyAgICAgICAgICBjb21wYXRpYmxlID0gImlk
dCw4YTM0MDAwIjsNCj4+ICsgICAgICAgICAgcmVnID0gPDB4NWI+Ow0KPj4gKyAgICB9Ow0KDQpJ
IGFtIHRyeWluZyB0byByZXBsaWNhdGUgdGhlIHByb2JsZW0gbG9jYWxseSB0byBjb25maXJtIHRo
ZSBmaXggcHJpb3IgdG8gcmUtc3VibWlzc2lvbi4NCg0KSSBoYXZlIHRyaWVkIHRoZSBmb2xsb3dp
bmc6DQoNCi4vdG9vbHMvZHQtZG9jLXZhbGlkYXRlIH4vcHJvamVjdHMvbGludXgvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3B0cC9wdHAtaWR0Y20ueWFtbA0KLi90b29scy9kdC1l
eHRyYWN0LWV4YW1wbGUgfi9wcm9qZWN0cy9saW51eC9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvcHRwL3B0cC1pZHRjbS55YW1sID4gZXhhbXBsZS5kdHMNCg0KSG93IHRvIHZhbGlk
YXRlIHRoZSBleGFtcGxlLmR0cyBmaWxlIGFnYWluc3QgdGhlIHNjaGVtYSBpbiBwdHAtaWR0Y20u
eWFtbD8NCg0KVGhhbmtzIGluIGFkdmFuY2UuDQoNClJlZ2FyZHMsDQpWaW5jZW50DQo=
