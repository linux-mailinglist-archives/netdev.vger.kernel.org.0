Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2ECFADE1E
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 19:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfIIRkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 13:40:19 -0400
Received: from us-smtp-delivery-168.mimecast.com ([63.128.21.168]:57500 "EHLO
        us-smtp-delivery-168.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728778AbfIIRkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 13:40:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
        s=mimecast20190405; t=1568050817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bGm8cFLECLLsTngjpe5Gi8z6a8eF/aJ7mMzplolIVHY=;
        b=JALSAh34A+k9iugXDFMhLc1yGHidBjKVHDy+sTh5WVegq+ADgYOi0V5FzNS7p1uhQB0wY+
        XjlOisgcEjqezXDZM688ckxtJE1yfKBToelck4z7HG4Ge0Al8xqxuGH4G5EkcwdfImUK8P
        /pratiDFrmHjWf48+q+P2Wmjy3WRsWs=
Received: from NAM05-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam05lp2054.outbound.protection.outlook.com [104.47.50.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-fV-PFGkmM-6c0elrEQ5tcA-1; Mon, 09 Sep 2019 13:40:16 -0400
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3660.namprd06.prod.outlook.com (10.167.236.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Mon, 9 Sep 2019 17:40:11 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::60b3:e38a:69b0:3f95]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::60b3:e38a:69b0:3f95%7]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 17:40:11 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "vitaly.gaiduk@cloudbear.ru" <vitaly.gaiduk@cloudbear.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC:     "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] net: phy: dp83867: Add SGMII mode type switching
Thread-Topic: [PATCH v4 2/2] net: phy: dp83867: Add SGMII mode type switching
Thread-Index: AQHVZzLGso1lPLk8MEK6S1hJcQkSf6cjnNsA
Date:   Mon, 9 Sep 2019 17:40:11 +0000
Message-ID: <1568050810.6344.13.camel@impinj.com>
References: <1568047940-14490-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
         <1568049566-16708-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
In-Reply-To: <1568049566-16708-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [216.207.205.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00cfd251-b5eb-42b2-f9a5-08d7354cc39c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR0601MB3660;
x-ms-traffictypediagnostic: MWHPR0601MB3660:
x-microsoft-antispam-prvs: <MWHPR0601MB3660B3B8B64424DD345CECABD3B70@MWHPR0601MB3660.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(199004)(189003)(66066001)(6246003)(6486002)(11346002)(446003)(26005)(2616005)(476003)(486006)(186003)(14454004)(53936002)(6512007)(256004)(66946007)(71200400001)(71190400001)(66476007)(66556008)(64756008)(66446008)(54906003)(110136005)(25786009)(76176011)(36756003)(4744005)(2201001)(5660300002)(86362001)(4326008)(229853002)(2906002)(102836004)(7736002)(305945005)(498600001)(6506007)(2501003)(6436002)(99286004)(6116002)(103116003)(3846002)(8676002)(8936002)(76116006)(91956017)(7416002)(81166006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3660;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 12ETQ6/+gFRJQWkGLrDn7+BdwcJVPVKmEdM3d6kis1f4A/CuymXWelES9d3vjTyd58KHoh8YsUEmrWkS/Wt32BaN+oR/FyhQYOEJw1wvbDEHnLxflrTcezBn5otprRPp/1n6DTu57S0uLcyRXokiXYK08TgSYoJeHuWhb7rq8QK2ev88MLvGClcTcvzaA9DlKrqtGerCCXgXsUNFy7AoGVpU0aVyp1BoC7qRghzDgofcg+HeqhcrHN/jwMTGkSIjD/kK/JxOU5dIOLPrt0KpjBJlDq3yVhq8I50g8zR5dnFAR26VN2mL147hOPi0Xj60NhzLbxcJ4pFewVRSKforQvD5PDAXN8w0PIrmnQUEEIgog/XGIPUUDtvPW4GTEmCokxURjLofNdKEZ55aCtp8KARoBypePcXdMktBhgBZ9X8=
x-ms-exchange-transport-forked: True
Content-ID: <0D97D7714A6EC04584D8A4FBF64BAB87@namprd06.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00cfd251-b5eb-42b2-f9a5-08d7354cc39c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 17:40:11.1016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AF0KlE9WzASCltDdpi0Rif/5lPQ8OLdgW0ar3Di66zFCiaMjdblUt4uwv5aKWkTDomsEtuogNy2nqd/hOEVo9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3660
X-MC-Unique: fV-PFGkmM-6c0elrEQ5tcA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA5LTA5IGF0IDIwOjE5ICswMzAwLCBWaXRhbHkgR2FpZHVrIHdyb3RlOg0K
PiBUaGlzIHBhdGNoIGFkZHMgYWJpbGl0eSB0byBzd2l0Y2ggYmVldHdlZW4gdHdvIFBIWSBTR01J
SSBtb2Rlcy4NCj4gU29tZSBoYXJkd2FyZSwgZm9yIGV4YW1wbGUsIEZQR0EgSVAgZGVzaWducyBt
YXkgdXNlIDYtd2lyZSBtb2RlDQo+IHdoaWNoIGVuYWJsZXMgZGlmZmVyZW50aWFsIFNHTUlJIGNs
b2NrIHRvIE1BQy4NCj4gDQo+ICsNCj4gKwkJdmFsID0gcGh5X3JlYWRfbW1kKHBoeWRldiwgRFA4
Mzg2N19ERVZBRERSLCBEUDgzODY3X1NHTUlJQ1RMKTsNCj4gKwkJLyogU0dNSUkgdHlwZSBpcyBz
ZXQgdG8gNC13aXJlIG1vZGUgYnkgZGVmYXVsdC4NCj4gKwkJICogSWYgd2UgcGxhY2UgYXBwcm9w
cmlhdGUgcHJvcGVydHkgaW4gZHRzIChzZWUgYWJvdmUpDQo+ICsJCSAqIHN3aXRjaCBvbiA2LXdp
cmUgbW9kZS4NCj4gKwkJICovDQo+ICsJCWlmIChkcDgzODY3LT5zZ21paV9yZWZfY2xrX2VuKQ0K
PiArCQkJdmFsIHw9IERQODM4NjdfU0dNSUlfVFlQRTsNCj4gKwkJZWxzZQ0KPiArCQkJdmFsICY9
IH5EUDgzODY3X1NHTUlJX1RZUEU7DQo+ICsJCXBoeV93cml0ZV9tbWQocGh5ZGV2LCBEUDgzODY3
X0RFVkFERFIsIERQODM4NjdfU0dNSUlDVEwsIHZhbCk7DQoNClNob3VsZCB1c2UgcGh5X21vZGlm
eV9tbWQoKS4NCg==

