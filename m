Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A2A369B16
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbhDWUF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:05:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58732 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhDWUFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 16:05:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13NJx1ge186682;
        Fri, 23 Apr 2021 20:03:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sl4U/BDRUazp3ve+QEJREtQmQg31WbFf0CQ7jRLtCLc=;
 b=fB18gcWXNSEJgiSED1XC2bsrxnEOOm2Hhaw4hWq3pz/WJ7js/ecaGL9Wy40zTPmDC9db
 XtGLARZvrYWE9ym5mFC3Q4AHiiKbx4H0HK9hxFOQB5XbRBMT73RASuxN0ltraMPFpNFU
 Ko7DmYuXqn/wp4EHeO9aEyCshG/18hF393njcI+xxONCy3uypBVcCTMfXydIOfWZ0jnb
 OHcFTZOK20W7MvbGho28THty7hYLB9+cO2iVeQZ/Z7MDMJjPvir0lcZybU0m4Pp3l7gw
 HpGQTIgMR+0HgrQFy4+aJM/YMow6e0eZ6917ZZ5zTeMC5JrAjydIhUTaWzeTindFwlLv aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37yqmnsfew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 20:03:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13NK1X9W112026;
        Fri, 23 Apr 2021 20:03:22 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by aserp3020.oracle.com with ESMTP id 383cbfwt6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 20:03:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBgtpm0apjTOawwAE24TTg2Mzcti1MvQgaZamIy++F1irm3ymjxp7mXrQ1ohDfhF5CjgW7/W1VjdjNP+52riqMxtRCEmmw6EZNZ7VPnNV+1jGs01jwxWzkbL2pwJlsL1LD12jOheLgyn5Eq5UjEmPlkK6Aq+EGvLKDuB/oX5rOuOSctzDjkzN/BKiKlJLLekWeoHQSHC3lOBMQW4FlFx3mnwS7t64mg1W6dxuxFmt40nq41vSuh4tcSFoq7tWVzMEMLNNLaAA8QKmeUuNZ3/miGqhwxS6xLUlaSlXMAvr9kC9EsON6QBay14povx4xVRwthdTpbW9KNIEhCDGUQbIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sl4U/BDRUazp3ve+QEJREtQmQg31WbFf0CQ7jRLtCLc=;
 b=VRTuQTgHRO/4oilQuFnzl8MfoHl351GpqtYVB+93JlC4atn5kP/SsCVLcVigxcuFiD9ii+V9hem8Vj+89ZIlFP+QYCwbOxaDqUWyJieJrm0Oy/gCBe3xbQ8+sU9FieA3aGnQzu+vxiCn3Z7ot7vzujOY4wVghqNlz5v5tb+sei5A60SXRIeA8uzU0l5wJ/o+IBVTDCWF/coOrMR5ow8/g4K1hcNOvJ0bZ/4cu8iyUJLtRF7slSdxYhGazUPJUjIJOtoAQwrm6KV9Byb+ase7vTrvQAjlSt3mSpkLA0YN+UEe8vo71Bj+VCsjo+3gYUQ1U4A0Vh1VGSARwfRDH7Xphw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sl4U/BDRUazp3ve+QEJREtQmQg31WbFf0CQ7jRLtCLc=;
 b=gbho6iEgHgDw2VgBxIBAGMBA/e5L6qcxBjtqP25wmQ8LE01manViUzmYWLaJxTL8kR9fcRUIPy22aEWy37Q0WYY2OTunDLQYXY67miW1Jh401xmf0ydeLfPKaVRzvT0Cr432FsRTby/DnQm76WHhBtH4dYXXwHPfQ3AvsJKWbac=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by MWHPR10MB1326.namprd10.prod.outlook.com (2603:10b6:300:2b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Fri, 23 Apr
 2021 20:03:17 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811%8]) with mapi id 15.20.4065.022; Fri, 23 Apr 2021
 20:03:17 +0000
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
Thread-Index: AQHXNgU7cqnWwo9uSUqkb8fv6D7LrKrAf6QAgABdihGAABDSgIABgYVxgAAb1IA=
Date:   Fri, 23 Apr 2021 20:03:17 +0000
Message-ID: <20210423200126.otleormmjh22joj3@revolver>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
 <20210420165001.3790670-2-Liam.Howlett@Oracle.com>
 <20210422124849.GA1521@willie-the-truck> <m1v98egoxf.fsf@fess.ebiederm.org>
 <20210422192349.ekpinkf3wxnmywe3@revolver> <m1y2d8dfx8.fsf@fess.ebiederm.org>
In-Reply-To: <m1y2d8dfx8.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: xmission.com; dkim=none (message not signed)
 header.d=none;xmission.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e21d55f-b6e5-4746-552f-08d90692d63c
x-ms-traffictypediagnostic: MWHPR10MB1326:
x-microsoft-antispam-prvs: <MWHPR10MB1326DF7E41142C0588455852FD459@MWHPR10MB1326.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d1XGgSjQPsLKRybqGOARp9JRnQQ90V+R9VIYy3jTyk0eB8TXsR5Y+9Mdc8dtVc/BL0fuch0cuc1t/hcyqJ4Mb3DKOiq6wt969EnyNTAwCRCvTNI3l4uqqIBStvcI7+DUW5LyMQ0fSo3r9Z0Lpdj6LLNDIwXzP0lxYGVgqOKV3h3/GP3IA0KGIOH6vlsPcuVzibcLJOIGkXEpO+4qnqKbacadgfiiBd2kAc6ua4RE9rmncDyseusu/rRsoSaPAELNup964Dc6iW8cmpH/OKDkll5rar0aTtfgReM2Mw2zUDWwx+mTXRCcS4npmffHH+REdDBrACcXPx63nKHhyl4frDdKO543/lWkJhkKsm0PK4ZzyJFuu1cN23qUfV7jcHnEyqL0DKzx1JGAyYmYvQwZFfqOss9Q6QJ8dwkJFEWC05tvkBZ2Ygss7UNZqOtP8EO04sJD76dzVBGvnHXQCVty1nhvdsnVUFEhU8eBF/4nTGFB8wZYxdEBa2O9uFV+71zdZWbfjAXCqsU3G7Pc9Ta1BdKain5dSUWCG9S0PeaEGs6vBA3fnBpOiES2Ae4Ef6CUtZcoC88zjpmyhq+oXAY8lPV40mWaiIlpbFsZTsMwhrc4p74diVKWvUKnaRoLr75B5kptscya94U30Uo5A9ZgzggYUrhHauDyYWf1uaj6wX50rSezl5drrhkY6HWYnb8w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(396003)(136003)(346002)(39860400002)(376002)(366004)(8676002)(2906002)(71200400001)(83380400001)(6506007)(76116006)(4326008)(64756008)(91956017)(6486002)(66446008)(66476007)(66946007)(1076003)(66556008)(8936002)(26005)(122000001)(33716001)(54906003)(316002)(38100700002)(478600001)(6512007)(44832011)(86362001)(30864003)(966005)(7416002)(9686003)(5660300002)(186003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0jxxKvvCvf1axRS/DrthKHPcASoEFCE730uC4QTpgD5GhS+Pu+sdV8MGECe6?=
 =?us-ascii?Q?eFYPUl1jah0mAa8Z1fxlz0h3eqBBP/3i2P9D95zt6YZ1tOxGrJYPzDTwS6Kj?=
 =?us-ascii?Q?oJ/KXuYPTOQEsEC4lPTQlNBxULcpABDmq1qs+5xpsr6gSL2iJ05+lD92zuW6?=
 =?us-ascii?Q?PT8V5/UIRiCSNVlhEI+RPtLCz3m7dCWlc6EuBLns0r72Ja69buzMbtiS0L8z?=
 =?us-ascii?Q?4OuA+6uAxEGfWwZmfmWRKHWR/ItH0tv8ZZqp1J75MIraESaMCQfkyVzEGWuC?=
 =?us-ascii?Q?54xZlD6/2NyArvU/1B9+Nc0PsNYYgV6XjgoQAlhwKciuftQ5fVgqCWGdgADc?=
 =?us-ascii?Q?DiJW3p+CHSP5gmkaY6HXu3NQUqYfRNKkxiHt34fxZXXjf3c5nmAsFpk2Sxc1?=
 =?us-ascii?Q?icehZGCfAFsXgSFiQT3bG6+BG7jwR+pfizkbPjooAGY4imek5BCS6N00kVND?=
 =?us-ascii?Q?R6b6KFCbkZ7ivMAs/5M1ivqYWeeQAARDm4DGcA8ED9wUeJpophLCsoZW/K80?=
 =?us-ascii?Q?x1T47jd0MPrDaXlkCBd2NmcXoOHFSmkYuuMsUgewOuD3+Zo/HQoJNLMIGUOQ?=
 =?us-ascii?Q?Ca+DpFDfBgLHoYMpaLeFdT71iZR+h8eFBbl1/BEHyYSk7qBSR98zkkjKan2I?=
 =?us-ascii?Q?pGjhTZVZy8LUXF/CYBMtjeg/l+MMnPiOBkS5CpW2P/QoB+hZyrWbt6etcAbV?=
 =?us-ascii?Q?b8I57GLj2zX4DVUIr7xX8ADz4HqouatuiWhYA2XiRckBgJcKGQwr7nMO+Hpv?=
 =?us-ascii?Q?4IgZs0O9lhJvNrMSrq6mtDvAO8jqSh/lbHwCb5XSfgln5e+M76yR6nI85eKX?=
 =?us-ascii?Q?ktfRT60ncCQr+t63vYu0E1p7XcWbWQLWMoslVvuciHPpnBHsRxMO37WbjnUW?=
 =?us-ascii?Q?smOgPAeYbZMoRss9tkxsfuFEqcqtxLxqruI7jNbb9EmhA0YTb3MT6TfIl5La?=
 =?us-ascii?Q?f2T87nAXge9iulChO6hZrWuG/BzuLCnYl+41fpNOak8FvdCDCe/Y/yrfbCbk?=
 =?us-ascii?Q?46jy71XY63hGUDEEc/RdfX4HWUg4TUpSgxFszs0BKXdyz/OudsysuETMyAcQ?=
 =?us-ascii?Q?nmg2MIF9+z0sxTYUPAlJdYT4B6qODivhNF79MaiC26goB5f0aa8jLmHjNoZG?=
 =?us-ascii?Q?OR+daF34vJhW5KIADNci2krDGcuddKjXR3aOd19z7FRFpENld400DynjPqIh?=
 =?us-ascii?Q?V+ic7MSRMN79e9vfhdtV1H9Rso9TRY8SR2CMRixDMUdHGmiDxuuzgsH4sCQZ?=
 =?us-ascii?Q?cpQswLTKvSk8FhA2Sopzv4fNkcPnQ2m7/jG3RuHO497CGwXkfIx8GP1bRCC6?=
 =?us-ascii?Q?eQ+gT/paN1zk8Z2kJphG+k/T?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23AF6DFB9B317D40A51E484DB1A9B4AC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e21d55f-b6e5-4746-552f-08d90692d63c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 20:03:17.7706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y4xAZRObt5BJwIq0tLED0aTuOXOmOHRirBPpjR21cu5VUz0fOi4Epe1zWOe3BxdTO7l0vJAtD0WlqeZZNdDOCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1326
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230132
X-Proofpoint-ORIG-GUID: kaav2VHXhv3x8ivys-XwcYtDn3izvJkB
X-Proofpoint-GUID: kaav2VHXhv3x8ivys-XwcYtDn3izvJkB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Eric W. Biederman <ebiederm@xmission.com> [210423 14:23]:
> Liam Howlett <liam.howlett@oracle.com> writes:
>=20
> > * Eric W. Biederman <ebiederm@xmission.com> [210422 14:23]:
> >> Will Deacon <will@kernel.org> writes:
> >>=20
> >> > [+Eric as he actually understands how this is supposed to work]
> >>=20
> >> I try.
> >>=20
> >
> > Thanks to both of you for looking at this.
> >
> >> > On Tue, Apr 20, 2021 at 04:50:13PM +0000, Liam Howlett wrote:
> >> >> arm64_notify_segfault() was used to force a SIGSEGV in all error ca=
ses
> >> >> in sigreturn() and rt_sigreturn() to avoid writing a new sig handle=
r.
> >> >> There is now a better sig handler to use which does not search the =
VMA
> >> >> address space and return a slightly incorrect error code.  Restore =
the
> >> >> older and correct si_code of SI_KERNEL by using arm64_notify_die().=
  In
> >> >> the case of !access_ok(), simply return SIGSEGV with si_code
> >> >> SEGV_ACCERR.
> >>=20
> >> What is userspace cares?  Why does it care?
> >
> >
> > Calling arm64_notify_segfault() as it is written is unreliable.
> > Searching for the address with find_vma() will return SEG_ACCERR almost
> > always, unless the address is larger than anything within *any* VMA.
> > I'm trying to fix this issue by cleaning up the callers to that functio=
n
> > and fix the function itself.
>=20
> I can't see the rest of the patches in your series so I am not quite
> certain what you are doing.
>=20
> Looking at the places that arm64_notify_segfault is called I do
> think you are right to be suspicious of that function.
>=20
> swp_handler seems a legitimate user as it emulates an instruction.
> For that case at least you should probably add the necessary
> check to see if the address is contained in the returned vma.

The initial patch was to do just that, but the discussion resulted in
other patches to try and clean up the signal handling around this area.
I was switching to find_vma_intersection() to find the vma.  There was
concern on if SEGV_ACCERR should be returned if the next vma
VM_GROWSDOWN as that would potentially indicate a stack expansion. [1]

>=20
> user_cache_maint_handler calls it with the tagged address, when
> it should use an untagged address with find_vma.  Otherwise
> user_cache_maint_handler is also performing instruction emulation
> and should work the same as swp_handler.

arm64_notify_segfault() calls untagged_addr() on the address passed to
find_vma().  Is there anything missing/wrong with this?

>=20
> The only other users are in sigreturn and rt_sigreturn, where the
> address is iffy.  But assuming the proper address is passed sigreturn
> and rt_sigreturn are also performing instruction emulation.
>=20
> > I don't have an example of why userspace cares about SI_KERNEL vs
> > SEGV_ACCERR/SEGV_MAPERR, but the git log on f71016a8a8c5 specifies that
> > this function was used to avoid having specific code to print an error
> > code.  I am restoring the old return code as it seems to makes more
> > sense and avoids the bug in the calling path.  If you'd rather, I can
> > change the notify_die line to use SIG_ACCERR as this is *almost* always
> > what is returend - except when the above mentioned bug is hit.  Upon
> > examining the code here, it seems unnecessary to walk the VMA tree to
> > find where the address lands in either of the error scenarios to know
> > what should be returned.
>=20
> Ignoring the possibility of a parse error what the code has is -EFAULT.
> If we want to distinguish between SEGV_ACCERR and SEGV_MAPERR we need
> the find_vma (and confirmation that the found vma contains the specified
> address) to see if there is a mapping at the specified address.
>=20
> Or as you point out later this could be a SIGBUS situation.
>=20
> >> This is changing userspace visible semantics so understanding userspac=
e
> >> and understanding how it might break, and what the risk of regression
> >> seems the most important detail here.
> >>=20
> >> >> This change requires exporting arm64_notfiy_die() to the arm64 trap=
s.h
> >> >>=20
> >> >> Fixes: f71016a8a8c5 (arm64: signal: Call arm64_notify_segfault when
> >> >> failing to deliver signal)
> >> >> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> >> >> ---
> >> >>  arch/arm64/include/asm/traps.h |  2 ++
> >> >>  arch/arm64/kernel/signal.c     |  8 ++++++--
> >> >>  arch/arm64/kernel/signal32.c   | 18 ++++++++++++++----
> >> >>  3 files changed, 22 insertions(+), 6 deletions(-)
> >> >>=20
> >> >> diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/as=
m/traps.h
> >> >> index 54f32a0675df..9b76144fcba6 100644
> >> >> --- a/arch/arm64/include/asm/traps.h
> >> >> +++ b/arch/arm64/include/asm/traps.h
> >> >> @@ -29,6 +29,8 @@ void arm64_notify_segfault(unsigned long addr);
> >> >>  void arm64_force_sig_fault(int signo, int code, unsigned long far,=
 const char *str);
> >> >>  void arm64_force_sig_mceerr(int code, unsigned long far, short lsb=
, const char *str);
> >> >>  void arm64_force_sig_ptrace_errno_trap(int errno, unsigned long fa=
r, const char *str);
> >> >> +void arm64_notify_die(const char *str, struct pt_regs *regs, int s=
igno,
> >> >> +		      int sicode, unsigned long far, int err);
> >> >> =20
> >> >>  /*
> >> >>   * Move regs->pc to next instruction and do necessary setup before=
 it
> >> >> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.=
c
> >> >> index 6237486ff6bb..9fde6dc760c3 100644
> >> >> --- a/arch/arm64/kernel/signal.c
> >> >> +++ b/arch/arm64/kernel/signal.c
> >> >> @@ -544,7 +544,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
> >> >>  	frame =3D (struct rt_sigframe __user *)regs->sp;
> >> >> =20
> >> >>  	if (!access_ok(frame, sizeof (*frame)))
> >> >> -		goto badframe;
> >> >> +		goto e_access;
> >> >> =20
> >> >>  	if (restore_sigframe(regs, frame))
> >> >>  		goto badframe;
> >> >> @@ -555,7 +555,11 @@ SYSCALL_DEFINE0(rt_sigreturn)
> >> >>  	return regs->regs[0];
> >> >> =20
> >> >>  badframe:
> >> >> -	arm64_notify_segfault(regs->sp);
> >> >> +	arm64_notify_die("Bad frame", regs, SIGSEGV, SI_KERNEL, regs->sp,=
 0);
> >> >> +	return 0;
> >> >> +
> >> >> +e_access:
> >> >> +	force_signal_inject(SIGSEGV, SEGV_ACCERR, regs->sp, 0);
> >> >>  	return 0;
> >> >
> >> > This seems really error-prone to me, but maybe I'm just missing some
> >> > context. What's the rule for reporting an si_code of SI_KERNEL vs
> >> > SEGV_ACCERR, and is the former actually valid for SIGSEGV?
> >>=20
> >> The si_codes SI_USER =3D=3D 0 and SI_KERNEL =3D=3D 0x80 are valid for =
all
> >> signals.  SI_KERNEL means I don't have any information for you other
> >> than signal number.
> >>=20
> >> In general something better than SI_KERNEL is desirable.
> >
> > I went with SI_KERNEL as that's what was there before.  I have no stron=
g
> > opinion on what should be returned; I do favour SIGBUS with si_code of
> > BUS_ADRALN but I didn't want to change user visable code too much -
> > especially to fix a bug in another function.
>=20
> I hadn't noticed earlier, but I agree that what the code is doing is a
> little strange.  I get SIGBUS and SIGEGV confused when I have not looked
> at the recently.  I think SIGBUS is for mapped access that fail, and
> SIGSEGV is for everything else. =20
>=20
> >> > With this change, pointing the (signal) stack to a kernel address wi=
ll
> >> > result in SEGV_ACCERR but pointing it to something like a PROT_NONE =
user
> >> > address will give SI_KERNEL (well, assuming that we manage to delive=
r
> >> > the SEGV somehow). I'm having a hard time seeing why that's a useful
> >> > distinction to make..
> >> >
> >> > If it's important to get this a particular way around, please can yo=
u
> >> > add some selftests?
> >>=20
> >> Going down the current path I see 3 possible cases:
> >>=20
> >> copy_from_user returns -EFAULT which becomes SEGV_MAPERR or SEGV_ACCER=
R.
> >
> > Almost always SEGV_ACCERR with the current bug, as mentioned above.
> > find_vma() searches from addr until the end of the address space, it
> > isn't just a simple lookup of the address.
>=20
> Which is clearly a logic error.
>=20
> In practice I don't know if anyone cares how sigreturn fails so we are
> in a grey area.
>=20
> >> A signal frame parse error.  For which SI_KERNEL seems as good an erro=
r
> >> code as any.
> >>=20
> >>=20
> >> On x86 there is no attempt to figure out the cause of the -EFAULT, and
> >> always uses SI_KERNEL.  This is because x86 just does:
> >> "force_sig(SIGSEGV);" As arm64 did until f71016a8a8c5 ("arm64: signal:
> >> Call arm64_notify_segfault when failing to deliver signal")
> >>=20
> >>=20
> >>=20
> >> I think the big question is what does it make sense to do here.
> >>=20
> >> The big picture.  Upon return from a signal the kernel arranges
> >> for rt_sigreturn to be called to return to a pre-signal state.
> >> As such rt_sigreturn can not return an error code.
> >>=20
> >> In general the kernel will write the signal frame and that will
> >> guarantee that the signal from can be processes by rt_sigreturn.
> >>=20
> >> For error handling we are dealing with the case that userspace
> >> has modified the signal frame.  So that it either does not
> >> parse or that it is unmapped.
> >>=20
> >>=20
> >> So who cares?  The only two cases I can think of are debuggers, and
> >> programs playing fancy memory management games like garbage collection=
s.
> >> I have heard of applications (like garbage collectors)
> >> unmapping/mprotecting memory to create a barrier.
> >>=20
> >> Liam Howlett is that the issue here?  Is not seeing SI_KERNEL confusin=
g
> >> the JVM?
> >
> > No, the issue here is that arm64_notify_segfault() has a bug which sent
> > me down a rabbit hole of issues and I'm really trying my best to help
> > out as best I can.  The bug certainly affects this function as it is
> > written today, but my patch will generate a consistent signal.
>=20
> Not so much.  There are other cases where -EFAULT causing a failing
> return in that function.  So I think you have in practice made the
> matter worse.  As after this patch it becomes less clear what the
> return code is.

I do not see my error.  The rt_sigreturn() checks for unaligned access,
the frame is access_ok(), then tries to restore the sigframe/altstack.
If it's unaligned the patch would retrun SI_KERNEL, if the access is not
okay then it returns SEGV_ACCERR, if the sigframe/altstack fail to be
restored then it retuns SI_KERNEL.

>=20
> >> For debuggers I expect the stack backtrace from SIGSEGV is enough to s=
ee
> >> that something is wrong.
> >>=20
> >> For applications performing fancy processing of the signal frame I thi=
nk
> >> that tends to be very architecture specific.  In part because even
> >> knowing the faulting address the size of the access is not known so th=
e
> >> instruction must be interpreted.  Getting a system call instead of a
> >> load or store instruction might be enough to completely confuse
> >> applications processing SEGV_MAPERR or SEGV_ACCERR.  Such applications
> >> may also struggle with the fact that the address in siginfo is less
> >> precise than it would be for an ordinary page fault.
> >>=20
> >>=20
> >> So my sense is if you known you are helping userspace returning either
> >> SEGV_MAPERR or SEGV_ACCERR go for it.  Otherwise there are enough
> >> variables that returning less information when rt_sigreturn fails
> >> would be more reliable.
> >>=20
> >>=20
> >> Or in short what is userspace doing?  What does userspace care about?
> >
> > I think I've answered this, but it's more of trying to fix a bug which
> > causes an *almost* reliable return code to be a reliable return code.
> > Am I correct in stating that in both of these scnarios - !access_ok()
> > and badframe, it is unnecessary to search the VMAs for where the addres=
s
> > falls to know what error code to return?
>=20
> You have answered you don't know what piece of userspace cares.
>=20
> For access_ok failure you are correct we don't need a find_vma call
> to tell what kind of failure we have.
>=20
> For anything return -EFAULT we don't know as -EFAULT has less precision
> than the instruction itself.
>=20
> My sense is that you should concentrate on the userspace instruction
> emulation case from swp_handler or user_cache_maint_handler.  Because
> those instructions can run unemulated we know exactly what the semantics
> should be in those cases.
>=20
> I suspect arm64_notify_segfault should be renamed arm64_notify_fault
> and generate SIGBUS or SIGSEGV as appropriate.
>=20
> In fact I suspect that proper handling is to call __do_page_fault or
> handle_mm_fault as do_page_fault does and then parse the VM_FAULT code
> for which signal to generate.   Possibly factoring out a helper
> converting VM_FAULT codes to signals.
>=20

This seems a bit too much for something that is in a gray area, as you
said above.

My goal was to tidy up the signal processing in these two functions and
alter the behaviour to be reliable.  If you believe that
arm64_notify_segfault() should be called anyways, then is there harm in
fixing the logic in that function and leaving rt_sigreturn() and
sigreturn() as they are? Please see my 3rd patch in the series at [2].

Thanks,
Liam

Link:
[1] https://lore.kernel.org/lkml/20210422185611.ccdf3rm4zr3xtuzl@revolver/
[2]
https://lore.kernel.org/lkml/20210420165001.3790670-3-Liam.Howlett@Oracle.c=
om/=
