Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06884155A1
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEFV3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 17:29:35 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12930 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEFV3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 17:29:34 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Woojung.Huh@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Woojung.Huh@microchip.com";
  x-sender="Woojung.Huh@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  a:mx1.microchip.iphmx.com a:mx2.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Woojung.Huh@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Woojung.Huh@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,439,1549954800"; 
   d="scan'208";a="33461632"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 06 May 2019 14:29:33 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 6 May 2019 14:29:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz4unriP6vkqt6KG0HTVxImRo2Alxmy+fyKM0lqVdYU=;
 b=EzEITD7WFSU/qUi7DUDxXpXxWdolCW2/9zqRd0keoaX5xgJKkIhHdZc6xNlMhi+2zld1cDL09rJUTLODWBtdurAYnfo2jEh8HT2/6Ujm76HUJXX5Xv/SXjnM2XK9p3LWiK0d4XPLJf037An0DwTvGKK/OOf9Yejak6+osxfcxoc=
Received: from DM5PR1101MB2139.namprd11.prod.outlook.com (10.174.104.136) by
 DM5PR1101MB2090.namprd11.prod.outlook.com (10.174.104.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Mon, 6 May 2019 21:29:18 +0000
Received: from DM5PR1101MB2139.namprd11.prod.outlook.com
 ([fe80::dcb0:6ce:8f02:9d65]) by DM5PR1101MB2139.namprd11.prod.outlook.com
 ([fe80::dcb0:6ce:8f02:9d65%3]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 21:29:18 +0000
From:   <Woojung.Huh@microchip.com>
To:     <ynezz@true.cz>, <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <steve.glendinning@shawell.net>, <UNGLinuxDriver@microchip.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <frowand.list@gmail.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <maxime.ripard@bootlin.com>, <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next v2 4/4] net: usb: smsc: fix warning reported by
 kbuild test robot
Thread-Topic: [PATCH net-next v2 4/4] net: usb: smsc: fix warning reported by
 kbuild test robot
Thread-Index: AQHVBFKA7+FmJGtDekycg4kDQT61q6ZenKEg
Date:   Mon, 6 May 2019 21:29:18 +0000
Message-ID: <DM5PR1101MB21399FAD9C7E072F24207C14E7300@DM5PR1101MB2139.namprd11.prod.outlook.com>
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
 <1557177887-30446-5-git-send-email-ynezz@true.cz>
In-Reply-To: <1557177887-30446-5-git-send-email-ynezz@true.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d876469-f074-4f84-2d07-08d6d269e596
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM5PR1101MB2090;
x-ms-traffictypediagnostic: DM5PR1101MB2090:
x-microsoft-antispam-prvs: <DM5PR1101MB2090F33ADC151AA37234D676E7300@DM5PR1101MB2090.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(366004)(346002)(39860400002)(189003)(199004)(33656002)(7696005)(86362001)(229853002)(316002)(110136005)(14444005)(8676002)(256004)(72206003)(54906003)(478600001)(99286004)(52536014)(6636002)(76176011)(81166006)(6246003)(66476007)(7416002)(64756008)(55016002)(66446008)(66556008)(73956011)(66946007)(9686003)(4326008)(53936002)(8936002)(25786009)(6116002)(3846002)(6436002)(76116006)(68736007)(486006)(71200400001)(71190400001)(66574012)(66066001)(305945005)(14454004)(7736002)(81156014)(446003)(11346002)(476003)(5660300002)(6506007)(26005)(2501003)(74316002)(102836004)(2906002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR1101MB2090;H:DM5PR1101MB2139.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jfM9JAw2WI01RYvQnbkGVl+fT2Qv4vi2ZotEaqeI8rnn+PU/Rthha5IDTxTGuh/SXtT+3Lm1unHb99oZISHDh9HtTCrN1/IGXWWOWXUKnSgyZdOvhcMjYFWMc7j0AI6QhjTytPmrUEfV4bRB0FAPeaXyBOpxsMA+GyjRqqSPnneGcjDjqcqTMMwrpuhXMzoyIW1+NMIrmqpK9Mk+jLHdA785025OSNOooBtTiv6SllFi5TGrBbL3Ugr8EdRxdMxBFu2bTbqRNvTVFFSyNJqSgLtTkba6xFgZn7MUXUm36tZ1AmHZkTaVNgOwKwaWzhHS1C6pg+csCJLo0t/5KCvCgKT0rwIaqwK0pWAe6lf6Bzw2PNW1KDD8ab7thAPMmnuYzft3skhfze1jqs+cy9W1tX8zAPY1ETJSZYOO+584lp0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d876469-f074-4f84-2d07-08d6d269e596
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 21:29:18.3226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2090
X-OriginatorOrg: microchip.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBUaGlzIHBhdGNoIGZpeGVzIGZvbGxvd2luZyB3YXJuaW5nIHJlcG9ydGVkIGJ5IGtidWlsZCB0
ZXN0IHJvYm90Og0KPiANCj4gIEluIGZ1bmN0aW9uIOKAmG1lbWNweeKAmSwNCj4gICAgICBpbmxp
bmVkIGZyb20g4oCYc21zYzc1eHhfaW5pdF9tYWNfYWRkcmVzc+KAmSBhdCBkcml2ZXJzL25ldC91
c2Ivc21zYzc1eHguYzo3Nzg6MywNCj4gICAgICBpbmxpbmVkIGZyb20g4oCYc21zYzc1eHhfYmlu
ZOKAmSBhdCBkcml2ZXJzL25ldC91c2Ivc21zYzc1eHguYzoxNTAxOjI6DQo+ICAuL2luY2x1ZGUv
bGludXgvc3RyaW5nLmg6MzU1Ojk6IHdhcm5pbmc6IGFyZ3VtZW50IDIgbnVsbCB3aGVyZSBub24t
bnVsbCBleHBlY3RlZCBbLVdub25udWxsXQ0KPiAgICByZXR1cm4gX19idWlsdGluX21lbWNweShw
LCBxLCBzaXplKTsNCj4gICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4g
IGRyaXZlcnMvbmV0L3VzYi9zbXNjNzV4eC5jOiBJbiBmdW5jdGlvbiDigJhzbXNjNzV4eF9iaW5k
4oCZOg0KPiAgLi9pbmNsdWRlL2xpbnV4L3N0cmluZy5oOjM1NTo5OiBub3RlOiBpbiBhIGNhbGwg
dG8gYnVpbHQtaW4gZnVuY3Rpb24g4oCYX19idWlsdGluX21lbWNweeKAmQ0KPiANCj4gSSd2ZSBy
ZXBsYWNlZCB0aGUgb2ZmZW5kaW5nIG1lbWNweSB3aXRoIGV0aGVyX2FkZHJfY29weSwgYmVjYXVz
ZSBJJ20NCj4gMTAwJSBzdXJlLCB0aGF0IG9mX2dldF9tYWNfYWRkcmVzcyBjYW4ndCByZXR1cm4g
TlVMTCBhcyBpdCByZXR1cm5zIHZhbGlkDQo+IHBvaW50ZXIgb3IgRVJSX1BUUiBlbmNvZGVkIHZh
bHVlLCBub3RoaW5nIGVsc2UuDQo+IA0KPiBJJ20gaGVzaXRhbnQgdG8ganVzdCBjaGFuZ2UgSVNf
RVJSIGludG8gSVNfRVJSX09SX05VTEwgY2hlY2ssIGFzIHRoaXMNCj4gd291bGQgbWFrZSB0aGUg
d2FybmluZyBkaXNhcHBlYXIgYWxzbywgYnV0IGl0IHdvdWxkIGJlIGNvbmZ1c2luZyB0bw0KPiBj
aGVjayBmb3IgaW1wb3NzaWJsZSByZXR1cm4gdmFsdWUganVzdCB0byBtYWtlIGEgY29tcGlsZXIg
aGFwcHkuDQo+IA0KPiBGaXhlczogYWRmYjNjYjJjNTJlICgibmV0OiB1c2I6IHN1cHBvcnQgb2Zf
Z2V0X21hY19hZGRyZXNzIG5ldyBFUlJfUFRSIGVycm9yIikNCj4gUmVwb3J0ZWQtYnk6IGtidWls
ZCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBQZXRyIMWgdGV0
aWFyIDx5bmV6ekB0cnVlLmN6Pg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFdvb2p1bmcgSHVoIDx3
b29qdW5nLmh1aEBtaWNyb2NoaXAuY29tPg0KDQo=
