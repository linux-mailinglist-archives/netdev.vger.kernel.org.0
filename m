Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A871426F3
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgATJS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:18:29 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:33828 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgATJS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:18:29 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E48DEC045A;
        Mon, 20 Jan 2020 09:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579511907; bh=jqRaCbJ/6ze4jy2b2Mk2JwOTR8j5g+x5FeIRALMiJOo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Hi/Ou263uDdL6YplOjp3+wCdXJJQd/awE72gXMuAkf1AVAZNJQ3CI4j6xgdddoa8W
         jIMscva5rtrLmRjGEJ92n0VMmcescontgBKEpt59aFlSopLGPAIKxaanlgEAgGwlIa
         rsJuhuEGks1QgA1f/WbzpHlfP143TgFzXxuwy91EnnUIOFixlGCc6FZz7fZ1QT9L5U
         Mu+q/shQryzYVtVygiaKhyp/90hBhyWCw0b9tea325QCdQXMyBVwL5Zc6FLDdUVK4R
         eDVDu57mYOi5WIupX3rUZEplm4tdxnm/jEqepDjFhrc142v6YxtYDEmKhRMJi6QAP3
         ECqg6hC+9l5yg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2788AA0079;
        Mon, 20 Jan 2020 09:18:26 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 20 Jan 2020 01:18:26 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 20 Jan 2020 01:18:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGAjUPQ3KYKymUq6bNmCWe8ZzQfQceVN/8Nt3rKlPoqrqe59tGwwhoI4qJFGvSmyA27ZZubjDnkTSDFUYyb8XkOpgmFPOk4Ns2k6IgLw0aWq39oF6k6wuM3UhRJ82+//SgVMpGXX/JRr77HdgnEFSv+1MBZbL0N9WFjyHJw9Oym/gmYy7zFs6Ea3ga+WgMGgnGbAZU1kttnAHow1GMDNxGMxaqnk2GCn17SVwSKSHozLW2e9G6QJOG56SDWPgxkR2JaufJHaCEJtHzlnaxeTXn28ofZ57cTYNTxkkGAhU0sxN6fabmL6AkNFhvuPMv1Cpjapq2rETAPRpGp4b60etQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqRaCbJ/6ze4jy2b2Mk2JwOTR8j5g+x5FeIRALMiJOo=;
 b=Qe0gxv+qSCEB5n9dWG/r0SroOZ3MSfUBcExgw+FUqPJrOYgq1p7ioaoVZX92haVVMn5fFswpQXipY6e3O3MqED+KQw7ixRdIIiASiYmH4KakFlVqlK7svZUHcbA9oJt9tIhoKeBGIQ6mKEOXDmdiaAtyay/A/LeHSpnfHAvtwS4pQhosSEo+8Si8l1oNxC8OvRY+2QUuE0y0LUf6fYZxGfWFr56cYNN21D3cA9XctPgCy3i5KpdQ+ihRyY1RkqyTim5+8ZrkM/vbBARm8bBHhpL9sei66AKm9Tkcah3qbC30m9h6Gs0Yw5O3h0X26eB1T7y2GyI/ZUCLGoBRTlXtQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqRaCbJ/6ze4jy2b2Mk2JwOTR8j5g+x5FeIRALMiJOo=;
 b=C1xUq5RFpSFNta0rvhzLiFdhZ0j1HMusyweevYPJBZWofQtOgZ2n1qMocA2fVNXlbQg07Jouh9kwZYRMN1iN6n1pvXOAGbHcqEu9k9zIO4EVLQLReq9gFM1bVXpcYK3RgqJmRj3Nh/LvKVhoE7TYxep7GY6mhGhLFlDFAd9kUXI=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3188.namprd12.prod.outlook.com (20.179.66.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Mon, 20 Jan 2020 09:18:24 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 09:18:24 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        David Ahern <dsahern@gmail.com>
Subject: RE: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Topic: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Index: AQHVtOPaDcyycxk/7Eqs7zmpoaCgzqfAhW2AgAAAN3CAGRmjAIAD3NaQgBIiGICAA9U7EA==
Date:   Mon, 20 Jan 2020 09:18:24 +0000
Message-ID: <BN8PR12MB32667A503E5338264EBE3AF1D3320@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
 <874kxxck0m.fsf@linux.intel.com>
 <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
 <a911e7b4-bb62-8dfb-43cb-ee6ff78c9415@ti.com>
 <BN8PR12MB3266149B178B38583E35D18AD33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <076a012b-a699-abac-ca04-56201036fb1d@ti.com>
In-Reply-To: <076a012b-a699-abac-ca04-56201036fb1d@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 243e8829-efb0-4147-1938-08d79d89b38f
x-ms-traffictypediagnostic: BN8PR12MB3188:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3188967BB52602BEE225C145D3320@BN8PR12MB3188.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(396003)(346002)(376002)(136003)(366004)(199004)(189003)(4326008)(5660300002)(55016002)(7696005)(2906002)(9686003)(33656002)(52536014)(66476007)(53546011)(6506007)(76116006)(71200400001)(110136005)(8936002)(54906003)(66946007)(478600001)(64756008)(26005)(66446008)(66556008)(186003)(86362001)(8676002)(81156014)(316002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3188;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mUFzbWOVrK8z43MwomWVRW0K5yt9YTn2NvkK3hisnMFpncH1HOFuLJU3ncRus51maM182FNfeL7fupT8WlRtVKd2UsgszmzghZKmcIx3MU1xtBsO+uAkftqDwBW8P+JLkZcP9++FMRGjPFkkhod8I94N42gfeXHJoJdz5HVt6Dh2Q0LHS5/m3OO89eDjJ+iPdWYcmdUpH1OYq2EFjxCFY6T/IKdYTIcNJBe0FoYORIjVjzfLDyK5ZLsDOCG4S4DCpJWJ4KUh4yGVoD8pN6X5V1r1Z0r91v1WrxRdTy685njDtGW1daqd/xgJBYuO1WQagYGVz3zupWyV9zHcRbpdo8/AI+zk3b/FmxoE0rr6Y/7F0owmcBU8cJSXvWvQUZV+653a7QTsoIysw2rFTnKX08d4aabTLquHKcIdRK4alepty5A8bwtb3DaUzhkpIQ06
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 243e8829-efb0-4147-1938-08d79d89b38f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 09:18:24.4135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m0T4SYNncLPaWeHa3pTBVTZ4z6EfECXX1Z8d4l5jdFEWn/OLRgj7rZPgUb2hOkIjIAMX8lI2qdf3HgHtj3H9lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3188
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTXVyYWxpIEthcmljaGVyaSA8bS1rYXJpY2hlcmkyQHRpLmNvbT4NCkRhdGU6IEphbi8x
Ny8yMDIwLCAyMjoxODowNyAoVVRDKzAwOjAwKQ0KDQo+IEhpIEpvc2UsDQo+IA0KPiBPbiAwMS8w
Ny8yMDIwIDA0OjI3IEFNLCBKb3NlIEFicmV1IHdyb3RlOg0KPiA+IEZyb206IE11cmFsaSBLYXJp
Y2hlcmkgPG0ta2FyaWNoZXJpMkB0aS5jb20+DQo+ID4gRGF0ZTogSmFuLzAzLzIwMjAsIDIyOjI0
OjE0DQo+ID4gKFVUQyswMDowMCkNCj4gPiANCj4gPj4gU28geW91IGhhdmUgb25lIHNjaGVkIGVu
dHJ5IHRoYXQgc3BlY2lmeSBTZXRBbmRIb2xkIGZvciBhbGwgcmVtYWluaW5nDQo+ID4+IHF1ZXVl
cy4gU28gdGhpcyBtZWFucywgcXVldWUgMCB3aWxsIG5ldmVyIGdldCBzZW50LiBJIGd1ZXNzIHlv
dSBhbHNvDQo+ID4+IHN1cHBvcnQgU2V0QW5kUmVsZWFzZSBzbyB0aGF0IGEgbWl4IG9mIFNldEFu
ZEhvbGQgZm9sbG93ZWQgYnkNCj4gPj4gU2V0QW5kUmVsZWFzZSBjYW4gYmUgc2VudCB0byBlbmFi
bGUgc2VuZGluZyBmcm9tIFF1ZXVlIDAuIElzIHRoYXQNCj4gPj4gY29ycmVjdD8NCj4gPj4NCj4g
Pj4gU29tZXRoaW5nIGxpa2UNCj4gPj4gICAgICAgICAgICAgICAgIHNjaGVkLWVudHJ5IEggMDIg
MzAwMDAwIFwgPD09PSAzMDAgdXNlYyB0eCBmcm9tIFExDQo+ID4+ICAgICAgICAgICAgICAgICBz
Y2hlZC1lbnRyeSBSIDAxIDIwMDAwMCAgIDw9PT0gMzAwIHVzZWMgdHggZnJvbSBRMA0KPiA+Pg0K
PiA+PiBKdXN0IHRyeWluZyB0byB1bmRlcnN0YW5kIGhvdyB0aGlzIGlzIGJlaW5nIHVzZWQgZm9y
IHJlYWwgd29ybGQNCj4gPj4gYXBwbGljYXRpb24uDQo+ID4gDQo+ID4gVGhpcyBpcyB0aGUgY29t
bWFuZCBJIHVzZToNCj4gPiANCj4gPiAjIHRjIHFkaXNjIGFkZCBkZXYgJGludGYgaGFuZGxlIDEw
MDogcGFyZW50IHJvb3QgdGFwcmlvIFwNCj4gPiAJbnVtX3RjIDQgXA0KPiA+IAltYXAgMCAxIDIg
MyAzIDMgMyAzIDMgMyAzIDMgMyAzIDMgMyBcDQo+ID4gCWJhc2UtdGltZSAkYmFzZSBcDQo+ID4g
CWN5Y2xlLXRpbWUgMTAwMDAwMCBcDQo+ID4gCXNjaGVkLWVudHJ5IFIgMDAgMTAwMDAwIFwNCj4g
PiAJc2NoZWQtZW50cnkgSCAwMiAyMDAwMDAgXA0KPiA+IAlzY2hlZC1lbnRyeSBIIDA0IDMwMDAw
MCBcDQo+ID4gCXNjaGVkLWVudHJ5IEggMDggNDAwMDAwIFwNCj4gPiAJZmxhZ3MgMHgyDQo+ID4g
IyBzbGVlcCAyDQo+ID4gIyBpcGVyZjMgLWMgPGlwPiAtdSAtYiAwIC10IDE1ICYNCj4gPiAjIHNs
ZWVwIDUNCj4gPiAjIGVjaG8gIlF1ZXVlIDM6IEV4cGVjdGVkPTQwJSwgUXVldWUgMCB3aWxsIG5v
dyBiZSBwcmVlbXB0ZWQiDQo+ID4gIyB0cGVyZiAtaSA8ZXRoWD4gLXAgMw0KPiA+IA0KPiA+IFRo
aXMgd2lsbCBiYXNpY2FsbHkgcHJlZW1wdCBRdWV1ZSAwIGFuZCBmbG9vZCBRdWV1ZSAzIHdpdGgg
ZXhwcmVzcw0KPiA+IHRyYWZmaWMuDQo+IEkgc2VlIHlvdSBkb24ndCBpbmNsdWRlIFEwIGluIHlv
dXIgc2NoZWR1bGUuIFdoeSBpcyB0aGF0IHRoZSBjYXNlPw0KPiANCj4gV2h5IGlzIHRoZSBlbnRy
eSB3aXRoIHplcm8gbWFzayBpbnRyb2R1Y2VkIChmaXJzdCBlbnRyeSk/IFR5cG8/DQo+IEkgdGhv
dWdodCBpdCBzaG91bGQgYmUgbGlrZSBiZWxvdy4gTm8/DQo+IA0KPiAgPiAjIHRjIHFkaXNjIGFk
ZCBkZXYgJGludGYgaGFuZGxlIDEwMDogcGFyZW50IHJvb3QgdGFwcmlvIFwNCj4gID4gCW51bV90
YyA0IFwNCj4gID4gCW1hcCAwIDEgMiAzIDMgMyAzIDMgMyAzIDMgMyAzIDMgMyAzIFwNCj4gID4g
CWJhc2UtdGltZSAkYmFzZSBcDQo+ICA+IAljeWNsZS10aW1lIDEwMDAwMDAgXA0KPiAgPiAJc2No
ZWQtZW50cnkgUiAwMSAxMDAwMDAgXA0KPiAgPiAJc2NoZWQtZW50cnkgSCAwMiAyMDAwMDAgXA0K
PiAgPiAJc2NoZWQtZW50cnkgSCAwNCAzMDAwMDAgXA0KPiAgPiAJc2NoZWQtZW50cnkgSCAwOCA0
MDAwMDAgXA0KPiAgPiAJZmxhZ3MgMHgyDQo+IA0KPiBCYXNlZCBvbiBteSB1bmRlcnN0YW5kaW5n
LCBpZiBob2xkQWR2YW5jZSBpcyB0MSBhbmQgcmVsZWFzZUFkdmFuY2UgaXMNCj4gdDIsIGhvbGQg
aXMgYXNzZXJ0ZWQgdDEgbmFubyBzZWNvbmQgYmVmb3JlIFExIHNsb3QgKGR1cmluZyBmaXJzdA0K
PiBlbnRyeSkgYmVnaW5zIGFuZCByZWxlYXNlIGlzIGFzc2VydGVkIHQyIG5hbm8gc2Vjb25kIGJl
Zm9yZSB0aGUgc3RhcnQgb2YNCj4gUTAgc2xvdCAoZHVyaW5nIGZvdXJ0aCBlbnRyeSkgc28gdGhh
dCBwcmUtZW1wdGFibGUgZnJhbWUgc3RhcnQgDQo+IHRyYW5zbWlzc2lvbiBkdXJpbmcgZmlyc3Qg
ZW50cnkuDQo+IA0KPiBJIHRob3VnaHQgUi9IIGVudHJpZXMgYXJlIGEgcmVwbGFjZW1lbnQgZm9y
IHplcm8gbWFzayBlbnRyeSB0aGF0DQo+IGFyZSBpbnRyb2R1Y2VkIGluIHRoZSBzY2hlZHVsZSBh
cyBhIGd1YXJkIGJhbmQgYmVmb3JlIGV4cHJlc3MgcXVldWUNCj4gc2xvdCB3aGVuIGZyYW1lIHBy
ZS1lbXB0aW9uIG5vdCBzdXBwb3J0ZWQuIElzIG15IHVuZGVyc3RhbmRpbmcgY29ycmVjdD8NCj4g
DQo+IFNvIHRoZSBhYm92ZSBtYWtlIHNlbnNlPw0KDQpZb3UgYXJlIHJpZ2h0LCBteSBleGFtcGxl
IHdhcyBhbiBvbGQgb25lLCBzb3JyeS4NCg0KVGhpcyBpcyB3aGF0IEknbSBjdXJyZW50bHkgdXNp
bmc6DQoNClsuLi5dDQpjeWNsZS10aW1lIDEwMDAwMDAgXA0Kc2NoZWQtZW50cnkgUiAwMiAyMDAw
MDAgXA0Kc2NoZWQtZW50cnkgUiAwNCA0MDAwMDAgXA0Kc2NoZWQtZW50cnkgSCAwOCA0MDAwMDAg
XA0KWy4uLl0NCg0KTm90aWNlIEkgZG9uJ3QgbmVlZCB0byBzZXQgUXVldWUgMCBvbiBzY2hlZC1l
bnRyeSBiZWNhdXNlIGl0cyBhbHdheXMgDQpwcmVlbXB0YWJsZSBxdWV1ZS4NCg0KVGhlbiBJIHRl
c3QgaXQgd2l0aDoNCiMgZWNobyAiUXVldWUgMDogRXhwPTYwJSINCiMgaXBlcmYzIC10IDE1IC1j
IDxpcD4gLVogLUEgPGNwdT4gJg0KIyBzbGVlcCA1DQojIGVjaG8gIlF1ZXVlIDM6IEV4cD00MCUi
DQojIHRwZXJmIC1pIDxpbnRlcmZhY2U+IC1wIDMgLWMgPGNwdT4NCg0KVGhpcyB3aWxsIHJlc3Vs
dCBpbjoNCi0gaXBlcmYgd2lsbCBoYXZlIDYwJSBvZiBiYW5kd2lkdGggYmVjYXVzZSBRdWV1ZSAw
LTIgaGF2ZSA0MDAgKyAyMDAgPSA2MCUgDQpjeWNsZSB0aW1lDQotIHRwZXJmIHdpbGwgaGF2ZSA0
MCUgb2YgYmFuZHdpZHRoIGJlY2F1c2UgUXVldWUgMyBoYXMgNDAlIGN5Y2xlIHRpbWUgYW5kIA0K
aXMgZXhwcmVzcyBRdWV1ZQ0KDQotLS0NClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
