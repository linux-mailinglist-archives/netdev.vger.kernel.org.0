Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7993BC63
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388868AbfFJTDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:03:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35956 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387674AbfFJTDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 15:03:38 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5AIxO0S022865;
        Mon, 10 Jun 2019 12:03:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TLPN5t5DwI7msD9zTVLYQbGuKknuEP16Ld4zb6la4YA=;
 b=lqBxxRir1h2mKAHr7EkxI33PHrda7+LtD6VGr5MCA6OGW7x81wxblYDS1VyCTRuEDJAE
 uAV/iiB0Kvb+hWW0OPm5z5HIGBOG6m55CY4lwYRZcpcg1S4R6AFHm654ea8RrLgr49sN
 fSRIak4a8Aaw1vk9Qy2szoTigG7+KVLhCdg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t1sjx18yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 10 Jun 2019 12:03:16 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Jun 2019 12:03:15 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 10 Jun 2019 12:03:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLPN5t5DwI7msD9zTVLYQbGuKknuEP16Ld4zb6la4YA=;
 b=TsORAzfNLoQGpHjSxXmjNcd/kUwz87zd7uVRWPk9/HawCj4lKa1q0wFcCMvxaXS/kHmLcfQqJj1txZar8AJlPsUS0tkOm9coG6XYnNwccdecbtWG9pVVeemW22FboJywDFFLl/kjHYkLho+waiQ/4MQcgNO366Ro8VLD7++rkks=
Received: from BYAPR15MB2968.namprd15.prod.outlook.com (20.178.237.149) by
 BYAPR15MB3173.namprd15.prod.outlook.com (20.179.56.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 19:02:56 +0000
Received: from BYAPR15MB2968.namprd15.prod.outlook.com
 ([fe80::1ccd:3dd5:6b36:eeed]) by BYAPR15MB2968.namprd15.prod.outlook.com
 ([fe80::1ccd:3dd5:6b36:eeed%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 19:02:56 +0000
From:   Hechao Li <hechaol@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH v1 bpf-next] selftests/bpf : Clean up feature/ when make
 clean
Thread-Topic: [PATCH v1 bpf-next] selftests/bpf : Clean up feature/ when make
 clean
Thread-Index: AQHVH62g7GQ5XKZJUEWeP1LzWDYO2qaVLtAAgAAQCQA=
Date:   Mon, 10 Jun 2019 19:02:56 +0000
Message-ID: <20190610190252.GA41381@hechaol-mbp.dhcp.thefacebook.com>
References: <20190610165708.2083220-1-hechaol@fb.com>
 <CAEf4BzZGK+SN1EPudi=tt8ppN58ovW8o+=JMd8rhEgr4KBnSmw@mail.gmail.com>
In-Reply-To: <CAEf4BzZGK+SN1EPudi=tt8ppN58ovW8o+=JMd8rhEgr4KBnSmw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0112.namprd15.prod.outlook.com
 (2603:10b6:101:21::32) To BYAPR15MB2968.namprd15.prod.outlook.com
 (2603:10b6:a03:f8::21)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:284]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecf121ab-28c1-406c-417b-08d6edd63f27
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3173;
x-ms-traffictypediagnostic: BYAPR15MB3173:
x-microsoft-antispam-prvs: <BYAPR15MB3173A9D26C53AF12FBBC9CD7D5130@BYAPR15MB3173.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:261;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(189003)(54906003)(52116002)(71190400001)(53546011)(76176011)(14444005)(476003)(256004)(316002)(6116002)(386003)(71200400001)(68736007)(6506007)(102836004)(8936002)(99286004)(486006)(186003)(81166006)(46003)(478600001)(8676002)(14454004)(9686003)(446003)(81156014)(11346002)(53936002)(86362001)(7736002)(6512007)(305945005)(6246003)(229853002)(1076003)(6436002)(25786009)(4326008)(6916009)(73956011)(5660300002)(66946007)(33656002)(2906002)(6486002)(66446008)(64756008)(66556008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3173;H:BYAPR15MB2968.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1RKMFDFFR2y9gc5UNoJJ2KgAdTOIjs+2aYoeJunUsmugGO0j2ZXnkWMr7Khx83KBjt5DzOe4hvs+WXfjOHfuYqWcY8wFtN76xJ9W85GvsR0M7Ew8s75KEpn9M/7Il9Bh69TNHmdC5EQH4c810oM8lj9n1+3ce7AM8UNzXOxFYPJtR4N9dotpZAQhnC77lbqCf0XKZLk7vsD1GY4qYDjuxm6m5upZvzKXi5d2DUlVS6QkO00DHp2aO/bl0fsVZJ6BQ2maG+My/ueTEy31AXYtTiRl0kd2+Mv8pQO0C0tfnGLxY4jt9mQoaTVaWOJy7kRdCjKYQnv+8Gr1zXUiiT7y1PL9MzF2oX1YUVvop7DS0+m058pk9yzzq66C51POIWdEVy3z7UvoJCXovjVhQYobyUQXXTP6fKcpLBg5xCXBV9U=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <786CD1747DA89B4088CCEA991E1F1D91@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf121ab-28c1-406c-417b-08d6edd63f27
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 19:02:56.1593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hechaol@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3173
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100128
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote on Mon [2019-Jun-10 11:05=
:28 -0700]:
> On Mon, Jun 10, 2019 at 9:57 AM Hechao Li <hechaol@fb.com> wrote:
> >
> > I got an error when compiling selftests/bpf:
> >
> > libbpf.c:411:10: error: implicit declaration of function 'reallocarray'=
;
> > did you mean 'realloc'? [-Werror=3Dimplicit-function-declaration]
> >   progs =3D reallocarray(progs, nr_progs + 1, sizeof(progs[0]));
> >
> > It was caused by feature-reallocarray=3D1 in FEATURE-DUMP.libbpf and it
> > was fixed by manually removing feature/ folder. This diff adds feature/
> > to EXTRA_CLEAN to avoid this problem.
> >
> > Signed-off-by: Hechao Li <hechaol@fb.com>
> > ---
>=20
> There is no need to include v1 into patch prefix for a first version
> of a patch. Only v2 and further versions are added.
>=20
>=20
> >  tools/testing/selftests/bpf/Makefile | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selft=
ests/bpf/Makefile
> > index 2b426ae1cdc9..44fb61f4d502 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -279,4 +279,5 @@ $(OUTPUT)/verifier/tests.h: $(VERIFIER_TESTS_DIR) $=
(VERIFIER_TEST_FILES)
> >                  ) > $(VERIFIER_TESTS_H))
> >
> >  EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS) $(ALU32_BUILD_DIR) \
> > -       $(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H)
> > +       $(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H) \
> > +       feature
>=20
> It doesn't seem any of linux's Makefile do that. From brief reading of
> build/Makefile.feature, it seems like it is supposed to handle
> transparently the case where environment changes and thus a set of
> supported features changes. I also verified that FEATURE-DUMP.libbpf
> is re-generated every single time I run make in
> tools/testing/selftests/bpf, even if nothing changed at all. So I
> don't think this patch is necessary.
>=20
> I'm not sure what was the cause of your original problem, though.
>=20
> > --
> > 2.17.1
> >

# Background:

My default GCC version is 4.8.5, which caused the following error when I
run make under selftests/bpf:
libbpf.c:39:10: fatal error: libelf.h: No such file or directory

To fix it, I have to run:

make CC=3D<Path to GCC 7.x>

The I got reallocarray not found error. By deleting feature/ folder
under selftests/bpf, it was fixed.

# Root Cause:

Now I found the root cause. When I run "make", which uses GCC 4.8.5, it
generates feature/test-reallocarray.d which indicates reallocarray is
enabled. However, when I switched to GCC 7.0, this file was not
re-generated and thus even FEATURE-DUMP.libbpf was re-generated,=20
feature-reallocarray is still 1 in it.

This can be reproduced by the following steps:
$ cd tools/testing/selftests/bpf
$ make clean && make CC=3D<Path to GCC 4.8.5>
(Fail due to libelf.h not found)
$ make clean && make CC=3D<Path to GCC 7.x>
(Should succeed but actually fail with reallocarray not defined)

If adding feature to EXTRA_CLEAN is not the way to go, do you have any
suggestion to fix such problem? I spent some time debugging this and I
hope to fix it so that other people with similar situation won't have to
waste time on this issue.

Thanks,
Hechao
