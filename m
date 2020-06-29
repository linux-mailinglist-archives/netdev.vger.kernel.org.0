Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58E820D4E5
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgF2TMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:12:33 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:33140 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbgF2TMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593457950; x=1624993950;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=9v0NonQR+jd0mWEGjtTii8ov6prejkupZ4PNCmplmEQ=;
  b=xk/csrETvkiCrG/TQs1dhAawdWP/i2w5Ny5n9W0ZCZaATGoH15uerIxU
   VzQM4muKweLyHkodsKAimSJ//ecgxNCoggWS8u3q2isET95lLiMntaZCP
   4oXf5stZp6of462c8wFNFvwZIB2WxYwH+zJQPBRDYJKwtMe69Z2Ed3GG8
   +j+lfIpFhRZ6G6PeFqYJEiq6MzQjWB34CpEeUgsYey0lkFHQ3sY4XE+HD
   C17o4mnrTr7I8RsVSVNqVGjARSJCiGE8g3keei3xTq+iTfstq9CCuS+Z1
   X+abDrPIHRsgw2Hhhd0LbI0TdMsctC+aH90cdQcNUCf6IgJikFY4zVHs/
   A==;
IronPort-SDR: UxPJI7sB2Tihrc+ahM18kSkoNy9TUt83SKYkh85hnQcHIGYnLnkkQ9poH6lbOu8gPLrz34yFWZ
 CF9u1bsBczYouxjsWHNvaadaLqyPmLxWnbjnQapCCXWOv8Ac82diRfM1Ko3aSryzyO9E2mpNbk
 P4Xsj7Be5nvhNRfue4MNeC6iIZYOx5Qo+Jo+mHuYL3Oivrqbq3c8MPobutgZUL8uxIiV1MoQa0
 VpOTqplX58ff2QCwRuTE++c2guWgOxYVr+PhTnd/RWx7v03mfwlXgekXNbYb+WNokq8krlfikA
 s78=
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="81221189"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 06:12:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 06:12:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 29 Jun 2020 06:12:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzuJYTDNewD7zwAF/KHUUFzWua4FdQv25oKYNzxr+QxrKSPuAx+He//KF/fAFkO0Km+09uV3QIZnrBPkgPXAA1zzveZlrY0wUArd3EPR5A3pfg5YUwJTIvYZfiQNBygsYnJQ24Y/p6tr6JT4Eu/xFilQZTR4SDRXeOorBYoQg9LLTGobbJ0kWOBxab45+qUidPg4Hsi6o2uODY8UgC6fTtBu69DEPNC4n5iPWM7BtGQC5QYiA3K0Pz5XOjPKq/oFBG+uFKL9yClzMhwlc50U01QDWyKjS5NKeFgX3HP3/6Um0kag+8JqsV+wbivTw7cjcNO/M9at88fIYwu90QZalQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9v0NonQR+jd0mWEGjtTii8ov6prejkupZ4PNCmplmEQ=;
 b=TtwUejN88ntNp/ertWHTBLqNPG4QNmgERCGJBQftc8SzyxLMjlU26rBjBZWoiw53qt43Z8RPNr8JbybKaoIDoZzgJ09+FCWX6kVsHajssi8jtZOg2UivCuiZWzP6lQhXTsyh9ErM6Yj8aBAPdr9CZulE3yrnbIX/RkVXsK4/DEpu5AHR+s5Ut4+hxoLEeOc6u0xqF/AveijE0zU9U3Hp2AR83c08mhOaKsxX7nzT1k1tbvqyvla72jVYdRTQ/0EVoD1y1yV6Wupy3rjClnWXc59PUkIb9xpDqjRApq/raxEOTyXgwxrLQgSoJrJpWs2+QCjp9hn3SXvv99I4ie79Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9v0NonQR+jd0mWEGjtTii8ov6prejkupZ4PNCmplmEQ=;
 b=hgEVNH6p77MUoL0ZJgPYzRkqoy3FncpQEm3pr9m3/HP0tDcYeaxdRiVwvJcfuST1VS5PMOSTFJMHSWzfaKQtQd3w9ilLJaFoO4ar3ysHg/8rchwZe8vrm74/q4Vg7KjmY/CJhznZLdbxt5GOb2xlomd6QnBvzyFBiTKgARtjsgY=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BY5PR11MB4434.namprd11.prod.outlook.com (2603:10b6:a03:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Mon, 29 Jun
 2020 13:12:37 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 13:12:37 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 5/8] smsc95xx: use PAL framework read/write functions
Thread-Topic: [PATCH net-next 5/8] smsc95xx: use PAL framework read/write
 functions
Thread-Index: AQHWThb1dhSsqe9GF0Cc+vjioDDITQ==
Date:   Mon, 29 Jun 2020 13:12:37 +0000
Message-ID: <574a2386c1b9ed6c18ce0f20d7afbae0826faaae.camel@microchip.com>
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
x-ms-office365-filtering-correlation-id: e61ebb11-e31e-4f2b-69fa-08d81c2e1836
x-ms-traffictypediagnostic: BY5PR11MB4434:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB44346B43A16440637767A0B8EC6E0@BY5PR11MB4434.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:255;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9a69o0CHuKLo+dTjRQ0ptbUAS9ZjzpsHxHuoI531d31JLw6uqOgy2F8b86uBnI+bhz8stitN4/zz7k4vNRWbof3WRzzB4K0lg/lBGt31ut1ipK+2xwu0CWQsSOxIwlGDzapFCCM8YkOxB3+J8n3U4E2lusJKPOabU1dQdRde8EI2aGB4XTLwOmzhATHkLPsnX+CA7M2QAEjMVtPSqZ+/njyMhdBpcXdZwZaN1XWQahLGDaQHOX6sBoBzEX0hGGrSvJPJCQPkeuFKaebU+Tm2CR0mPc/7HbuwP5UotE6CbwiXE/HfWmv8QAHAYad+3yRcmNoCWFbpawOgP7WtWejlCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(83380400001)(6512007)(8676002)(8936002)(5660300002)(36756003)(110136005)(4326008)(316002)(2906002)(6486002)(107886003)(66946007)(6506007)(2616005)(76116006)(91956017)(66476007)(66556008)(64756008)(66446008)(186003)(26005)(478600001)(86362001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xqDm45XLn9J+BdHnOmnBSG18vFoko5NdgWB4XFl5lLY/Cozi/Jdy+TOZJLTN/il1Ct3wHlovsimjoPAqMbScvz6qEjxjwhPPvYTGyM4x1/9w+b30sjAFog2ywb1kXB4utk3+2NNpcOe3D4CVgxqNwi3+Ezdun1xwJQAFLAk3bFnrs4OLAJzlL9sH0WkjMEvOelzl8nFbkzRYg4/KjiJERLpihn5iSP77WTSnBqifRt6HuDZGvllqikkAgcuENXL2sjZMd16U/QvKjBUphu9lDfQCIcTD2fENSfoFTu2Si+ZPlFEw5aa3XSLQu16og1D1WbmKvCYwx0K8KLPTWK9r9iR38DhEw1/EvDZy6bGt0PbG6A8e+sFh+GGkIuhp/drtt03W3mlTijCtbOvg8jDTXUQ9ZlIDYFHxAOWj+daTCpmLYm+pI1iPMEjwjtTgCN0mriJlG0bsztD/ffK4eYi7zOXIA/4s1q3tk/UaR//Z2aLuoRSFehnMsvMEL4nNR7Yq
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F92DBBDCB4C98499C62D5C4FF37AB96@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e61ebb11-e31e-4f2b-69fa-08d81c2e1836
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 13:12:37.1608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BzSxLzh5sPEerYpDAq3iL/GE9dqq6IrBQ6JUWPeG4VrBWFe6WNkVRqvKFn9B+0ZoH8qgPmriSWkL2I6ZJYD17siti5C3bPfE0rOZUPk/8MU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4434
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
KHN0cnVjdCBzbXNjOTV4eF9wcml2ICopKGRldi0NCj5kYXRhWzBdKTsNCiAJdTMyIHZhbDsNCiAJ
aW50IGJ1ZjsNCiANCi0JYnVmID0gc21zYzk1eHhfbWRpb19yZWFkKGRldi0+bmV0LCBkZXYtPm1p
aS5waHlfaWQsDQpTUEVDSUFMX0NUUkxfU1RTKTsNCisJYnVmID0gcGh5X3JlYWQocGRhdGEtPnBo
eWRldiwgU1BFQ0lBTF9DVFJMX1NUUyk7DQogCWlmIChidWYgJiBTUEVDSUFMX0NUUkxfU1RTX09W
UlJEX0FNRElYXykgew0KIAkJaWYgKGJ1ZiAmIFNQRUNJQUxfQ1RSTF9TVFNfQU1ESVhfRU5BQkxF
XykNCiAJCQlyZXR1cm4gRVRIX1RQX01ESV9BVVRPOw0KQEAgLTc4MiwzOSArNzgzLDMxIEBAIHN0
YXRpYyB2b2lkIHNldF9tZGl4X3N0YXR1cyhzdHJ1Y3QgbmV0X2RldmljZQ0KKm5ldCwgX191OCBt
ZGl4X2N0cmwpDQogCSAgICAocGRhdGEtPmNoaXBfaWQgPT0gSURfUkVWX0NISVBfSURfODk1MzBf
KSB8fA0KIAkgICAgKHBkYXRhLT5jaGlwX2lkID09IElEX1JFVl9DSElQX0lEXzk3MzBfKSkgew0K
IAkJLyogRXh0ZW5kIE1hbnVhbCBBdXRvTURJWCB0aW1lciBmb3IgOTUwMEEvOTUwMEFpICovDQot
CQlidWYgPSBzbXNjOTV4eF9tZGlvX3JlYWQoZGV2LT5uZXQsIGRldi0+bWlpLnBoeV9pZCwNCi0J
CQkJCSBQSFlfRURQRF9DT05GSUcpOw0KKwkJYnVmID0gcGh5X3JlYWQocGRhdGEtPnBoeWRldiwg
UEhZX0VEUERfQ09ORklHKTsNCiAJCWJ1ZiB8PSBQSFlfRURQRF9DT05GSUdfRVhUX0NST1NTT1ZF
Ul87DQotCQlzbXNjOTV4eF9tZGlvX3dyaXRlKGRldi0+bmV0LCBkZXYtPm1paS5waHlfaWQsDQot
CQkJCSAgICBQSFlfRURQRF9DT05GSUcsIGJ1Zik7DQorCQlwaHlfd3JpdGUocGRhdGEtPnBoeWRl
diwgUEhZX0VEUERfQ09ORklHLCBidWYpOw0KIAl9DQogDQogCWlmIChtZGl4X2N0cmwgPT0gRVRI
X1RQX01ESSkgew0KLQkJYnVmID0gc21zYzk1eHhfbWRpb19yZWFkKGRldi0+bmV0LCBkZXYtPm1p
aS5waHlfaWQsDQotCQkJCQkgU1BFQ0lBTF9DVFJMX1NUUyk7DQorCQlidWYgPSBwaHlfcmVhZChw
ZGF0YS0+cGh5ZGV2LCBTUEVDSUFMX0NUUkxfU1RTKTsNCiAJCWJ1ZiB8PSBTUEVDSUFMX0NUUkxf
U1RTX09WUlJEX0FNRElYXzsNCiAJCWJ1ZiAmPSB+KFNQRUNJQUxfQ1RSTF9TVFNfQU1ESVhfRU5B
QkxFXyB8DQogCQkJIFNQRUNJQUxfQ1RSTF9TVFNfQU1ESVhfU1RBVEVfKTsNCi0JCXNtc2M5NXh4
X21kaW9fd3JpdGUoZGV2LT5uZXQsIGRldi0+bWlpLnBoeV9pZCwNCi0JCQkJICAgIFNQRUNJQUxf
Q1RSTF9TVFMsIGJ1Zik7DQorCQlwaHlfd3JpdGUocGRhdGEtPnBoeWRldiwgU1BFQ0lBTF9DVFJM
X1NUUywgYnVmKTsNCiAJfSBlbHNlIGlmIChtZGl4X2N0cmwgPT0gRVRIX1RQX01ESV9YKSB7DQot
CQlidWYgPSBzbXNjOTV4eF9tZGlvX3JlYWQoZGV2LT5uZXQsIGRldi0+bWlpLnBoeV9pZCwNCi0J
CQkJCSBTUEVDSUFMX0NUUkxfU1RTKTsNCisJCWJ1ZiA9IHBoeV9yZWFkKHBkYXRhLT5waHlkZXYs
IFNQRUNJQUxfQ1RSTF9TVFMpOw0KIAkJYnVmIHw9IFNQRUNJQUxfQ1RSTF9TVFNfT1ZSUkRfQU1E
SVhfOw0KIAkJYnVmICY9IH4oU1BFQ0lBTF9DVFJMX1NUU19BTURJWF9FTkFCTEVfIHwNCiAJCQkg
U1BFQ0lBTF9DVFJMX1NUU19BTURJWF9TVEFURV8pOw0KIAkJYnVmIHw9IFNQRUNJQUxfQ1RSTF9T
VFNfQU1ESVhfU1RBVEVfOw0KLQkJc21zYzk1eHhfbWRpb193cml0ZShkZXYtPm5ldCwgZGV2LT5t
aWkucGh5X2lkLA0KLQkJCQkgICAgU1BFQ0lBTF9DVFJMX1NUUywgYnVmKTsNCisJCXBoeV93cml0
ZShwZGF0YS0+cGh5ZGV2LCBTUEVDSUFMX0NUUkxfU1RTLCBidWYpOw0KIAl9IGVsc2UgaWYgKG1k
aXhfY3RybCA9PSBFVEhfVFBfTURJX0FVVE8pIHsNCi0JCWJ1ZiA9IHNtc2M5NXh4X21kaW9fcmVh
ZChkZXYtPm5ldCwgZGV2LT5taWkucGh5X2lkLA0KLQkJCQkJIFNQRUNJQUxfQ1RSTF9TVFMpOw0K
KwkJYnVmID0gcGh5X3JlYWQocGRhdGEtPnBoeWRldiwgU1BFQ0lBTF9DVFJMX1NUUyk7DQogCQli
dWYgJj0gflNQRUNJQUxfQ1RSTF9TVFNfT1ZSUkRfQU1ESVhfOw0KIAkJYnVmICY9IH4oU1BFQ0lB
TF9DVFJMX1NUU19BTURJWF9FTkFCTEVfIHwNCiAJCQkgU1BFQ0lBTF9DVFJMX1NUU19BTURJWF9T
VEFURV8pOw0KIAkJYnVmIHw9IFNQRUNJQUxfQ1RSTF9TVFNfQU1ESVhfRU5BQkxFXzsNCi0JCXNt
c2M5NXh4X21kaW9fd3JpdGUoZGV2LT5uZXQsIGRldi0+bWlpLnBoeV9pZCwNCi0JCQkJICAgIFNQ
RUNJQUxfQ1RSTF9TVFMsIGJ1Zik7DQorCQlwaHlfd3JpdGUocGRhdGEtPnBoeWRldiwgU1BFQ0lB
TF9DVFJMX1NUUywgYnVmKTsNCiAJfQ0KIAlwZGF0YS0+bWRpeF9jdHJsID0gbWRpeF9jdHJsOw0K
IH0NCg==
