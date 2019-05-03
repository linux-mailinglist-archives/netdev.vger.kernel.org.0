Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A45A13215
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 18:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfECQVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 12:21:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34479 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726267AbfECQVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 12:21:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x43GCYSV027232;
        Fri, 3 May 2019 09:21:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : content-type : content-id : content-transfer-encoding
 : mime-version; s=facebook;
 bh=LBzCx0m134aPtQk9z07upe8ASmVSQ/NUhJ6gK868WPk=;
 b=F9aoivHtvwon8draABYUZAGc3/bdQETOo4egf53klkJCNPP1TNdPKay5/C2vplbttIic
 Pr9DQfLyAZ+yASNoAUG3fKdSMhYWFMtLGgx65/wKiUhTjzV/7hLjQT3PclRlyOWphikn
 KHTFZ/kY+oKa76KkIJDamGMM0Y5dnb2SxHM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2s86r1k0q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 May 2019 09:21:28 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 3 May 2019 09:21:27 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 3 May 2019 09:21:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBzCx0m134aPtQk9z07upe8ASmVSQ/NUhJ6gK868WPk=;
 b=fr+ONPEHj5io90Zl3alHs7ZKxJWzuOj6FVBDV3gHR8K0KhzbFGmfNPmTLOsLzLCQKJxWx9Ng/YrNx3LoZBRKqqvdW5bfeNW3pf7+b3fUNuMVbVQrg9v7wk/tzwDaxjNccl4mG7ftNjJfVgej8J2Npg37W8e9+eHTFsnKGw39cbQ=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2775.namprd15.prod.outlook.com (20.179.158.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Fri, 3 May 2019 16:21:26 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::750c:2d8e:bf62:4d0d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::750c:2d8e:bf62:4d0d%5]) with mapi id 15.20.1856.008; Fri, 3 May 2019
 16:21:25 +0000
From:   Yonghong Song <yhs@fb.com>
To:     netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: bpftool doc man page build failure
Thread-Topic: bpftool doc man page build failure
Thread-Index: AQHVAcxB+ZLo09PUHkCRkk5C26pzvA==
Date:   Fri, 3 May 2019 16:21:25 +0000
Message-ID: <d84c162f-9ccf-18f5-6d99-d7c88eb61a89@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:301:5f::39) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:35ed]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcb44aa7-cfb3-4aea-8cb2-08d6cfe36383
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2775;
x-ms-traffictypediagnostic: BYAPR15MB2775:
x-microsoft-antispam-prvs: <BYAPR15MB2775C1652A6893B228B73E6DD3350@BYAPR15MB2775.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(39860400002)(376002)(136003)(199004)(189003)(2906002)(305945005)(7736002)(186003)(386003)(46003)(5660300002)(6506007)(81156014)(81166006)(8676002)(486006)(71200400001)(476003)(478600001)(2616005)(71190400001)(68736007)(8936002)(31686004)(25786009)(14454004)(102836004)(66446008)(66476007)(6436002)(66556008)(64756008)(66946007)(73956011)(53936002)(256004)(52116002)(99286004)(6512007)(31696002)(86362001)(316002)(2501003)(36756003)(110136005)(6486002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2775;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yBCAXqkfq8W/UNwkonNUl3VUbTHrJMqUyoT70lG4eCx6K76PlTuozo+QTk5YwDa0ZSQcIilaXE+TIaz1vqp8FMdxYhmo1rQcPf4ExIw2DzSXDmPE3/dPBE4LX8yXllf/HeqeA6qmuAdAe6ZsO3/G1Oke9JQCzoKY3FWReh/oE5O1jByaWDiUimEfu3+vWhleMLnSf7LzN26jwOBiemCdIsSHnbfw3jqdkQPVXacFf/OrfgKgFKE5UIJ/TL+lNMDsIYmW+9QAI61O6y/VQkiAmr05ZjM+lzDU7H9yS/lQb+VOlwCLn9mC1OPmxLKpwsSYJ0X0WFIRRBqucvzG3gz7vaNz0GX1k92J2PDpx+uikUjFxSqZAaarjneio4snmyfc1gT4tZU/RaLfnKwQXsnNi3EjNfclPPbk9/yEuVOZlXI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E384097FC477941A0CEF58108705D42@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb44aa7-cfb3-4aea-8cb2-08d6cfe36383
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 16:21:25.7758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-03_09:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UXVlbnRpbiwNCg0KSSBoaXQgdGhlIGZvbGxvd2luZyBlcnJvcnMgd2l0aCBsYXRlc3QgYnBmLW5l
eHQuDQoNCi1iYXNoLTQuNCQgbWFrZSBtYW4NCiAgIEdFTiAgICAgIGJwZnRvb2wtcGVyZi44DQog
ICBHRU4gICAgICBicGZ0b29sLW1hcC44DQogICBHRU4gICAgICBicGZ0b29sLjgNCiAgIEdFTiAg
ICAgIGJwZnRvb2wtbmV0LjgNCiAgIEdFTiAgICAgIGJwZnRvb2wtZmVhdHVyZS44DQogICBHRU4g
ICAgICBicGZ0b29sLXByb2cuOA0KICAgR0VOICAgICAgYnBmdG9vbC1jZ3JvdXAuOA0KICAgR0VO
ICAgICAgYnBmdG9vbC1idGYuOA0KICAgR0VOICAgICAgYnBmLWhlbHBlcnMucnN0DQpQYXJzZWQg
ZGVzY3JpcHRpb24gb2YgMTExIGhlbHBlciBmdW5jdGlvbihzKQ0KVHJhY2ViYWNrIChtb3N0IHJl
Y2VudCBjYWxsIGxhc3QpOg0KICAgRmlsZSAiLi4vLi4vLi4vLi4vc2NyaXB0cy9icGZfaGVscGVy
c19kb2MucHkiLCBsaW5lIDQyMSwgaW4gPG1vZHVsZT4NCiAgICAgcHJpbnRlci5wcmludF9hbGwo
KQ0KICAgRmlsZSAiLi4vLi4vLi4vLi4vc2NyaXB0cy9icGZfaGVscGVyc19kb2MucHkiLCBsaW5l
IDE4NywgaW4gcHJpbnRfYWxsDQogICAgIHNlbGYucHJpbnRfb25lKGhlbHBlcikNCiAgIEZpbGUg
Ii4uLy4uLy4uLy4uL3NjcmlwdHMvYnBmX2hlbHBlcnNfZG9jLnB5IiwgbGluZSAzNzgsIGluIHBy
aW50X29uZQ0KICAgICBzZWxmLnByaW50X3Byb3RvKGhlbHBlcikNCiAgIEZpbGUgIi4uLy4uLy4u
Ly4uL3NjcmlwdHMvYnBmX2hlbHBlcnNfZG9jLnB5IiwgbGluZSAzNTYsIGluIHByaW50X3Byb3Rv
DQogICAgIHByb3RvID0gaGVscGVyLnByb3RvX2JyZWFrX2Rvd24oKQ0KICAgRmlsZSAiLi4vLi4v
Li4vLi4vc2NyaXB0cy9icGZfaGVscGVyc19kb2MucHkiLCBsaW5lIDU2LCBpbiANCnByb3RvX2Jy
ZWFrX2Rvd24NCiAgICAgJ3R5cGUnIDogY2FwdHVyZS5ncm91cCgxKSwNCkF0dHJpYnV0ZUVycm9y
OiAnTm9uZVR5cGUnIG9iamVjdCBoYXMgbm8gYXR0cmlidXRlICdncm91cCcNCm1ha2U6ICoqKiBb
YnBmLWhlbHBlcnMucnN0XSBFcnJvciAxDQotYmFzaC00LjQkIHB3ZA0KL2hvbWUveWhzL3dvcmsv
bmV0LW5leHQvdG9vbHMvYnBmL2JwZnRvb2wvRG9jdW1lbnRhdGlvbg0KLWJhc2gtNC40JA0KDQpN
YXliZSBhIGZvcm1hdCBpc3N1ZSBpbiB0aGUgY29tbWVudHMgd2l0aCBzb21lIHJlY2VudCBoZWxw
ZXJzPw0KDQpUaGFua3MsDQoNCllvbmdob25nDQo=
