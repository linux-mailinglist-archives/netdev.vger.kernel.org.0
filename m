Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6315AEE6
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgBLRlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:41:16 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:19085 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgBLRlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:41:16 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 1RHY2CfYUkHbQmfnwi1lEOIK3dGrWeM/uLJTo/5F/qV8i0zv6zprdxZfz8r12CKKFnZJCUIAfX
 GPLGgDI1AXKiTew5PfIRZdvyuuxcPO1oNOtI1ii2n+1di3BgdUeckbQ2pn+oVdirFF7wpTYxMg
 7eEz+e43N25O+IFkVmBYFAYRZ4nXzhxTbr8z5BNlxfLTo4+fupK34r03OXNWt5Q5oFNL4w/QRH
 eUSDlBY4iBMgy6dxtcgkO8oaoiGpMPBTryAwqpkSW8LRXI1a27PzbX6NIAC6gPQH8sQhYwbR7t
 uzU=
X-IronPort-AV: E=Sophos;i="5.70,433,1574146800"; 
   d="scan'208";a="65174265"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2020 10:41:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Feb 2020 10:41:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 12 Feb 2020 10:41:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRZADvkmOXULA9B3C/SzeUD+enMIy/TC9hbzzzpQLlZBk0QZM3AF4HvI09UkOqSc6Mq1Cm3ebjjj6HmJvjdhBiF6EAokujMONXzqNTpGF/7KhzWCXbNEjOHrR9KDZQkWUHaeWK8RZdwfANyYOSMmlcYhPyjo04GaVWF49CCETzV34E5wgoMuPsRanRBOzwdLqRirMvytIs64OgfdGHWDzw4SWxw+iHlDjHM/JqeJA8cPppb8yvCMdWFnbQCj+VEQ7IHGfUFdoZpKJIYYLIjk37+/GouBmm0THc9olMEyyghliV6NsLbtRGTvZnD1HK1fz9LHZc4rQaHch6JwMNU0tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzdGJezmkFzNN180i7jHMqQsQWtnWXToOBNkvnvvxqo=;
 b=ilSDC7LAGoNU4Sipk9y9wlOTNCXQaYyPUhdQdN7/wSWakUoohxYLdxKViCgtNnKzhioRijk7zjnGVJGTCpZ939mGG3WxbYv9263LzOcJjzcluRU4xW0bAFPbEOfuM0n6sE1aSpEvSNcu4LbJMjDjZbkCu6MGo4UOcQgTHa0EFJgI+5x1yOfrpk/O2k+WsIMJrYVItG12ZLzPvy2y29PDR+QnbtLRnl3fJvBt90Jv1IVQc+gqUSh2sgvqDTZuGzc1WjPXoR1Pck1fQIVwbxbR0mC2Uxo9PnLc4cx2RQZr6NaPS5hHCGNXzNRpAMp4akscxxAVTePhHrg6B7OCuhxbpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzdGJezmkFzNN180i7jHMqQsQWtnWXToOBNkvnvvxqo=;
 b=l0ZehEK1ieGQRUq5kJSd0LBneyMBaFF2nRwGGOyIYHgXw0hITNjX6KB+tfxGKx3ZmOCkGLk+qRObRffLAWQENXbN3ntMPtDNERfX/wCkY+5zHdcWW1gcgM27IIDwLh0gNzF6TjY2adJfyg4mtGjGz047TyYiaT9gmTdTsgUBoNs=
Received: from DM6PR11MB3225.namprd11.prod.outlook.com (20.176.120.224) by
 DM6PR11MB4412.namprd11.prod.outlook.com (52.132.248.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.25; Wed, 12 Feb 2020 17:41:12 +0000
Received: from DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::dc6b:1191:3a76:8b6a]) by DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::dc6b:1191:3a76:8b6a%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 17:41:12 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <alexandre.belloni@bootlin.com>, <davem@davemloft.net>
CC:     <Nicolas.Ferre@microchip.com>, <harini.katakam@xilinx.com>,
        <shubhrajyoti.datta@xilinx.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: macb: ensure interface is not suspended on
 at91rm9200
Thread-Topic: [PATCH net] net: macb: ensure interface is not suspended on
 at91rm9200
Thread-Index: AQHV4cueHo/KwsB3c0m5FenGWngNKw==
Date:   Wed, 12 Feb 2020 17:41:12 +0000
Message-ID: <bdf8550b-e49f-5e3a-2cfb-02ae7b7bf26e@microchip.com>
References: <20200212164538.383741-1-alexandre.belloni@bootlin.com>
In-Reply-To: <20200212164538.383741-1-alexandre.belloni@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2e847b8-ff0c-435b-6d13-08d7afe2c0d1
x-ms-traffictypediagnostic: DM6PR11MB4412:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4412218DBCA59063FA34BBF3871B0@DM6PR11MB4412.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(136003)(376002)(346002)(189003)(199004)(6486002)(31696002)(64756008)(4326008)(66946007)(15650500001)(71200400001)(5660300002)(76116006)(26005)(91956017)(36756003)(66556008)(6506007)(86362001)(66476007)(66446008)(6512007)(53546011)(31686004)(54906003)(110136005)(81156014)(2906002)(186003)(478600001)(316002)(81166006)(2616005)(8676002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB4412;H:DM6PR11MB3225.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SEpT8mXWx7exRGLs1FpX5X5js569LsIvCZ9L9ugIGh0lPG81WKibib0TaYudNzrrFty47OEsCLs8JmbQNI8mP+sxi2ikz5+tuyXsZPdoSssWrLppIJjVB6SkvOHMvMuUp2ebLnNCHOFzV7AkFYa9EfYsim0izFo7kF2QwjcmfdyS5hhQztOdL99Gz1wLtgQzlIkclJY+Cni+SKK2YJHaRQUMTSF0DMCbxVRZx2DkRZViXceVpyn5vb3s1Q3JL+mxwFXaCgzJx5df5a5rPm91tnrlncsn6G6/ZWYY6b30X5pLvTq+vKFFEwxDI8hVzRsFYo3xarLr1EsBYhVNMjm7WyV2mpP9yMJYtNdfa0WTopIOh4K6tqXr20suAA3E03YvrTLwKlxuGGGNYxZbW700XWXH151hsYjbzDlqjUq31nW8S6XJYSyf/KjDoXMA3q3u
x-ms-exchange-antispam-messagedata: EozoTu686hAyGJ+HE4+/DsSMW6wxtyilOcWBeLd/FaBirvv5Oszl2HDqvA2qB6yf+QAR5JKNalGMyLQwxeWoGKYQnSutV5VRKnb/7W6OMg6PKLUeyTHaK26KzfeacnpM6/CoIFia8/sP429YDk0uaA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <75B9403E1075C14A90568274E66FBB60@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e847b8-ff0c-435b-6d13-08d7afe2c0d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 17:41:12.7485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TXSoR7Pz6IwHQiHH6E9e6opuprovo0ycKMXU94JVRZtXNM/BuOH5VfAO82kmtYkcicFv00SY6XtwIwJJzsyAwAnfV7A/SWk2vO9i1Ty1UXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLjAyLjIwMjAgMTg6NDUsIEFsZXhhbmRyZSBCZWxsb25pIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEJlY2F1c2Ugb2YgYXV0b3N1c3Bl
bmQsIGF0OTFldGhlcl9zdGFydCBpcyBjYWxsZWQgd2l0aCBjbG9ja3MgZGlzYWJsZWQuDQo+IEVu
c3VyZSB0aGF0IHBtX3J1bnRpbWUgZG9lc24ndCBzdXNwZW5kIHRoZSBpbnRlcmZhY2UgYXMgc29v
biBhcyBpdCBpcw0KPiBvcGVuZWQgYXMgdGhlcmUgaXMgbm8gcG1fcnVudGltZSBzdXBwb3J0IGlz
IHRoZSBvdGhlciByZWxldmFudCBwYXJ0cyBvZiB0aGUNCj4gcGxhdGZvcm0gc3VwcG9ydCBmb3Ig
YXQ5MXJtOTIwMC4NCj4gDQo+IEZpeGVzOiBkNTRmODlhZjZjYzQgKCJuZXQ6IG1hY2I6IEFkZCBw
bSBydW50aW1lIHN1cHBvcnQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcmUgQmVsbG9uaSA8
YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+DQoNClJldmlld2VkLWJ5OiBDbGF1ZGl1IEJl
em5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0KPiAtLS0NCj4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCA2ICsrKysrLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IDQ1MDhmMGQxNTBkYS4uZGVmOTRl
OTE4ODNhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2Jf
bWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMN
Cj4gQEAgLTM3OTAsNiArMzc5MCwxMCBAQCBzdGF0aWMgaW50IGF0OTFldGhlcl9vcGVuKHN0cnVj
dCBuZXRfZGV2aWNlICpkZXYpDQo+ICAgICAgICAgdTMyIGN0bDsNCj4gICAgICAgICBpbnQgcmV0
Ow0KPiANCj4gKyAgICAgICByZXQgPSBwbV9ydW50aW1lX2dldF9zeW5jKCZscC0+cGRldi0+ZGV2
KTsNCj4gKyAgICAgICBpZiAocmV0IDwgMCkNCj4gKyAgICAgICAgICAgICAgIHJldHVybiByZXQ7
DQo+ICsNCj4gICAgICAgICAvKiBDbGVhciBpbnRlcm5hbCBzdGF0aXN0aWNzICovDQo+ICAgICAg
ICAgY3RsID0gbWFjYl9yZWFkbChscCwgTkNSKTsNCj4gICAgICAgICBtYWNiX3dyaXRlbChscCwg
TkNSLCBjdGwgfCBNQUNCX0JJVChDTFJTVEFUKSk7DQo+IEBAIC0zODU0LDcgKzM4NTgsNyBAQCBz
dGF0aWMgaW50IGF0OTFldGhlcl9jbG9zZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHEtPnJ4X2J1ZmZlcnMsIHEtPnJ4X2J1ZmZlcnNfZG1hKTsN
Cj4gICAgICAgICBxLT5yeF9idWZmZXJzID0gTlVMTDsNCj4gDQo+IC0gICAgICAgcmV0dXJuIDA7
DQo+ICsgICAgICAgcmV0dXJuIHBtX3J1bnRpbWVfcHV0KCZscC0+cGRldi0+ZGV2KTsNCj4gIH0N
Cj4gDQo+ICAvKiBUcmFuc21pdCBwYWNrZXQgKi8NCj4gLS0NCj4gMi4yNC4xDQo+IA0KPiA=
