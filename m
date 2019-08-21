Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F49197AEA
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfHUNcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:32:43 -0400
Received: from mail-eopbgr790089.outbound.protection.outlook.com ([40.107.79.89]:39648
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727226AbfHUNcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 09:32:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtMoTVeh8mG7iobR1Oxz/CBr6WOvZM9KD1Y4qgz6Ha21YSyHsadc2SsQNk/Ex1RMSNFIN16DCe7QBq68jSXPv3kEkBif2+O2rfgvwspTRdDfBmhMWUvjA1RjQB0ApIhxiMPBgWuSwOS1yrWrwDFPAt8dsGCcXo7soVoQJ/q1l5nQhweYT+7EZ40l9hkB8ogZ8ojbb4+j4QZuv2cSa11bUfPyIf/hi4IpwuyyKNUeEiEaN3+tlLdZJ0KViRgmwrGp3MZypR+3rlPQN9EHuYLqNBQypOPyft5MSnWsu+YdBjcPJkDvc2tjOkRELwZrxRIUK3tSFnZ1N8WdvEQ7FwVmZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9979dGzkIlKuU4bdH8id1myaf7IZP+Y5vTaitmC6AM=;
 b=VVr9KCysCmKAusnIIgT4S62a/6RVRbj6swbUz0VVTFyFUTwshpulr7Vh1myMzPBlytP5ygCYqneWNeu3gFP/Y4cYrokWK/E6HeY/c692FdAISd/3y46axkXtgldf73tOWhNnRcvOAkGYkSNT37a0cSjBvUuCoYjA3ZRg/70U2bbycFUTVAV8sdGl8n55kaEoteQwn0e0EfKTQe1beQoFT6x43RBpUsVrb1WuXjjDdgR4HHK92vJrNs+IP6leIrrGTFEO7z+oTzvoEbpGX7vT42D+KWc2rcaBwdrTeh30XUR9HzFZ+9vA6qUvPu/KZ/dzvyhNNnj40CL+GrlrqK1Qow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9979dGzkIlKuU4bdH8id1myaf7IZP+Y5vTaitmC6AM=;
 b=rBXl768oCjlN7DCKfKmmZW2qAPz9KxDhNZunG7gq6XtdgpiZ97wf3OySfa0RussN2garlqUe24WM7o0Sp+3nEVSGBWWqQTgJ0kGvHx6S1W1Pl07MT2i2dv38thjMy/lEP8NgjiFU+c7lV32zgy5BTgtOnzNR+2gEZTnl661Kxpk=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3932.namprd12.prod.outlook.com (10.255.174.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 13:32:34 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::585:2d27:6e06:f9b0]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::585:2d27:6e06:f9b0%7]) with mapi id 15.20.2178.018; Wed, 21 Aug 2019
 13:32:34 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] amd-xgbe: use devm_platform_ioremap_resource()
 to simplify code
Thread-Topic: [PATCH net-next] amd-xgbe: use devm_platform_ioremap_resource()
 to simplify code
Thread-Index: AQHVWByGFSxQcKHRfkq92WOQ3hnAh6cFmYwA
Date:   Wed, 21 Aug 2019 13:32:34 +0000
Message-ID: <f485a7b2-5bbf-1dfa-ea54-553db85c7ddb@amd.com>
References: <20190821123203.71404-1-yuehaibing@huawei.com>
In-Reply-To: <20190821123203.71404-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0076.namprd12.prod.outlook.com
 (2603:10b6:802:20::47) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d21b58a-ee4b-4684-ad02-08d7263c0626
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3932;
x-ms-traffictypediagnostic: DM6PR12MB3932:
x-microsoft-antispam-prvs: <DM6PR12MB393298EE2512771E066593B2ECAA0@DM6PR12MB3932.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(199004)(189003)(6246003)(186003)(2501003)(8936002)(81156014)(81166006)(8676002)(36756003)(66946007)(66446008)(5660300002)(64756008)(66556008)(66476007)(53936002)(86362001)(31696002)(25786009)(4326008)(256004)(2906002)(6486002)(386003)(53546011)(6506007)(102836004)(6512007)(26005)(66066001)(3846002)(6116002)(11346002)(446003)(476003)(2616005)(486006)(14454004)(99286004)(305945005)(7736002)(54906003)(110136005)(52116002)(76176011)(71190400001)(478600001)(71200400001)(6436002)(316002)(31686004)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3932;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +PTcFmM0j6xX703NYz0ts8u7aY/39ZYAcnyRBCp3OkLGUBiFwOAMxZ2Y6rDAJmI6KltTRHwX8aS/NlOpx+tDNXNN/UJE45m8u97g41Oiu1wY2LpNHvEsXVhCf6TgQJEvbJ7+B3591w3ppU2otc/p0JEX0Nnenpd3lrDWvcrlddcw9+l8B6487I3aj9MIus8K+xk5Wwm156V6yz6UiBxuWRh8QUiLoLyN0EkKZssfmBEzRMJaLYxZ5+eDaWg/3p8LewYhvI5DPFFWyNycy+25xGwl++O3fB5wv9/ohSwoLAfPcuntGZjqD8jQSobR93k7Jjm/asN1Bcse1vAZdb91Kb292KkIOV14zRzhLIDrL1bMQMjbsiQwU+JNyPkAh5KmDRDq80g0dVndmuNcshxjC1oztjtdw6Age5KjVwOD4zk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CF3085C61999143BDFA7060F3FF9641@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d21b58a-ee4b-4684-ad02-08d7263c0626
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 13:32:34.0624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nXgBgHKIN6q7IBjfdWS163lH/fzuNa1YVY9OLqoJXG4m+tmdhBCuVEEjMn9h5hO0+gL6ONscEtXuXvj+iGa7EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3932
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yMS8xOSA3OjMyIEFNLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBVc2UgZGV2bV9wbGF0Zm9y
bV9pb3JlbWFwX3Jlc291cmNlKCkgdG8gc2ltcGxpZnkgdGhlIGNvZGUgYSBiaXQuDQo+IFRoaXMg
aXMgZGV0ZWN0ZWQgYnkgY29jY2luZWxsZS4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBIdWxrIFJvYm90
IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWXVlSGFpYmluZyA8eXVlaGFp
YmluZ0BodWF3ZWkuY29tPg0KDQpBY2tlZC1ieTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFj
a3lAYW1kLmNvbT4NCg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FtZC94Z2JlL3hn
YmUtcGxhdGZvcm0uYyB8IDE5ICsrKysrKysrLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2Vk
LCA4IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2FtZC94Z2JlL3hnYmUtcGxhdGZvcm0uYyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2FtZC94Z2JlL3hnYmUtcGxhdGZvcm0uYw0KPiBpbmRleCBkY2U5ZTU5Li40ZWJk
MjQxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWQveGdiZS94Z2JlLXBs
YXRmb3JtLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1kL3hnYmUveGdiZS1wbGF0
Zm9ybS5jDQo+IEBAIC0zMDEsNyArMzAxLDYgQEAgc3RhdGljIGludCB4Z2JlX3BsYXRmb3JtX3By
b2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJc3RydWN0IHhnYmVfcHJ2X2Rh
dGEgKnBkYXRhOw0KPiAgCXN0cnVjdCBkZXZpY2UgKmRldiA9ICZwZGV2LT5kZXY7DQo+ICAJc3Ry
dWN0IHBsYXRmb3JtX2RldmljZSAqcGh5X3BkZXY7DQo+IC0Jc3RydWN0IHJlc291cmNlICpyZXM7
DQo+ICAJY29uc3QgY2hhciAqcGh5X21vZGU7DQo+ICAJdW5zaWduZWQgaW50IHBoeV9tZW1udW0s
IHBoeV9pcnFudW07DQo+ICAJdW5zaWduZWQgaW50IGRtYV9pcnFudW0sIGRtYV9pcnFlbmQ7DQo+
IEBAIC0zNTMsOCArMzUyLDcgQEAgc3RhdGljIGludCB4Z2JlX3BsYXRmb3JtX3Byb2JlKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJfQ0KPiAgDQo+ICAJLyogT2J0YWluIHRoZSBt
bWlvIGFyZWFzIGZvciB0aGUgZGV2aWNlICovDQo+IC0JcmVzID0gcGxhdGZvcm1fZ2V0X3Jlc291
cmNlKHBkZXYsIElPUkVTT1VSQ0VfTUVNLCAwKTsNCj4gLQlwZGF0YS0+eGdtYWNfcmVncyA9IGRl
dm1faW9yZW1hcF9yZXNvdXJjZShkZXYsIHJlcyk7DQo+ICsJcGRhdGEtPnhnbWFjX3JlZ3MgPSBk
ZXZtX3BsYXRmb3JtX2lvcmVtYXBfcmVzb3VyY2UocGRldiwgMCk7DQo+ICAJaWYgKElTX0VSUihw
ZGF0YS0+eGdtYWNfcmVncykpIHsNCj4gIAkJZGV2X2VycihkZXYsICJ4Z21hYyBpb3JlbWFwIGZh
aWxlZFxuIik7DQo+ICAJCXJldCA9IFBUUl9FUlIocGRhdGEtPnhnbWFjX3JlZ3MpOw0KPiBAQCAt
MzYzLDggKzM2MSw3IEBAIHN0YXRpYyBpbnQgeGdiZV9wbGF0Zm9ybV9wcm9iZShzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgCWlmIChuZXRpZl9tc2dfcHJvYmUocGRhdGEpKQ0KPiAg
CQlkZXZfZGJnKGRldiwgInhnbWFjX3JlZ3MgPSAlcFxuIiwgcGRhdGEtPnhnbWFjX3JlZ3MpOw0K
PiAgDQo+IC0JcmVzID0gcGxhdGZvcm1fZ2V0X3Jlc291cmNlKHBkZXYsIElPUkVTT1VSQ0VfTUVN
LCAxKTsNCj4gLQlwZGF0YS0+eHBjc19yZWdzID0gZGV2bV9pb3JlbWFwX3Jlc291cmNlKGRldiwg
cmVzKTsNCj4gKwlwZGF0YS0+eHBjc19yZWdzID0gZGV2bV9wbGF0Zm9ybV9pb3JlbWFwX3Jlc291
cmNlKHBkZXYsIDEpOw0KPiAgCWlmIChJU19FUlIocGRhdGEtPnhwY3NfcmVncykpIHsNCj4gIAkJ
ZGV2X2VycihkZXYsICJ4cGNzIGlvcmVtYXAgZmFpbGVkXG4iKTsNCj4gIAkJcmV0ID0gUFRSX0VS
UihwZGF0YS0+eHBjc19yZWdzKTsNCj4gQEAgLTM3Myw4ICszNzAsOCBAQCBzdGF0aWMgaW50IHhn
YmVfcGxhdGZvcm1fcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAlpZiAo
bmV0aWZfbXNnX3Byb2JlKHBkYXRhKSkNCj4gIAkJZGV2X2RiZyhkZXYsICJ4cGNzX3JlZ3MgID0g
JXBcbiIsIHBkYXRhLT54cGNzX3JlZ3MpOw0KPiAgDQo+IC0JcmVzID0gcGxhdGZvcm1fZ2V0X3Jl
c291cmNlKHBoeV9wZGV2LCBJT1JFU09VUkNFX01FTSwgcGh5X21lbW51bSsrKTsNCj4gLQlwZGF0
YS0+cnh0eF9yZWdzID0gZGV2bV9pb3JlbWFwX3Jlc291cmNlKGRldiwgcmVzKTsNCj4gKwlwZGF0
YS0+cnh0eF9yZWdzID0gZGV2bV9wbGF0Zm9ybV9pb3JlbWFwX3Jlc291cmNlKHBoeV9wZGV2LA0K
PiArCQkJCQkJCSAgcGh5X21lbW51bSsrKTsNCj4gIAlpZiAoSVNfRVJSKHBkYXRhLT5yeHR4X3Jl
Z3MpKSB7DQo+ICAJCWRldl9lcnIoZGV2LCAicnh0eCBpb3JlbWFwIGZhaWxlZFxuIik7DQo+ICAJ
CXJldCA9IFBUUl9FUlIocGRhdGEtPnJ4dHhfcmVncyk7DQo+IEBAIC0zODMsOCArMzgwLDggQEAg
c3RhdGljIGludCB4Z2JlX3BsYXRmb3JtX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBk
ZXYpDQo+ICAJaWYgKG5ldGlmX21zZ19wcm9iZShwZGF0YSkpDQo+ICAJCWRldl9kYmcoZGV2LCAi
cnh0eF9yZWdzICA9ICVwXG4iLCBwZGF0YS0+cnh0eF9yZWdzKTsNCj4gIA0KPiAtCXJlcyA9IHBs
YXRmb3JtX2dldF9yZXNvdXJjZShwaHlfcGRldiwgSU9SRVNPVVJDRV9NRU0sIHBoeV9tZW1udW0r
Kyk7DQo+IC0JcGRhdGEtPnNpcjBfcmVncyA9IGRldm1faW9yZW1hcF9yZXNvdXJjZShkZXYsIHJl
cyk7DQo+ICsJcGRhdGEtPnNpcjBfcmVncyA9IGRldm1fcGxhdGZvcm1faW9yZW1hcF9yZXNvdXJj
ZShwaHlfcGRldiwNCj4gKwkJCQkJCQkgIHBoeV9tZW1udW0rKyk7DQo+ICAJaWYgKElTX0VSUihw
ZGF0YS0+c2lyMF9yZWdzKSkgew0KPiAgCQlkZXZfZXJyKGRldiwgInNpcjAgaW9yZW1hcCBmYWls
ZWRcbiIpOw0KPiAgCQlyZXQgPSBQVFJfRVJSKHBkYXRhLT5zaXIwX3JlZ3MpOw0KPiBAQCAtMzkz
LDggKzM5MCw4IEBAIHN0YXRpYyBpbnQgeGdiZV9wbGF0Zm9ybV9wcm9iZShzdHJ1Y3QgcGxhdGZv
cm1fZGV2aWNlICpwZGV2KQ0KPiAgCWlmIChuZXRpZl9tc2dfcHJvYmUocGRhdGEpKQ0KPiAgCQlk
ZXZfZGJnKGRldiwgInNpcjBfcmVncyAgPSAlcFxuIiwgcGRhdGEtPnNpcjBfcmVncyk7DQo+ICAN
Cj4gLQlyZXMgPSBwbGF0Zm9ybV9nZXRfcmVzb3VyY2UocGh5X3BkZXYsIElPUkVTT1VSQ0VfTUVN
LCBwaHlfbWVtbnVtKyspOw0KPiAtCXBkYXRhLT5zaXIxX3JlZ3MgPSBkZXZtX2lvcmVtYXBfcmVz
b3VyY2UoZGV2LCByZXMpOw0KPiArCXBkYXRhLT5zaXIxX3JlZ3MgPSBkZXZtX3BsYXRmb3JtX2lv
cmVtYXBfcmVzb3VyY2UocGh5X3BkZXYsDQo+ICsJCQkJCQkJICBwaHlfbWVtbnVtKyspOw0KPiAg
CWlmIChJU19FUlIocGRhdGEtPnNpcjFfcmVncykpIHsNCj4gIAkJZGV2X2VycihkZXYsICJzaXIx
IGlvcmVtYXAgZmFpbGVkXG4iKTsNCj4gIAkJcmV0ID0gUFRSX0VSUihwZGF0YS0+c2lyMV9yZWdz
KTsNCj4gDQo=
