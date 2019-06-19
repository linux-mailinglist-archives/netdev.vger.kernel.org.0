Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D5F4B1F1
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfFSGI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:08:58 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:50270 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbfFSGI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:08:58 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5J61ulm005196;
        Tue, 18 Jun 2019 23:08:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=oyyb4DNWdCPiZKPIfZYrdg0Sjfuh63vo9fnKmctQN0s=;
 b=F+kFmQnOHsSky9SICkDTCL5DOTOhmqih58bTYZUaR1PaSKglZCmkOScMEpye7G2ZDMOr
 SwUIY0Wl3ah2ekLhKl/UzeLFR/WYw+YOn96NmboDM7AZGVcE4uQ82p2gsH/mnCE0tq3b
 pK+2t0rMTQgu4398txYWFCx5Qy6S7YGoE/zOAm9cgSnF6fMbOaXFmi4iat2CDBi+PTum
 /+GP/j32zYZIebwI2z57CyUakCWnFVOo+CWmFm5hYSf/d05gUIatUiguYpx9ajQKG1Qg
 l3ecDgJMRLDeRKO8LuSN5m0pcBXBqjN3JddVIChmDSGi0xCsdxvqKtI4oRi1kqOaBjMg YQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2054.outbound.protection.outlook.com [104.47.34.54])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t78059vy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 23:08:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyyb4DNWdCPiZKPIfZYrdg0Sjfuh63vo9fnKmctQN0s=;
 b=eRCRFN/yXkBn2u5IDMGkr9VHS0z1Gp+837aVbLxEnulHAlWaWt3LtRCLWsxOGLszho27dulVU+S1jZGGyaYkWYGcqz27BYOQitNO+KzPUz/8bW4ftqXSWzEX/nVAIsZl0rQ9FdIQnRFWOzi0FWyDTKBjWti3ibZTEfUW+1LFbsk=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2599.namprd07.prod.outlook.com (10.166.92.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Wed, 19 Jun 2019 06:08:31 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 06:08:31 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH v2 6/6] net: macb: parameter added to cadence ethernet
 controller DT binding
Thread-Topic: [PATCH v2 6/6] net: macb: parameter added to cadence ethernet
 controller DT binding
Thread-Index: AQHVJgYEcZZJIulgrkCx/rDn3Q1+Caah0UUAgACfxUA=
Date:   Wed, 19 Jun 2019 06:08:31 +0000
Message-ID: <CO2PR07MB2469320BE676BF3ED860E8C5C1E50@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560642579-29803-1-git-send-email-pthombar@cadence.com>
 <1560883527-10591-1-git-send-email-pthombar@cadence.com>
 <0375c350-ed33-728d-4106-e6f5348c5295@gmail.com>
In-Reply-To: <0375c350-ed33-728d-4106-e6f5348c5295@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1hNmRlNzlhNi05MjU4LTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcYTZkZTc5YTctOTI1OC0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSI3NTUiIHQ9IjEzMjA1Mzk4MTA3NjMxNTM3OSIgaD0ibkk5dmZMMnJRajVPRllmU2Y0ekR2ZDRnczg0PSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22ab3d9d-59af-4233-f499-08d6f47c8dfa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2599;
x-ms-traffictypediagnostic: CO2PR07MB2599:
x-microsoft-antispam-prvs: <CO2PR07MB2599AB552D59275BE1BEB053C1E50@CO2PR07MB2599.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(396003)(39860400002)(366004)(346002)(376002)(189003)(199004)(36092001)(81156014)(5660300002)(2906002)(4744005)(33656002)(3846002)(53936002)(256004)(66446008)(14454004)(2501003)(7736002)(66476007)(73956011)(6116002)(4326008)(107886003)(508600001)(6246003)(486006)(25786009)(66556008)(64756008)(52536014)(66946007)(76176011)(446003)(7696005)(81166006)(11346002)(476003)(305945005)(186003)(86362001)(26005)(2201001)(55016002)(316002)(110136005)(74316002)(14444005)(8936002)(9686003)(78486014)(102836004)(99286004)(6506007)(6436002)(71190400001)(66066001)(229853002)(55236004)(71200400001)(8676002)(68736007)(76116006)(54906003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2599;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pIE+DfHP3yBjiH4Q9a+P1wFFrNCaCbsIH5Q3fxpmyfqZiIMWzxPe2H5f/HJyIpWM61FWtBkoPBcxruBTjvSqmf06KoRBhO5v61rDmjbqFEoN5cxb+chK5rEWttRXonNs0Zjkk6dCJXk8YzIf2CD0An6m9gUprXu0R+LbWrqLblUq8NxTbhZmMqv7++3vQjUg64GE2BG4Wo8tivbMdMIKJXiV53d1x1OvE07P9UpSbnFOTOEx8huVV8oB6hDfwZM/fB/C7qKtVr3BaUnY8Hx82FQJEHma7jLjfZQ2SzK9LzzKxj6BTk3sK/eKspmPzGZ76S29bRnQWGDwFQmHU0R6+w90JtrGeLFbCJODJ4oY8RbStSdgCuNeyFbqqCo27VcralDe2kRrL+I1RqQNM0I6aiYy6FDvx5JV+RPWCIaL6Ng=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ab3d9d-59af-4233-f499-08d6f47c8dfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 06:08:31.2077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2599
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRmxvcmlhbiwNCg0KPlBsZWFzZSBkb24ndCByZXN1Ym1pdCBpbmRpdmlkdWFsIHBhdGNoZXMg
YXMgcmVwbGllcyB0byB5b3VyIHByZXZpb3VzDQo+b25lcywgcmUtc3VibWl0dGluZyB0aGUgZW50
aXJlIHBhdGNoIHNlcmllcywgc2VlIHRoaXMgbmV0ZGV2LUZBUSBzZWN0aW9uDQo+Zm9yIGRldGFp
bHM6DQoNCkkgd2lsbCByZXN1Ym1pdCBlbnRpcmUgcGF0Y2ggc2VyaWVzIHNlcGFyYXRlbHkuDQoN
Cj4NCj4+ICstIHNlcmRlcy1yYXRlIEV4dGVybmFsIHNlcmRlcyByYXRlLk1hbmRhdG9yeSBmb3Ig
VVNYR01JSSBtb2RlLg0KPg0KPj4gKwk1IC0gNUcNCj4NCj4+ICsJMTAgLSAxMEcNCj4NCj4NCj4N
Cj5UaGVyZSBzaG91bGQgYmUgYW4gdW5pdCBzcGVjaWZpZXIgaW4gdGhhdCBwcm9wZXJ0eSwgc29t
ZXRoaW5nIGxpa2U6DQo+c2VyZGVzLXJhdGUtZ2Jwcw0KPmNhbid0IHdlIHNvbWVob3cgYXV0b21h
dGljYWxseSBkZXRlY3QgdGhhdD8NCg0KT2ssIHN1cmUuIEkgd2lsbCBhZGQgdW5pdCBzcGVjaWZp
ZXIgdG8gcHJvcGVydHkgbmFtZS4gDQpObywgY3VycmVudGx5IEhXIGRvbuKAmXQgaGF2ZSB3YXkg
dG8gYXV0byBkZXRlY3QgZXh0ZXJuYWwgc2VyZGVzIHJhdGUuDQoNClJlZ2FyZHMsDQpQYXJzaHVy
YW0gVGhvbWJhcmUNCg==
