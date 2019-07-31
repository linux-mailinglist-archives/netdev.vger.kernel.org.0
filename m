Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84FE7BB36
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfGaIKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:10:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63452 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725866AbfGaIKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:10:40 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6V85SHd010833;
        Wed, 31 Jul 2019 01:10:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4Rd6/E4J20E+P26Mrl6epiMx844I7RHweJ0gW6PYY58=;
 b=MGDr1VJfqvW7PPQvESeDwCz7yDjSwvcjtuZoVMykV5797zoF+r2hK0O1oAOMKTVL7bxX
 huuayfL/EEAfrZP5dvMzkk1uuvoEKbNi60mRfFmd/eNvie+dV78YQEGG9wbj964ghEpH
 807NUcA0IMIVhf2onRZluB1+HW4D2G5fWV0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2u31kwgvmp-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Jul 2019 01:10:21 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 01:10:18 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 01:10:18 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 31 Jul 2019 01:10:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWgcSpoGRXv5mS+v8rLB+9VmpwLialOFJyApgGbAUjIoc0zizLe7kbhB8x9a9VC91ZQCefLBLFny+WY+PRTL5sYOXroU5S0YXzLFjz90PxmFCZTNh/YjjtiNO+XqFCDCuc9FtClQ18ZwAEJBxT9j1zCvWqvXzEJwt7SZIklzOzfvTXrCZsj5oDdIU9ZoK7rKHpdXcSMBS/adY7qk+uFz4ehpQxQbGnnIB+IbDR0dYYQMIPhE8FWCml5Elszm0gCOkOg1nOsW2rMLrUAHIxxHis9lUJOLyUevx+SPMBDe35LD8UVT51FnlrGtOp32wR7b1kvIGH6n1cO2ub6ClQ2PYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Rd6/E4J20E+P26Mrl6epiMx844I7RHweJ0gW6PYY58=;
 b=l1sBx9Vmu3iBtPLKOM5PWNAJrP/9aHQLqACCoPDDVgKZVKHxSx9NxZ6+4oGvlSfI8TO66CYciJWR+CuPKoNjLj2eJcktpeBb31um4+au0AyeehnVZdDK1FGRx7zaVknkVmyKEk0fD/TLCJ+LVK3AowHkauKAbIqE8k7o37eQwGZFO0TY76adrZk1M6OuQ7xAp8xO/sFcfB7E5KPbdUNqKYvx98pnLZOLi3FrbkVuZbek40a0KcsxRTIwVB9C1fTPIpxvCKUu+zBEc97iMp14TuLl1sQUeQq0DzMm8kHz2+UuIw2mZUPWr1dowmwuQW3Ye9kiTbUWqUS+ARWq88dGkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Rd6/E4J20E+P26Mrl6epiMx844I7RHweJ0gW6PYY58=;
 b=U4ssEG+L03EON/5QuJo5InotSa0RjyST1NPP+zra+MVwYD+af8qIteA2xp7SWWkvLg7zHYc73nq186OJ0WvNBzMqJGj/K19R7mIguOTXCa7C0glXKpGngQ4RLrsxOh8gN5RaWCvxZqnIkNzthvBbltekeFNd8FYI6AktVR5BRZo=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1807.namprd15.prod.outlook.com (10.174.255.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Wed, 31 Jul 2019 08:10:16 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 08:10:16 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "Lorenz Bauer" <lmb@cloudflare.com>, Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wCAATKggIAAgfQAgAAt2QCAAFEqAIAFfSwAgAPZeACAAQAYAIAAxVOA
Date:   Wed, 31 Jul 2019 08:10:16 +0000
Message-ID: <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
 <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
 <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
 <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
 <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com>
 <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
In-Reply-To: <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6d8b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 991d1ba5-71f5-460a-87e5-08d7158e857f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1807;
x-ms-traffictypediagnostic: MWHPR15MB1807:
x-microsoft-antispam-prvs: <MWHPR15MB1807759C324904C351C46ADBB3DF0@MWHPR15MB1807.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(346002)(136003)(376002)(199004)(189003)(476003)(6916009)(486006)(6436002)(81166006)(81156014)(71190400001)(186003)(71200400001)(6506007)(256004)(2616005)(102836004)(8936002)(53546011)(14454004)(14444005)(5024004)(7736002)(305945005)(2906002)(86362001)(8676002)(53936002)(54906003)(50226002)(46003)(68736007)(7416002)(6512007)(76116006)(57306001)(229853002)(4326008)(25786009)(478600001)(446003)(36756003)(6486002)(5660300002)(64756008)(66556008)(11346002)(66476007)(66946007)(66446008)(6246003)(316002)(76176011)(33656002)(6116002)(99286004)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1807;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OPiL/JU+/TDOmAzPFrjOkL69zspXwE5qC2VvTSHgz3zxMsfaZ7mwAf30iUtwQvtGm1dhnvMDE6mw0weSRbHuvX+HshucNZA+m3SUYfzpLlPUNK3lqTfqzq3r/QlCuCpSGQ90eESzBJhhcBabqxXLzXGksHFQqKI+AgpuPbbDyO029Czuv6Q95lVTrIkHWTrBG4z6NYYZo7ep4JOGrhrEfpM41fCn/CAAQ6N8mU/xvlDzgcWbS7+B5lkMB9CYqFkohZ/2/fXSRn3TsQ8KxgUmo1NJMI2prdUz3y8VKOLIGN9TGSS6JbUBmPEeTFVplh8UqCfq8drxQu8U3mgvQ2Pnr5W3Jx/sJ68cTAmudPiQXenzJGQ7FZr/NAUQtnidqT25/numyXtuowoTsrahcdNWkvmOPwkeSoEhAvjElwrapUs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E5B76352B389D4A87E904B6B19E7BF7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 991d1ba5-71f5-460a-87e5-08d7158e857f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 08:10:16.3069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1807
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310086
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2019, at 1:24 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Mon, Jul 29, 2019 at 10:07 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Hi Andy,
>>=20
>>> On Jul 27, 2019, at 11:20 AM, Song Liu <songliubraving@fb.com> wrote:
>>>=20
>>> Hi Andy,
>>>=20
>>>=20

[...]

>>>=20
>>=20
>> I would like more comments on this.
>>=20
>> Currently, bpf permission is more or less "root or nothing", which we
>> would like to change.
>>=20
>> The short term goal is to separate bpf from root, in other words, it is
>> "all or nothing". Special user space utilities, such as systemd, would
>> benefit from this. Once this is implemented, systemd can call sys_bpf()
>> when it is not running as root.
>=20
> As generally nasty as Linux capabilities are, this sounds like a good
> use for CAP_BPF_ADMIN.

I actually agree CAP_BPF_ADMIN makes sense. The hard part is to make=20
existing tools (setcap, getcap, etc.) and libraries aware of the new CAP.

>=20
> But what do you have in mind?  Isn't non-root systemd mostly just the
> user systemd session?  That should *not* have bpf() privileges until
> bpf() is improved such that you can't use it to compromise the system.

cgroup bpf is the major use case here. A less important use case is to=20
run bpf selftests without being root.=20

>=20
>>=20
>> In longer term, it may be useful to provide finer grain permission of
>> sys_bpf(). For example, sys_bpf() should be aware of containers; and
>> user may only have access to certain bpf maps. Let's call this
>> "fine grain" capability.
>>=20
>>=20
>> Since we are seeing new use cases every year, we will need many
>> iterations to implement the fine grain permission. I think we need an
>> API that is flexible enough to cover different types of permission
>> control.
>>=20
>> For example, bpf_with_cap() can be flexible:
>>=20
>>        bpf_with_cap(cmd, attr, size, perm_fd);
>>=20
>> We can get different types of permission via different combinations of
>> arguments:
>>=20
>>    A perm_fd to /dev/bpf gives access to all sys_bpf() commands, so
>>    this is "all or nothing" permission.
>>=20
>>    A perm_fd to /sys/fs/cgroup/.../bpf.xxx would only allow some
>>    commands to this specific cgroup.
>>=20
>=20
> I don't see why you need to invent a whole new mechanism for this.
> The entire cgroup ecosystem outside bpf() does just fine using the
> write permission on files in cgroupfs to control access.  Why can't
> bpf() do the same thing?

It is easier to use write permission for BPF_PROG_ATTACH. But it is=20
not easy to do the same for other bpf commands: BPF_PROG_LOAD and=20
BPF_MAP_*. A lot of these commands don't have target concept. Maybe=20
we should have target concept for all these commands. But that is a=20
much bigger project. OTOH, "all or nothing" model allows all these=20
commands at once.

Well, that being said, I will look more into using write permission=20
in cgroupfs.=20

Thanks again for all these comments and suggestions. Please let us=20
know your future thoughts and insights.=20

Song
