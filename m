Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F303BFEB
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390721AbfFJXhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:37:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38748 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390716AbfFJXhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 19:37:36 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5ANZIb5002912;
        Mon, 10 Jun 2019 16:37:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fDIYlLlHR5kG0I34hesY7C4RlsSxwts+kq5ICIC8xpA=;
 b=faEMETIO51LpH/B9kPqxfL+1XLdzeDw8jEtAVZVQ9dKHUxJeASfI0xuBPPjGuZdDfHwe
 TBE3fGr2cnrfaVN55f3eI2h8rxnqP+ykUPDC/eoQm4tnlNyR2NHpqfVYuknWn0g6/IDo
 llE8PP3xyrOV7dhWa+Mgjuy97kdlMcS4S/c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t1s63264v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 10 Jun 2019 16:37:13 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Jun 2019 16:37:12 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 10 Jun 2019 16:37:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDIYlLlHR5kG0I34hesY7C4RlsSxwts+kq5ICIC8xpA=;
 b=Vug1lHXCeDc9A4XWWfA1fgm1krxf+6O/Aaul+tcvVL3Z5T/zRak93JdTLtzQlwE3SSBUaZPE4iXEM24iRDo1EQaojrPvU3I+L2d2hZXZ9MezlNrb55u2Myhnn1aBj89GCml++IDBOfc3IIAuLMl7TC59ne2/IV67yoA0sp3QxjM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1949.namprd15.prod.outlook.com (10.175.8.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Mon, 10 Jun 2019 23:37:10 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:37:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Hechao Li <hechaol@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v1 bpf-next] selftests/bpf : Clean up feature/ when make
 clean
Thread-Topic: [PATCH v1 bpf-next] selftests/bpf : Clean up feature/ when make
 clean
Thread-Index: AQHVH62f7FaYR0Jg40GsFfzFT4Z/eaaVLtAAgAAQDgCAAEydgA==
Date:   Mon, 10 Jun 2019 23:37:10 +0000
Message-ID: <958F91F9-A596-45DB-B550-894EE82F80B9@fb.com>
References: <20190610165708.2083220-1-hechaol@fb.com>
 <CAEf4BzZGK+SN1EPudi=tt8ppN58ovW8o+=JMd8rhEgr4KBnSmw@mail.gmail.com>
 <20190610190252.GA41381@hechaol-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190610190252.GA41381@hechaol-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:73aa]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b378678d-371a-4312-3f03-08d6edfc8f23
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1949;
x-ms-traffictypediagnostic: MWHPR15MB1949:
x-microsoft-antispam-prvs: <MWHPR15MB194980BDDC5C3ADF27DB8F87B3130@MWHPR15MB1949.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:311;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(376002)(396003)(366004)(199004)(189003)(478600001)(66446008)(81166006)(81156014)(446003)(102836004)(305945005)(8936002)(91956017)(68736007)(64756008)(99286004)(53936002)(6506007)(76116006)(8676002)(66556008)(82746002)(53546011)(66946007)(7736002)(14454004)(66476007)(73956011)(76176011)(2906002)(6116002)(25786009)(46003)(11346002)(316002)(476003)(71190400001)(71200400001)(2616005)(6862004)(4326008)(83716004)(186003)(37006003)(33656002)(6486002)(486006)(256004)(6636002)(14444005)(6436002)(54906003)(36756003)(229853002)(6512007)(50226002)(57306001)(5660300002)(6246003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1949;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uffuMjyZUgLmRC92bcdPrZWGwRovJ/6B7VDhWn+aroWGJQSDGVXZj9OpN+pG0R8lInPLvOCRyNilZyL97X/93FNhsa+UGxon/574UCi7hF2rqNZI/qTMTyx5b78fkA9p+6SYHOp+rC/iAWSii48/LFjBwZm7cnPsLZDTTje9UqG0xLsJ0j+9YEJo+Bj36QpKzZHtAQBm46QLfWOMUWvv+O7jyZyVtbggZfbeG/Z87/VNc1QK2CcnQk9Fw7W1skl3R8cTlZpC5UhQdMEV7GW88Yv3TW723jN+U7mQQmy9UrcKWiFkvgxxd+fyTedakhILK40ZTUlFFim2PsnjlUgM1DuPefJ6wjWTMlBHV1V1rWM55SvwS89cUUAblaTnubEN6bv6c9lM68hXoTs8VgEIhf2mdPYp4Tfw4im9gxZJWAE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <09BD337A7CC6CF4F8207F905F3CC9C71@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b378678d-371a-4312-3f03-08d6edfc8f23
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:37:10.6397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1949
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 10, 2019, at 12:02 PM, Hechao Li <hechaol@fb.com> wrote:
>=20
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote on Mon [2019-Jun-10 11:=
05:28 -0700]:
>> On Mon, Jun 10, 2019 at 9:57 AM Hechao Li <hechaol@fb.com> wrote:
>>>=20
>>> I got an error when compiling selftests/bpf:
>>>=20
>>> libbpf.c:411:10: error: implicit declaration of function 'reallocarray'=
;
>>> did you mean 'realloc'? [-Werror=3Dimplicit-function-declaration]
>>>  progs =3D reallocarray(progs, nr_progs + 1, sizeof(progs[0]));
>>>=20
>>> It was caused by feature-reallocarray=3D1 in FEATURE-DUMP.libbpf and it
>>> was fixed by manually removing feature/ folder. This diff adds feature/
>>> to EXTRA_CLEAN to avoid this problem.
>>>=20
>>> Signed-off-by: Hechao Li <hechaol@fb.com>
>>> ---
>>=20
>> There is no need to include v1 into patch prefix for a first version
>> of a patch. Only v2 and further versions are added.
>>=20
>>=20
>>> tools/testing/selftests/bpf/Makefile | 3 ++-
>>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selft=
ests/bpf/Makefile
>>> index 2b426ae1cdc9..44fb61f4d502 100644
>>> --- a/tools/testing/selftests/bpf/Makefile
>>> +++ b/tools/testing/selftests/bpf/Makefile
>>> @@ -279,4 +279,5 @@ $(OUTPUT)/verifier/tests.h: $(VERIFIER_TESTS_DIR) $=
(VERIFIER_TEST_FILES)
>>>                 ) > $(VERIFIER_TESTS_H))
>>>=20
>>> EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS) $(ALU32_BUILD_DIR) \
>>> -       $(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H)
>>> +       $(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H) \
>>> +       feature

I think this makes sense (before we find a better solution). Folder
feature is already in .gitignore, we know it can be removed.=20

Thanks,
Song

>>=20
>> It doesn't seem any of linux's Makefile do that. From brief reading of
>> build/Makefile.feature, it seems like it is supposed to handle
>> transparently the case where environment changes and thus a set of
>> supported features changes. I also verified that FEATURE-DUMP.libbpf
>> is re-generated every single time I run make in
>> tools/testing/selftests/bpf, even if nothing changed at all. So I
>> don't think this patch is necessary.
>>=20
>> I'm not sure what was the cause of your original problem, though.
>>=20
>>> --
>>> 2.17.1
>>>=20
>=20
> # Background:
>=20
> My default GCC version is 4.8.5, which caused the following error when I
> run make under selftests/bpf:
> libbpf.c:39:10: fatal error: libelf.h: No such file or directory
>=20
> To fix it, I have to run:
>=20
> make CC=3D<Path to GCC 7.x>
>=20
> The I got reallocarray not found error. By deleting feature/ folder
> under selftests/bpf, it was fixed.
>=20
> # Root Cause:
>=20
> Now I found the root cause. When I run "make", which uses GCC 4.8.5, it
> generates feature/test-reallocarray.d which indicates reallocarray is
> enabled. However, when I switched to GCC 7.0, this file was not
> re-generated and thus even FEATURE-DUMP.libbpf was re-generated,=20
> feature-reallocarray is still 1 in it.
>=20
> This can be reproduced by the following steps:
> $ cd tools/testing/selftests/bpf
> $ make clean && make CC=3D<Path to GCC 4.8.5>
> (Fail due to libelf.h not found)
> $ make clean && make CC=3D<Path to GCC 7.x>
> (Should succeed but actually fail with reallocarray not defined)
>=20
> If adding feature to EXTRA_CLEAN is not the way to go, do you have any
> suggestion to fix such problem? I spent some time debugging this and I
> hope to fix it so that other people with similar situation won't have to
> waste time on this issue.
>=20
> Thanks,
> Hechao

