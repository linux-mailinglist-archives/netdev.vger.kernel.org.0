Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B103836872E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbhDVT2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:28:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54642 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVT2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:28:09 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MJMQGO034745;
        Thu, 22 Apr 2021 19:24:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FZfWjXRrUG/x5aoOrBdjc7vHcBySGVMHhAzx3/XaKhY=;
 b=ob7a5gOLqeL5EhCFHS3J10vyyW4LYrFkJjXgz/0+br462InVILbX16gBEXsUZXdL139y
 MqgM83BqNtjKM5ww/Mco2yImw9LeEWouRyzO82Y3a78k/0rVOk3i6XCZu94YLfycWa0S
 NZBcAZsUsKcn+2AXsYJZayEDD3C9iV9MRNUg1XEh7/AXYzdeEP2gKkkOO2LQe1ytxV6c
 qt4GiXk79JBlpz4KRdM6KdanRjK5nt5vDBRJzeWDtHicQMI8jI3QYQqBjpMgTeiUlRGW
 6woPC/IfEZVZb4tYopSb2Cer16I8Mf5AK0qSHh5iO4XQWOOgatYyumT3WxOyAPa8Xt5l MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37yn6ceh9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 19:24:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MJLMoF041387;
        Thu, 22 Apr 2021 19:24:03 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2054.outbound.protection.outlook.com [104.47.37.54])
        by aserp3020.oracle.com with ESMTP id 383cbd8b00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 19:24:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+48Q3H7kSQG/+sRop0NW4VuT2AvnSB8YOtD55dwzv7szsqRmT891vd7akKcnsCJ/kuh8dGGFDD6dkmyA31+WZpgzEQaF+h5bY/76Ev5nZo3+1mARgW73/45Uzlt4JcAW3hZY3QaY2f4fCa1p3WCVSrLgb1kH+7oGEQKzOqPrkeFdYBk2cJMcRwr/Rcx0GO7yUn6iv5VUVoYteI7o/g4VlmW1UjWE7P090uCKNogrNymVsUP6I080vLsb/zAARUT+OAXwbp4V082jzHKYmjU0eZvS5kN7CoExq956H6y4JiIxIAokVHdtFegdnP40x+7E4l4DF2E6byo1IhUfLJDHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZfWjXRrUG/x5aoOrBdjc7vHcBySGVMHhAzx3/XaKhY=;
 b=I62XQ4p26pTXZrZbtNcT79JKlK053V/+rPBd8h+sgLoiFnGIqLe9yNk8x1fs++14yj9O+KdReEB6p9iFL0YZH6ZJWcheWaqTNMBBjobxfDF7++UKqhmMuMgS171PF5t7IgVzb+DVkt9kThvOZTnLkPQhSgApI20AjAyn2c8kqHL8k3sTGRSP1+a+OXr/mDdvRgjZC8VmKW+zM9v+SCuArDzWAozQTy1qbgzX5C96lLx4yCZdrDXM+WtslQQzP8e6lpwca15dT6oaiFRtwKSGssuiWL+FjJcISIRSNPerrhwC6PGxEYGQnwRx6aTl2DOEqLgj7h1GpWJmTGfz31/eJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZfWjXRrUG/x5aoOrBdjc7vHcBySGVMHhAzx3/XaKhY=;
 b=V9rkoUi/Enov4AyuDXWJyAxrveTncQ/0fyJL9ayfMi+t+u8Nd/N/DsT8l+S6xEvL6ND89a3LdcRLfKDhpOWt69t43NSUgVBYyP280zPnTRS4b/T4Ba6vvq6dPUHmkK+pmmGOtuEvnb3C5ZKo1A09r/Kxp+KwBgc9+uES9K3PO2Y=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by CO1PR10MB4755.namprd10.prod.outlook.com (2603:10b6:303:9f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 19:24:01 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811%8]) with mapi id 15.20.4065.022; Thu, 22 Apr 2021
 19:24:01 +0000
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
Thread-Index: AQHXNgU7cqnWwo9uSUqkb8fv6D7LrKrAf6QAgABdihGAABDSgA==
Date:   Thu, 22 Apr 2021 19:24:00 +0000
Message-ID: <20210422192349.ekpinkf3wxnmywe3@revolver>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
 <20210420165001.3790670-2-Liam.Howlett@Oracle.com>
 <20210422124849.GA1521@willie-the-truck> <m1v98egoxf.fsf@fess.ebiederm.org>
In-Reply-To: <m1v98egoxf.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: xmission.com; dkim=none (message not signed)
 header.d=none;xmission.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a9b45f3-c88f-47ec-5202-08d905c42f13
x-ms-traffictypediagnostic: CO1PR10MB4755:
x-microsoft-antispam-prvs: <CO1PR10MB47554431840FEC5FEDAC3959FD469@CO1PR10MB4755.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o6wmD0mdhSeECSUuchnAP0TGpMAibW/bSfTH0FOeAAmjV2CX+oJQJc8ZZ9Ja2cq8jmZQl4hzx57mM0lHeEheCZD9A/0GT3dbrOFSwmoqgdjcK/pZEiDwWQUpikdhbxxKEaXzQ/ZxQ0DfR2kUGgO3xR7vOzhOu221ORZrQNXLZSiD6Ve+PUNPLKDqUVIasG9kPJTFK6JYDgS40+JDaB9tMOu/IswhUAjcYwxPgLvsZ/+gf25YoEAOEzf2x1Zas4YFgDzikw0spb/qi7u9C3O9dur8Gv9iEL7FCr+J42d3Nc7kOMSEI1vhBKlxzverSF0AWtIwhWikr6aV9l+cVrOzPwlLW9nsDBIJIB19kd0G8czmz3sNKeXiHj3dzhF0cXEJTgK/YkuFmjTEyTN4/MQ/C68h3FWcNTAcut5yc4Q2rVFv8EFf3OCw003acoMvCn2SY6NEvAHOsgETn8ns8PWYXkiJiOU0IoSzDC2gisbbb72lQs8gR0hvt7QAF/KG2/Mp1yiDPCBMWrOJfcFGuJ8m4eX2wd7ACYpLIgk0ZWnQ1QQGw+UVBB64qDMWhuGVzeit4w3DKoCuA97j387TuW7dWhuFzP0MvvqzECyE9807yCs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(136003)(376002)(39860400002)(396003)(346002)(366004)(66556008)(6512007)(64756008)(26005)(316002)(1076003)(66446008)(86362001)(71200400001)(4326008)(122000001)(38100700002)(6486002)(9686003)(33716001)(8676002)(91956017)(7416002)(83380400001)(76116006)(5660300002)(6916009)(8936002)(54906003)(44832011)(66946007)(186003)(66476007)(6506007)(2906002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WkrLz5ntkIbQuCS77K8Pof94vFHmtd7yY3GnWLJo/oYTZ1yrWPNkMbLMKhN4?=
 =?us-ascii?Q?yKlJ30gTF2MlGepwPKP2EWTe5ZR5Hk8fC6SA+5VXTFXy2jPEE53SL2EnOiYG?=
 =?us-ascii?Q?/bf3qYCg/TxShFYCle3Ghy24t1YtiuClUuqlzjuN2+CT0PCHpKjvwSnuV45p?=
 =?us-ascii?Q?MC7mLaJ4wn8PLRvr+uxc5KxMNZavnsyNlox4A0CpY8FfoOx9NZzKm625lpqX?=
 =?us-ascii?Q?bNZnz8iuoaHGJf52mPb9T/qSa6e1uwm+5AIt8M/LYgyTL+nXxwPIFxOxCYS6?=
 =?us-ascii?Q?rmq7KwBIVaXCTJHIAtRPQZa3Q6No/A4REFhSvEzaCCIuqoETEL+Ee8eu5ELc?=
 =?us-ascii?Q?v2bAN28Q90VG5QOaTnWToYG53il0mnAmiyjxkrD8xdvSWzc/eInL/bz4uSYO?=
 =?us-ascii?Q?fTpnrCutKEItrOYu0Scjv2ALmGTRWrbdCHXoJ/ztZCw9dushMLNtAMGLrhZf?=
 =?us-ascii?Q?rOspzM30sTsD9yjuD6gH1/D/uEISgCtxiNagTI0gYaBrEiIkRNj8wYfNjaIM?=
 =?us-ascii?Q?k8mvvy6LjQtfXnjnYyyoOAYnVVVMXG4DHn/iK834lTvHcm5r6C9efJgr+4K+?=
 =?us-ascii?Q?+C7LwWXMBDIm2brdmzPcXH+yJ6lwLTTSMLSuMJ865i4Zu0CZL/SngCsgEjRr?=
 =?us-ascii?Q?EU4zmWtWsYWUG+gURoEX6ERrH16XL0n0WSSS03KRCMVsSMTqFhOHlFJAQ9RI?=
 =?us-ascii?Q?nNaKdlI8G8si9P94YYgmL5zgsf8qKyEo/+DS3q4ulhsxFTKj+RKQtshwk9Xw?=
 =?us-ascii?Q?pFTZb9yycqBQ7MHdbgGV5jo+hNVB2qkHmU/uY/K+tgeZnOGvhlGtt7o2q294?=
 =?us-ascii?Q?yQqK/pldEMz5b2AzREB+EOTKOPvjheFO2Sb6F6u4AEXUUHxBNVycUdh4QOVx?=
 =?us-ascii?Q?NVVmskQ36EUL/bSJXXvUysns4t6KqrUPheqtg5hy9tR62HXP5v0aU84QK6fQ?=
 =?us-ascii?Q?egdUrKz4bbeJbC/w3c+1S9aBvVhMn1toHAbu7B3PMy8buiOL717pIAfaI/xf?=
 =?us-ascii?Q?xTXsP4XVYCS89fh3V2IjliSQyXjThdeExrpQPdK3CCYWCGVLGIOUZtYnDn3V?=
 =?us-ascii?Q?dB5roxZZ96uPd5CWyTpiRivwCFgNxPOYtXOheUaqsPV3Rz5781Bs4tR3fHjg?=
 =?us-ascii?Q?c44S8ojMBkI1RJ9UCmCQ0inABzXNTCKJthGXTKmVQvXIdSrX2/TU8r4SBACh?=
 =?us-ascii?Q?cn6RWrkBQD9wStkVoeUzF2QiXY2WyleoM1VfEg+D+fZq4pOtPJwpNV3/gwzT?=
 =?us-ascii?Q?7PWwAKH3M0SZctIHYXubO4OkS5ABeSQdaXwtVuaBmjyC946IQ83B1raMbZkQ?=
 =?us-ascii?Q?2AH60lOC/3/wa5IlflIRjcxB?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <81AED3984011EE44A68E455EF0218A4D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9b45f3-c88f-47ec-5202-08d905c42f13
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 19:24:00.9760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rv5TzWyvqslghgGVqYiqqS3YnI64jIpanF4wBKh9kDpA0pGaH9PRVJRPNUkjjjD5Se2ywkAgBWSq9B0bTrOdCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4755
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220143
X-Proofpoint-GUID: 2eBBhhiSDtkGzVQJq2PRWtRaG3d8U-AB
X-Proofpoint-ORIG-GUID: 2eBBhhiSDtkGzVQJq2PRWtRaG3d8U-AB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Eric W. Biederman <ebiederm@xmission.com> [210422 14:23]:
> Will Deacon <will@kernel.org> writes:
>=20
> > [+Eric as he actually understands how this is supposed to work]
>=20
> I try.
>=20

Thanks to both of you for looking at this.

> > On Tue, Apr 20, 2021 at 04:50:13PM +0000, Liam Howlett wrote:
> >> arm64_notify_segfault() was used to force a SIGSEGV in all error cases
> >> in sigreturn() and rt_sigreturn() to avoid writing a new sig handler.
> >> There is now a better sig handler to use which does not search the VMA
> >> address space and return a slightly incorrect error code.  Restore the
> >> older and correct si_code of SI_KERNEL by using arm64_notify_die().  I=
n
> >> the case of !access_ok(), simply return SIGSEGV with si_code
> >> SEGV_ACCERR.
>=20
> What is userspace cares?  Why does it care?


Calling arm64_notify_segfault() as it is written is unreliable.
Searching for the address with find_vma() will return SEG_ACCERR almost
always, unless the address is larger than anything within *any* VMA.
I'm trying to fix this issue by cleaning up the callers to that function
and fix the function itself.

I don't have an example of why userspace cares about SI_KERNEL vs
SEGV_ACCERR/SEGV_MAPERR, but the git log on f71016a8a8c5 specifies that
this function was used to avoid having specific code to print an error
code.  I am restoring the old return code as it seems to makes more
sense and avoids the bug in the calling path.  If you'd rather, I can
change the notify_die line to use SIG_ACCERR as this is *almost* always
what is returend - except when the above mentioned bug is hit.  Upon
examining the code here, it seems unnecessary to walk the VMA tree to
find where the address lands in either of the error scenarios to know
what should be returned.

>=20
> This is changing userspace visible semantics so understanding userspace
> and understanding how it might break, and what the risk of regression
> seems the most important detail here.
>=20
> >> This change requires exporting arm64_notfiy_die() to the arm64 traps.h
> >>=20
> >> Fixes: f71016a8a8c5 (arm64: signal: Call arm64_notify_segfault when
> >> failing to deliver signal)
> >> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> >> ---
> >>  arch/arm64/include/asm/traps.h |  2 ++
> >>  arch/arm64/kernel/signal.c     |  8 ++++++--
> >>  arch/arm64/kernel/signal32.c   | 18 ++++++++++++++----
> >>  3 files changed, 22 insertions(+), 6 deletions(-)
> >>=20
> >> diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/t=
raps.h
> >> index 54f32a0675df..9b76144fcba6 100644
> >> --- a/arch/arm64/include/asm/traps.h
> >> +++ b/arch/arm64/include/asm/traps.h
> >> @@ -29,6 +29,8 @@ void arm64_notify_segfault(unsigned long addr);
> >>  void arm64_force_sig_fault(int signo, int code, unsigned long far, co=
nst char *str);
> >>  void arm64_force_sig_mceerr(int code, unsigned long far, short lsb, c=
onst char *str);
> >>  void arm64_force_sig_ptrace_errno_trap(int errno, unsigned long far, =
const char *str);
> >> +void arm64_notify_die(const char *str, struct pt_regs *regs, int sign=
o,
> >> +		      int sicode, unsigned long far, int err);
> >> =20
> >>  /*
> >>   * Move regs->pc to next instruction and do necessary setup before it
> >> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> >> index 6237486ff6bb..9fde6dc760c3 100644
> >> --- a/arch/arm64/kernel/signal.c
> >> +++ b/arch/arm64/kernel/signal.c
> >> @@ -544,7 +544,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
> >>  	frame =3D (struct rt_sigframe __user *)regs->sp;
> >> =20
> >>  	if (!access_ok(frame, sizeof (*frame)))
> >> -		goto badframe;
> >> +		goto e_access;
> >> =20
> >>  	if (restore_sigframe(regs, frame))
> >>  		goto badframe;
> >> @@ -555,7 +555,11 @@ SYSCALL_DEFINE0(rt_sigreturn)
> >>  	return regs->regs[0];
> >> =20
> >>  badframe:
> >> -	arm64_notify_segfault(regs->sp);
> >> +	arm64_notify_die("Bad frame", regs, SIGSEGV, SI_KERNEL, regs->sp, 0)=
;
> >> +	return 0;
> >> +
> >> +e_access:
> >> +	force_signal_inject(SIGSEGV, SEGV_ACCERR, regs->sp, 0);
> >>  	return 0;
> >
> > This seems really error-prone to me, but maybe I'm just missing some
> > context. What's the rule for reporting an si_code of SI_KERNEL vs
> > SEGV_ACCERR, and is the former actually valid for SIGSEGV?
>=20
> The si_codes SI_USER =3D=3D 0 and SI_KERNEL =3D=3D 0x80 are valid for all
> signals.  SI_KERNEL means I don't have any information for you other
> than signal number.
>=20
> In general something better than SI_KERNEL is desirable.

I went with SI_KERNEL as that's what was there before.  I have no strong
opinion on what should be returned; I do favour SIGBUS with si_code of
BUS_ADRALN but I didn't want to change user visable code too much -
especially to fix a bug in another function.

>=20
> > With this change, pointing the (signal) stack to a kernel address will
> > result in SEGV_ACCERR but pointing it to something like a PROT_NONE use=
r
> > address will give SI_KERNEL (well, assuming that we manage to deliver
> > the SEGV somehow). I'm having a hard time seeing why that's a useful
> > distinction to make..
> >
> > If it's important to get this a particular way around, please can you
> > add some selftests?
>=20
> Going down the current path I see 3 possible cases:
>=20
> copy_from_user returns -EFAULT which becomes SEGV_MAPERR or SEGV_ACCERR.

Almost always SEGV_ACCERR with the current bug, as mentioned above.
find_vma() searches from addr until the end of the address space, it
isn't just a simple lookup of the address.

>=20
> A signal frame parse error.  For which SI_KERNEL seems as good an error
> code as any.
>=20
>=20
> On x86 there is no attempt to figure out the cause of the -EFAULT, and
> always uses SI_KERNEL.  This is because x86 just does:
> "force_sig(SIGSEGV);" As arm64 did until f71016a8a8c5 ("arm64: signal:
> Call arm64_notify_segfault when failing to deliver signal")
>=20
>=20
>=20
> I think the big question is what does it make sense to do here.
>=20
> The big picture.  Upon return from a signal the kernel arranges
> for rt_sigreturn to be called to return to a pre-signal state.
> As such rt_sigreturn can not return an error code.
>=20
> In general the kernel will write the signal frame and that will
> guarantee that the signal from can be processes by rt_sigreturn.
>=20
> For error handling we are dealing with the case that userspace
> has modified the signal frame.  So that it either does not
> parse or that it is unmapped.
>=20
>=20
> So who cares?  The only two cases I can think of are debuggers, and
> programs playing fancy memory management games like garbage collections.
> I have heard of applications (like garbage collectors)
> unmapping/mprotecting memory to create a barrier.
>=20
> Liam Howlett is that the issue here?  Is not seeing SI_KERNEL confusing
> the JVM?

No, the issue here is that arm64_notify_segfault() has a bug which sent
me down a rabbit hole of issues and I'm really trying my best to help
out as best I can.  The bug certainly affects this function as it is
written today, but my patch will generate a consistent signal.

>=20
> For debuggers I expect the stack backtrace from SIGSEGV is enough to see
> that something is wrong.
>=20
> For applications performing fancy processing of the signal frame I think
> that tends to be very architecture specific.  In part because even
> knowing the faulting address the size of the access is not known so the
> instruction must be interpreted.  Getting a system call instead of a
> load or store instruction might be enough to completely confuse
> applications processing SEGV_MAPERR or SEGV_ACCERR.  Such applications
> may also struggle with the fact that the address in siginfo is less
> precise than it would be for an ordinary page fault.
>=20
>=20
> So my sense is if you known you are helping userspace returning either
> SEGV_MAPERR or SEGV_ACCERR go for it.  Otherwise there are enough
> variables that returning less information when rt_sigreturn fails
> would be more reliable.
>=20
>=20
> Or in short what is userspace doing?  What does userspace care about?

I think I've answered this, but it's more of trying to fix a bug which
causes an *almost* reliable return code to be a reliable return code.
Am I correct in stating that in both of these scnarios - !access_ok()
and badframe, it is unnecessary to search the VMAs for where the address
falls to know what error code to return?

Thanks,
Liam=
