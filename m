Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5631635E461
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345499AbhDMQyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:54:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36332 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345505AbhDMQxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:53:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DGjZlk131869;
        Tue, 13 Apr 2021 16:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sGSneAywt5+o/HpO9KbMtMKEBKahv23hM/sdITtV1Us=;
 b=iEcbg5GQIqQgsojrSh7nh24XEDGxUicRFaWSqq4oT+2RjgA1xam80UGAxeEgLpmL3HiZ
 dBvp0+xh7mt0FA/i2LXaPmo/cyqxQWMa+w5kH0TCJ+6wf3KE952MbajF+8qQPnRNmRnx
 nLlmyAtUvOVGFgJnQqVag8Cm9RWowjzrZLuFDt4J2pk1lX/FV2YIZ0t04oB9vaMK8bN4
 R8r49d10OzS+Rhw9DgI+p04t495DiB8JXdGZFv34a6Xk3OPwyJp6tMkKXZ6hXmA0VliF
 9/0YxnY8oEZXbfCnamRuwp2kEz4WEMhTA4IAx6YhgEE3nfMZh+Y/1GaS/TDHUc4f2r/j Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnfrt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 16:52:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DGjf69086567;
        Tue, 13 Apr 2021 16:52:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3020.oracle.com with ESMTP id 37unx01mrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 16:52:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7fb3lQlKWXpDIsmA/Ly1CupLgrZ/1PokuNEL5OyaV7sjeFz8hab0Ujh/a3rdfSSHRVe+9I0QGSA4zch9YXyAy9x5D/aHdple4fNbDlYc6872qw3le4C1M6rtRZoAEhGOzmL6+0FVIRad3xTDolzL/kxdVR5UXHv75BPcJXT0mBQo0M8wVeD+pgt7/XIwA2NrO0cOvEdgnio/Oyz8HaDqR5CJ3XGYTBF61It3qTkfVCaXZj9f+O9KtTG0QfDfKh7lKweucNKKNX3iXbGfBQiF2NEAUEK0tE6n31Z+TGdQrNdmjHuDZP+AG2ocXGPf9UrE5lroHPgBcpHgpjxdSrU6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGSneAywt5+o/HpO9KbMtMKEBKahv23hM/sdITtV1Us=;
 b=WxOV9WvEcXqOn6ZlgpsZDQis+BaRzmck5J75kkw5JfFBwV8Tnz5Qrs0FtJw9jSbAobZrmgu15rQzYlCH5ZMVeq726rIR1ykS3p+bsCfRRct5XsJzfMbPUN/66D6FjcXQ9G/d/erTYoLnMP4EFgKfYNMwyfrCbdjwpK3En6CRFGoI84fJ4tvSPqEtXpSSX6nAjdNuYzbGLbyReslsfEM7OYxaG3NItTdrZO0+dP12dFIoVpwgODYpfwUpKeU2DO/39QUJP1wNmlqDhlOZG6X3CdY99tCTU+vEQDxwEahUaBqP1A0uXgoRbPF+qqoX1RhV2jarbl1Rdzr4harWbZZXXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGSneAywt5+o/HpO9KbMtMKEBKahv23hM/sdITtV1Us=;
 b=RecCQVT1dFeoJ+pgWT8ueWqpUH4w8eeb6s/IhneZd0IbZErXAaZQVnrghPZeBdpiKZBmeFbmhn844yZHu0S0+eb+o1TfZCrQ5jDZlE6TwfKDwMRF+yWG6bWfqMSRe/em7NTcYfpO1gMSG69/4LU9ID89fo+ORUlB5xEEYz0TUS0=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by CO1PR10MB4548.namprd10.prod.outlook.com (2603:10b6:303:97::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Tue, 13 Apr
 2021 16:52:34 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::1ce7:260b:b004:c82c]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::1ce7:260b:b004:c82c%11]) with mapi id 15.20.4020.022; Tue, 13 Apr
 2021 16:52:34 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
CC:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH] arch/arm64/kernel/traps: Use find_vma_intersection() in
 traps for setting si_code
Thread-Topic: [PATCH] arch/arm64/kernel/traps: Use find_vma_intersection() in
 traps for setting si_code
Thread-Index: AQHXK8A77pSb5Vt+VUCCce95n7TITaqxL0MAgAGEBoA=
Date:   Tue, 13 Apr 2021 16:52:34 +0000
Message-ID: <20210413143035.7zrct6a3up42uaoo@revolver>
References: <20210407150940.542103-1-Liam.Howlett@Oracle.com>
 <20210412174343.GG2060@arm.com>
In-Reply-To: <20210412174343.GG2060@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d4252d1-d373-4069-f92e-08d8fe9c893f
x-ms-traffictypediagnostic: CO1PR10MB4548:
x-microsoft-antispam-prvs: <CO1PR10MB4548F6AC01A2D8AB2C37EA9EFD4F9@CO1PR10MB4548.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pHGlgrn8GaM2F7WQKDH3RZrUwpp0Ohmf3dmrpavA3yN73IUnErSSRPQ340lYvPgOk8Q2DDyGudbcq/RJ2YkGSyg7dKbGWrr40MH0iGJFNLq3C4jG00zphcF8+vJtSLaRlP4UyevwDpQqTmWKHMTLgtkX9yIlYLyP86VooCNPIGdQEdC5e4T6hBMZlja5QewKm0tvgsto/FPqFQjB03Eyc/BUWA+lofjKBp3PewaVwgJ4xFtkgZuidRMeNsqeWmLgpSVGb1b3/H2Xo8L2k5aTViXlc+QmB8zBjh9DyJxkfIkQL7NVPY26PjpjgZ6F8RjMMBRy6DCF8RPbSK9vAFwRPl3Vf++fHbuRLcvLWYnhbl+s8c5Qy2ZPpgjIFHuOzJgNa7HCZ6f7fVeE9YgRzCnkgLOSM/IllNzTqlB6YrjyQ9DWPYiOiXeTm9bh5kXa0zd+GVHgX6nbVwzICe4EBfFny3JZlLmC8har+QSqQ2BcJ+zhawxDLLBUSjOqYtMGrS5wDvxXFY4RC3ysfYxHHupdad+zCYGqpYBcANdXzh5EoBa7u6R/RxdOoCJuiAMv3c0lllHQlofAm6MFFPyYGVq+KDovAh/kexA5r2ekmK3o1Nk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(136003)(396003)(376002)(39860400002)(346002)(366004)(316002)(38100700002)(8676002)(33716001)(7416002)(2906002)(122000001)(4326008)(83380400001)(91956017)(44832011)(8936002)(6506007)(26005)(1076003)(6486002)(9686003)(66556008)(66946007)(478600001)(6916009)(66476007)(66446008)(64756008)(71200400001)(5660300002)(76116006)(6512007)(186003)(86362001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?sckKfVQYEdKdCl4cZznb9lJKJ6k7h9jotZrxmIbRUAMmTw34dGKhGWqvjcMr?=
 =?us-ascii?Q?nuKcSTtXq8YKZeiuA/xgAcCxIWGMHIEw9HVOmKxkEK8F08ycrlxZf8w+RG7x?=
 =?us-ascii?Q?QFF+auCGTjjmDoJLjZSq7tSTg3ZuAG+C8mEtW2BwhIRRplvG3OJAX43QpWrS?=
 =?us-ascii?Q?HaVlO2vylEiqEPrjuFg82Gp5HtPIIL/UEJtDoz4oFfuEh5WZFyLjWkM/2gP/?=
 =?us-ascii?Q?RLBlciqWuNIJxcWUN4M1AsXD8GSlQek+xgiKLT8hyGjN1yVpXdLTG+0LDSUY?=
 =?us-ascii?Q?Xmgp/GLWBo2OxOt/3BRdwkBxtLBVgVtXv0crR44+n0Vk7gmK375jToD06L5T?=
 =?us-ascii?Q?deipCg0nEM48nsjxj/Ph4M3Eb3ZOMwGXiezq04UBBe2Y8oGctx91I4s+zAlI?=
 =?us-ascii?Q?x1wmyebgXZJZKFdXMvjDypkYrjr9K875+0H2TwdgCiZP7Hes7a+m0cJjcmFM?=
 =?us-ascii?Q?1cm6sJ5Sr9x7MyshaQoygYBuYJrLsaMq11rpqm9FuXndXoU/9wAZhnp3qSSm?=
 =?us-ascii?Q?Pila1YPGpzcklr6wxBmc/94ca6mWo+3MTHfspXfMQ8cYkPtFzQEeOcRc4vsQ?=
 =?us-ascii?Q?U+UOFthxL0rp7TljhVsrgxf9C1APIxUdjoUlJavdGzhg9ADRdzhLLhNI3Fdu?=
 =?us-ascii?Q?Ijp9rOmiHJdsegbyFUlIDweoQ1JOynTC3c9wfbPp9/YCUDCiFWHCriPrx7eP?=
 =?us-ascii?Q?+ioYnDnHQy8WXdzLrB8Epbaum2pi/OhjZ+ZIhAhUgRQp24X/IFWi1bM/of7R?=
 =?us-ascii?Q?3DDcrtTy5EirsWRGG3MzLhUDnO2JoboyFYitNWMTRAp+LDnFKb4ZwWxyPjaY?=
 =?us-ascii?Q?uCB/DDTKyCQPVZjvRwRywyzGsEru31yEPVK7HJQUeo7o+oraosRTWGzirLGP?=
 =?us-ascii?Q?AFB/7F5EdvIJ0fCy6p94mG+DyjBg859VqorL0NTrXJOq9CvitLihbHRZbSiX?=
 =?us-ascii?Q?xXAhpuaQyhjyANB8rqAvCHy9hVCvejN63oqJKBZVm/C5/FAwR+G8zoMGIVPK?=
 =?us-ascii?Q?qhEcMbA62WbwD4jlwA6gYhjdzIlxgoPcmsGzuviXczeK7n+9dOHczJ1xEhmJ?=
 =?us-ascii?Q?lqH215RyNriXUfc3XwSZe3K4ivmAhXKnNXBTSDYSjpQyokELx8AwHvFWrCKh?=
 =?us-ascii?Q?3oLGiDzJbanAwrQJKt0SBgY5A9w7nDZqdYvDBZ8NFqcDd6dTQV8+tEZge4tl?=
 =?us-ascii?Q?f5YLThn0UIJXYYU5fwR7wBsrs4fs4kzEsUpgbGJ4jIFpam1hNVhMpIlfA4ku?=
 =?us-ascii?Q?/XrjfFWUFVZ8UF6zGx94U5NwF5QUrzDFkiJsrEtSEMvw9jJ6/kI/kIKP3BVs?=
 =?us-ascii?Q?ttXgOAza9RqDXLGNP/pnlxKf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9DFE480AA2A27A4B8FD7862F6C9EEEBF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d4252d1-d373-4069-f92e-08d8fe9c893f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 16:52:34.2580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3fKO3ORR3Df5NpuyfdRXYq6INqc5wVIrZMuXViKG6nzqflkDODtWwMrPyEKmyauHeYRjx8ayeu0nlzzfIXdTyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4548
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130113
X-Proofpoint-ORIG-GUID: 1fGwcI-NKdukB8X6ciZqQpcdT7wOH_R8
X-Proofpoint-GUID: 1fGwcI-NKdukB8X6ciZqQpcdT7wOH_R8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Catalin Marinas <catalin.marinas@arm.com> [210412 13:44]:
> On Wed, Apr 07, 2021 at 03:11:06PM +0000, Liam Howlett wrote:
> > find_vma() will continue to search upwards until the end of the virtual
> > memory space.  This means the si_code would almost never be set to
> > SEGV_MAPERR even when the address falls outside of any VMA.  The result
> > is that the si_code is not reliable as it may or may not be set to the
> > correct result, depending on where the address falls in the address
> > space.
> >=20
> > Using find_vma_intersection() allows for what is intended by only
> > returning a VMA if it falls within the range provided, in this case a
> > window of 1.
> >=20
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> > ---
> >  arch/arm64/kernel/traps.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> > index a05d34f0e82a..a44007904a64 100644
> > --- a/arch/arm64/kernel/traps.c
> > +++ b/arch/arm64/kernel/traps.c
> > @@ -383,9 +383,10 @@ void force_signal_inject(int signal, int code, uns=
igned long address, unsigned i
> >  void arm64_notify_segfault(unsigned long addr)
> >  {
> >  	int code;
> > +	unsigned long ut_addr =3D untagged_addr(addr);
> > =20
> >  	mmap_read_lock(current->mm);
> > -	if (find_vma(current->mm, untagged_addr(addr)) =3D=3D NULL)
> > +	if (find_vma_intersection(current->mm, ut_addr, ut_addr + 1) =3D=3D N=
ULL)
> >  		code =3D SEGV_MAPERR;
> >  	else
> >  		code =3D SEGV_ACCERR;


Thank you for taking the time to thoroughly review this patch.

>=20
> I don't think your change is entirely correct either. We can have a
> fault below the vma of a stack (with VM_GROWSDOWN) and
> find_vma_intersection() would return NULL but it should be a SEGV_ACCERR
> instead.

I'm pretty sure I am missing something.  From what you said above, I
think this means that there can be a user cache fault below the stack
which should notify the user application that they are not allowed to
expand the stack by sending a SIGV_ACCERR in the si_code?  Is this
expected behaviour or am I missing a code path to this function?

>=20
> Maybe this should employ similar checks as __do_page_fault() (with
> expand_stack() and VM_GROWSDOWN).

You mean the code needs to detect endianness and to check if this is an
attempt to expand the stack for both cases?

Thanks,
Liam=
