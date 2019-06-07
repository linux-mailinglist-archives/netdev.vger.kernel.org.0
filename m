Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECE7399B6
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbfFGX0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:26:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39354 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730177AbfFGX0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 19:26:24 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x57NQ2er018341;
        Fri, 7 Jun 2019 16:26:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=T1ZHMYlWTZhtvOlKQz2SlImgWoRaYrag7Gi1SXry6N4=;
 b=VbQLtbKqaBvk8WLzGwH7Mk++Q0RU8U8ivLHVfaIkuaf9Ln5r6Ox6O10JM6bCuHcp1/MM
 RDSw4emtXXA52gkv5GLZkMbR9Pd8gl55mJYxYkYGzfeDivxvYTsVYW/oDa3ZkJ5XmE+q
 9uIlpWkIXGL6SoTs6oqvOaJVsWPJAjpmWiA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2syv2fs6bk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 07 Jun 2019 16:26:02 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 7 Jun 2019 16:26:00 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 7 Jun 2019 16:25:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1ZHMYlWTZhtvOlKQz2SlImgWoRaYrag7Gi1SXry6N4=;
 b=nHWGMANByqNAOOrFj31SOVqlxVZpiBU6zcDenbsMYP3xUyvDOnR02I0vqP0Myy4D4ULsw8ocq6xarzJlJhRvw4YumUPE4uxXJXkAtqjdbn1jchSuGK5+Y+d4etkPFBNHQ7M4NPis4P4phFM4rw1sgi1FPeOIgprlJz8SfNq7Ta4=
Received: from DM6PR15MB2635.namprd15.prod.outlook.com (20.179.161.152) by
 DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Fri, 7 Jun 2019 23:25:58 +0000
Received: from DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::5022:93e0:dd8b:b1a1]) by DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::5022:93e0:dd8b:b1a1%7]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 23:25:58 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, Hechao Li <hechaol@fb.com>
CC:     Hechao Li <hechaol@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 0/2] bpf: Add a new API
Thread-Topic: [PATCH v4 bpf-next 0/2] bpf: Add a new API
Thread-Index: AQHVHYhZ4evW/B5n5E6gKryRNYrgQA==
Date:   Fri, 7 Jun 2019 23:25:58 +0000
Message-ID: <20190607232550.GA5472@tower.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1201CA0010.namprd12.prod.outlook.com
 (2603:10b6:301:4a::20) To DM6PR15MB2635.namprd15.prod.outlook.com
 (2603:10b6:5:1a6::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::e7a8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 129b7fc3-c8a5-4646-6b75-08d6eb9f7ec7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR15MB3001;
x-ms-traffictypediagnostic: DM6PR15MB3001:
x-microsoft-antispam-prvs: <DM6PR15MB30017478EE1494A87A539C86BE100@DM6PR15MB3001.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(376002)(39860400002)(396003)(199004)(189003)(6486002)(256004)(81166006)(316002)(8936002)(54906003)(305945005)(386003)(66946007)(6436002)(6506007)(53546011)(6512007)(66476007)(64756008)(52116002)(102836004)(9686003)(7736002)(66556008)(73956011)(110136005)(71200400001)(2906002)(186003)(33656002)(71190400001)(66446008)(478600001)(6636002)(81156014)(86362001)(68736007)(229853002)(14454004)(99286004)(8676002)(6116002)(46003)(1076003)(5660300002)(4326008)(53936002)(6246003)(25786009)(476003)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3001;H:DM6PR15MB2635.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xK/SbYTbFMmtMXazI1loKv0lEuqz1BeSLwXbTe9I4uyqW06o3Q6C/m/8fvwr3f7TqOLkNYn3EjsMmJSN/SgWXhPM+9ddSew99mptt+15H5i1EdARGnez2nAE4Et9mGc0W8fgb5q2MohQmGMA1zEwQHsdBbyIFle/PQQlbYSd18i3MZksMem2Nw/4nIDq4u1BEO1Pug50Y905BAPyLpLNfBtc1XNV4AWVL0l5Zd3/8hlnCZ99YlouW9WtfPsosxbHqLr3U8NGjtQoLAsoJKTYI2GrOJA+mia+jNXhx5djIQpmQuodWzspgWFQVgK2O4EbM3PHNYOJstHIMyawI6H+hOo1LcH3+fnlb680y0rMaE1BWc0ZB/Ci1h7+t3F8qcrLFOvippzj5diNCAKzIFzOMSPgHYOF3R5gFOUWw+aXKpU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B0C903AF6A6754B8AD45DB869D7DA3C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 129b7fc3-c8a5-4646-6b75-08d6eb9f7ec7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 23:25:58.2067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3001
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-07_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2019 06:37 PM, Hechao Li wrote:
> Getting number of possible CPUs is commonly used for per-CPU BPF maps
> and perf_event_maps. Add a new API libbpf_num_possible_cpus() that
> helps user with per-CPU related operations and remove duplicate
> implementations in bpftool and selftests.
>=20
> v4: Fixed error code when reading 0 bytes from possible CPU file
>=20
> Hechao Li (2):
>   bpf: add a new API libbpf_num_possible_cpus()
>   bpf: use libbpf_num_possible_cpus in bpftool and selftests
>=20
>  tools/bpf/bpftool/common.c             | 53 +++---------------------
>  tools/lib/bpf/libbpf.c                 | 57 ++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h                 | 16 ++++++++
>  tools/lib/bpf/libbpf.map               |  1 +
>  tools/testing/selftests/bpf/bpf_util.h | 37 +++--------------
>  5 files changed, 84 insertions(+), 80 deletions(-)

> Series applied, thanks!

> P.s.: Please retain full history (v1->v2->v3->v4) in cover letter next ti=
me as
> that is typical convention and helps readers of git log to follow what ha=
s been
> changed over time.


Hello!

I'm getting the following errors on an attempt to build bpf tests.
Reverting the last patch fixes it.

Please, take a look.

Thank you!


clang -I. -I./include/uapi -I../../../include/uapi -idirafter /usr/local/in=
clude -idirafter /opt/fb/devtoolset/bin/../lib/clang/4.0.0/include -idiraft=
er /usr/include -Wno-compare-distinct-pointer-types \
	 -O2 -target bpf -emit-llvm -c progs/sockmap_parse_prog.c -o - |      \
llc -march=3Dbpf -mcpu=3Dgeneric  -filetype=3Dobj -o /data/users/guro/linux=
/tools/testing/selftests/bpf/sockmap_parse_prog.o
In file included from progs/sockmap_parse_prog.c:3:
./bpf_util.h:9:10: fatal error: 'libbpf.h' file not found
#include <libbpf.h>
         ^~~~~~~~~~
1 error generated.

...

clang -I. -I./include/uapi -I../../../include/uapi -idirafter /usr/local/in=
clude -idirafter /opt/fb/devtoolset/bin/../lib/clang/4.0.0/include -idiraft=
er /usr/include -Wno-compare-distinct-pointer-types \
	 -O2 -target bpf -emit-llvm -c progs/test_sysctl_prog.c -o - |      \
llc -march=3Dbpf -mcpu=3Dgeneric  -filetype=3Dobj -o /data/users/guro/linux=
/tools/testing/selftests/bpf/test_sysctl_prog.o
In file included from progs/test_sysctl_prog.c:11:
./bpf_util.h:9:10: fatal error: 'libbpf.h' file not found
#include <libbpf.h>
         ^~~~~~~~~~
1 error generated.
clang -I. -I./include/uapi -I../../../include/uapi -idirafter /usr/local/in=
clude -idirafter /opt/fb/devtoolset/bin/../lib/clang/4.0.0/include -idiraft=
er /usr/include -Wno-compare-distinct-pointer-types \
	 -O2 -target bpf -emit-llvm -c progs/sockmap_verdict_prog.c -o - |      \
llc -march=3Dbpf -mcpu=3Dgeneric  -filetype=3Dobj -o /data/users/guro/linux=
/tools/testing/selftests/bpf/sockmap_verdict_prog.o
In file included from progs/sockmap_verdict_prog.c:3:
./bpf_util.h:9:10: fatal error: 'libbpf.h' file not found
#include <libbpf.h>
         ^~~~~~~~~~
1 error generated.

...

clang -I. -I./include/uapi -I../../../include/uapi -idirafter /usr/local/in=
clude -idirafter /opt/fb/devtoolset/bin/../lib/clang/4.0.0/include -idiraft=
er /usr/include -Wno-compare-distinct-pointer-types \
	 -O2 -target bpf -emit-llvm -c progs/sockmap_tcp_msg_prog.c -o - |      \
llc -march=3Dbpf -mcpu=3Dgeneric  -filetype=3Dobj -o /data/users/guro/linux=
/tools/testing/selftests/bpf/sockmap_tcp_msg_prog.o
In file included from progs/sockmap_tcp_msg_prog.c:3:
./bpf_util.h:9:10: fatal error: 'libbpf.h' file not found
#include <libbpf.h>
         ^~~~~~~~~~
1 error generated.


