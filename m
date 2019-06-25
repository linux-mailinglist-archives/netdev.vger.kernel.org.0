Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF8F51F6D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbfFYABD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:01:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48140 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726631AbfFYABD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:01:03 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5ONrZGf019635;
        Mon, 24 Jun 2019 17:00:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1KUYvvy7TYx7gYz9XSqgufG67pt/omR2tMk9xUNO+dQ=;
 b=QeLvPWFoo2jhj1J45Hr+XHbzxHRpQkyBfioCzhyEvcA0pqutkDs60qn/3SmxPD8ztWMJ
 Djo8O/z7wUE3U+O6eKqPGd1VeXFbMUJYQR0sTUPZmF4ni7a2oxInZ+PJq1fIf6XC5xoi
 iqNiKM5DxglYnIrdVVc9pCDJsMSnCkGWzU0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2tb3gw97kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Jun 2019 17:00:37 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 17:00:36 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 17:00:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KUYvvy7TYx7gYz9XSqgufG67pt/omR2tMk9xUNO+dQ=;
 b=NP0D9O5SaHgT0NkB4pZ2FXKw9GIw04qLr1pv+QRkJpydj/P4ZrML7QAtXdLnQcfDwzw607VLIdVrgiRMlz5/RHb4LDb5JRlAVuUJ+LzZdw44MhUsaQ3c0t8LHl41vfR6bzBTHDc5ZlmSdeYKO+P32+GXeuX9skEDzHP5qiYeZNY=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1773.namprd15.prod.outlook.com (10.174.97.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Tue, 25 Jun 2019 00:00:35 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 00:00:35 +0000
From:   Song Liu <songliubraving@fb.com>
To:     allanzhang <allanzhang@google.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] bpf: Allow bpf_skb_event_output for more prog
 types
Thread-Topic: [PATCH v3 0/2] bpf: Allow bpf_skb_event_output for more prog
 types
Thread-Index: AQHVKuikUE/omfxviUSX95ATQSfH9KarfDQA
Date:   Tue, 25 Jun 2019 00:00:35 +0000
Message-ID: <C74526B1-7426-4F84-A5D3-DA444A17CFCD@fb.com>
References: <20190624235720.167067-1-allanzhang@google.com>
In-Reply-To: <20190624235720.167067-1-allanzhang@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2:78ae]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7412e4b-6c41-4849-0858-08d6f9002636
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1773;
x-ms-traffictypediagnostic: MWHPR15MB1773:
x-microsoft-antispam-prvs: <MWHPR15MB17733ECDECA64BEC28DB4E8FB3E30@MWHPR15MB1773.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(396003)(136003)(39860400002)(199004)(189003)(256004)(76176011)(14444005)(446003)(478600001)(50226002)(186003)(14454004)(8936002)(25786009)(2906002)(486006)(66946007)(66476007)(476003)(7736002)(73956011)(76116006)(66446008)(64756008)(66556008)(2616005)(305945005)(11346002)(102836004)(6506007)(81156014)(53546011)(81166006)(4326008)(54906003)(33656002)(8676002)(316002)(6512007)(68736007)(5660300002)(4744005)(6486002)(229853002)(6246003)(6916009)(6436002)(6116002)(99286004)(46003)(86362001)(36756003)(71190400001)(57306001)(71200400001)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1773;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9yJpQMC7NQ9qjEpdR1cGyZqAwL0DA+lnCbwdr+1PRkgO1CnQCulYR/tBvJi0wJlqjrMV5W6jPghs7rNPPGtVoQZTubGb465l//4RaDT5UfgBAqbuTNNKAmsE2wk1l/xVW+0uYh5lLSdl5SzvVHWolXgKchWN3TaGEGTbA7cq9wi0ZLNNqTXKFUOrm1JDW9Ri2uX7ZAKvF7oW0VvOdqP5dLt4Iw+CO7CM2aBN20P+EjsPLBoztIUyPd5NaGJ2DSZJPNZsfkFEd51P2kG/AlWst43S0MEG/DdVqOvmiGCfW/+T0FvOe2388sbuG94o9nHruADlVwRxCz+rXQ+qfzni3T986fYgxkM/LzIFOli+lwdf178/aNFuCDZl/yi0QKVXBLF03XlvFF7vTPGSiNKYaNWfUMiCmKj8den+cr+4TYg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A32A135E791AF4CB3FE11154083D599@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d7412e4b-6c41-4849-0858-08d6f9002636
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 00:00:35.3543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1773
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=994 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 24, 2019, at 4:57 PM, allanzhang <allanzhang@google.com> wrote:
>=20
> Software event output is only enabled by a few prog types right now (TC,
> LWT out, XDP, sockops). Many other skb based prog types need
> bpf_skb_event_output to produce software event.
>=20
> Added socket_filter, cg_skb, sk_skb prog types to generate sw event.
>=20
> *** BLURB HERE ***
    ^^^^^^ this should be removed.=20

Please include bpf-next in the subject prefix.=20
Please also include changes from v1 to v2 and v2 to v3 in the cover=20
letter, like:

changes v1 =3D> v2:
1. ...
2. ...

Thanks,
Song


>=20
> allanzhang (2):
>  bpf: Allow bpf_skb_event_output for a few prog types
>  bpf: Add selftests for bpf_perf_event_output
>=20
> net/core/filter.c                             |  6 ++
> tools/testing/selftests/bpf/test_verifier.c   | 33 ++++++-
> .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
> 3 files changed, 132 insertions(+), 1 deletion(-)
> create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c
>=20
> --=20
> 2.22.0.410.gd8fdbe21b5-goog
>=20

