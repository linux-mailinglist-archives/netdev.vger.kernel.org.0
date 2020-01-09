Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1262113599F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 13:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgAIM6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 07:58:52 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:64882 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbgAIM6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 07:58:51 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: VrreSy4N6AEFQ3fIpQX+t5mnKq/TbPIBEjp2e+/B9d5drO1B+7yP5OZ6onESa9n4xzmjGnL0dc
 7kPUjv8WZuhaCOl1CJUDAFokUY3nNdSxZ4wQ5lvgEUjYZVRlJNSkWbuUtlxQQNZMkjzeJL2TgF
 8sELUB8PpUYH2aaETGCKwGKMV1ddqYMqri6rvhi/kxsr3zGv033Ew0dABElwtBckrid2Q/sANh
 btsozDqY3gQnr1scEjMvcGSQN1Ud8++0u+lb3psWLcGjRHi/PI2K7iBZ09Geig0ShKG/sTiwTg
 1vM=
X-IronPort-AV: E=Sophos;i="5.69,413,1571727600"; 
   d="scan'208";a="64172608"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2020 05:58:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 Jan 2020 05:58:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 9 Jan 2020 05:58:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MD6LsjXgnAPnndPAFQCl7cktyjg/yunu1laz9hSoAomCVzp0RfG8pZQ0qq2a15p6aAquz2RMIraS/XEXiIE0x9Vx6TxLrKYpr0IXY8m6S8rCnsiMQ34jrpWoU6T6AmXuwt5q65R2bIOmOzDK7ECG0BwLe0dFmb/LNg2KNS3NMAEP5Fu9ATXmDdGnueOSyjRWUB54ug6SI2orjTEp/v+uM/1VGaZ4pgRWqewB9L+nNwMoSNM4/KRfUsLX+eHMHE6c2h7ycs8otg3dyhrQ71v5cZZOpk0KfxWvovxXJ33j1OhXhF8tuvJ7u9vv9sOV9YmnqcuIY9BK4alkxwmud9BXKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wV7Yz7TkSPBZtoLXaDgsQ1Cc1LdwIHuePckpaHdGO0=;
 b=V+umkpv3QFWdu6Tg2gpMYW/k+Qwzl1GKTQKuL40SzzM8UKZ1wp+fsVVj5fOKVYw2gwITDBgpk5yUuUuUkvX1KeyN9r51h6OCCjUNp/mB+a1oXtUmzbv8Q6ODvriYawGcmtpnGrhJ/ajjyE8FkuabCKIwk06xfI2GUwrGPzvSPPTWXZF5FPp+dypztGY+ewZrqc2OwetCrUCNxzlL7QxmZyukqqo0+NZcZjTl8IUzbcm1fK70+FagFi79h3tksVdk3nSSLCIcJTXLvsm7a+J4TGRqgSZsDTmQoc/k+I09QCRlY9qctQ4CDT6dLSPjrRywIj9vLWViIx+RQ81Z2BXvKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wV7Yz7TkSPBZtoLXaDgsQ1Cc1LdwIHuePckpaHdGO0=;
 b=kFa+UF4xcAWXWDaffFUeGLqbtazoFRmk76+SZsDejgCy4H5pEMSOSYEHlmLETEVqeuFe4XIfUOEuBfYuJxKsgHwk9i/kChKOUoAVhpQdtfHpbxcaUeJcgUSc2iSJp74CiPu4W7n01CUU/dSNPCtsFgXcfByCaC+LKk5FWLQKPOg=
Received: from SN6PR11MB2830.namprd11.prod.outlook.com (52.135.91.21) by
 SN6PR11MB3184.namprd11.prod.outlook.com (52.135.111.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 12:58:45 +0000
Received: from SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::9439:53a6:d896:d176]) by SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::9439:53a6:d896:d176%7]) with mapi id 15.20.2623.008; Thu, 9 Jan 2020
 12:58:45 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <mparab@cadence.com>, <jakub.kicinski@netronome.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
CC:     <dkangude@cadence.com>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>, <Claudiu.Beznea@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <f.fainelli@gmail.com>, <pthombar@cadence.com>
Subject: Re: [PATCH net-next] net: macb: add support for C45 MDIO read/write
Thread-Topic: [PATCH net-next] net: macb: add support for C45 MDIO read/write
Thread-Index: AQHVxsgRJdTeLoudqUqYZd98iyeUCKfiS3sA
Date:   Thu, 9 Jan 2020 12:58:45 +0000
Message-ID: <b82f3c881aae730210fcbba095ed1851381d2481.camel@microchip.com>
References: <1578559006-16343-1-git-send-email-mparab@cadence.com>
In-Reply-To: <1578559006-16343-1-git-send-email-mparab@cadence.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d652330c-3b09-4f1a-272d-08d79503a987
x-ms-traffictypediagnostic: SN6PR11MB3184:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB31844749E495786F28542F33E0390@SN6PR11MB3184.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39860400002)(376002)(366004)(136003)(189003)(199004)(6486002)(2906002)(54906003)(110136005)(8676002)(2616005)(316002)(8936002)(6512007)(86362001)(81156014)(66446008)(91956017)(76116006)(64756008)(66556008)(66476007)(81166006)(71200400001)(66946007)(478600001)(7416002)(5660300002)(6506007)(186003)(26005)(4326008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3184;H:SN6PR11MB2830.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iY3tkZT4y/6dKWkxWJO9oxW33UDMJgDDaaeSHjfZmcmt2JCIuYlzQi1jIST/8mVKGhjZHIYYbE2blrATe7q/HxEfnr7jVUjsGH7jf1dc1tk+8Mw1zVGN+HEZeBo1nyMUtw9Dcya9wNKtg77o8c+urzO4Ef7ajXIpwrwMfkGydLAoNvBkWCmvxiJv1izZFpawmFnANZlFlcgge6wq7usscYj4g844I6andVHY83zooWJPUQrcGWGUoz/1iumfF8U3pU7nVFMGRAwIP9gykk+KHLc/pbNFtjEPgpHr+EtLd82taVdz73fnMi6AVSye5nb4fBKJJLZa2Pqqu2GcTaDUEsuLDkEUqUVmqJb3cw5BE1Ox2DLicsORBh+x/Q+n+dobny2YX4hSLpjknAdTTxJPKcekv8Gwz56XTINrQwQUtxNX5SkA0ZEwJXlR0iu28eAs
Content-Type: text/plain; charset="utf-8"
Content-ID: <D79D8CD6DE0E21418AF06C8D08010CB7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d652330c-3b09-4f1a-272d-08d79503a987
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 12:58:45.5633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hW2CGhnaMcxcdrhn54mudJiXWVyTYFmelAyqrxcADOHLCr+7chtJlO6mOwf1mvIu8ea65+2inPjq27NhDdEBDej6BShaKDBXM3rqZ9ShqqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3184
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TGUgamV1ZGkgMDkgamFudmllciAyMDIwIMOgIDA4OjM2ICswMDAwLCBNaWxpbmQgUGFyYWIgYSDD
qWNyaXQgOg0KPiBUaGlzIHBhdGNoIG1vZGlmeSBNRElPIHJlYWQvd3JpdGUgZnVuY3Rpb25zIHRv
IHN1cHBvcnQNCj4gY29tbXVuaWNhdGlvbiB3aXRoIEM0NSBQSFkuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBNaWxpbmQgUGFyYWIgPG1wYXJhYkBjYWRlbmNlLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEFu
ZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCg0KQWNrZWQtYnk6IE5pY29sYXMgRmVycmUgPG5p
Y29sYXMuZmVycmVAbWljcm9jaGlwLmNvbT4NCg0KVGhhbmtzIE1pbGluZC4gQmVzdCByZWdhcmRz
LA0KICBOaWNvbGFzDQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21h
Y2IuaCAgICAgIHwgMTUgKysrKy0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21h
Y2JfbWFpbi5jIHwgNjEgKysrKysrKysrKysrKysrKysrKy0tLS0tDQo+ICAyIGZpbGVzIGNoYW5n
ZWQsIDYxIGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYi5oDQo+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvY2FkZW5jZS9tYWNiLmgNCj4gaW5kZXggMTlmZTRmNDg2N2M3Li5kYmY3MDcwZmNkYmEg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYi5oDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYi5oDQo+IEBAIC02MzAsMTAgKzYz
MCwxNyBAQA0KPiAgI2RlZmluZSBHRU1fQ0xLX0RJVjk2ICAgICAgICAgICAgICAgICAgICAgICAg
ICA1DQo+IA0KPiAgLyogQ29uc3RhbnRzIGZvciBNQU4gcmVnaXN0ZXIgKi8NCj4gLSNkZWZpbmUg
TUFDQl9NQU5fU09GICAgICAgICAgICAgICAgICAgICAgICAgICAgMQ0KPiAtI2RlZmluZSBNQUNC
X01BTl9XUklURSAgICAgICAgICAgICAgICAgICAgICAgICAxDQo+IC0jZGVmaW5lIE1BQ0JfTUFO
X1JFQUQgICAgICAgICAgICAgICAgICAgICAgICAgIDINCj4gLSNkZWZpbmUgTUFDQl9NQU5fQ09E
RSAgICAgICAgICAgICAgICAgICAgICAgICAgMg0KPiArI2RlZmluZSBNQUNCX01BTl9DMjJfU09G
ICAgICAgICAgICAgICAgICAgICAgICAxDQo+ICsjZGVmaW5lIE1BQ0JfTUFOX0MyMl9XUklURSAg
ICAgICAgICAgICAgICAgICAgIDENCj4gKyNkZWZpbmUgTUFDQl9NQU5fQzIyX1JFQUQgICAgICAg
ICAgICAgICAgICAgICAgMg0KPiArI2RlZmluZSBNQUNCX01BTl9DMjJfQ09ERSAgICAgICAgICAg
ICAgICAgICAgICAyDQo+ICsNCj4gKyNkZWZpbmUgTUFDQl9NQU5fQzQ1X1NPRiAgICAgICAgICAg
ICAgICAgICAgICAgMA0KPiArI2RlZmluZSBNQUNCX01BTl9DNDVfQUREUiAgICAgICAgICAgICAg
ICAgICAgICAwDQo+ICsjZGVmaW5lIE1BQ0JfTUFOX0M0NV9XUklURSAgICAgICAgICAgICAgICAg
ICAgIDENCj4gKyNkZWZpbmUgTUFDQl9NQU5fQzQ1X1BPU1RfUkVBRF9JTkNSICAgICAgICAgICAg
Mg0KPiArI2RlZmluZSBNQUNCX01BTl9DNDVfUkVBRCAgICAgICAgICAgICAgICAgICAgICAzDQo+
ICsjZGVmaW5lIE1BQ0JfTUFOX0M0NV9DT0RFICAgICAgICAgICAgICAgICAgICAgIDINCj4gDQo+
ICAvKiBDYXBhYmlsaXR5IG1hc2sgYml0cyAqLw0KPiAgI2RlZmluZSBNQUNCX0NBUFNfSVNSX0NM
RUFSX09OX1dSSVRFICAgICAgICAgICAweDAwMDAwMDAxDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBpbmRleCA0MWM0ODU0ODU2MTkuLjdlNzM2MTc2MWY4
ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4u
Yw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IEBA
IC0zMzcsMTEgKzMzNywzMCBAQCBzdGF0aWMgaW50IG1hY2JfbWRpb19yZWFkKHN0cnVjdCBtaWlf
YnVzICpidXMsIGludA0KPiBtaWlfaWQsIGludCByZWdudW0pDQo+ICAgICAgICAgaWYgKHN0YXR1
cyA8IDApDQo+ICAgICAgICAgICAgICAgICBnb3RvIG1kaW9fcmVhZF9leGl0Ow0KPiANCj4gLSAg
ICAgICBtYWNiX3dyaXRlbChicCwgTUFOLCAoTUFDQl9CRihTT0YsIE1BQ0JfTUFOX1NPRikNCj4g
LSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKFJXLCBNQUNCX01BTl9SRUFE
KQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1BQ0JfQkYoUEhZQSwgbWlpX2lk
KQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1BQ0JfQkYoUkVHQSwgcmVnbnVt
KQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1BQ0JfQkYoQ09ERSwgTUFDQl9N
QU5fQ09ERSkpKTsNCj4gKyAgICAgICBpZiAocmVnbnVtICYgTUlJX0FERFJfQzQ1KSB7DQo+ICsg
ICAgICAgICAgICAgICBtYWNiX3dyaXRlbChicCwgTUFOLCAoTUFDQl9CRihTT0YsIE1BQ0JfTUFO
X0M0NV9TT0YpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1BQ0JfQkYoUlcsIE1B
Q0JfTUFOX0M0NV9BRERSKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JG
KFBIWUEsIG1paV9pZCkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgTUFDQl9CRihS
RUdBLCAocmVnbnVtID4+IDE2KSAmIDB4MUYpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8IE1BQ0JfQkYoREFUQSwgcmVnbnVtICYgMHhGRkZGKQ0KPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCBNQUNCX0JGKENPREUsIE1BQ0JfTUFOX0M0NV9DT0RFKSkpOw0KPiArDQo+ICsg
ICAgICAgICAgICAgICBzdGF0dXMgPSBtYWNiX21kaW9fd2FpdF9mb3JfaWRsZShicCk7DQo+ICsg
ICAgICAgICAgICAgICBpZiAoc3RhdHVzIDwgMCkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
Z290byBtZGlvX3JlYWRfZXhpdDsNCj4gKw0KPiArICAgICAgICAgICAgICAgbWFjYl93cml0ZWwo
YnAsIE1BTiwgKE1BQ0JfQkYoU09GLCBNQUNCX01BTl9DNDVfU09GKQ0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCBNQUNCX0JGKFJXLCBNQUNCX01BTl9DNDVfUkVBRCkNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgTUFDQl9CRihQSFlBLCBtaWlfaWQpDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICB8IE1BQ0JfQkYoUkVHQSwgKHJlZ251bSA+PiAxNikgJiAweDFG
KQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKENPREUsIE1BQ0JfTUFO
X0M0NV9DT0RFKSkpOw0KPiArICAgICAgIH0gZWxzZSB7DQo+ICsgICAgICAgICAgICAgICBtYWNi
X3dyaXRlbChicCwgTUFOLCAoTUFDQl9CRihTT0YsIE1BQ0JfTUFOX0MyMl9TT0YpDQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKFJXLCBNQUNCX01BTl9DMjJfUkVB
RCkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1BQ0JfQkYoUEhZQSwgbWlp
X2lkKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgTUFDQl9CRihSRUdBLCBy
ZWdudW0pDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKENPREUs
IE1BQ0JfTUFOX0MyMl9DT0RFKSkpOw0KPiArICAgICAgIH0NCj4gDQo+ICAgICAgICAgc3RhdHVz
ID0gbWFjYl9tZGlvX3dhaXRfZm9yX2lkbGUoYnApOw0KPiAgICAgICAgIGlmIChzdGF0dXMgPCAw
KQ0KPiBAQCAtMzcwLDEyICszODksMzIgQEAgc3RhdGljIGludCBtYWNiX21kaW9fd3JpdGUoc3Ry
dWN0IG1paV9idXMgKmJ1cywgaW50DQo+IG1paV9pZCwgaW50IHJlZ251bSwNCj4gICAgICAgICBp
ZiAoc3RhdHVzIDwgMCkNCj4gICAgICAgICAgICAgICAgIGdvdG8gbWRpb193cml0ZV9leGl0Ow0K
PiANCj4gLSAgICAgICBtYWNiX3dyaXRlbChicCwgTUFOLCAoTUFDQl9CRihTT0YsIE1BQ0JfTUFO
X1NPRikNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKFJXLCBNQUNC
X01BTl9XUklURSkNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKFBI
WUEsIG1paV9pZCkNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKFJF
R0EsIHJlZ251bSkNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKENP
REUsIE1BQ0JfTUFOX0NPREUpDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgTUFD
Ql9CRihEQVRBLCB2YWx1ZSkpKTsNCj4gKyAgICAgICBpZiAocmVnbnVtICYgTUlJX0FERFJfQzQ1
KSB7DQo+ICsgICAgICAgICAgICAgICBtYWNiX3dyaXRlbChicCwgTUFOLCAoTUFDQl9CRihTT0Ys
IE1BQ0JfTUFOX0M0NV9TT0YpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1BQ0Jf
QkYoUlcsIE1BQ0JfTUFOX0M0NV9BRERSKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
fCBNQUNCX0JGKFBIWUEsIG1paV9pZCkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
TUFDQl9CRihSRUdBLCAocmVnbnVtID4+IDE2KSAmIDB4MUYpDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8IE1BQ0JfQkYoREFUQSwgcmVnbnVtICYgMHhGRkZGKQ0KPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKENPREUsIE1BQ0JfTUFOX0M0NV9DT0RFKSkpOw0K
PiArDQo+ICsgICAgICAgICAgICAgICBzdGF0dXMgPSBtYWNiX21kaW9fd2FpdF9mb3JfaWRsZShi
cCk7DQo+ICsgICAgICAgICAgICAgICBpZiAoc3RhdHVzIDwgMCkNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgZ290byBtZGlvX3dyaXRlX2V4aXQ7DQo+ICsNCj4gKyAgICAgICAgICAgICAgIG1h
Y2Jfd3JpdGVsKGJwLCBNQU4sIChNQUNCX0JGKFNPRiwgTUFDQl9NQU5fQzQ1X1NPRikNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgTUFDQl9CRihSVywgTUFDQl9NQU5fQzQ1X1dSSVRF
KQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNCX0JGKFBIWUEsIG1paV9pZCkN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgTUFDQl9CRihSRUdBLCAocmVnbnVtID4+
IDE2KSAmIDB4MUYpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1BQ0JfQkYoQ09E
RSwgTUFDQl9NQU5fQzQ1X0NPREUpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1B
Q0JfQkYoREFUQSwgdmFsdWUpKSk7DQo+ICsgICAgICAgfSBlbHNlIHsNCj4gKyAgICAgICAgICAg
ICAgIG1hY2Jfd3JpdGVsKGJwLCBNQU4sIChNQUNCX0JGKFNPRiwgTUFDQl9NQU5fQzIyX1NPRikN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1BQ0JfQkYoUlcsIE1BQ0JfTUFO
X0MyMl9XUklURSkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IE1BQ0JfQkYo
UEhZQSwgbWlpX2lkKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgTUFDQl9C
RihSRUdBLCByZWdudW0pDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBNQUNC
X0JGKENPREUsIE1BQ0JfTUFOX0MyMl9DT0RFKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgTUFDQl9CRihEQVRBLCB2YWx1ZSkpKTsNCj4gKyAgICAgICB9DQo+IA0KPiAgICAg
ICAgIHN0YXR1cyA9IG1hY2JfbWRpb193YWl0X2Zvcl9pZGxlKGJwKTsNCj4gICAgICAgICBpZiAo
c3RhdHVzIDwgMCkNCj4gLS0NCj4gMi4xNy4xDQo+IA0K
