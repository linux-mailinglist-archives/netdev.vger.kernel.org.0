Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E12370218
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 22:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbhD3Uc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 16:32:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhD3Uc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 16:32:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UKTXxf018937;
        Fri, 30 Apr 2021 20:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ytd0EBZuCH2DhGa0yOoGcRQSiDUfgUue6dwBQFTYjfg=;
 b=yflx9bMK/g/JxQisS63uO73qM5CM22JqqB3ytSx9tAJ5e/fzah170F/Uj6Z+M8L2XoCA
 8caSUI5T+1D5j3zJc11tFnRwkhztApQFqqesSqF4nrrsYHEZNI2+r+dqO8llLnVXJLOw
 3ZFlGI7/gnedymdxz4TfY/kBs0UDwrP2x+pXUhZT+c+DD5iLTc+XIX1TjrTTYAOw5gr4
 XUwfa3WaDgcnI5skhvfKXgZyGGW2/EO+v8ckQuN04a3Lro7xyyIxDfC4bvomn0slQMoX
 BVqybw+PPTdnowtIz4ThjIdsBNIY/SYF+o/AMHeu3uc4WN5bKtQorJANX3/XO6LR9IwV ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 385aft8wer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 20:31:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UKUs7n135376;
        Fri, 30 Apr 2021 20:31:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 384w3y7g77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 20:31:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGfkM9VrY3nmEQmkWnxzVD7CqePC9esH3OC4WbRSYjQEvzx2Cs925tDmcYl6Rs5X6sK5ulxIjh6MvycME8zyoXO4AP9aPv/MpCEuiPU+CztfZNe5b18BRr9SnvQCi8zonRcZopWAd5XE9Yxe8yZdmQL9XArtqlrzY79VDqJDGZ5Ay5Ly1pHS+f3r/7hwfiTFOFWQsKgCDTX4iIH4rUFPL8emuHm2x5XNffLTfLq7xq8LRj8QCoqIMpqZqnyt9ncLxKI/pgARBy+buO8L78UFRKvIa7Ovmz/TfA9E2Ul2sOc/pz5RzrrfdKglvkxPtHy1Rb0BOG0HU1YMXWxX7Qelbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ytd0EBZuCH2DhGa0yOoGcRQSiDUfgUue6dwBQFTYjfg=;
 b=BPU2hE1C+POhfszsH7ks4FuONDJxmkrvfmtsdMThhggp6VI0hK9nkq8F1j8uY3ucuM+Px/5pGjhgD0aLrLGOOL2AayUcR+m6pO2KF+VWNQushDT6rtF6N889IQWcaqpVuCyN6njmPu+Mv28OEjp8PumEUtZbVP/h5V3Aqp+ozWspoRRpRPkTR3BIjShgR63s0XrCmvyICS5gdC4tt/czMft2v9jEvncy1yyEXD6M9VFroYd0gBqFL4kVLkApdlrMC0ukjY2M2T6vLHEzj4j0uE/BcO+AsvMii6ezNC3AdpbLot9RUlsrEwKL4AU0bmHFWwcFvsBcOta9zsRZd6rU4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ytd0EBZuCH2DhGa0yOoGcRQSiDUfgUue6dwBQFTYjfg=;
 b=r55yJFyAcrdB9AmM2sa8E2O+WqmKnwK5wj2dTCtQDUb3rRBqC5jvsVqGDHayjhhnEAdm+H0C4IGy3ycudYErpequDw0JpCHQSCh7FAGpPaO/YGN+ZHhEcmxnEYDso/zdcdX/o+98L2plSwXxcfBMksbCuIY8zzEC4Q+aXB49rZM=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 20:31:42 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811%8]) with mapi id 15.20.4065.034; Fri, 30 Apr 2021
 20:31:42 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn()
 sometime returns the wrong signals
Thread-Topic: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn()
 sometime returns the wrong signals
Thread-Index: AQHXNgU7cqnWwo9uSUqkb8fv6D7LrKrAf6QAgABdihGAABDSgIABgYVxgAAb1ICACUmEkIABocSAgAATi8aAAAlrAA==
Date:   Fri, 30 Apr 2021 20:31:42 +0000
Message-ID: <20210430203136.lnzqt7vuninh5v4t@revolver>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
 <20210420165001.3790670-2-Liam.Howlett@Oracle.com>
 <20210422124849.GA1521@willie-the-truck> <m1v98egoxf.fsf@fess.ebiederm.org>
 <20210422192349.ekpinkf3wxnmywe3@revolver> <m1y2d8dfx8.fsf@fess.ebiederm.org>
 <20210423200126.otleormmjh22joj3@revolver> <m1czud6krk.fsf@fess.ebiederm.org>
 <20210430184757.mez7ujmyzm43g6z2@revolver> <m1y2cztuiw.fsf@fess.ebiederm.org>
In-Reply-To: <m1y2cztuiw.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: xmission.com; dkim=none (message not signed)
 header.d=none;xmission.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd2b4ac0-cc04-4f74-a442-08d90c16f75c
x-ms-traffictypediagnostic: CO1PR10MB4545:
x-microsoft-antispam-prvs: <CO1PR10MB4545355D29FBD4CE6F9A85FCFD5E9@CO1PR10MB4545.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5xK1O6aIO5puV761wAxiFj3ojqiPWE8DQCzSYWOhWExWolZMYS1ASowM5W0mnEB70A2NJobvFP/8L3ixhnNFHclZCfa5sC6yCwY9NYO3sRw+urhyN/5/IQbYtDlscIerLsU6MK4UufT2rTiRn5Rt4Y68t0zajt4BOLZKCd2PB+eC6rJWkvf4dRn2JlLo7do9jCDRQqCYCOPZ78bnmqzAG9TaWiKf/zSebGjOFiH8OQNmTa6mPapAKDcDXZC/lKYR1YIRElYdX4J7QAV9rRFqyJA9KjK3FmhdWZLcptOtzOvB8IUo6ekmaTi70RT+o4iNTxwJviEAF7g0Ch9vKJqU8p8AIVLvuQbuSFOOWlWXw2brWFN/IcppGGL3zpqExsBGbH1YUj5UQ/Y1Sk/n/gMKyIujRsAoiXayrf+nOuYl1/P5nTgqgVHVbr79qDdXzWuNkDWMglLN4eLmNLp9/ik9Gz5ZNZQ7ENYIC/hy01oR3ddSmXQ6K2OGwww2DQo/CXbJOUpVeX5tG+qo7KktG78qJz1Hbd0mdd0aknTCSPLezGuylBhDEM1jYk70T0aCrW16Z1GixJYnk9+hf+cs/JaKgzZ9tf+0KH5JEutIG6FnoXw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(376002)(366004)(39860400002)(136003)(396003)(346002)(4326008)(122000001)(44832011)(38100700002)(6506007)(6916009)(71200400001)(186003)(1076003)(7416002)(86362001)(2906002)(26005)(66446008)(9686003)(6486002)(8936002)(6512007)(76116006)(66946007)(66476007)(64756008)(5660300002)(54906003)(66556008)(33716001)(316002)(83380400001)(478600001)(91956017)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vTvR/ffO2muwLuv340Le4TMZQdWtM2G9978q2wxhExxF5n/S2OFKdcsr0Pkx?=
 =?us-ascii?Q?5OO0ZJEyR4lJTysam3uUxG8ounFgApLY7vPcK8EHfbn88kJf/v8GklSYInYz?=
 =?us-ascii?Q?Mn038rID2n9SklQkwYovJPLYFkl3qB3H62skr70zljnjJVqEscKCC4i+7ANc?=
 =?us-ascii?Q?dOdbt8Tor2wOmu/bDrHaDFwZsHTPtK4kCziS3H29NmRdZR8InluX4KViJuoM?=
 =?us-ascii?Q?SdWhhOqvhGjx2TOHXzYpm8FPg0Fkz6wZJRzYW/xayb1AqCzfCGpz7Vh0MLtL?=
 =?us-ascii?Q?mmqighFaIu8Dw5OuA4DNNRmNaXEGCewKgt3rf39UZ/TNW5J9KGKsbz/RNGOD?=
 =?us-ascii?Q?HZINsEpgagnWL4fjJ72Y11gX54jhFQrR2ivwJuDKF6nJjeF1A+cCA3rb0+ss?=
 =?us-ascii?Q?lGg4PcvOE3BQG8+2LNod6uyFd1acNdKEdrsZiEvMDOhO5+ohNflC+/ZjUU/C?=
 =?us-ascii?Q?C8H2ZLcKB5WDzrTabDz8rkoEar0RLbpj8uacml+Z5eIviNVtDY6r4b8Ce9a/?=
 =?us-ascii?Q?yStRuYBVK3hTQbeh0/wWz3kX3pOHiyFjZJ94MGRlHVUj/U9kNMMw1q0KFAur?=
 =?us-ascii?Q?4ennZ0RUco5dgJSHISM1uf4wlcixZintbY68cguQo18fzt9lh1mIW2KXGmiR?=
 =?us-ascii?Q?f8asjsuDkZfhpdbJ52Zpm8gIcDBu3lma089fviZrqdQL6rWilzFizcb4lADI?=
 =?us-ascii?Q?mOWOkxM3lc3Hyx1wAjg0AmZTaFGNEY0vjboLueKoRAq7q3f0apj86/BDtYL0?=
 =?us-ascii?Q?AM6PmBSnPz3gXUCmtstE0kZ925pr3UeM/JUM8XN9xbbnHOdZoOJ+sIoInU1t?=
 =?us-ascii?Q?upC/QQstTH7ubrjmUcVl6sb2tYj6k/zyC+dNdPkAvHozejPGrlbSeqLnhpDq?=
 =?us-ascii?Q?oQOp+8KUsjCKlEgeGMypNDJursdD8f9P0/gs0PSqIVxm5BcsLg2Isk7YkBFq?=
 =?us-ascii?Q?xSbsNkpg6Q5wk5vDEAD6+Sel+jW6eCVXKs03nhYR7+FePDdm59ck+5ZK853w?=
 =?us-ascii?Q?EogLO8mBfq6fyVwEu7C0whw//YSL6O/lqpPVc5ew5NZ9qWspY9ReKl1LlyVO?=
 =?us-ascii?Q?T4N9gg/kNgU0BrNIJy97Zp+MxkYSmoMd+ymnqhSxYbc7xMqDUHq/BRaX9XHp?=
 =?us-ascii?Q?GgDX0Z5Xhoqzx5jv+OjmvvCOlQfZRLOpsXuHI7adtbm4JdiyGEDtVy7LbHlf?=
 =?us-ascii?Q?0gxmqYXUD/iS9zlFN08mW0YHDlVi2PRfw5WXw6koaRC4v08qt8r2HBs5K6u2?=
 =?us-ascii?Q?5MZXxKDz8Qi9zrZpgNf+J6X3en73QxoRpiWr8Tg/CLIfmmRF7ecrIxAE05Q4?=
 =?us-ascii?Q?SBUSfVfsI7NpWtwL3r9IWDFb?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C22D56E6697C7408A635F6FE48D379E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2b4ac0-cc04-4f74-a442-08d90c16f75c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2021 20:31:42.6984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h/AiCAmGedUQTNE53Ym+gn0azKNtcOaNxkV2ac5O72xIwwNDdnUlmih2MxJfSHLPpxYJ7Ln2FHH43+qPbcGJDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300143
X-Proofpoint-GUID: T3FpPbNyOKmiSFtv-tCtbq6Cwowm-v3Z
X-Proofpoint-ORIG-GUID: T3FpPbNyOKmiSFtv-tCtbq6Cwowm-v3Z
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104300143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Eric W. Biederman <ebiederm@xmission.com> [210430 15:57]:
> Liam Howlett <liam.howlett@oracle.com> writes:
>=20
> > This is way out of scope for what I'm doing.  I'm trying to fix a call
> > to the wrong mm API.  I was trying to clean up any obvious errors in
> > calling functions which were exposed by fixing that error.  If you want
> > this fixed differently, then please go ahead and tackle the problems yo=
u
> > see.
>=20
> I was asked by the arm maintainers to describe what the code should be
> doing here.  I hope I have done that.
>=20
> What is very interesting is that the code in __do_page_fault does not
> use find_vma_intersection it uses find_vma.  Which suggests that
> find_vma_intersection may not be the proper mm api.
>=20
> The logic is:
>=20
> From __do_page_fault:
> 	struct vm_area_struct *vma =3D find_vma(mm, addr);
>=20
> 	if (unlikely(!vma))
> 		return VM_FAULT_BADMAP;
>=20
> 	/*
> 	 * Ok, we have a good vm_area for this memory access, so we can handle
> 	 * it.
> 	 */
> 	if (unlikely(vma->vm_start > addr)) {
> 		if (!(vma->vm_flags & VM_GROWSDOWN))
> 			return VM_FAULT_BADMAP;
> 		if (expand_stack(vma, addr))
> 			return VM_FAULT_BADMAP;
> 	}
>=20
> 	/*
> 	 * Check that the permissions on the VMA allow for the fault which
> 	 * occurred.
> 	 */
> 	if (!(vma->vm_flags & vm_flags))
> 		return VM_FAULT_BADACCESS;
>=20
> From do_page_fault:
>=20
> 	arm64_force_sig_fault(SIGSEGV,
> 			      fault =3D=3D VM_FAULT_BADACCESS ? SEGV_ACCERR : SEGV_MAPERR,
> 			      far, inf->name);
>=20
>=20
> Hmm.  If the expand_stack step is skipped. Does is the logic equivalent
> to find_vma_intersection?
>=20
> 	static inline struct vm_area_struct *find_vma_intersection(
>         	struct mm_struct * mm,
>                 unsigned long start_addr,
>                 unsigned long end_addr)
> 	{
> 		struct vm_area_struct * vma =3D find_vma(mm,start_addr);
> =09
> 		if (vma && end_addr <=3D vma->vm_start)
> 			vma =3D NULL;
> 		return vma;
> 	}
>=20
> Yes. It does look that way.  VM_FAULT_BADMAP is returned when a vma
> covering the specified address is not found.  And VM_FAULT_BADACCESS is
> returned when there is a vma and there is a permission problem.
>=20
> There are also two SIGBUS cases that arm64_notify_segfault does not
> handle.
>=20
> So it appears changing arm64_notify_segfault to use
> find_vma_intersection instead of find_vma would be a correct but
> incomplete fix.

The reason VM_GROWSDOWN is checked here is to see if the stack should be
attempted to be expanded, which happens above.  If VM_GROWSDOWN is true,
then wouldn't the do_page_fault() and __do_page_fault() calls already be
done and be handling this case?

>=20
> I don't see a point in changing sigerturn or rt_sigreturn.

Both functions call arm64_notify_segfault() on !access_ok() which I've
increased the potential for returning SEGV_MAPERR.  It is also not
necessary to walk the VMAs when !access_ok(), so it seemed a decent
thing to do.

Thanks,
Liam=
