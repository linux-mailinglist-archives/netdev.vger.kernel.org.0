Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D945EF3B
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 00:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfGCWnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 18:43:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbfGCWnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 18:43:22 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63Mcv9X006617;
        Wed, 3 Jul 2019 15:43:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=X9I1zmHQOgm/qlaUDCcdjey+iaogEhUZYbUriYOZRU0=;
 b=rPQrYz79LH/BcYp6e6zfGVxipXX2AK2lQ1+LnDWRAiIuS30tXg4PXfXguV7OIhOj7H3c
 ve+4MPE69JX11+1isiZ0hwSFCC/MMVAHlAmVP2K8O+xLJXkC8joNUIqC5oIPG35xRiYT
 6hJrlbB6f4Lte9ZVtr/LLspPWoGJIeZRh24= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tgqvraxt6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 03 Jul 2019 15:43:01 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 3 Jul 2019 15:43:00 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 3 Jul 2019 15:43:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9I1zmHQOgm/qlaUDCcdjey+iaogEhUZYbUriYOZRU0=;
 b=E1XUyvYMYbohy2WTabfzGWv9295FBxZIsr3fmdoXRVb8gltz29qXfw+kNe/7UMLPRL+B6wSuRpx+JCSWHCmA9uwMNXsoN0p/QOGEiGN4uIjQbfUqnVp848zG/WezWet308FB7aIxtUCEbmo8N2k+MYYUw0fjIBsvSUsVaNB9sCw=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3431.namprd15.prod.outlook.com (20.179.59.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.15; Wed, 3 Jul 2019 22:42:39 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 22:42:39 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 0/4] capture integers in BTF type info for map
 defs
Thread-Topic: [PATCH v3 bpf-next 0/4] capture integers in BTF type info for
 map defs
Thread-Index: AQHVMdJ4/wW4AyF07UKehLMJaHrtH6a5fZSA
Date:   Wed, 3 Jul 2019 22:42:38 +0000
Message-ID: <c72c1591-7796-07a0-2e48-9c187cd28ab8@fb.com>
References: <20190703190604.4173641-1-andriin@fb.com>
In-Reply-To: <20190703190604.4173641-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::45) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:f960]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03b9dab3-f744-4c2c-3052-08d70007c02f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3431;
x-ms-traffictypediagnostic: BYAPR15MB3431:
x-microsoft-antispam-prvs: <BYAPR15MB3431DE77CCBF5113C0AF1B41D3FB0@BYAPR15MB3431.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(39860400002)(346002)(396003)(189003)(199004)(478600001)(6636002)(76176011)(68736007)(6116002)(186003)(73956011)(99286004)(66476007)(256004)(2201001)(86362001)(31696002)(8936002)(81156014)(81166006)(8676002)(102836004)(66446008)(25786009)(14444005)(66556008)(6506007)(46003)(66946007)(53546011)(52116002)(386003)(64756008)(5660300002)(14454004)(11346002)(110136005)(71190400001)(71200400001)(6246003)(53936002)(2906002)(316002)(2501003)(6436002)(36756003)(6512007)(31686004)(486006)(476003)(2616005)(6486002)(7736002)(446003)(305945005)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3431;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vn6YttB+plTzE7kMiiLzioTHS3xLZO+20ValGHIoRuqWr3kiH/AaM9p0wx6DJjvbImcC9uN69rm11zuPIKnp4EFbH8qDdMJlYGswqtRqTm02jnkrhcmIYehslhU6CBzHjzutzfAqgf0mL/urlFWkHf2aJj+opNoQ3s50JdNJc9kqTQqbughGlm7Lck+g5/sc3Ug1w+OnTtTOjy4AOhR/cBelSpiGmk7Hee5kI9Dx7FDAO81lDW87vx9Hu2K3Ty8ilEa1BkHQQoho0mZuO9Nb2Qq0WomcfFsaiiNwYpcL7nYo6W1783lTB+UTIP+ztTklKFOzrM9G+niPpqDiFrD0V3dIEAo9JnVp58dYmyhkNIzMyi77SRxAuHZj1aVoQlVzrDboNLKmAlIWVq4gwAD2gznQHVmEWHn5L5nG5xV67bo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34BF8271F5721F42AE51517A6C2E9215@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 03b9dab3-f744-4c2c-3052-08d70007c02f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 22:42:38.9171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3431
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030277
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMy8xOSAxMjowNiBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBUaGlzIHBh
dGNoIHNldCBpbXBsZW1lbnRzIGFuIHVwZGF0ZSB0byBob3cgQlRGLWRlZmluZWQgbWFwcyBhcmUg
c3BlY2lmaWVkLiBUaGUNCj4gY2hhbmdlIGlzIGluIGhvdyBpbnRlZ2VyIGF0dHJpYnV0ZXMsIGUu
Zy4sIHR5cGUsIG1heF9lbnRyaWVzLCBtYXBfZmxhZ3MsIGFyZQ0KPiBzcGVjaWZpZWQ6IG5vdyB0
aGV5IGFyZSBjYXB0dXJlZCBhcyBwYXJ0IG9mIG1hcCBkZWZpbml0aW9uIHN0cnVjdCdzIEJURiB0
eXBlDQo+IGluZm9ybWF0aW9uICh1c2luZyBhcnJheSBkaW1lbnNpb24pLCBlbGltaW5hdGluZyB0
aGUgbmVlZCBmb3IgY29tcGlsZS10aW1lDQo+IGRhdGEgaW5pdGlhbGl6YXRpb24gYW5kIGtlZXBp
bmcgYWxsIHRoZSBtZXRhZGF0YSBpbiBvbmUgcGxhY2UuDQo+IA0KPiBBbGwgZXhpc3Rpbmcgc2Vs
ZnRlc3RzIHRoYXQgd2VyZSB1c2luZyBCVEYtZGVmaW5lZCBtYXBzIGFyZSB1cGRhdGVkLCBhbG9u
Zw0KPiB3aXRoIHNvbWUgb3RoZXIgc2VsZnRlc3RzLCB0aGF0IHdlcmUgc3dpdGNoZWQgdG8gbmV3
IHN5bnRheC4NCj4gDQo+IHYyLT52MzoNCj4gLSByZW5hbWUgX19pbnQgaW50byBfX3VpbnQgKFlv
bmdob25nKTsNCj4gdjEtPnYyOg0KPiAtIHNwbGl0IGJwZl9oZWxwZXJzLmggY2hhbmdlIGZyb20g
bGliYnBmIGNoYW5nZSAoU29uZykuDQo+IA0KPiBBbmRyaWkgTmFrcnlpa28gKDQpOg0KPiAgICBs
aWJicGY6IGNhcHR1cmUgdmFsdWUgaW4gQlRGIHR5cGUgaW5mbyBmb3IgQlRGLWRlZmluZWQgbWFw
IGRlZnMNCj4gICAgc2VsZnRlc3RzL2JwZjogYWRkIF9faW50IGFuZCBfX3R5cGUgbWFjcm8gZm9y
IEJURi1kZWZpbmVkIG1hcHMNCj4gICAgc2VsZnRlc3RzL2JwZjogY29udmVydCBzZWxmdGVzdHMg
dXNpbmcgQlRGLWRlZmluZWQgbWFwcyB0byBuZXcgc3ludGF4DQo+ICAgIHNlbGZ0ZXN0cy9icGY6
IGNvbnZlcnQgbGVnYWN5IEJQRiBtYXBzIHRvIEJURi1kZWZpbmVkIG9uZXMNCj4gDQoNCldpdGgg
dHlwb3MgaW4gcGF0Y2ggMi80IChtZW50aW9uZWQgaW4gYW5vdGhlciB0aHJlYWQpLCBhY2sgdGhl
IHdob2xlIHNlcmllcy4NCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+
ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDU4ICsr
KysrLS0tLQ0KPiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9icGZfaGVscGVycy5oICAg
ICB8ICAgMyArDQo+ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL2JwZl9mbG93
LmMgIHwgIDI4ICsrLS0tDQo+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvZ2V0X2Nncm91cF9p
ZF9rZXJuLmMgIHwgIDI2ICsrLS0tDQo+ICAgLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
cy9uZXRjbnRfcHJvZy5jIHwgIDIwICsrLS0NCj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvcHJvZ3MvcHlwZXJmLmggICAgfCAgOTAgKysrKysrKy0tLS0tLS0NCj4gICAuLi4vc2VsZnRl
c3RzL2JwZi9wcm9ncy9zYW1wbGVfbWFwX3JldDAuYyAgICAgfCAgMjQgKystLQ0KPiAgIC4uLi9z
ZWxmdGVzdHMvYnBmL3Byb2dzL3NvY2tldF9jb29raWVfcHJvZy5jICB8ICAxMyArLS0NCj4gICAu
Li4vYnBmL3Byb2dzL3NvY2ttYXBfdmVyZGljdF9wcm9nLmMgICAgICAgICAgfCAgNDggKysrKy0t
LS0NCj4gICAuLi4vdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3N0cm9iZW1ldGEuaCAgfCAg
NjggKysrKystLS0tLS0NCj4gICAuLi4vc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2J0Zl9uZXdr
di5jICAgICAgfCAgMTMgKy0tDQo+ICAgLi4uL2JwZi9wcm9ncy90ZXN0X2dldF9zdGFja19yYXd0
cC5jICAgICAgICAgIHwgIDM5ICsrKy0tLS0NCj4gICAuLi4vc2VsZnRlc3RzL2JwZi9wcm9ncy90
ZXN0X2dsb2JhbF9kYXRhLmMgICAgfCAgMzcgKysrLS0tDQo+ICAgdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL3Byb2dzL3Rlc3RfbDRsYi5jIHwgIDY1ICsrKystLS0tLS0tDQo+ICAgLi4uL3Nl
bGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9sNGxiX25vaW5saW5lLmMgIHwgIDY1ICsrKystLS0tLS0t
DQo+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9tYXBfaW5fbWFwLmMgICAgIHwgIDMw
ICsrLS0tDQo+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9tYXBfbG9jay5jICAgICAg
IHwgIDI2ICsrLS0tDQo+ICAgLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X29i
al9pZC5jIHwgIDEyICstDQo+ICAgLi4uL2JwZi9wcm9ncy90ZXN0X3NlbGVjdF9yZXVzZXBvcnRf
a2Vybi5jICAgIHwgIDY3ICsrKystLS0tLS0tDQo+ICAgLi4uL2JwZi9wcm9ncy90ZXN0X3NlbmRf
c2lnbmFsX2tlcm4uYyAgICAgICAgIHwgIDI2ICsrLS0tDQo+ICAgLi4uL2JwZi9wcm9ncy90ZXN0
X3NvY2tfZmllbGRzX2tlcm4uYyAgICAgICAgIHwgIDc4ICsrKysrLS0tLS0tLS0NCj4gICAuLi4v
c2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X3NwaW5fbG9jay5jICAgICAgfCAgMzYgKysrLS0tDQo+
ICAgLi4uL2JwZi9wcm9ncy90ZXN0X3N0YWNrdHJhY2VfYnVpbGRfaWQuYyAgICAgIHwgIDU1ICsr
KystLS0tLQ0KPiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3Rfc3RhY2t0cmFjZV9tYXAu
YyB8ICA1MiArKystLS0tLS0NCj4gICAuLi4vc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X3RjcF9l
c3RhdHMuYyAgICAgfCAgMTMgKy0tDQo+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF90
Y3BicGZfa2Vybi5jICAgIHwgIDI2ICsrLS0tDQo+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3Mv
dGVzdF90Y3Bub3RpZnlfa2Vybi5jIHwgIDI4ICsrLS0tDQo+ICAgdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL3Byb2dzL3Rlc3RfeGRwLmMgIHwgIDI2ICsrLS0tDQo+ICAgLi4uL3NlbGZ0ZXN0
cy9icGYvcHJvZ3MvdGVzdF94ZHBfbG9vcC5jICAgICAgIHwgIDI2ICsrLS0tDQo+ICAgLi4uL3Nl
bGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF94ZHBfbm9pbmxpbmUuYyAgIHwgIDgxICsrKysrLS0tLS0t
LS0NCj4gICAuLi4vc2VsZnRlc3RzL2JwZi9wcm9ncy94ZHBfcmVkaXJlY3RfbWFwLmMgICAgfCAg
MTIgKy0NCj4gICAuLi4vdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3hkcGluZ19rZXJuLmMg
fCAgMTIgKy0NCj4gICAuLi4vc2VsZnRlc3RzL2JwZi90ZXN0X3F1ZXVlX3N0YWNrX21hcC5oICAg
ICAgfCAgMzAgKystLS0NCj4gICAuLi4vdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3Rfc29ja21h
cF9rZXJuLmggfCAxMTAgKysrKysrKysrLS0tLS0tLS0tDQo+ICAgMzQgZmlsZXMgY2hhbmdlZCwg
NTcxIGluc2VydGlvbnMoKyksIDc3MiBkZWxldGlvbnMoLSkNCj4gDQo=
