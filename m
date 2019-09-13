Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6045B276E
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfIMVnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:43:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28144 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727985AbfIMVnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:43:51 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DLhEi0028653;
        Fri, 13 Sep 2019 14:43:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=t29OAYCSJodBeaQ4OAYLbJt+9h6OFHwbktpmVfe1jKM=;
 b=MyzBBF8F05/+yBdNgHDkYeg0D3gAvzXTTwRDlM0XLyUdtEK02sdXRcX42Q471h+4UlSc
 Rpnt8slmVvA6yhXxkFU5L4Qb5SF7xnfAU17ocCppxrSUP6uMInhDSFzWw7645eOJFzNP
 3xMI2rjfbJdirg++cFR4uPekb9AS1eDCdpQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v0ehf1cd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 14:43:25 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 14:43:24 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 14:43:24 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 14:43:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dl1r6nKZeBfwEW2DULCJQfwWRw9aipl03EEhf/N9IQg9v1PFXPCdfNkB8fuGafw7AgcbCpZ7CyJI85DphyR+3Osia43333Aez1A1+tV9R+JTITllU03ozVRvn4goVTsv4jjcT9XuliWzfCi3YeR8MmbdXvP4vNiodbkYVuWjyK5/OoEDBRaVMicJMrLkK3+mN/6fAsmeCNQgXwrBVaNhP8ZWFzLiAmr8JywKJTkEkNHQ2RPeK6Di4PIllMLdnQ05t0beQZMLSX6zHNd2ZJYQhi27yPrFmtRBMBGAV/gM/4oLUqTn34FSoz62yp+MOVqgkwiSOOG8hV82zBqnzQFywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t29OAYCSJodBeaQ4OAYLbJt+9h6OFHwbktpmVfe1jKM=;
 b=QELwGw1HVCkkpLLAC09FeNrTbDfquJlfNmiy3Sip2g13zjmnFOiwzTIu4d+Mbbw6rQidAHCny4fAypZOcsPe3t9/FfkNeA1gJ4lwpTukCGTB1eqg943sq2Pe0ME89uJmlzj9u9VBJSjIeZfbWgyn605i/nuNY282RTJzsyoeJFsuz1Vadtm1Nz6NLRq0Xg4GcLkhfxGMEmJLLZClfEqwSOgKsPHvCGYI4hDyxrdIMMXOHBOswDCsvzceeonmUl+QmP0sd7I03todofW6hHBFPb7WRwQUXqk3fJm3JG/ftjgg3OLWKtnSDbJwdsuuHCjGVZBac5ILq5s02wutYXI9Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t29OAYCSJodBeaQ4OAYLbJt+9h6OFHwbktpmVfe1jKM=;
 b=UFK4Ffj+kmSrP4fSAS75ZGKdSOELrW5eb6q+8MOSY0CNipBq1Niz5aFe9sNr/njM0mItqnjVTQyPbRofhxGqMSecW4oS/qrlDxzHZJ/jEVMunyhqUDABSKQ3aWFjcHOT2oFuIz3lHBZzwLZlSpDDym0O0Krx/Xmy7SC+kH2TXqs=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2790.namprd15.prod.outlook.com (20.179.158.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Fri, 13 Sep 2019 21:43:23 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 21:43:22 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next 10/11] libbpf: makefile: add C/CXX/LDFLAGS to
 libbpf.so and test_libpf targets
Thread-Topic: [PATCH bpf-next 10/11] libbpf: makefile: add C/CXX/LDFLAGS to
 libbpf.so and test_libpf targets
Thread-Index: AQHVZ8P227ZjVLoXXk6TohiF3lwY/qcqKPuA
Date:   Fri, 13 Sep 2019 21:43:22 +0000
Message-ID: <0ad42019-2614-b70c-f93e-527c136bba83@fb.com>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-11-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190910103830.20794-11-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:907:1::34) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0811495f-7f13-455d-f49e-08d738936674
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2790;
x-ms-traffictypediagnostic: BYAPR15MB2790:
x-microsoft-antispam-prvs: <BYAPR15MB27901BEF426C2D8EEDCABC0FD3B30@BYAPR15MB2790.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:172;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6512007)(2906002)(478600001)(66556008)(305945005)(110136005)(66476007)(6486002)(81156014)(8676002)(6436002)(66446008)(54906003)(486006)(86362001)(256004)(2501003)(71200400001)(71190400001)(316002)(476003)(7416002)(36756003)(14454004)(76176011)(99286004)(7736002)(31686004)(64756008)(31696002)(2201001)(5660300002)(4326008)(25786009)(52116002)(81166006)(6116002)(66946007)(8936002)(229853002)(102836004)(386003)(53546011)(186003)(6506007)(446003)(11346002)(2616005)(53936002)(6246003)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2790;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h6eI+6TiSSBB2gQwkFT9WOhp6Qvb/zIcqCZFReq/T4GzXVA8gRzSVd7tnF700OsjoL5zKGvl1SbMNPtHtV7fe0lJjwzmUApqR9+dzj7eNKFI5P7zhDdjJjqgjoCymgBTtJkLfh/Q/SYpIr1EMW/z/WUXkZcO6CdZu7Bwww5/Nt8ztoHPXTW76tQEXxFan80nsKGqubBEeyAFE3tneu8OZ+pKyV5j9qVdRed8W9VB0TJNDraVSx9Qj4XnqzS+Spx8ORjc/2EKgdTHbpb4qd1Q0bOXycvsS0z4kWYndIxpV4ZLsKkC5rPsJVmq9OaNdRQ5sxkuWPfKSdckTpJwA2+tDAFcIsErrAJQ+wgPf9e3LfUsyVxH9KIuEYGaoAaDUizMia3LsE5L23PbQd2EMHQePeRKJrjEckNMrc4Fs6u2T3o=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9276BE0779FC2146AD5B81D975A87A3E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0811495f-7f13-455d-f49e-08d738936674
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 21:43:22.8652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +yq3wAw+VXgg+4uUkBDgU+vAgTJyJnd1QQ1Ujz+mijBS2FFuwTjzT8FOeb0Ng2xb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2790
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_10:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130216
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTAvMTkgMTE6MzggQU0sIEl2YW4gS2hvcm9uemh1ayB3cm90ZToNCj4gSW4gY2Fz
ZSBvZiBMREZMQUdTIGFuZCBFWFRSQV9DQy9DWFggZmxhZ3MgdGhlcmUgaXMgbm8gd2F5IHRvIHBh
c3MgdGhlbQ0KPiBjb3JyZWN0bHkgdG8gYnVpbGQgY29tbWFuZCwgZm9yIGluc3RhbmNlIHdoZW4g
LS1zeXNyb290IGlzIHVzZWQgb3INCj4gZXh0ZXJuYWwgbGlicmFyaWVzIGFyZSB1c2VkLCBsaWtl
IC1sZWxmLCB3aWNoIGNhbiBiZSBhYnNlbnQgaW4NCj4gdG9vbGNoYWluLiBUaGlzIGlzIHVzZWQg
Zm9yIHNhbXBsZXMvYnBmIGNyb3NzLWNvbXBpbGluZyBhbGxvd2luZyB0bw0KPiBnZXQgZWxmIGxp
YiBmcm9tIHN5c3Jvb3QuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBJdmFuIEtob3JvbnpodWsgPGl2
YW4ua2hvcm9uemh1a0BsaW5hcm8ub3JnPg0KPiAtLS0NCj4gICBzYW1wbGVzL2JwZi9NYWtlZmls
ZSAgIHwgIDggKysrKysrKy0NCj4gICB0b29scy9saWIvYnBmL01ha2VmaWxlIHwgMTEgKysrKysr
KystLS0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25z
KC0pDQoNCkNvdWxkIHlvdSBzZXBhcmF0ZSB0aGlzIHBhdGNoIGludG8gdHdvPw0KT25lIG9mIGxp
YmJwZiBhbmQgYW5vdGhlciBmb3Igc2FtcGxlcy4NCg0KVGhlIHN1YmplY3QgJ2xpYmJwZjogLi4u
JyBpcyBub3QgZW50aXJlbHkgYWNjdXJhdGUuDQoNCj4gDQo+IGRpZmYgLS1naXQgYS9zYW1wbGVz
L2JwZi9NYWtlZmlsZSBiL3NhbXBsZXMvYnBmL01ha2VmaWxlDQo+IGluZGV4IDc5YzlhYTQxODMy
ZS4uNGVkYzUyMzJjZmMxIDEwMDY0NA0KPiAtLS0gYS9zYW1wbGVzL2JwZi9NYWtlZmlsZQ0KPiAr
KysgYi9zYW1wbGVzL2JwZi9NYWtlZmlsZQ0KPiBAQCAtMTg2LDYgKzE4NiwxMCBAQCBjY2ZsYWdz
LXkgKz0gLUkkKHNyY3RyZWUpL3Rvb2xzL3BlcmYNCj4gICBjY2ZsYWdzLXkgKz0gJChEX09QVElP
TlMpDQo+ICAgY2NmbGFncy15ICs9IC1XYWxsDQo+ICAgY2NmbGFncy15ICs9IC1mb21pdC1mcmFt
ZS1wb2ludGVyDQo+ICsNCj4gK0VYVFJBX0NYWEZMQUdTIDo9ICQoY2NmbGFncy15KQ0KPiArDQo+
ICsjIG9wdGlvbnMgbm90IHZhbGlkIGZvciBDKysNCj4gICBjY2ZsYWdzLXkgKz0gLVdtaXNzaW5n
LXByb3RvdHlwZXMNCj4gICBjY2ZsYWdzLXkgKz0gLVdzdHJpY3QtcHJvdG90eXBlcw0KPiAgIA0K
PiBAQCAtMjUyLDcgKzI1Niw5IEBAIGNsZWFuOg0KPiAgIA0KPiAgICQoTElCQlBGKTogRk9SQ0UN
Cj4gICAjIEZpeCB1cCB2YXJpYWJsZXMgaW5oZXJpdGVkIGZyb20gS2J1aWxkIHRoYXQgdG9vbHMv
IGJ1aWxkIHN5c3RlbSB3b24ndCBsaWtlDQo+IC0JJChNQUtFKSAtQyAkKGRpciAkQCkgUk09J3Jt
IC1yZicgTERGTEFHUz0gc3JjdHJlZT0kKEJQRl9TQU1QTEVTX1BBVEgpLy4uLy4uLyBPPQ0KPiAr
CSQoTUFLRSkgLUMgJChkaXIgJEApIFJNPSdybSAtcmYnIEVYVFJBX0NGTEFHUz0iJChQUk9HU19D
RkxBR1MpIiBcDQo+ICsJCUVYVFJBX0NYWEZMQUdTPSIkKEVYVFJBX0NYWEZMQUdTKSIgTERGTEFH
Uz0kKFBST0dTX0xERkxBR1MpIFwNCj4gKwkJc3JjdHJlZT0kKEJQRl9TQU1QTEVTX1BBVEgpLy4u
Ly4uLyBPPQ0KPiAgIA0KPiAgICQob2JqKS9zeXNjYWxsX25ycy5oOgkkKG9iaikvc3lzY2FsbF9u
cnMucyBGT1JDRQ0KPiAgIAkkKGNhbGwgZmlsZWNoayxvZmZzZXRzLF9fU1lTQ0FMTF9OUlNfSF9f
KQ0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9NYWtlZmlsZSBiL3Rvb2xzL2xpYi9icGYv
TWFrZWZpbGUNCj4gaW5kZXggYzZmOTRjZmZlMDZlLi5iY2NmYTU1NmVmNGUgMTAwNjQ0DQo+IC0t
LSBhL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUNCj4gKysrIGIvdG9vbHMvbGliL2JwZi9NYWtlZmls
ZQ0KPiBAQCAtOTQsNiArOTQsMTAgQEAgZWxzZQ0KPiAgICAgQ0ZMQUdTIDo9IC1nIC1XYWxsDQo+
ICAgZW5kaWYNCj4gICANCj4gK2lmZGVmIEVYVFJBX0NYWEZMQUdTDQo+ICsgIENYWEZMQUdTIDo9
ICQoRVhUUkFfQ1hYRkxBR1MpDQo+ICtlbmRpZg0KPiArDQo+ICAgaWZlcSAoJChmZWF0dXJlLWxp
YmVsZi1tbWFwKSwgMSkNCj4gICAgIG92ZXJyaWRlIENGTEFHUyArPSAtREhBVkVfTElCRUxGX01N
QVBfU1VQUE9SVA0KPiAgIGVuZGlmDQo+IEBAIC0xNzYsOCArMTgwLDkgQEAgJChCUEZfSU4pOiBm
b3JjZSBlbGZkZXAgYnBmZGVwDQo+ICAgJChPVVRQVVQpbGliYnBmLnNvOiAkKE9VVFBVVClsaWJi
cGYuc28uJChMSUJCUEZfVkVSU0lPTikNCj4gICANCj4gICAkKE9VVFBVVClsaWJicGYuc28uJChM
SUJCUEZfVkVSU0lPTik6ICQoQlBGX0lOKQ0KPiAtCSQoUVVJRVRfTElOSykkKENDKSAtLXNoYXJl
ZCAtV2wsLXNvbmFtZSxsaWJicGYuc28uJChMSUJCUEZfTUFKT1JfVkVSU0lPTikgXA0KPiAtCQkJ
CSAgICAtV2wsLS12ZXJzaW9uLXNjcmlwdD0kKFZFUlNJT05fU0NSSVBUKSAkXiAtbGVsZiAtbyAk
QA0KPiArCSQoUVVJRVRfTElOSykkKENDKSAkKExERkxBR1MpIFwNCj4gKwkJLS1zaGFyZWQgLVds
LC1zb25hbWUsbGliYnBmLnNvLiQoTElCQlBGX01BSk9SX1ZFUlNJT04pIFwNCj4gKwkJLVdsLC0t
dmVyc2lvbi1zY3JpcHQ9JChWRVJTSU9OX1NDUklQVCkgJF4gLWxlbGYgLW8gJEANCj4gICAJQGxu
IC1zZiAkKEBGKSAkKE9VVFBVVClsaWJicGYuc28NCj4gICAJQGxuIC1zZiAkKEBGKSAkKE9VVFBV
VClsaWJicGYuc28uJChMSUJCUEZfTUFKT1JfVkVSU0lPTikNCj4gICANCj4gQEAgLTE4NSw3ICsx
OTAsNyBAQCAkKE9VVFBVVClsaWJicGYuYTogJChCUEZfSU4pDQo+ICAgCSQoUVVJRVRfTElOSykk
KFJNKSAkQDsgJChBUikgcmNzICRAICReDQo+ICAgDQo+ICAgJChPVVRQVVQpdGVzdF9saWJicGY6
IHRlc3RfbGliYnBmLmNwcCAkKE9VVFBVVClsaWJicGYuYQ0KPiAtCSQoUVVJRVRfTElOSykkKENY
WCkgJChJTkNMVURFUykgJF4gLWxlbGYgLW8gJEANCj4gKwkkKFFVSUVUX0xJTkspJChDWFgpICQo
Q1hYRkxBR1MpICQoTERGTEFHUykgJChJTkNMVURFUykgJF4gLWxlbGYgLW8gJEANCj4gICANCj4g
ICAkKE9VVFBVVClsaWJicGYucGM6DQo+ICAgCSQoUVVJRVRfR0VOKXNlZCAtZSAic3xAUFJFRklY
QHwkKHByZWZpeCl8IiBcDQo+IA0K
