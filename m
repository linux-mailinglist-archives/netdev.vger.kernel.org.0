Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D4120DAF8
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388675AbgF2UCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:02:21 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16407 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731899AbgF2UCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593460932; x=1624996932;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=EB+APyaleRVmPJVAGCa5i+yCnTzlPa1QLxtKMqPwPJU=;
  b=A30kY/dncR1FRoTCBuF4rN26zeyGbf5lnvWu0tBRR45M3Jwl68rhrrjA
   l3IwfCQ6TMe7al2bhKyAn1Fv3BqxOaKbcP2jw4VRNRkZDPQYXRjyp668n
   t5S/koDdAMJnHprF6vw3ixs1vaHadirhW/WGrXv66sTCdekNrWqQ0OT4E
   ATA0dl3wf8Uh1I1SaKBypfxNF6xDKenmaNy56RHaITTV3ftSZenaN2/Fj
   tuS2jmunBB4wnmfO26+8avjDg/O3UpCdrTPwo6CWq9huFi+WpKEnnW3fm
   lJmCG88q6uyJN8Nlszhl2TXC+H7+OLKLgkn94kXFABs1rnrc2iF4Avrfz
   g==;
IronPort-SDR: s2A854RC44Ng6FSMBB+VDmYLYbaKI8leO6uH5HlLjf8IdKHgJt4WOCU2fdna+fWCCFLZdTXgSN
 LLOeVyXPpXcT2cvKb6AP2HrsMrlzZgAFKK4Ewm1STF5+FBQ5FbntASeICNkGUQPIgVVN9Grv4+
 m9BYzpP8SN47TNe1kCa7xWy/P8p8slaZ9K2IezOydBVkMFlnfLjzYAlh+ZoY/C5zpDHVBSVU+R
 jyB2DPTnNiCO5cM13y6jEf2qpze/H6L1mwy4qf+YRbRLjOcmBn5SMLFpMFbKwT4jwSKYPs8mPB
 FyQ=
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="85542655"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 13:01:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 13:01:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 29 Jun 2020 13:01:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wsb+uyZ86sPf4VGj0ayDoXO+QBzSMDtOsy9kWYOf97Z1QeOKwt6OY4TXv83ENF3TJOBYk6kUGbQTeGwirEGDVPv2xdMedrha1Ry19qXXfz+jYJgnucsmv6EyqjlHhK83cqKGN3fi2wRDVfCYe5AyfFFVTmycA/r3n7ru6x9n+05Ro9doOly404YlU8L03490FVJu4eJTF54Zflbnv4kIeRG9YZkfNs/CsTvyg2QQDnQMvI4893KfxYCRSWbwKWrQYkUyLjM9a/wamT4uo3iJTt6/X6y6CNOneHgVpEQTwb+vdSFSnhFoWzM86y6xZCRAIIGex9zrx81npUxLc1T8RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EB+APyaleRVmPJVAGCa5i+yCnTzlPa1QLxtKMqPwPJU=;
 b=bChGzZ8DIW8cUkAiBc1vRL1ZXGwVlvsRAt+D6+AgDAEChKiwHtE6y4ZAWz//29YUc5FTkLs0/aQVr/IWb5PLx5IrfZj9LJ7n9QktMuvKFi0u7OR2FEwehi75N4TfLEndJ82Dp+UdxVC+bxYDKzrvqJ+rN7MqU7O75kdKlti/PS+Fye/y1cUeZdg6IRtIdqECJjjpLKnqXBTzRES76LA96zwTQl9mN/civ5ZGpruWDwfQ7YyGQ6WWLIxT3GhOhsHco9YSm5ytwhSwqu7/aq0HR0ZApfXCjezMr2EAvTCu/aTRKCxNnfPu7jIkvJvckkDSTxfBVpYOd9/wKYEVEAw4kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EB+APyaleRVmPJVAGCa5i+yCnTzlPa1QLxtKMqPwPJU=;
 b=F7bteOrZ2hJ3bWyJEIXb+NtXZ+NnL4TPpKe4QLHadup23lJcgMbNf8AFdHWOPDMveujl6HcPAPbmD2EnMQjn+XH7uAIcM3JuPd0rXtMtOx8rPjrUfLHJ3QOQVI5R3xv29lL6b7WAvFjvfHVKn1nqWESYBBjBWI9TN1xj4fSYkvE=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BYAPR11MB2792.namprd11.prod.outlook.com (2603:10b6:a02:c3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Mon, 29 Jun
 2020 20:01:50 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 20:01:50 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 5/8] smsc95xx: use PAL framework read/write functions
Thread-Topic: [PATCH net-next 5/8] smsc95xx: use PAL framework read/write
 functions
Thread-Index: AQHWTlAgCd9g40loA0yzf+9zUiDr1w==
Date:   Mon, 29 Jun 2020 20:01:50 +0000
Message-ID: <1042a3a5a592b489ca803fadc5ddbb8d7b8ad82f.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [93.202.178.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7586f594-51c6-44c6-5769-08d81c67433a
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2792E91AFAD1C498590C4B98EC6E0@BYAPR11MB2792.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:255;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcoYKK2GI303+cC3nSo/Da9ilPORpL8LTpNpjkrFudZhWvWR8a5dTYxLcP+I5kScna9+S2QtAobQrAn4R/Pcg3oc0RvUlatPyFaEkSByU1EJ472j0IAGLWm9Q73adVPgIKkeP/BVo4+DzDifQZDB+QpAjY2r+HbsIiAiXDhfhB7x1in4NTfqNgl2ens9VSFK8j9jLdIkDlzggEPVdeoEyHNKTG61HfIzY95U1x4yJM3TV/KarCdWH4Egsd3nvsoZIl0CZoOQr034QVT9/C8Bzo0QXhLNKFq8PADrltmlYNqvclKso6/+65mmMRm6Kdqy8cubS/bINvQ+lk7bhGieuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(6506007)(4326008)(110136005)(478600001)(2616005)(2906002)(8676002)(316002)(8936002)(36756003)(6512007)(186003)(86362001)(83380400001)(71200400001)(26005)(6486002)(76116006)(107886003)(91956017)(5660300002)(66446008)(64756008)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KHOvojJl8F2X6GAhrSfbWfGpMC2MkZrfQFdMIyz6afxwood+nSGIfgwViXc+U5eQs6Kc9enF+sO1wZNRFaaPedwWRotapL5bWQNP3KkyGLk2kx/qxZAwbmoiacKApF+m57ZimxNXvlbEMgCvskC8yCYYUs6BUjYHxuYue2yLTWrHbAk8gvwkM68Uon2IRxEGlnVi+njRcegQkSTKYWj9Pq4yEIYfT+k5rtmMniklTXqoi+5FgA+ITFKrELysmbqMa79iCDNVCW5gJfXFvMHlejcD5fZpHWuHulTEIGzRQKdGf9Y9uF+zeNHGPl0Juc8RmTRCRF2R76s0H52rx3baI6HuPMqWPpEerv3NqZalh0XPpNlbBcVJoGtt2guGgjl/jfKHmQ91xoL313cvPZDPc5t09n+L6bs6Xt0LTCGiwFoPd0nVAzvGOiSovTAwetd0wy1sv6hODG86QVvQYCtmX0DFAAFBJSiP9x8QapWw1odTB7npyKWU5RsQ2xdl1hva
Content-Type: text/plain; charset="utf-8"
Content-ID: <405BC85156EFD644B6F786613ED5185A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7586f594-51c6-44c6-5769-08d81c67433a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 20:01:50.5932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mvx7zjApsWCZ/7ND9BlNlx8ZeXM9TjA6E9k8OGzbUyjCAAmvYGo+yYjZc1MXD9FCr2cQV55FNjXvoyb+D9zrTw8SX4hkgEQJX6XeF+ktR3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VXNlIGZ1bmN0aW9ucyBwaHlfcmVhZCBhbmQgcGh5X3dyaXRlIGluc3RlYWQgb2Ygc21zYzk1eHhf
bWRpb19yZWFkIGFuZA0Kc21zYzk1eHhfbWRpb193cml0ZSByZXNwZWN0aXZlbHkuDQoNClNpZ25l
ZC1vZmYtYnk6IEFuZHJlIEVkaWNoIDxhbmRyZS5lZGljaEBtaWNyb2NoaXAuY29tPg0KLS0tDQog
ZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgfCAzMyArKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25z
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYyBiL2RyaXZlcnMv
bmV0L3VzYi9zbXNjOTV4eC5jDQppbmRleCAzYjhmN2U0MzlmNDQuLjExYWY1ZDVlY2U2MCAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5jDQorKysgYi9kcml2ZXJzL25ldC91
c2Ivc21zYzk1eHguYw0KQEAgLTU3NCw3ICs1NzQsNyBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X2xp
bmtfcmVzZXQoc3RydWN0IHVzYm5ldCAqZGV2KQ0KIAlpbnQgcmV0Ow0KIA0KIAkvKiBjbGVhciBp
bnRlcnJ1cHQgc3RhdHVzICovDQotCXJldCA9IHNtc2M5NXh4X21kaW9fcmVhZChkZXYtPm5ldCwg
bWlpLT5waHlfaWQsIFBIWV9JTlRfU1JDKTsNCisJcmV0ID0gcGh5X3JlYWQocGRhdGEtPnBoeWRl
diwgUEhZX0lOVF9TUkMpOw0KIAlpZiAocmV0IDwgMCkNCiAJCXJldHVybiByZXQ7DQogDQpAQCAt
NTg0LDggKzU4NCw4IEBAIHN0YXRpYyBpbnQgc21zYzk1eHhfbGlua19yZXNldChzdHJ1Y3QgdXNi
bmV0ICpkZXYpDQogDQogCW1paV9jaGVja19tZWRpYShtaWksIDEsIDEpOw0KIAltaWlfZXRodG9v
bF9nc2V0KCZkZXYtPm1paSwgJmVjbWQpOw0KLQlsY2xhZHYgPSBzbXNjOTV4eF9tZGlvX3JlYWQo
ZGV2LT5uZXQsIG1paS0+cGh5X2lkLA0KTUlJX0FEVkVSVElTRSk7DQotCXJtdGFkdiA9IHNtc2M5
NXh4X21kaW9fcmVhZChkZXYtPm5ldCwgbWlpLT5waHlfaWQsIE1JSV9MUEEpOw0KKwlsY2xhZHYg
PSBwaHlfcmVhZChwZGF0YS0+cGh5ZGV2LCBNSUlfQURWRVJUSVNFKTsNCisJcm10YWR2ID0gcGh5
X3JlYWQocGRhdGEtPnBoeWRldiwgTUlJX0xQQSk7DQogDQogCW5ldGlmX2RiZyhkZXYsIGxpbmss
IGRldi0+bmV0LA0KIAkJICAic3BlZWQ6ICV1IGR1cGxleDogJWQgbGNsYWR2OiAlMDR4IHJtdGFk
djogJTA0eFxuIiwNCkBAIC03NTMsMTAgKzc1MywxMSBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X2V0
aHRvb2xfc2V0X3dvbChzdHJ1Y3QNCm5ldF9kZXZpY2UgKm5ldCwNCiBzdGF0aWMgaW50IGdldF9t
ZGl4X3N0YXR1cyhzdHJ1Y3QgbmV0X2RldmljZSAqbmV0KQ0KIHsNCiAJc3RydWN0IHVzYm5ldCAq
ZGV2ID0gbmV0ZGV2X3ByaXYobmV0KTsNCisJc3RydWN0IHNtc2M5NXh4X3ByaXYgKnBkYXRhID0g
KHN0cnVjdCBzbXNjOTV4eF9wcml2ICopKGRldi0NCj4gZGF0YVswXSk7DQogCXUzMiB2YWw7DQog
CWludCBidWY7DQogDQotCWJ1ZiA9IHNtc2M5NXh4X21kaW9fcmVhZChkZXYtPm5ldCwgZGV2LT5t
aWkucGh5X2lkLA0KU1BFQ0lBTF9DVFJMX1NUUyk7DQorCWJ1ZiA9IHBoeV9yZWFkKHBkYXRhLT5w
aHlkZXYsIFNQRUNJQUxfQ1RSTF9TVFMpOw0KIAlpZiAoYnVmICYgU1BFQ0lBTF9DVFJMX1NUU19P
VlJSRF9BTURJWF8pIHsNCiAJCWlmIChidWYgJiBTUEVDSUFMX0NUUkxfU1RTX0FNRElYX0VOQUJM
RV8pDQogCQkJcmV0dXJuIEVUSF9UUF9NRElfQVVUTzsNCkBAIC03ODIsMzkgKzc4MywzMSBAQCBz
dGF0aWMgdm9pZCBzZXRfbWRpeF9zdGF0dXMoc3RydWN0IG5ldF9kZXZpY2UNCipuZXQsIF9fdTgg
bWRpeF9jdHJsKQ0KIAkgICAgKHBkYXRhLT5jaGlwX2lkID09IElEX1JFVl9DSElQX0lEXzg5NTMw
XykgfHwNCiAJICAgIChwZGF0YS0+Y2hpcF9pZCA9PSBJRF9SRVZfQ0hJUF9JRF85NzMwXykpIHsN
CiAJCS8qIEV4dGVuZCBNYW51YWwgQXV0b01ESVggdGltZXIgZm9yIDk1MDBBLzk1MDBBaSAqLw0K
LQkJYnVmID0gc21zYzk1eHhfbWRpb19yZWFkKGRldi0+bmV0LCBkZXYtPm1paS5waHlfaWQsDQot
CQkJCQkgUEhZX0VEUERfQ09ORklHKTsNCisJCWJ1ZiA9IHBoeV9yZWFkKHBkYXRhLT5waHlkZXYs
IFBIWV9FRFBEX0NPTkZJRyk7DQogCQlidWYgfD0gUEhZX0VEUERfQ09ORklHX0VYVF9DUk9TU09W
RVJfOw0KLQkJc21zYzk1eHhfbWRpb193cml0ZShkZXYtPm5ldCwgZGV2LT5taWkucGh5X2lkLA0K
LQkJCQkgICAgUEhZX0VEUERfQ09ORklHLCBidWYpOw0KKwkJcGh5X3dyaXRlKHBkYXRhLT5waHlk
ZXYsIFBIWV9FRFBEX0NPTkZJRywgYnVmKTsNCiAJfQ0KIA0KIAlpZiAobWRpeF9jdHJsID09IEVU
SF9UUF9NREkpIHsNCi0JCWJ1ZiA9IHNtc2M5NXh4X21kaW9fcmVhZChkZXYtPm5ldCwgZGV2LT5t
aWkucGh5X2lkLA0KLQkJCQkJIFNQRUNJQUxfQ1RSTF9TVFMpOw0KKwkJYnVmID0gcGh5X3JlYWQo
cGRhdGEtPnBoeWRldiwgU1BFQ0lBTF9DVFJMX1NUUyk7DQogCQlidWYgfD0gU1BFQ0lBTF9DVFJM
X1NUU19PVlJSRF9BTURJWF87DQogCQlidWYgJj0gfihTUEVDSUFMX0NUUkxfU1RTX0FNRElYX0VO
QUJMRV8gfA0KIAkJCSBTUEVDSUFMX0NUUkxfU1RTX0FNRElYX1NUQVRFXyk7DQotCQlzbXNjOTV4
eF9tZGlvX3dyaXRlKGRldi0+bmV0LCBkZXYtPm1paS5waHlfaWQsDQotCQkJCSAgICBTUEVDSUFM
X0NUUkxfU1RTLCBidWYpOw0KKwkJcGh5X3dyaXRlKHBkYXRhLT5waHlkZXYsIFNQRUNJQUxfQ1RS
TF9TVFMsIGJ1Zik7DQogCX0gZWxzZSBpZiAobWRpeF9jdHJsID09IEVUSF9UUF9NRElfWCkgew0K
LQkJYnVmID0gc21zYzk1eHhfbWRpb19yZWFkKGRldi0+bmV0LCBkZXYtPm1paS5waHlfaWQsDQot
CQkJCQkgU1BFQ0lBTF9DVFJMX1NUUyk7DQorCQlidWYgPSBwaHlfcmVhZChwZGF0YS0+cGh5ZGV2
LCBTUEVDSUFMX0NUUkxfU1RTKTsNCiAJCWJ1ZiB8PSBTUEVDSUFMX0NUUkxfU1RTX09WUlJEX0FN
RElYXzsNCiAJCWJ1ZiAmPSB+KFNQRUNJQUxfQ1RSTF9TVFNfQU1ESVhfRU5BQkxFXyB8DQogCQkJ
IFNQRUNJQUxfQ1RSTF9TVFNfQU1ESVhfU1RBVEVfKTsNCiAJCWJ1ZiB8PSBTUEVDSUFMX0NUUkxf
U1RTX0FNRElYX1NUQVRFXzsNCi0JCXNtc2M5NXh4X21kaW9fd3JpdGUoZGV2LT5uZXQsIGRldi0+
bWlpLnBoeV9pZCwNCi0JCQkJICAgIFNQRUNJQUxfQ1RSTF9TVFMsIGJ1Zik7DQorCQlwaHlfd3Jp
dGUocGRhdGEtPnBoeWRldiwgU1BFQ0lBTF9DVFJMX1NUUywgYnVmKTsNCiAJfSBlbHNlIGlmICht
ZGl4X2N0cmwgPT0gRVRIX1RQX01ESV9BVVRPKSB7DQotCQlidWYgPSBzbXNjOTV4eF9tZGlvX3Jl
YWQoZGV2LT5uZXQsIGRldi0+bWlpLnBoeV9pZCwNCi0JCQkJCSBTUEVDSUFMX0NUUkxfU1RTKTsN
CisJCWJ1ZiA9IHBoeV9yZWFkKHBkYXRhLT5waHlkZXYsIFNQRUNJQUxfQ1RSTF9TVFMpOw0KIAkJ
YnVmICY9IH5TUEVDSUFMX0NUUkxfU1RTX09WUlJEX0FNRElYXzsNCiAJCWJ1ZiAmPSB+KFNQRUNJ
QUxfQ1RSTF9TVFNfQU1ESVhfRU5BQkxFXyB8DQogCQkJIFNQRUNJQUxfQ1RSTF9TVFNfQU1ESVhf
U1RBVEVfKTsNCiAJCWJ1ZiB8PSBTUEVDSUFMX0NUUkxfU1RTX0FNRElYX0VOQUJMRV87DQotCQlz
bXNjOTV4eF9tZGlvX3dyaXRlKGRldi0+bmV0LCBkZXYtPm1paS5waHlfaWQsDQotCQkJCSAgICBT
UEVDSUFMX0NUUkxfU1RTLCBidWYpOw0KKwkJcGh5X3dyaXRlKHBkYXRhLT5waHlkZXYsIFNQRUNJ
QUxfQ1RSTF9TVFMsIGJ1Zik7DQogCX0NCiAJcGRhdGEtPm1kaXhfY3RybCA9IG1kaXhfY3RybDsN
CiB9DQo=
