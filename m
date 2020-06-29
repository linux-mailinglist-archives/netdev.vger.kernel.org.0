Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E5320DAE8
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgF2UBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:01:43 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:37694 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388663AbgF2UBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593460900; x=1624996900;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=GuKqolz5JdJf4NWj/t5ROC5tWY4P7hBzorVaD0wUBR0=;
  b=ONgSBqX0WA+aPrucbIUV4Hw8FU48DVvTzJsSoshXqFE/SCXcyw4ACCL9
   MdiCK60njCc+ZQC3TLkJHeEWHFyfG3v2LGYR+V8ZtXvuJ+0CnRS+UagG1
   8+eh4aSTnQUZPISlH+arBm0OZR5gGC4bZih3jJQoDLoApmkShx321W4hg
   ON/QrOQw7cKYFkBbtNxrgKb5/IxIe7pDdDDDBFol0dU0YvKiKMIfrnlyL
   vZEQnmsoIwsis3DFcItZAxbsBcHu+dEsjkfC66b1XzfuJ/Fv/aA60Tpf3
   OxVBBwlUTvBFbh6GycC7twcs0HMlkM5KFsg0Z7ZLyItCZTGm3I93NTTWM
   w==;
IronPort-SDR: DG4Q2CbTr8Z3dwStGRTe3WENELPH4Eg0B8a4UPDE5O/pHlTERkUG+ZCG2buHq0CB0Dumcu5Ap1
 ONjixcK0sflLz136wqUrNmhL97ri0Pc51LLaKCcLB0TAs7VHyK8d+5SvnajUoyfWNdCOx5QGqC
 Yw71afDWoEqBqj6qzieFDLlQFgpLZ/PPa8v1hpRlD/4N5Yci3RXJGhbc4Zrm9U/KoRAkWK9cKf
 6nlWjhc37UwUHZKWqrEE2uXCrHfZfgAC78rpejocoPrJtAV2/1ost/ft+MCfLIYAV/qlqFPSNX
 4IA=
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="81282299"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 13:01:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 13:01:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 29 Jun 2020 13:01:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2mW6AgvpZVmEkx4yA8IB8DKMeRRMhpgUttJW1u41OU/USUwulTKiJmBKQmcNgy3g2rxxFU4UTcI5VReGPRy6c+NJ3DDrLtJiJfPJ67OlNYZYssGHlu740I4lRr6tOVq0GXLEbJA05G+M+Pj9kEj1/scyH2Jne6ANXjFj2Akv5hJHlkoUS88boIwIXUyiOqfTOraUpXgpm/6Z5h/A/tfBYpeXMJpKH9p3awmnOzr69NsJhPIDKGXGgtFhF3FXppGLSRSits6OKmVbQLwZ+0q3l19nMqwdVDaiCj5YHiqqAnX6UnV4UQQoTVjP3TXoi7bgLIkEfJst6K7pY7L9+FQaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuKqolz5JdJf4NWj/t5ROC5tWY4P7hBzorVaD0wUBR0=;
 b=NE4kZmaos4IMN0cYcjSHwCF0rRB1HPFsyDCf2dnwGLlw1yE60QM95/OiEyacrCKrUXhBj/9Znc6J6j3YuOS0vFuqNKRtnO2VTbMYkG2k10Cscg91ZqufHc8KjpbRNnaKx5a7PQV4CEsooGGbns1z2yveWKhRTbCbJpih3qGAGg/BBLPgpLTeJccqbXagT/9rcbJfW3b6jqINPFY1EY2lyughKJHClletmKHe4R5yQmHxddM2YteN/kz6Lx4MJ4wpgd7E0wZX2EtM3rfi3B4al2xbd1ZTzfdwNfzpgWfw+unRNl3pljZG4LIWwo36W8KxHzCpLsd5tiejtA54r5lUJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuKqolz5JdJf4NWj/t5ROC5tWY4P7hBzorVaD0wUBR0=;
 b=HNj+2+8LDZJJpzwsK9m7KD9m8Hu2dgCunyGORDLL1lP0lztc+7vmDzi7XkIPyVzbwx1R9ptaPevRUuwFNeDgfbzLa75EGNoL3k3G6oC+X4vH93kYAVhPHX2PKvgB/FnerNUpYQf5Kjy6SmkY9iES0tKNInweEEKk6HEqVPeSp5g=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BYAPR11MB2792.namprd11.prod.outlook.com (2603:10b6:a02:c3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Mon, 29 Jun
 2020 20:01:37 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 20:01:37 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 4/8] smsc95xx: remove redundant link status checking
Thread-Topic: [PATCH net-next 4/8] smsc95xx: remove redundant link status
 checking
Thread-Index: AQHWTlAYtCMdiBWdTkmrUkiuLo/zjQ==
Date:   Mon, 29 Jun 2020 20:01:37 +0000
Message-ID: <5aa823eedf590bd7a3e27de5223aa1204bb3d811.camel@microchip.com>
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
x-ms-office365-filtering-correlation-id: 9c64c2a7-324b-44f8-032e-08d81c673b39
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2792CB02DC03C6DB19A13C38EC6E0@BYAPR11MB2792.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EgyOgoC0nCBiWR7XnF4ZSxLKZ2/dhUkk7hd2gMw5TzESEnRNb5MQwkf2RM97uAyB7OioGFSaFAW96hyRl62Yrf+RHhMydrGudk4wojXCj0guZIrtJZZXPdhh+Er3fsYRWaTqaYDIlndooun5bbi6JYdThTTPXQAsA0Wwv1X86oEakipQUZR9N6gPFqYdZ8kK++RSNT04MEklmZpdX7BNYSmRaQQJe+pZOINArbUCEE+rX93+FF61QEbh0rOt17w3Cw+C1f+AXR5P3WtAVn5XZfexZBHZZibl9PxJwV/xpIRib81S9BpqlPDttepGNSHs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(6506007)(4326008)(110136005)(478600001)(2616005)(2906002)(8676002)(316002)(8936002)(36756003)(6512007)(186003)(86362001)(83380400001)(71200400001)(26005)(6486002)(76116006)(107886003)(91956017)(5660300002)(66446008)(64756008)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hOmZqn/EZX26KJPmcQPpRMKMJjO5pQ/dI482pPLRF/N1J6EE8mo04Nc6T0cUlTVBbwULKo6d4QxAXdu8WjxI/+NJmmAatKnMJdtShkwKFT71cZjihpV0/ALoSSOBj/yJWO8AyBki+JmBYrAuBo9EHnKfIQC2FSgpUy/japou3nbH5qZXfy8UP5M1aE3B5qhkfdLr8gsjvwWGQgZQpjMN+SirhqlpWk2UItplRaRy4TizI4/+Ncm7kQK+g4uD8g5qW8Yin8YNs6x/cLVmWZj0kCG88sH4z2s/2t+xMQJLuLHpX4/hQf9z9EpLMvAfkl9UGzRymrM8muKKws3qS7fEultEjqvvPtuSPD/GOzs3J3Jmns3NQ949nxo/kaa7yDciqgkUO/SwoW3VGyUeAxYp9k+EKehgsNgTwRZoM5B1cheslv1sspLiLDAoDfqAamtjUkyWYGF534xJwXKMy+SRX/iQU5eYY7fweik7dSNUVptsSYd+/mJACnhGF3OKjLS/
Content-Type: text/plain; charset="utf-8"
Content-ID: <98A003E78B4D304BA1238DF22741617F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c64c2a7-324b-44f8-032e-08d81c673b39
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 20:01:37.1807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ML49XZPM3zYIxQpBiXrfnKPV+cRacflxTHq/2dpD+MChqtV5PoRr3vfi+5m0vMB5gbyTNokk8SMWUfi3uQ9LU9lijcDkVjDPlK8iVENcOZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q3VycmVudCBkcml2ZXIgc3VwcG9ydHMgUEFMIHRoYXQgZG9lcyBsaW5rIHN0YXR1cyBjaGVja2lu
ZyBhbnl3YXkuDQoNClNpZ25lZC1vZmYtYnk6IEFuZHJlIEVkaWNoIDxhbmRyZS5lZGljaEBtaWNy
b2NoaXAuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgfCA1NSAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1NSBkZWxl
dGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5jIGIvZHJp
dmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMNCmluZGV4IGZiYjgwYTdhZWYzMi4uM2I4ZjdlNDM5ZjQ0
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMNCisrKyBiL2RyaXZlcnMv
bmV0L3VzYi9zbXNjOTV4eC5jDQpAQCAtNTEsOCArNTEsNiBAQA0KICNkZWZpbmUgU1VTUEVORF9B
TExNT0RFUwkJKFNVU1BFTkRfU1VTUEVORDAgfA0KU1VTUEVORF9TVVNQRU5EMSB8IFwNCiAJCQkJ
CSBTVVNQRU5EX1NVU1BFTkQyIHwNClNVU1BFTkRfU1VTUEVORDMpDQogDQotI2RlZmluZSBDQVJS
SUVSX0NIRUNLX0RFTEFZICgyICogSFopDQotDQogc3RydWN0IHNtc2M5NXh4X3ByaXYgew0KIAl1
MzIgY2hpcF9pZDsNCiAJdTMyIG1hY19jcjsNCkBAIC02NCw4ICs2Miw2IEBAIHN0cnVjdCBzbXNj
OTV4eF9wcml2IHsNCiAJdTggc3VzcGVuZF9mbGFnczsNCiAJdTggbWRpeF9jdHJsOw0KIAlib29s
IGxpbmtfb2s7DQotCXN0cnVjdCBkZWxheWVkX3dvcmsgY2Fycmllcl9jaGVjazsNCi0Jc3RydWN0
IHVzYm5ldCAqZGV2Ow0KIAlzdHJ1Y3QgbWlpX2J1cyAqbWRpb2J1czsNCiAJc3RydWN0IHBoeV9k
ZXZpY2UgKnBoeWRldjsNCiB9Ow0KQEAgLTYzNiw0NCArNjMyLDYgQEAgc3RhdGljIHZvaWQgc21z
Yzk1eHhfc3RhdHVzKHN0cnVjdCB1c2JuZXQgKmRldiwNCnN0cnVjdCB1cmIgKnVyYikNCiAJCQkg
ICAgaW50ZGF0YSk7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIHNldF9jYXJyaWVyKHN0cnVjdCB1c2Ju
ZXQgKmRldiwgYm9vbCBsaW5rKQ0KLXsNCi0Jc3RydWN0IHNtc2M5NXh4X3ByaXYgKnBkYXRhID0g
KHN0cnVjdCBzbXNjOTV4eF9wcml2ICopKGRldi0NCj4gZGF0YVswXSk7DQotDQotCWlmIChwZGF0
YS0+bGlua19vayA9PSBsaW5rKQ0KLQkJcmV0dXJuOw0KLQ0KLQlwZGF0YS0+bGlua19vayA9IGxp
bms7DQotDQotCWlmIChsaW5rKQ0KLQkJdXNibmV0X2xpbmtfY2hhbmdlKGRldiwgMSwgMCk7DQot
CWVsc2UNCi0JCXVzYm5ldF9saW5rX2NoYW5nZShkZXYsIDAsIDApOw0KLX0NCi0NCi1zdGF0aWMg
dm9pZCBjaGVja19jYXJyaWVyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCi17DQotCXN0cnVj
dCBzbXNjOTV4eF9wcml2ICpwZGF0YSA9IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3QNCnNtc2M5
NXh4X3ByaXYsDQotCQkJCQkJY2Fycmllcl9jaGVjay53b3JrKTsNCi0Jc3RydWN0IHVzYm5ldCAq
ZGV2ID0gcGRhdGEtPmRldjsNCi0JaW50IHJldDsNCi0NCi0JaWYgKHBkYXRhLT5zdXNwZW5kX2Zs
YWdzICE9IDApDQotCQlyZXR1cm47DQotDQotCXJldCA9IHNtc2M5NXh4X21kaW9fcmVhZChkZXYt
Pm5ldCwgZGV2LT5taWkucGh5X2lkLCBNSUlfQk1TUik7DQotCWlmIChyZXQgPCAwKSB7DQotCQlu
ZXRkZXZfd2FybihkZXYtPm5ldCwgIkZhaWxlZCB0byByZWFkIE1JSV9CTVNSXG4iKTsNCi0JCXJl
dHVybjsNCi0JfQ0KLQlpZiAocmV0ICYgQk1TUl9MU1RBVFVTKQ0KLQkJc2V0X2NhcnJpZXIoZGV2
LCAxKTsNCi0JZWxzZQ0KLQkJc2V0X2NhcnJpZXIoZGV2LCAwKTsNCi0NCi0Jc2NoZWR1bGVfZGVs
YXllZF93b3JrKCZwZGF0YS0+Y2Fycmllcl9jaGVjaywNCkNBUlJJRVJfQ0hFQ0tfREVMQVkpOw0K
LX0NCi0NCiAvKiBFbmFibGUgb3IgZGlzYWJsZSBUeCAmIFJ4IGNoZWNrc3VtIG9mZmxvYWQgZW5n
aW5lcyAqLw0KIHN0YXRpYyBpbnQgc21zYzk1eHhfc2V0X2ZlYXR1cmVzKHN0cnVjdCBuZXRfZGV2
aWNlICpuZXRkZXYsDQogCW5ldGRldl9mZWF0dXJlc190IGZlYXR1cmVzKQ0KQEAgLTEzNjMsMTEg
KzEzMjEsNiBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X2JpbmQoc3RydWN0IHVzYm5ldCAqZGV2LA0K
c3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYpDQogCWRldi0+bmV0LT5taW5fbXR1ID0gRVRIX01J
Tl9NVFU7DQogCWRldi0+bmV0LT5tYXhfbXR1ID0gRVRIX0RBVEFfTEVOOw0KIAlkZXYtPmhhcmRf
bXR1ID0gZGV2LT5uZXQtPm10dSArIGRldi0+bmV0LT5oYXJkX2hlYWRlcl9sZW47DQotDQotCXBk
YXRhLT5kZXYgPSBkZXY7DQotCUlOSVRfREVMQVlFRF9XT1JLKCZwZGF0YS0+Y2Fycmllcl9jaGVj
aywgY2hlY2tfY2Fycmllcik7DQotCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmcGRhdGEtPmNhcnJp
ZXJfY2hlY2ssDQpDQVJSSUVSX0NIRUNLX0RFTEFZKTsNCi0NCiAJcmV0dXJuIDA7DQogDQogdW5y
ZWdpc3Rlcl9tZGlvOg0KQEAgLTEzODYsNyArMTMzOSw2IEBAIHN0YXRpYyB2b2lkIHNtc2M5NXh4
X3VuYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYsDQpzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikN
CiAJc3RydWN0IHNtc2M5NXh4X3ByaXYgKnBkYXRhID0gKHN0cnVjdCBzbXNjOTV4eF9wcml2ICop
KGRldi0NCj4gZGF0YVswXSk7DQogDQogCWlmIChwZGF0YSkgew0KLQkJY2FuY2VsX2RlbGF5ZWRf
d29ya19zeW5jKCZwZGF0YS0+Y2Fycmllcl9jaGVjayk7DQogCQltZGlvYnVzX3VucmVnaXN0ZXIo
cGRhdGEtPm1kaW9idXMpOw0KIAkJbWRpb2J1c19mcmVlKHBkYXRhLT5tZGlvYnVzKTsNCiAJCW5l
dGlmX2RiZyhkZXYsIGlmZG93biwgZGV2LT5uZXQsICJmcmVlIHBkYXRhXG4iKTsNCkBAIC0xNjUx
LDggKzE2MDMsNiBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X3N1c3BlbmQoc3RydWN0IHVzYl9pbnRl
cmZhY2UNCippbnRmLCBwbV9tZXNzYWdlX3QgbWVzc2FnZSkNCiAJCXJldHVybiByZXQ7DQogCX0N
CiANCi0JY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZwZGF0YS0+Y2Fycmllcl9jaGVjayk7DQot
DQogCWlmIChwZGF0YS0+c3VzcGVuZF9mbGFncykgew0KIAkJbmV0ZGV2X3dhcm4oZGV2LT5uZXQs
ICJlcnJvciBkdXJpbmcgbGFzdCByZXN1bWVcbiIpOw0KIAkJcGRhdGEtPnN1c3BlbmRfZmxhZ3Mg
PSAwOw0KQEAgLTE4OTYsMTAgKzE4NDYsNiBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X3N1c3BlbmQo
c3RydWN0IHVzYl9pbnRlcmZhY2UNCippbnRmLCBwbV9tZXNzYWdlX3QgbWVzc2FnZSkNCiAJaWYg
KHJldCAmJiBQTVNHX0lTX0FVVE8obWVzc2FnZSkpDQogCQl1c2JuZXRfcmVzdW1lKGludGYpOw0K
IA0KLQlpZiAocmV0KQ0KLQkJc2NoZWR1bGVfZGVsYXllZF93b3JrKCZwZGF0YS0+Y2Fycmllcl9j
aGVjaywNCi0JCQkJICAgICAgQ0FSUklFUl9DSEVDS19ERUxBWSk7DQotDQogCXJldHVybiByZXQ7
DQogfQ0KIA0KQEAgLTE5MTksNyArMTg2NSw2IEBAIHN0YXRpYyBpbnQgc21zYzk1eHhfcmVzdW1l
KHN0cnVjdCB1c2JfaW50ZXJmYWNlDQoqaW50ZikNCiANCiAJLyogZG8gdGhpcyBmaXJzdCB0byBl
bnN1cmUgaXQncyBjbGVhcmVkIGV2ZW4gaW4gZXJyb3IgY2FzZSAqLw0KIAlwZGF0YS0+c3VzcGVu
ZF9mbGFncyA9IDA7DQotCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmcGRhdGEtPmNhcnJpZXJfY2hl
Y2ssDQpDQVJSSUVSX0NIRUNLX0RFTEFZKTsNCiANCiAJaWYgKHN1c3BlbmRfZmxhZ3MgJiBTVVNQ
RU5EX0FMTE1PREVTKSB7DQogCQkvKiBjbGVhciB3YWtlLXVwIHNvdXJjZXMgKi8NCg==
