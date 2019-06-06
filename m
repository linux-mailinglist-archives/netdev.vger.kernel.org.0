Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3BD37EB1
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfFFU0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:26:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38976 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726238AbfFFU0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:26:42 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x56KNnQo023427;
        Thu, 6 Jun 2019 13:26:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=k2u79adnh+QA4E7cMoffd0t5ncHGC3xu12U1phnUwvQ=;
 b=pAF0o9zHGkeYiCOQ9bDGLFufQfMG0miqiez40062wYJxXQIzJVidiHOX2T1nqG2N8c1C
 U8k/RUVqaYJ58xDJDvLlQegrGjSA1zUD4crASxaUb9L9qxGLkksI1hPuSTWp+whrhtmG
 OiZHfWwa9F120XKcTTfC2a5MGlSL0JQyRPM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2sy0e8a5r0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 13:26:22 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 13:26:19 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 13:26:19 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 13:26:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2u79adnh+QA4E7cMoffd0t5ncHGC3xu12U1phnUwvQ=;
 b=ku5xernAC0r8BEpO3b8ZtBf96hfmp1ChCbUgBALcwYiPTV3kG/iSxAfspOW/31SoY09qgl0uFKYVGDc0/Zz1SkQ86X5zXEiZSKXZR8nC3iY1NNfBCN1G/y2R93MyZdAvR6yu4SN3gMP7DNfBjej5Vs81qDvAdGE7PmQ69bYNaM4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1341.namprd15.prod.outlook.com (10.175.3.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Thu, 6 Jun 2019 20:26:18 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 20:26:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Hechao Li <hechaol@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 0/2] bpf: Add a new API
 libbpf_num_possible_cpus()
Thread-Topic: [PATCH v3 bpf-next 0/2] bpf: Add a new API
 libbpf_num_possible_cpus()
Thread-Index: AQHVHJ+pGecXb/AAWEijMq1c4ytq/aaPEvCA
Date:   Thu, 6 Jun 2019 20:26:17 +0000
Message-ID: <248CC010-8281-4EAC-8190-E98653753BBB@fb.com>
References: <20190606193927.2489147-1-hechaol@fb.com>
In-Reply-To: <20190606193927.2489147-1-hechaol@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:bed9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39941e4a-c2aa-4f95-3196-08d6eabd3b2d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1341;
x-ms-traffictypediagnostic: MWHPR15MB1341:
x-microsoft-antispam-prvs: <MWHPR15MB1341555F09281B0BD35E7C5FB3170@MWHPR15MB1341.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(51914003)(199004)(6506007)(82746002)(83716004)(186003)(229853002)(8936002)(36756003)(54906003)(37006003)(66476007)(256004)(68736007)(4744005)(46003)(86362001)(2616005)(64756008)(76116006)(476003)(6512007)(25786009)(486006)(6436002)(478600001)(6486002)(446003)(11346002)(57306001)(7736002)(14454004)(4326008)(5660300002)(71200400001)(53546011)(66446008)(102836004)(81156014)(81166006)(316002)(66946007)(6862004)(50226002)(6246003)(53936002)(33656002)(73956011)(6636002)(2906002)(6116002)(71190400001)(76176011)(66556008)(99286004)(305945005)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1341;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I0wkoVT19+p5HhVF7JCcGihQiDvlJZxrH5EB6ujzF9SEqNS4UfyIqdhdixv9m8S4td/QhbpODTbUqpA2lXoPCWWTyChm6AJF7XxWX49k1KCPBF4FeUKCiW7HS1aGgM5ovQSoHGRAAyw7fzmi7xKJ8ybpe6zT1iEQTMi8i2U6YtaPCwA3N5WaYiMbELO+a3Jyua0bjcjaTNRz6kCrbQh4V8awKFXnRnT73wjh60L6CZ/Wu0MqfAx8MtHzs3m2bvIFGxLKxjY5EvwKipfJU/QbwcboKge9SdRSyk3eIo0b8o8+hFIRXVzjBtuNO4mV5qpnGoIV65qZ1MNiV4DapTMCv7ONyV8UjnfXw+WpGavs4aZeYO5Xw3DMVlcxRpVacm0lVDagKN6azbZ147LbG4vhvJf8tcUWYl+KZAq6QdoFk6Q=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E71ED11C7794048AA93A0238F84EBCD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 39941e4a-c2aa-4f95-3196-08d6eabd3b2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 20:26:18.0348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1341
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 6, 2019, at 12:39 PM, Hechao Li <hechaol@fb.com> wrote:
>=20
> Getting number of possible CPUs is commonly used for per-CPU BPF maps
> and perf_event_maps. Add a new API libbpf_num_possible_cpus() that
> helps user with per-CPU related operations and remove duplicate
> implementations in bpftool and selftests.
>=20
> Hechao Li (2):
>  bpf: add a new API libbpf_num_possible_cpus()
>  bpf: use libbpf_num_possible_cpus in bpftool and selftests

For the series:

Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the patch!

>=20
> tools/bpf/bpftool/common.c             | 53 +++---------------------
> tools/lib/bpf/libbpf.c                 | 57 ++++++++++++++++++++++++++
> tools/lib/bpf/libbpf.h                 | 16 ++++++++
> tools/lib/bpf/libbpf.map               |  1 +
> tools/testing/selftests/bpf/bpf_util.h | 37 +++--------------
> 5 files changed, 84 insertions(+), 80 deletions(-)
>=20
> --=20
> 2.17.1
>=20

