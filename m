Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85854275A9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfEWFpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:45:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54238 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725806AbfEWFpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:45:31 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4N5d5f3013545;
        Wed, 22 May 2019 22:45:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IjLGlLxSjrcckTOm4pJgmPz2xk7rgypXkE+fStWeU18=;
 b=HUlD9zNv4YppcRIQVC9O8MMOZMdSVYZf5h/PsOZd7EnLAtqBYu1AQp7E082+XGPhlKRv
 XtuQVq2R8bJMB4kBcqiGGnI4B/cJMdlrbH1LL7Yq8j61MnGG1H/c5XsNe0g4+2PXGIWe
 Wpfu8SCMdqevn0Tg7h9KuxQiYrJLPKkugQI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2snabk27fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 May 2019 22:45:10 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 22:45:09 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 22:45:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjLGlLxSjrcckTOm4pJgmPz2xk7rgypXkE+fStWeU18=;
 b=qYQ3Z4gteH0MJeCVmOVcBsPqnYxckFiuMuOedX/Z1Ju4vMjFaF64s5hH7ScCFOpKYO9IlTNPXU2zw3AA/wzOmBQ0ry1U4MhMtlfQ+04Hl2CixTfhZImZj654S0YzoFP4M11up6447YZF5F0beM+4Ous1bvUZOucON7rWTApkLZw=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2549.namprd15.prod.outlook.com (20.179.155.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 05:45:06 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 05:45:06 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: enable all available
 cgroup v2 controllers
Thread-Topic: [PATCH v2 bpf-next 3/4] selftests/bpf: enable all available
 cgroup v2 controllers
Thread-Index: AQHVEPUDEyOQmYd8ekSwbcC0WXX9P6Z4M2mA
Date:   Thu, 23 May 2019 05:45:05 +0000
Message-ID: <98e6207c-f024-eae6-9e4b-d95223879e4d@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
 <20190522232051.2938491-4-guro@fb.com>
In-Reply-To: <20190522232051.2938491-4-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1201CA0019.namprd12.prod.outlook.com
 (2603:10b6:301:4a::29) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c87a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40b2bbc0-ed2f-4c8b-8f12-08d6df41ced2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2549;
x-ms-traffictypediagnostic: BYAPR15MB2549:
x-microsoft-antispam-prvs: <BYAPR15MB25492EAAB050227DDA4594F1D3010@BYAPR15MB2549.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(346002)(376002)(39860400002)(199004)(189003)(6512007)(305945005)(99286004)(53546011)(36756003)(102836004)(7736002)(486006)(2906002)(478600001)(46003)(71190400001)(8676002)(71200400001)(81166006)(8936002)(53936002)(14454004)(2616005)(476003)(2501003)(81156014)(6506007)(386003)(52116002)(54906003)(14444005)(256004)(76176011)(86362001)(66946007)(66476007)(73956011)(4326008)(6486002)(110136005)(68736007)(6246003)(25786009)(186003)(229853002)(5660300002)(6116002)(66446008)(446003)(31696002)(66556008)(316002)(11346002)(64756008)(31686004)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2549;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KnDnL/B+c44bPEvItuqhRzE8xbvFYL8kA+zQTrS2dfc3+qJObAyHNs4SvEpq9F91fHdj14aH5D0Bd7iQ8IVWMjW8vDyNS0etL90bvuoQDrXnob3vPS274PL0fD+x8lbrUhlJLtPgzI3D1/3owRk/lfp8gzCFXigJxO0IWg9XbKruusuDLIoqKYCzunaBmWUHEAV8KmvNJmWFNx7LU6OQOq8cV+y52qaIhesJ4t2hgKmrW5Tal3M2r4zOhF5XSENLMXzBfXn0Cs+x7Xz+Kl7WcKapYRK61m8Fg2+t2T5nHfUDS2I8Bbrtd70Jj8OtGZ9tkvu7QvbhzFXjReNfW7Az/tZVRxmy1/4n1AUfg3m4RUkvzTbfMNl921HlbAoiqFSl2utl9T/m/kzpXRq5NUQ1wPB3YcTa84kVJBGt/JQdCn0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25ACBFE0A167F0489F4F9BF0B28E85FE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b2bbc0-ed2f-4c8b-8f12-08d6df41ced2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 05:45:05.9215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2549
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjIvMTkgNDoyMCBQTSwgUm9tYW4gR3VzaGNoaW4gd3JvdGU6DQo+IEVuYWJsZSBh
bGwgYXZhaWxhYmxlIGNncm91cCB2MiBjb250cm9sbGVycyB3aGVuIHNldHRpbmcgdXANCj4gdGhl
IGVudmlyb25tZW50IGZvciB0aGUgYnBmIGtzZWxmdGVzdHMuIEl0J3MgcmVxdWlyZWQgdG8gcHJv
cGVybHkgdGVzdA0KPiB0aGUgYnBmIHByb2cgYXV0by1kZXRhY2ggZmVhdHVyZS4gQWxzbyBpdCB3
aWxsIGdlbmVyYWxseSBpbmNyZWFzZQ0KPiB0aGUgY29kZSBjb3ZlcmFnZS4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFJvbWFuIEd1c2hjaGluIDxndXJvQGZiLmNvbT4NCkxvb2tzIGdvb2QgdG8gbWUu
IEFjayB3aXRoIG9uZSBuaXQgYmVsb3cuDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZi
LmNvbT4NCg0KPiAtLS0NCj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvY2dyb3VwX2hl
bHBlcnMuYyB8IDU3ICsrKysrKysrKysrKysrKysrKysrDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDU3
IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9icGYvY2dyb3VwX2hlbHBlcnMuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9jZ3Jv
dXBfaGVscGVycy5jDQo+IGluZGV4IDY2OTJhNDBhNjk3OS4uNGVmZTU3YzE3MWNkIDEwMDY0NA0K
PiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvY2dyb3VwX2hlbHBlcnMuYw0KPiAr
KysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvY2dyb3VwX2hlbHBlcnMuYw0KPiBAQCAt
MzMsNiArMzMsNjAgQEANCj4gICAJc25wcmludGYoYnVmLCBzaXplb2YoYnVmKSwgIiVzJXMlcyIs
IENHUk9VUF9NT1VOVF9QQVRILCBcDQo+ICAgCQkgQ0dST1VQX1dPUktfRElSLCBwYXRoKQ0KPiAg
IA0KPiArLyoqDQo+ICsgKiBlbmFibGVfYWxsX2NvbnRyb2xsZXJzKCkgLSBFbmFibGUgYWxsIGF2
YWlsYWJsZSBjZ3JvdXAgdjIgY29udHJvbGxlcnMNCj4gKyAqDQo+ICsgKiBFbmFibGUgYWxsIGF2
YWlsYWJsZSBjZ3JvdXAgdjIgY29udHJvbGxlcnMgaW4gb3JkZXIgdG8gaW5jcmVhc2UNCj4gKyAq
IHRoZSBjb2RlIGNvdmVyYWdlLg0KPiArICoNCj4gKyAqIElmIHN1Y2Nlc3NmdWwsIDAgaXMgcmV0
dXJuZWQuDQo+ICsgKi8NCj4gK2ludCBlbmFibGVfYWxsX2NvbnRyb2xsZXJzKGNoYXIgKmNncm91
cF9wYXRoKQ0KPiArew0KPiArCWNoYXIgcGF0aFtQQVRIX01BWCArIDFdOw0KPiArCWNoYXIgYnVm
W1BBVEhfTUFYXTsNCj4gKwljaGFyICpjLCAqYzI7DQo+ICsJaW50IGZkLCBjZmQ7DQo+ICsJc2l6
ZV90IGxlbjsNCj4gKw0KPiArCXNucHJpbnRmKHBhdGgsIHNpemVvZihwYXRoKSwgIiVzL2Nncm91
cC5jb250cm9sbGVycyIsIGNncm91cF9wYXRoKTsNCj4gKwlmZCA9IG9wZW4ocGF0aCwgT19SRE9O
TFkpOw0KPiArCWlmIChmZCA8IDApIHsNCj4gKwkJbG9nX2VycigiT3BlbmluZyBjZ3JvdXAuY29u
dHJvbGxlcnM6ICVzIiwgcGF0aCk7DQo+ICsJCXJldHVybiAtMTsNCkl0IGxvb2tzIGxpa2UgZWl0
aGVyIC0xIG9yIDEgY291bGQgYmUgcmV0dXJuZWQgdG8gaW5kaWNhdGUgYW4gZXJyb3INCmluIHRo
aXMgZmlsZS4gTWF5YmUsIGF0IGxlYXN0IGZvciB0aGUgY29uc2lzdGVuY3kgb2YgdGhpcyBmaWxl
LA0KYWx3YXlzIHJldHVybmluZyAxIGlzIHByZWZlcnJlZCBhcyBzZXR1cF9jZ3JvdXBfZW52aXJv
bm1lbnQoKQ0KaGFzIHRoZSBmb2xsb3dpbmcgY29tbWVudHM6DQogICogVGhpcyBmdW5jdGlvbiB3
aWxsIHByaW50IGFuIGVycm9yIHRvIHN0ZGVyciBhbmQgcmV0dXJuIDEgaWYgaXQgaXMgdW5hYmxl
DQogICogdG8gc2V0dXAgdGhlIGNncm91cCBlbnZpcm9ubWVudC4gSWYgc2V0dXAgaXMgc3VjY2Vz
c2Z1bCwgMCBpcyByZXR1cm5lZC4NCg0KPiArCX0NCj4gKw0KPiArCWxlbiA9IHJlYWQoZmQsIGJ1
Ziwgc2l6ZW9mKGJ1ZikgLSAxKTsNCj4gKwlpZiAobGVuIDwgMCkgew0KPiArCQljbG9zZShmZCk7
DQo+ICsJCWxvZ19lcnIoIlJlYWRpbmcgY2dyb3VwLmNvbnRyb2xsZXJzOiAlcyIsIHBhdGgpOw0K
PiArCQlyZXR1cm4gLTE7DQo+ICsJfQ0KPiArCWJ1ZltsZW5dID0gMDsNCj4gKwljbG9zZShmZCk7
DQo+ICsNCj4gKwkvKiBObyBjb250cm9sbGVycyBhdmFpbGFibGU/IFdlJ3JlIHByb2JhYmx5IG9u
IGNncm91cCB2MS4gKi8NCj4gKwlpZiAobGVuID09IDApDQo+ICsJCXJldHVybiAwOw0KPiArDQo+
ICsJc25wcmludGYocGF0aCwgc2l6ZW9mKHBhdGgpLCAiJXMvY2dyb3VwLnN1YnRyZWVfY29udHJv
bCIsIGNncm91cF9wYXRoKTsNCj4gKwljZmQgPSBvcGVuKHBhdGgsIE9fUkRXUik7DQo+ICsJaWYg
KGNmZCA8IDApIHsNCj4gKwkJbG9nX2VycigiT3BlbmluZyBjZ3JvdXAuc3VidHJlZV9jb250cm9s
OiAlcyIsIHBhdGgpOw0KPiArCQlyZXR1cm4gLTE7DQo+ICsJfQ0KPiArDQo+ICsJZm9yIChjID0g
c3RydG9rX3IoYnVmLCAiICIsICZjMik7IGM7IGMgPSBzdHJ0b2tfcihOVUxMLCAiICIsICZjMikp
IHsNCj4gKwkJaWYgKGRwcmludGYoY2ZkLCAiKyVzXG4iLCBjKSA8PSAwKSB7DQo+ICsJCQlsb2df
ZXJyKCJFbmFibGluZyBjb250cm9sbGVyICVzOiAlcyIsIGMsIHBhdGgpOw0KPiArCQkJY2xvc2Uo
Y2ZkKTsNCj4gKwkJCXJldHVybiAtMTsNCj4gKwkJfQ0KPiArCX0NCj4gKwljbG9zZShjZmQpOw0K
PiArCXJldHVybiAwOw0KPiArfQ0KPiArDQo+ICAgLyoqDQo+ICAgICogc2V0dXBfY2dyb3VwX2Vu
dmlyb25tZW50KCkgLSBTZXR1cCB0aGUgY2dyb3VwIGVudmlyb25tZW50DQo+ICAgICoNCj4gQEAg
LTcxLDYgKzEyNSw5IEBAIGludCBzZXR1cF9jZ3JvdXBfZW52aXJvbm1lbnQodm9pZCkNCj4gICAJ
CXJldHVybiAxOw0KPiAgIAl9DQo+ICAgDQo+ICsJaWYgKGVuYWJsZV9hbGxfY29udHJvbGxlcnMo
Y2dyb3VwX3dvcmtkaXIpKQ0KPiArCQlyZXR1cm4gMTsNCj4gKw0KPiAgIAlyZXR1cm4gMDsNCj4g
ICB9DQo+ICAgDQo+IA0K
